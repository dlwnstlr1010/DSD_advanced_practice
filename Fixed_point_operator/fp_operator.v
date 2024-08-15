module fp_operator(
    input signed [31:0] din_1, din_2,
    input i_sel,
    output reg signed [31:0] dout);

    always @(*) begin
        case (i_sel)
        0 : dout = din_1 + din_2;
        default : dout = (din_1 * din_2) >>> 16;
        endcase
    end
endmodule