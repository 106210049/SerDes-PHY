//  Class: serdes_sequences
//
class serdes_sequences extends uvm_sequence #(serdes_packet);
    `uvm_object_utils(serdes_sequences);

    //  Group: Functions

    //  Constructor: new
    function new(string name = "serdes_sequences");
        super.new(name);
    endfunction: new

    //  Task: pre_body
    //  This task is a user-definable callback that is called before the execution 
    //  of <body> ~only~ when the sequence is started with <start>.
    //  If <start> is called with ~call_pre_post~ set to 0, ~pre_body~ is not called.
    // extern virtual task pre_body();
    task pre_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
            phase = get_starting_phase();
        `else 
            phase = starting_phase;
        `endif
        if(phase != null) begin
            // Raise objection to prevent the run_phase from ending before the sequence is complete
            phase.raise_objection(this, get_type_name());
            `uvm_info(get_type_name(), "raise objection", UVM_MEDIUM)
        end
    endtask: pre_body
    

    //  Task: post_body
    //  This task is a user-definable callback task that is called after the execution 
    //  of <body> ~only~ when the sequence is started with <start>.
    //  If <start> is called with ~call_pre_post~ set to 0, ~post_body~ is not called.
    // extern virtual task post_body();
    task post_body();
        uvm_phase phase;
        `ifdef UVM_VERSION_1_2
            phase = get_starting_phase();
        `else 
            phase = starting_phase;
        `endif
        if(phase != null) begin
            // Drop objection to allow the run_phase to end after the sequence is complete
            phase.drop_objection(this, get_type_name());
            `uvm_info(get_type_name(), "drop objection", UVM_MEDIUM)
        end
    endtask: post_body
    
endclass: serdes_sequences

class serdes_random_sequences extends serdes_sequences;
    `uvm_object_utils(serdes_random_sequences);

    function new(string name = "serdes_random_sequences");
        super.new(name);
    endfunction: new

    task body();
        `uvm_info(get_type_name(), "Executing serdes_random_sequences", UVM_LOW)
        `uvm_do(req)
    endtask: body

endclass: serdes_random_sequences

class serdes_zero_sequences extends serdes_sequences;
    `uvm_object_utils(serdes_zero_sequences);

    function new(string name = "serdes_zero_sequences");
        super.new(name);
    endfunction: new

    task body();
        `uvm_info(get_type_name(), "Executing serdes_zero_sequences", UVM_LOW)
        `uvm_do_with(req, {req.payload_A == 32'h0; req.payload_B == 32'h0;})
    endtask: body

endclass: serdes_zero_sequences

class serdes_one_sequences extends serdes_sequences;
    `uvm_object_utils(serdes_one_sequences);

    function new(string name = "serdes_one_sequences");
        super.new(name);
    endfunction: new

    task body();
        `uvm_info(get_type_name(), "Executing serdes_one_sequences", UVM_LOW)
        `uvm_do_with(req, {req.payload_A == 32'hFF; req.payload_B == 32'hFF;})
    endtask: body
endclass: serdes_one_sequences

class serdes_5_packet_sequences extends serdes_sequences;
    `uvm_object_utils(serdes_5_packet_sequences);

    function new(string name = "serdes_5_packet_sequences");
        super.new(name);
    endfunction: new

    virtual task body();
        `uvm_info(get_type_name(), "Executing serdes_one_sequences", UVM_LOW)
        repeat(5)
            `uvm_do(req)
    endtask: body
endclass: serdes_5_packet_sequences