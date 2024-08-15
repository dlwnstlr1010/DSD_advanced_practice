`timescale 1ns / 1ps
module tb_matmul ();
    reg clk;
    reg rstn;
    reg en;
    reg valid_i;
    reg [127:0] din;
    reg [7:0] win;
    wire valid_o;
    wire [511:0] matmul;

initial begin
    clk = 0;
    forever begin
        #5 clk = ~clk;
    end
end

initial begin
    rstn = 1;
    #20 rstn = 0;
    en = 0; valid_i = 0; din = 0; win = 0;
    #10 rstn = 1;
end

initial begin
    #40 wait(rstn);
    #15 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02}; win = 8'h01;
    #10 en = 1; din = {8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04}; win = 8'h02;
    #10 en = 1; din = {8'h05, 8'h06, 8'h05, 8'h06, 8'h01, 8'h01, 8'h05, 8'h06, 8'h01, 8'h06, 8'h05, 8'h06, 8'h05, 8'h06, 8'h01, 8'h06}; win = 8'h03;
    #10 en = 1; din = {8'h01, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h01, 8'h08, 8'h07, 8'h08}; win = 8'h04;
    #10 en = 1; din = {8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02, 8'h01, 8'h02}; win = 8'h05;
    #10 en = 1; din = {8'h03, 8'h04, 8'h03, 8'h04, 8'h01, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04, 8'h03, 8'h04}; win = 8'h06;
    #10 en = 1; din = {8'h05, 8'h01, 8'h05, 8'h06, 8'h05, 8'h06, 8'h05, 8'h06, 8'h01, 8'h06, 8'h05, 8'h06, 8'h05, 8'h01, 8'h05, 8'h06}; win = 8'h07;
    #10 en = 1; din = {8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h01, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08, 8'h07, 8'h08}; win = 8'h08;
    valid_i = 1;
    #10 en = 0; din = 0; win = 0;
    valid_i = 0;
    #10 en = 0; din = 0; win = 0;
end

initial begin
    #100
    wait(win == 0);
    #20
    $stop();
end

matmul dut(
    .clk_i(clk),
    .rstn_i(rstn),
    .valid_i(valid_i),
    .en_i(en),
    .din_i(din),
    .win_i(win),
    .vld_o(valid_o),
    .matmul_o(matmul)
);
endmodule