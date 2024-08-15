module matmul2( //Column calculation
input wire clk_i,
input wire rstn_i,
input wire en_i,
input wire valid_i,
input wire signed [63:0] temp_i, //Column is 8 bits * 8
input wire signed [7:0] din3_i, //Only one element of the column vector participates in the calculation.
output wire valid_o,
output wire signed [255:0] matmul_o);

wire mac_valid;
reg [1:0] total_valid;
integer i;

assign valid_o = total_valid [0];

always @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i) begin
        total_valid <= 0;
    end
    else begin
        total_valid [0] <= mac_valid;
        total_valid [1] <= total_valid [0];
    end
end

wire [31:0] mac_outputs [7:0];

assign matmul_o = {mac_outputs[7], mac_outputs[6], mac_outputs[5], mac_outputs[4], mac_outputs[3], mac_outputs[2], mac_outputs[1], mac_outputs[0]};

generate
    genvar j;
    for (j = 0; j < 8; j = j + 1) begin
        mac mac_inst(
            .clk_i(clk_i),
            .rstn_i(rstn_i),
            .dsp_en_i(en_i),
            .clear(total_valid[1]),
            .dsp_valid_i(valid_i),
            .dsp_input_i(temp_i[(8*j)+7:8*j]),
            .dsp_weight_i(din3_i),
            .dsp_output_o(mac_outputs[j]), //32bits
            .dsp_valid_o(mac_valid)
        );
    end
endgenerate
endmodule