module mac(
    input wire clk_i,
    input wire rstn_i,
    input wire dsp_enable_i,
    input wire dsp_valid_i,

    input wire signed [7:0] dsp_input_i,
    input wire signed [7:0] dsp_weight_i,

    output wire signed [31:0] dsp_output_o,
    output wire dsp_valid_o);

    reg signed [30:0] partial_sum;
    reg signed [31:0] dsp_output;
    wire signed [31:0] dsp_temp;
    
    reg delay_dsp_valid_i;

    assign dsp_output_o = dsp_output;
    assign dsp_valid_o = delay_dsp_valid_i; //Why valid_i and valid_o always exist together.

    always @(posedge clk_i or negedge rstn_i) begin
        if (~rstn_i) begin
            partial_sum <= 0;
        end
        else begin
            partial_sum <= $signed({dsp_temp[31], dsp_temp[29:0]});
        end
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if (~rstn_i) begin
            delay_dsp_valid_i <= 0;
        end
        else begin
            delay_dsp_valid_i <= dsp_valid_i; 
        end
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if (~rstn_i) begin
            dsp_output <= 0;
        end
        else if (delay_dsp_valid_i) begin
            dsp_output <= dsp_temp;
        end
        else begin
            dsp_output <= 0;
        end
    end

    xbip_dsp48_macro_0 DSP_for_MAC (
    .CLK(clk_i),             // Clock input
    .CE(dsp_enable_i),       // DSP enable signal input
    .A(dsp_input_i),         // Data input A
    .B(dsp_weight_i),        // Weight input B
    .C(partial_sum),         // Partial sum input C
    .P(dsp_temp)             // DSP output
);
endmodule