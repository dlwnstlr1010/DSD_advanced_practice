module top(
    input [31:0] din_1, din_2,
    input i_sel,
    output [31:0] dout);

        fp_operator inst (.din_1(din_1),
                          .din_2(din_2),
                          .i_sel(i_sel),
                          .dout(dout));
endmodule
