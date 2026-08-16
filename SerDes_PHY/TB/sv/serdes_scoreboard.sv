typedef enum bit {EQUALITY, UVM} comp_t;

class serdes_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(serdes_scoreboard)

    comp_t compare_policy = EQUALITY;

    // Khai báo analysis imp cho expected và actual
    `uvm_analysis_imp_decl(_exp)
    `uvm_analysis_imp_decl(_mon)

    uvm_analysis_imp_exp #(serdes_packet, serdes_scoreboard) exp_imp;
    uvm_analysis_imp_mon #(serdes_packet, serdes_scoreboard) mon_imp;

    // Hàng đợi lưu expected và actual
    serdes_packet exp_queue[$];
    serdes_packet act_queue[$];

    int packets_in;
    int packets_out;
    int pass_count;
    int fail_count;

    function new(string name = "serdes_scoreboard", uvm_component parent);
        super.new(name, parent);
        exp_imp = new("exp_imp", this);
        mon_imp = new("mon_imp", this);
    endfunction

    // Nhận expected từ monitor
    function void write_exp(serdes_packet packet);
        serdes_packet scb_packet;
        $cast(scb_packet, packet.clone());
        packets_in++;
        exp_queue.push_back(scb_packet);
        `uvm_info(get_type_name(),
            $sformatf("Expected packet queued: dir=%s payload=%0h",
                      scb_packet.dir.name(),
                      scb_packet.get_payload_for_dir(scb_packet.dir)),
            UVM_HIGH)
    endfunction

    // Nhận actual từ monitor
    function void write_mon(serdes_packet packet);
        serdes_packet scb_packet;
        $cast(scb_packet, packet.clone());
        packets_out++;
        act_queue.push_back(scb_packet);
        `uvm_info(get_type_name(),
            $sformatf("Actual packet queued: dir=%s payload=%0h",
                      scb_packet.dir.name(),
                      scb_packet.get_payload_for_dir(scb_packet.dir)),
            UVM_HIGH)
    endfunction

    // So sánh expected và actual
    function void check_phase(uvm_phase phase);
        serdes_packet exp_pkt;
        serdes_packet act_pkt;

        `uvm_info(get_type_name(), "Checking scoreboard (FIFO compare)", UVM_LOW)

        while (exp_queue.size() > 0 && act_queue.size() > 0) begin
            exp_pkt = exp_queue.pop_front();
            act_pkt = act_queue.pop_front();

            case (compare_policy)
                EQUALITY: begin
                    if (exp_pkt.dir == act_pkt.dir &&
                        exp_pkt.get_payload_for_dir(exp_pkt.dir) ==
                        act_pkt.get_payload_for_dir(act_pkt.dir)) begin
                        pass_count++;
                        `uvm_info(get_type_name(),
                            $sformatf("MATCH: dir=%s payload=%0h",
                                      act_pkt.dir.name(),
                                      act_pkt.get_payload_for_dir(act_pkt.dir)),
                            UVM_MEDIUM)
                    end else begin
                        fail_count++;
                        `uvm_error(get_type_name(),
                            $sformatf("MISCOMPARE: exp dir=%s payload=%0h, act dir=%s payload=%0h",
                                      exp_pkt.dir.name(),
                                      exp_pkt.get_payload_for_dir(exp_pkt.dir),
                                      act_pkt.dir.name(),
                                      act_pkt.get_payload_for_dir(act_pkt.dir)))
                    end
                end

                UVM: begin
                    if (exp_pkt.compare(act_pkt)) begin
                        pass_count++;
                        `uvm_info(get_type_name(),
                                  "MATCH via uvm_object::compare()", UVM_MEDIUM)
                    end else begin
                        fail_count++;
                        `uvm_error(get_type_name(),
                            $sformatf("MISCOMPARE via uvm_object::compare()\nEXP:\n%s\nACT:\n%s",
                                      exp_pkt.sprint(), act_pkt.sprint()))
                    end
                end
            endcase
        end

        // Báo lỗi nếu còn dư expected hoặc actual
        foreach (exp_queue[j]) begin
            exp_pkt = exp_queue[j];
            `uvm_error(get_type_name(),
                $sformatf("UNMATCHED EXPECTED: dir=%s payload=%0h",
                          exp_pkt.dir.name(),
                          exp_pkt.get_payload_for_dir(exp_pkt.dir)))
        end

        foreach (act_queue[j]) begin
            act_pkt = act_queue[j];
            `uvm_error(get_type_name(),
                $sformatf("UNMATCHED ACTUAL: dir=%s payload=%0h",
                          act_pkt.dir.name(),
                          act_pkt.get_payload_for_dir(act_pkt.dir)))
        end
    endfunction

    // Báo cáo kết quả cuối cùng
    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),
            $sformatf("Scoreboard summary: packets_in=%0d packets_out=%0d pass=%0d fail=%0d",
                      packets_in, packets_out, pass_count, fail_count),
            UVM_LOW)
        if (fail_count > 0 || exp_queue.size() > 0 || packets_in != packets_out)
            `uvm_error(get_type_name(),"Status:\n\nSimulation FAILED\n")
        else
            `uvm_info(get_type_name(),"Status:\n\nSimulation PASSED\n", UVM_NONE)
    endfunction
endclass
