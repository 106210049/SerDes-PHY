class serdes_monitor extends uvm_monitor;
    `uvm_component_utils(serdes_monitor)

    int num_pkt_col;

    // Analysis ports để kết nối với scoreboard
    uvm_analysis_port #(serdes_packet) exp_ap;
    uvm_analysis_port #(serdes_packet) mon_ap;

    // Virtual Interface để quan sát DUT
    virtual interface serdes_if vif;

    function new(string name = "serdes_monitor", uvm_component parent);
        super.new(name, parent);
        exp_ap = new("exp_ap", this);
        mon_ap = new("mon_ap", this);
    endfunction

    function void connect_phase(uvm_phase phase);
        if(!serdes_vif_config::get(this, "", "vif", vif))
            `uvm_error(get_type_name(),
                $sformatf("virtual interface must be set for: %s vif", get_full_name()))
    endfunction

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(),
            {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction

    task run_phase(uvm_phase phase);
        bit [31:0] payload;
        src direction;

        wait(vif.rst_n === 1'b1);
        `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)

        forever begin
            // Khai báo biến trước khi dùng
            serdes_packet exp_pkt;
            serdes_packet act_pkt;

            // Quan sát phía input (expected)
            vif.observe_input(payload, direction);
            exp_pkt = serdes_packet::type_id::create("exp_pkt", this);
            exp_pkt.dir = direction;
            exp_pkt.payload = payload;
            exp_pkt.set_payload_for_dir(direction, payload);
            exp_ap.write(exp_pkt);

            // Quan sát phía output (actual)
            vif.collect_packet(payload, direction);
            act_pkt = serdes_packet::type_id::create("act_pkt", this);
            act_pkt.dir = direction;
            act_pkt.payload = payload;
            act_pkt.set_payload_for_dir(direction, payload);
            mon_ap.write(act_pkt);

            num_pkt_col++;
        end
    endtask


    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(),
            $sformatf("Report: SerDes Monitor observed %0d transactions", num_pkt_col),
            UVM_LOW)
        if(num_pkt_col == 0)
            `uvm_error(get_type_name(), "No packets observed")
    endfunction
endclass
