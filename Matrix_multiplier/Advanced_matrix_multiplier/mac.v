module mac(
    input wire clk_i,
    input wire rstn_i,
    input wire dsp_en_i,
    input wire dsp_valid_i,
    input wire clear, //When the Mac completes the operation for one row, it initializes the results so that they do not accumulate.
    input wire signed [7:0] dsp_input_i, //8 bits
    input wire signed [7:0] dsp_weight_i, //8 bits
    output wire signed [31:0] dsp_output_o,
    output wire dsp_valid_o);

    reg signed [30:0] partial_sum;
    reg [1:0] delay_dsp_valid_o;
    reg [31:0] dsp_output;
    wire [31:0] dsp_temp;
    reg clear_delay;

    assign dsp_valid_o = delay_dsp_valid_o[1];
    assign dsp_output_o = dsp_output;
    
    always @(posedge clk_i or negedge rstn_i) begin
        if(~rstn_i) begin
            partial_sum <= 0;
        end
        else if(clear_delay) begin
            partial_sum <= 0;
        end
        else begin
            partial_sum <= $signed({dsp_temp[31], dsp_temp[29:0]});
        end
    end

    always @(posedge clk_i or negedge rstn_i) begin
        if (~rstn_i) begin
            delay_dsp_valid_o <= 0;
            clear_delay <= 0;
        end
        else begin
            delay_dsp_valid_o[0] <= dsp_valid_i;
            delay_dsp_valid_o[1] <= delay_dsp_valid_o[0];
            clear_delay <= clear;
            //Originally, I thought that the valid_o signal could be used as a clear signal, but there was an error in the partial sum value.
            //So I thought I should delay one more clock by analyzing the waveform. Analyzing waveforms is very important.
        end
    end

    always @(posedge clk_i or negedge rstn_i ) begin
        if(delay_dsp_valid_o[1]) begin
            clear_delay <= 0;
            dsp_output <= dsp_temp;
        end
        else begin
            dsp_output <= 0;
        end
    end

    xbip_dsp48_macro_0 dsp_for_mac(
    .CLK(clk_i),  // input wire CLK
    .CE(dsp_en_i),    // input wire CE
    .A(dsp_input_i),      // input wire [7 : 0] A
    .B(dsp_weight_i),      // input wire [7 : 0] B
    .C(partial_sum),      // input wire [30 : 0] C
    .P(dsp_temp)      // output wire [31 : 0] P 
    );
endmodule