`timescale 1ns/1ps

module tb_top;
    import uvm_pkg::*;
    `include "uvm_macros.svh"
    import serdes_pkg::*;
    `include "../sv/serdes_scoreboard.sv"
    `include "serdes_tb.sv"
    `include "serdes_test_lib.sv"
    
    // Clock & reset
    logic clk;
    logic rst_n;

    // Clock generation
    initial clk = 0;
    initial rst_n = 1;
    always #5 clk = ~clk;

    // Reset generation
    initial begin
        @(posedge clk);
        #1 rst_n <= 1'b0;
        @(posedge clk);
        #1 rst_n <= 1'b1;
    end

    // Interface instance
    serdes_if ser_if(clk, rst_n);

    // DUT instance
    Duplex_Top dut (
        .clk(clk),
        .rst_n(rst_n),
        .data_in_A(ser_if.data_in_A),
        .data_in_B(ser_if.data_in_B),
        .i_enc_A(ser_if.i_enc_A),
        .i_dec_A(ser_if.i_dec_A),
        .i_enc_B(ser_if.i_enc_B),
        .i_dec_B(ser_if.i_dec_B),
        .data_out_A(ser_if.data_out_A),
        .data_out_B(ser_if.data_out_B),
        .count_pre_last_A(ser_if.count_pre_last_A),
        .count_pre_last_B(ser_if.count_pre_last_B),
        .deser_finish_A(ser_if.deser_finish_A),
        .deser_finish_B(ser_if.deser_finish_B)
    );

    // Dump waveform
    initial begin
        $dumpfile("duplex_uvm.vcd");
        $dumpvars(0, tb_top);
    end

    // UVM run
    initial begin
        // cấu hình virtual interface cho agent
        serdes_vif_config::set(null, "*.tb.serdes.agent.*", "vif", ser_if);
        run_test();
    end
endmodule
