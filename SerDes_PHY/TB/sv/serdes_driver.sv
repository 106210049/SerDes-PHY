class serdes_driver extends uvm_driver #(serdes_packet);
    `uvm_component_utils(serdes_driver);

    int num_pkg_sent;
    virtual interface serdes_if vif;
    // uvm_analysis_port #(serdes_packet) req_ap;

    function new(string name = "serdes_driver", uvm_component parent);
        super.new(name, parent);
        // req_ap = new("req_ap", this);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        if(!serdes_vif_config::get(this, "", "vif", vif))
            `uvm_error(get_type_name(), $sformatf("virtual interface must be set for: %s vif", get_full_name()))
        else 
            `uvm_info(get_type_name(), "Driver is connected with interface", UVM_HIGH)
    endfunction: connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction : start_of_simulation_phase

    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(),$sformatf("Driver is running"), UVM_LOW);
        @(negedge vif.rst_n);
        vif.serdes_reset();
        @(posedge vif.rst_n);
        `uvm_info(get_type_name(), "Reset dropped", UVM_MEDIUM)
        forever begin
            // Get new item from the sequencer
            seq_item_port.get_next_item(req);
            // Send the item to DUT
            send_packet(req);
            // Communicate item done to the sequencer
            seq_item_port.item_done();
        end
    endtask: run_phase

    task send_packet(serdes_packet packet);
        // serdes_packet exp_pkt;
        bit [31:0] tx_payload;

        tx_payload = packet.get_payload_for_dir(packet.dir);
        `uvm_info(get_type_name(), $sformatf("Sending Packet :\n%s", packet.sprint()), UVM_HIGH)
        // exp_pkt = serdes_packet::type_id::create("exp_pkt");
        // $cast(exp_pkt, packet.clone()); 
        // req_ap.write(exp_pkt);
        fork 
            begin
                case(packet.dir)
                   SRC_A: begin
                        vif.send_A_to_B(tx_payload);
                   end 
                   SRC_B: begin
                        vif.send_B_to_A(tx_payload); 
                   end
                endcase
            end
            @(posedge vif.drvstart) void'(begin_tr(req, "Driver_SerDes_Packet"));
        join
        end_tr(req);
        num_pkg_sent++;
    endtask: send_packet

endclass: serdes_driver