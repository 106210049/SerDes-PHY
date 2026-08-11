class base_test extends uvm_test;
    `uvm_component_utils(base_test);

    serdes_tb tb;

    //  Group: Functions

    //  Constructor: new
    function new(string name = "base_test", uvm_component parent);
        super.new(name, parent); 
    endfunction: new

    virtual function void build_phase(uvm_phase phase);
        // UVM Config to set the agent to active mode and set the recording detail to 1
        uvm_config_int::set(this, "tb.serdes.agent", "is_active", UVM_ACTIVE);
        uvm_config_int::set(this, "*", "recording_detail", 1);
        super.build_phase(phase);
        // Create the testbench
        tb = serdes_tb::type_id::create("tb", this);
        `uvm_info(get_type_name(), $sformatf("Build Phase of Test is being executed!"), UVM_HIGH)
    endfunction: build_phase

    // function end of elaboration phase
    virtual function void end_of_elaboration_phase(uvm_phase phase);
        // Print the topology of the testbench
        `uvm_info(get_type_name(), $sformatf("End of Elaboration Phase of Test is being executed!"), UVM_HIGH)
        uvm_top.print_topology();
        super.end_of_elaboration_phase(phase);        
    endfunction: end_of_elaboration_phase

    task run_phase(uvm_phase phase);
         // Set drain time to 200ns to allow for any pending transactions to complete before ending     
        uvm_objection obj = phase.get_objection();
        obj.set_drain_time(this, 200ns);
        `uvm_info(get_type_name(), $sformatf("Run Phase of Test is being executed!"), UVM_HIGH)
        super.run_phase(phase);
        phase.raise_objection(this, get_type_name());
        `uvm_info(get_type_name(), $sformatf("Raise objection in run phase"), UVM_HIGH)
        phase.drop_objection(this, get_type_name());
        `uvm_info(get_type_name(), $sformatf("Drop objection in run phase"), UVM_HIGH)
    endtask: run_phase
    
    virtual function void check_phase(uvm_phase phase);
        `uvm_info(get_type_name(),"Check config usage at check phase", UVM_HIGH);
        check_config_usage();
    endfunction: check_phase
    
endclass: base_test

class serdes_random_test extends base_test;
    // component macro
  `uvm_component_utils(serdes_random_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this,
        "tb.serdes.agent.sequencer.run_phase",
        "default_sequence",
        serdes_random_sequences::type_id::get());
    super.build_phase(phase);
  endfunction: build_phase

endclass: serdes_random_test

class serdes_zero_test extends base_test;
    // component macro
  `uvm_component_utils(serdes_zero_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
  
  function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this, 
        "tb.serdes.agent.sequencer.run_phase", 
        "default_sequence", 
        serdes_zero_sequences::type_id::get());
    super.build_phase(phase);
  endfunction: build_phase

endclass: serdes_zero_test

class serdes_one_test extends base_test;
    // component macro
  `uvm_component_utils(serdes_one_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this, 
        "tb.serdes.agent.sequencer.run_phase", 
        "default_sequence", 
        serdes_one_sequences::type_id::get());
    super.build_phase(phase);
  endfunction: build_phase

endclass: serdes_one_test

class serdes_5_packet_test extends base_test;
   // component macro
  `uvm_component_utils(serdes_5_packet_test)

  // component constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new

  function void build_phase(uvm_phase phase);
    uvm_config_wrapper::set(this, 
        "tb.serdes.agent.sequencer.run_phase", 
        "default_sequence", 
        serdes_5_packet_sequences::type_id::get());
    super.build_phase(phase);
  endfunction: build_phase
endclass: serdes_5_packet_test