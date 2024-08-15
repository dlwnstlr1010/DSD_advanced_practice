module matmul(
input wire clk_i,
input wire rstn_i,
input wire en_i,
input wire valid_i,
input wire [127:0] din_i,
input wire [7:0] win_i,

output wire vld_o,
output wire [32*16-1:0] matmul_o);

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////// Process valid_o signal from each Mac ///////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wire mac_valid;
reg total_valid;

assign vld_o = total_valid;

always @(posedge clk_i or negedge rstn_i) begin
    if (!rstn_i) begin
        total_valid <= 0;
    end
    else begin
        total_valid <= mac_valid;
    end
end
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////// Create a register that lists the final result value ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
wire [31:0] mac_outputs [15:0];

assign matmul_o =   {mac_outputs[15], mac_outputs[14], mac_outputs[13], mac_outputs[12], 
                     mac_outputs[11], mac_outputs[10], mac_outputs[9], mac_outputs[8],
                     mac_outputs[7], mac_outputs[6], mac_outputs[5], mac_outputs[4],
                     mac_outputs[3], mac_outputs[2], mac_outputs[1], mac_outputs[0]};

//"assign matmul_o = assign mac_outputs;" The reason this is not legally allowed is because 
//matmul_o is a signal with a length of 512 bits (32 * 16 = 512), while mac_outputs is an array of 16 32-bit signals.

generate
    genvar i;
    for (i = 0; i < 16 ; i=i+1) begin : mac_inst
        mac mac_inst (
            .clk_i(clk_i),
            .rstn_i(rstn_i),
            .dsp_en_i(en_i),
            .dsp_valid_i(valid_i),
            .dsp_input_i(din_i[i*8+7:i*8]),
            .dsp_weight_i(win_i[7:0]),
            .dsp_valid_o(mac_valid),
            .dsp_output_o(mac_outputs[i])
        );
    end
endgenerate
endmodule