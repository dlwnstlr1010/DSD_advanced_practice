`timescale 1ns / 1ps

module tb_top;
    reg [31:0] din_1, din_2;
    reg i_sel;
    wire [31:0] dout;

    top uut (.din_1(din_1),
             .din_2(din_2),
             .i_sel(i_sel),
             .dout(dout));

    initial begin
        //initialize
        din_1 = 32'h00000000;
        din_2 = 32'h00000000;
        i_sel = 0;
        #10;
        
        //Test case 1 : Addition
        i_sel = 0;
        din_1 = 32'h00010000; //1.0
        din_2 = 32'h00001000; //0.5
        #10;
        $display("Addition: dout = %h", dout); //Expected : 32'h00011000
        
        //Test case 2 : signed Addition
        i_sel = 0;
        din_1 = -32'sh00010000; //-1.0
        din_2 = 32'h00001000; //0.5
        #10;
        $display("Addition: dout = %h", dout);

        //Test case 3 : signed Addition
        i_sel = 0;
        din_1 = 32'sh00010000; //1.0
        din_2 = -32'h00001000; //-0.5
        #10;
        $display("Addition: dout = %h", dout);

        //Test case 4 : Multiplication
        i_sel = 1;
        din_1 = 32'h00010000; //1.0
        din_2 = 32'h00001000; //0.5
        #10;
        $display("Multiplication: dout = %h", dout); //Expected : 32'h00001000 

        //Test case 5 : signed Multiplication
        i_sel = 1;
        din_1 = -32'sh00010000; //-1.0
        din_2 = 32'sh00001000; //0.5
        #10;
        $display("Multiplication: dout = %h", dout);

        $finish;
    end
endmodule