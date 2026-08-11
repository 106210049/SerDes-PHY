class serdes_monitor extends uvm_monitor;
    `uvm_component_utils(serdes_monitor)

    serdes_packet ser_pkt;

    int num_pkt_col;

    // TLM ports used to connect the monitor to the scoreboard
    uvm_analysis_port #(serdes_packet) item_collected_port;
    
    // Virtual Interface for monitoring DUT signals
    virtual interface serdes_if vif;

    function new(string name = "serdes_monitor", uvm_component parent);
        super.new(name, parent);
        item_collected_port = new("item_collected_port", this);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        if(!serdes_vif_config::get(this, "", "vif", vif))
            `uvm_error(get_type_name(), $sformatf("virtual interface must be set for: %s vif", get_full_name()))
    endfunction: connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction : start_of_simulation_phase

    task run_phase(uvm_phase phase);
        bit [31:0] payload;
        src direction;

        wait (vif.rst_n === 1'b1);
        `uvm_info(get_type_name(), "Detected Reset Done", UVM_MEDIUM)
        forever begin
            ser_pkt = serdes_packet::type_id::create("ser_pkt", this);
            fork
                vif.collect_packet(payload, direction);
                void'(begin_tr(ser_pkt, "Monitor_SerDes_Packet"));
            join
            ser_pkt.dir = direction;
            ser_pkt.set_payload_for_dir(direction, payload);
            ser_pkt.sample_coverage();
            num_pkt_col++;

            `uvm_info(get_type_name(),
                    $sformatf("Monitor collected packet from %s: %h",
                                (direction == SRC_A) ? "A" : "B",
                                payload),
                    UVM_LOW)
            end_tr(ser_pkt);
            item_collected_port.write(ser_pkt);
            ser_pkt.print();
        end
    endtask


    function void report_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Report: SerDes Monitor Collected %0d Packets", num_pkt_col), UVM_LOW)
        if(num_pkt_col == 0)
            `uvm_error(get_type_name(), "No packets collected")
    endfunction: report_phase
endclass: serdes_monitor