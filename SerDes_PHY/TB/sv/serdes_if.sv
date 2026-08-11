interface serdes_if (input logic clk, input logic rst_n);
    timeunit 1ns;
    timeprecision 100ps;

    import uvm_pkg::*;
    `include "uvm_macros.svh"

    import serdes_pkg::*;

    // song song cho A
    logic [31:0] data_in_A;
    logic [31:0] data_out_A;
    logic        i_enc_A;
    logic        i_dec_A;
    logic        count_pre_last_A;
    logic        deser_finish_A;

    // song song cho B
    logic [31:0] data_in_B;
    logic [31:0] data_out_B;
    logic        i_enc_B;
    logic        i_dec_B;
    logic        count_pre_last_B;
    logic        deser_finish_B;

    // signal cho transaction recording
    bit monstart, drvstart;

    // Reset task
    task serdes_reset();
        data_in_A       <= '0;
        data_in_B       <= '0;
        i_enc_A         <= 1'b0;
        i_dec_A         <= 1'b0;
        i_enc_B         <= 1'b0;
        i_dec_B         <= 1'b0;
        monstart        = 0;
        drvstart        = 0;
    endtask

    // Task gửi từ A sang B
    task send_A_to_B(input logic [31:0] payload);
        @(posedge clk);
        data_in_A <= payload;
        i_enc_A   <= 1'b1;
        drvstart  = 1;
        @(posedge clk);
        i_enc_A   <= 1'b0;
        drvstart  = 0;

        // Đợi SerDes A bắt đầu truyền serial
        @(posedge dut.serdes_A.u_ctl.start_o);

        // Tạo xung kích hoạt decode đủ dài để deserializer đi qua FSM
        @(posedge clk);
        i_dec_B <= 1'b1;
        @(posedge clk);
        i_dec_B <= 1'b0;

        // Chờ đúng xung finish rising-edge, sau đó đợi finish về 0 trước khi gửi packet kế tiếp
        @(posedge deser_finish_B);
        while (deser_finish_B) @(posedge clk);
    endtask

    // Task gửi từ B sang A
    task send_B_to_A(input logic [31:0] payload);
        @(posedge clk);
        data_in_B <= payload;
        i_enc_B   <= 1'b1;
        drvstart  = 1;
        @(posedge clk);
        i_enc_B   <= 1'b0;
        drvstart  = 0;

        // Đợi SerDes B bắt đầu truyền serial
        @(posedge dut.serdes_B.u_ctl.start_o);

        // Tạo xung kích hoạt decode đủ dài để deserializer đi qua FSM
        @(posedge clk);
        i_dec_A <= 1'b1;
        @(posedge clk);
        i_dec_A <= 1'b0;

        // Chờ đúng xung finish rising-edge, sau đó đợi finish về 0 trước khi gửi packet kế tiếp
        @(posedge deser_finish_A);
        while (deser_finish_A) @(posedge clk);
    endtask

    // Capture packet ngay khi finish lên mức 1 để lấy giá trị data_out thật của packet đang hoàn tất.
    task collect_packet(output bit [31:0] payload, output src direction);
        forever begin
            wait (deser_finish_A || deser_finish_B);

            if (deser_finish_A) begin
                payload   = data_out_A;
                direction = SRC_B;
                wait (!deser_finish_A);
                return;
            end

            if (deser_finish_B) begin
                payload   = data_out_B;
                direction = SRC_A;
                wait (!deser_finish_B);
                return;
            end
        end
    endtask


endinterface : serdes_if
