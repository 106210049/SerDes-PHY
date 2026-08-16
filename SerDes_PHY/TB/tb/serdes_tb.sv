class serdes_tb extends uvm_env;
    `uvm_component_utils(serdes_tb);

    serdes_env serdes;
    serdes_scoreboard serdes_scb;
    //  Constructor: new
    function new(string name = "serdes_tb", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    // Build Phase 
    virtual function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        serdes = serdes_env::type_id::create("serdes", this);
        serdes_scb = serdes_scoreboard::type_id::create("serdes_scb", this);
        `uvm_info(get_type_name(), $sformatf("Testbench Build Phase is being executed !"), UVM_HIGH)
    endfunction: build_phase

    function void connect_phase(uvm_phase phase);
        serdes.agent.monitor.exp_ap.connect(serdes_scb.exp_imp);
        serdes.agent.monitor.mon_ap.connect(serdes_scb.mon_imp);
        // serdes.agent.driver.req_ap.connect(serdes_scb.exp_imp);

    endfunction: connect_phase

    function void start_of_simulation_phase(uvm_phase phase);
        `uvm_info(get_type_name(), {"start of simulation for ", get_full_name()}, UVM_HIGH)
    endfunction : start_of_simulation_phase
    
    task run_phase(uvm_phase phase);
        `uvm_info(get_type_name(), $sformatf("Testbench Run Phase is begin executed!"), UVM_LOW) 
    endtask: run_phase
endclass: serdes_tb