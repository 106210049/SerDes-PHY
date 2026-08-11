class serdes_agent extends uvm_agent;
    `uvm_component_utils(serdes_agent);
    int is_active = UVM_ACTIVE;

    serdes_driver driver;
    serdes_sequencer sequencer;
    serdes_monitor monitor;

    function new(string name = "serdes_agent", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        monitor = serdes_monitor::type_id::create("monitor", this);

        if (uvm_config_int::exists(this, "", "is_active")) begin
            `uvm_info("CFG", "Property is_active exists in config DB", UVM_LOW)
            if (!uvm_config_int::get(this, "", "is_active", is_active)) begin
            `uvm_error("CFG", "Failed to get is_active value")
            is_active = UVM_PASSIVE; // fallback
            end
        end else begin
            `uvm_error("CFG", "Property is_active haven't set in config DB")
            is_active = UVM_PASSIVE; // fallback
        end

        if (is_active == UVM_ACTIVE) begin
            `uvm_info(get_type_name(), "AGENT IS ACTIVE !", UVM_HIGH);
            sequencer = serdes_sequencer::type_id::create("sequencer", this);
            driver    = serdes_driver::type_id::create("driver", this);
        end
    endfunction: build_phase

    virtual function void connect_phase(uvm_phase phase);
        if(is_active == UVM_ACTIVE) begin
            driver.seq_item_port.connect(sequencer.seq_item_export);
        end
    endfunction: connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction : start_of_simulation_phase

    
endclass: serdes_agent