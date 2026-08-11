class serdes_sequencer extends uvm_sequencer #(serdes_packet);
    `uvm_component_utils(serdes_sequencer)

    function new(string name = "serdes_sequencer", uvm_component parent);
        super.new(name, parent);
    endfunction: new

    function void start_of_simulation_phase(uvm_phase phase);
        super.start_of_simulation_phase(phase);
        
    endfunction: start_of_simulation_phase
    
    
endclass: serdes_sequencer