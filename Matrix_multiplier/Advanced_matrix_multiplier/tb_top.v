`timescale 1ns / 1ps
module tb_top();
    reg clk;
    reg rstn;
    reg en;
    reg valid;
    reg valid2;
    reg signed [7:0] din;
    reg signed [63:0] win1;
    reg signed [7:0] win2;
    wire vld;
    wire [63:0] matmul_o;

    initial begin
        clk = 0;
        forever begin
            #5 clk = ~clk;
        end
    end

    initial begin
        rstn = 1;
        #20 rstn = 0;
        en = 0; valid = 0; valid2 = 0; din = 0; win1 = 0; win2 = 0;
        #10 rstn = 1;
    end
    
    initial begin
        #45
        wait(rstn);

         //First set
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h03, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h01};
        #10 en = 1; din = 8'h02; win1 = {8'h01, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01};
        #10 en = 1; din = 8'h03; win1 = {8'h02, 8'h01, 8'h01, 8'h03, 8'h01, 8'h03, 8'h01, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h02, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01, 8'h01};
    
        valid = 1;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;
        valid = 0;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;

        //Second set
        #10 en = 1; din = 8'h02; win1 = {8'h01, 8'h03, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h01};
        #10 en = 1; din = 8'h03; win1 = {8'h01, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01};
        #10 en = 1; din = 8'h02; win1 = {8'h02, 8'h01, 8'h01, 8'h03, 8'h01, 8'h03, 8'h01, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h02, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01, 8'h01};
    
        valid = 1;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;
        valid = 0;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;

        //Third set
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h03, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h02, 8'h01, 8'h01, 8'h03, 8'h01, 8'h03, 8'h01, 8'h01};
        #10 en = 1; din = 8'h02; win1 = {8'h01, 8'h02, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01, 8'h01};
    
        valid = 1;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;
        valid = 0;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;

        //Fourth set
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h03, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h01};
        #10 en = 1; din = 8'h02; win1 = {8'h01, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01};
        #10 en = 1; din = 8'h03; win1 = {8'h02, 8'h01, 8'h01, 8'h03, 8'h01, 8'h03, 8'h01, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h02, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01, 8'h01};
    
        valid = 1;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;
        valid = 0;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;

        //Fifth set
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h03, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h01};
        #10 en = 1; din = 8'h02; win1 = {8'h01, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h02, 8'h01, 8'h01, 8'h03, 8'h01, 8'h03, 8'h01, 8'h01};
        #10 en = 1; din = 8'h02; win1 = {8'h01, 8'h02, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01, 8'h01};
    
        valid = 1;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;
        valid = 0;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;

        //Sixth set
        #10 en = 1; din = 8'h02; win1 = {8'h01, 8'h03, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h02, 8'h01, 8'h01, 8'h03, 8'h01, 8'h03, 8'h01, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h02, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01, 8'h01};
    
        valid = 1;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;
        valid = 0;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;

        //Seventh set
        #10 en = 1; din = 8'h03; win1 = {8'h01, 8'h03, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h01};
        #10 en = 1; din = 8'h03; win1 = {8'h01, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01};
        #10 en = 1; din = 8'h02; win1 = {8'h02, 8'h01, 8'h01, 8'h03, 8'h01, 8'h03, 8'h01, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h02, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01, 8'h01};
    
        valid = 1;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;
        valid = 0;
        #10 en = 0; din = 0; win1 = 0; win2 = 0;

        //Eigth set
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h03, 8'h02, 8'h01, 8'h01, 8'h01, 8'h02, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h01, 8'h01, 8'h02, 8'h01, 8'h01, 8'h02, 8'h03, 8'h01};
        #10 en = 1; din = 8'h01; win1 = {8'h02, 8'h01, 8'h01, 8'h03, 8'h01, 8'h03, 8'h01, 8'h01};
        #10 en = 1; din = 8'h02; win1 = {8'h01, 8'h02, 8'h03, 8'h01, 8'h01, 8'h02, 8'h01, 8'h01};
        
        valid = 1; valid2 = 1;
        #10 en = 0; din = 0; win1 = 0; win2 = 0; 
        valid = 0; valid2 = 0;
        #10 en = 0; din = 0; win1 = 0; win2 = 0; 
        
        valid2 = 1;
        #20 en = 1; #5 win2 = 8'h01; 
        #10 win2 = 8'h02; 
        #10 win2 = 8'h02; 
        #10 win2 = 8'h01; 
        #10 win2 = 8'h03; 
        #10 win2 = 8'h02; 
        #10 win2 = 8'h01; 
        #10 win2 = 8'h02; 
        #10 win2 = 8'h0;
        valid2 = 0;
        en = 0; din = 0; win1 = 0; win2 = 0; 
    end

    initial begin
        #100
        wait(win1 == 0);
        #600
        $stop();
    end

    top DUT(
        .clk_i(clk),
        .rstn_i(rstn),
        .en_i(en),
        .valid_i(valid),
        .valid_i_2(valid2),
        .din1_i(din),
        .din2_i(win1),
        .din3_i(win2),
        .vld_o(vld),
        .matmul_o(matmul_o)
    );
endmodule