module MAC(
input wire clk_i,
input wire rstn_i,
input wire dsp_enable_i,
input wire dsp_valid_i,
input wire signed [7:0] dsp_input_i,
input wire signed [7:0] dsp_weight_i,

output wire signed [31:0] dsp_output_o,
output wire dsp_valid_o);

reg signed [30:0] partial_sum;

reg [1:0] delay_dsp_valid_o;
reg [31:0] dsp_output;
wire [31:0] dsp_temp;

assign dsp_valid_o = delay_dsp_valid_o[1];
assign dsp_output_o = dsp_output;

//STEP1: Handling partial sums (it is important to use the dsp_temp variable)
always@(posedge clk_i or negedge rstn_i) begin
    if(!rstn_i) begin
            partial_sum <= 0;
    end
    else begin
            partial_sum <= $signed({dsp_temp[31], dsp_temp[29:0]});
    end
end

//STEP2: Code to push the dsp_valid_o signal one clock
always @(posedge clk_i or negedge rstn_i) begin
    if(!rstn_i) begin
        delay_dsp_valid_o <= 0;
    end
    else begin
        delay_dsp_valid_o[0] <= dsp_valid_i;
        delay_dsp_valid_o[1] <= delay_dsp_valid_o[0];
    end
end

//STEP3: Code that derives the final output according to the dsp_valid_o signal
always @(posedge clk_i or negedge rstn_i) begin
    if (delay_dsp_valid_o[1]) begin
        dsp_output <= dsp_temp;
    end
    else begin
        dsp_output <= 0;
    end
end

xbip_dsp48_macro_0 DSP_for_MAC (
  .CLK(clk_i),  // input wire CLK
  .CE(dsp_enable_i),    // input wire CE
  .A(dsp_input_i),      // input wire [7 : 0] A
  .B(dsp_weight_i),      // input wire [7 : 0] B
  .C(partial_sum),      // input wire [30 : 0] C
  .P(dsp_temp)      // output wire [31 : 0] P
);
endmodule