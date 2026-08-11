typedef enum {SRC_A, SRC_B} src;

class serdes_packet extends uvm_sequence_item;

    rand bit [31:0] payload_A;
    rand bit [31:0] payload_B;
    bit [31:0] payload; // legacy compatibility field
    rand src dir;

    `uvm_object_utils_begin(serdes_packet)
        `uvm_field_int(payload_A, UVM_ALL_ON + UVM_BIN);
        `uvm_field_int(payload_B, UVM_ALL_ON + UVM_BIN);
        `uvm_field_int(payload, UVM_ALL_ON + UVM_BIN);
        `uvm_field_enum(src, dir, UVM_ALL_ON);
    `uvm_object_utils_end

    constraint payload_range {
        payload_A inside {[32'h0:32'hFF]};
        payload_B inside {[32'h0:32'hFF]};
    }

    covergroup cg_serdes_packet;

        cp_payload_a: coverpoint payload_A {
            bins zero   = {32'h0};
            bins random = {[32'h1:32'hFE]};
            bins one    = {32'hFF};
        }

        cp_payload_b: coverpoint payload_B {
            bins zero   = {32'h0};
            bins random = {[32'h1:32'hFE]};
            bins one    = {32'hFF};
        }

        cp_dir: coverpoint dir {
            bins src_A = {SRC_A};
            bins src_B = {SRC_B};
        }

        cross_serdes_dir: cross cp_payload_a, cp_payload_b, cp_dir {
            // Khi payload_A bất kỳ và dir=SRC_A
            bins packet_src_A = binsof(cp_payload_a) && binsof(cp_dir.src_A);

            // Khi payload_B bất kỳ và dir=SRC_B
            bins packet_src_B = binsof(cp_payload_b) && binsof(cp_dir.src_B);
        }

    endgroup



    function new(string name = "serdes_packet");
        super.new(name);
        cg_serdes_packet = new();
    endfunction

    function void post_randomize();
        payload = get_payload_for_dir(dir);
    endfunction

    function bit [31:0] get_payload_for_dir(src d);
        case (d)
            SRC_A: return payload_A;
            SRC_B: return payload_B;
            default: return payload;
        endcase
    endfunction

    function void set_payload_for_dir(src d, bit [31:0] value);
        payload = value;
        case (d)
            SRC_A: payload_A = value;
            SRC_B: payload_B = value;
        endcase
    endfunction

    function void sample_coverage();
        cg_serdes_packet.sample();
    endfunction

endclass
