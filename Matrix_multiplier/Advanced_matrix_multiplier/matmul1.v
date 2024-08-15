module matmul1( //Row cacultaion
    input wire clk_i,
    input wire rstn_i,
    input wire en_i,
    input wire valid_i,
    input wire signed [7:0] din1_i, // 8 bits per element
    input wire signed [63:0] din2_i, // The number of bits that 8 mac processes in one cycle is 64 bits
    output wire valid_o,
    output wire signed [63:0] matmul_temp
);

wire mac_valid;
reg total_valid;
integer i;

assign valid_o = total_valid;

always @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i) begin
        total_valid <= 0;
    end
    else begin
        total_valid <= mac_valid;
    end
end

wire [31:0] mac_outputs [7:0];
reg [7:0] intermediate [7:0];

assign matmul_temp = {intermediate[7], intermediate[6], intermediate[5], intermediate[4], intermediate[3], intermediate[2], intermediate[1], intermediate[0]};

always @(posedge clk_i or negedge rstn_i) begin
    if (~rstn_i) begin
        for (i = 0; i < 8; i = i + 1) begin
                intermediate[i] <= 0;
        end
    end
    else begin
        if(valid_o) begin
            for (i = 0; i < 8; i = i + 1) begin
                    intermediate[i] <= mac_outputs[i][7:0]; //This is a grammar that can only retrieve the lower 8 bits.
            end
        end
    end
end

generate
    genvar a;
    for (a = 0; a < 8; a = a + 1) begin
            mac mac_inst (
                .clk_i(clk_i),
                .rstn_i(rstn_i),
                .dsp_en_i(en_i),
                .clear(valid_o),
                .dsp_valid_i(valid_i),
                .dsp_input_i(din1_i),
                .dsp_weight_i(din2_i[(8*a)+7:8*a]), //The dsp_weight_i signal is 8 bits and the din2_i signal is 64 bits. Therefore, the bits corresponding to 8 macs must be divided.
                .dsp_valid_o(mac_valid),
                .dsp_output_o(mac_outputs[a])
            ); 
        end
endgenerate
endmodule