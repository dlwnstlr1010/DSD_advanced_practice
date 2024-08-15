module top(
    input wire clk_i,
    input wire rstn_i,
    input wire en_i,
    input wire valid_i,
    input wire valid_i_2,
    input wire signed [7:0] din1_i,
    input wire signed [63:0] din2_i,
    input wire signed [7:0] din3_i,
    output wire vld_o,
    output wire signed [255:0] matmul_o
    );

//Why should you use wire type in the top module?
//It is impossible to instigate  �sub-modules to sub-modules   in the top module.
//Therefore, by declaring a wire-type variable within the top module, a commonly shared port is created.
wire valid1_o;
wire signed [63:0] result_matmul_1;
wire signed [63:0] result_storage;

matmul1 matmul1_inst (
    .clk_i(clk_i),
    .rstn_i(rstn_i),

    // Input Control Signal
    .en_i(en_i),        // mac enable signal
    .valid_i(valid_i),  // mac valid_o signal

    // Input Data
    .din1_i(din1_i),    // 8bit Input din1
    .din2_i(din2_i),    // 64bit Input din2 (8bit * 8pcs)

    // Output Signal & Calc. Result
    .valid_o(valid1_o),         
    .matmul_temp(result_matmul_1)   // 64bit Output signal (8bit * 8pcs)
);

storage storage_inst(
    .clk_i(clk_i),
    .rstn_i(rstn_i),

    .wr_en(valid1_o),               // Write Enable Signal (Provided Matmul_1)
    
    .matmul_temp(result_matmul_1),      // Input Data: 8bit * 8pcs = 64bit
    .matmul_temp_o(result_storage)   // Output Data: 8bit * 8pcs = 64bit
);

matmul2 matmul2_inst (
    .clk_i(clk_i),
    .rstn_i(rstn_i),

    .en_i(en_i),
    .valid_i(valid_i_2),       //i want another......!   

    .temp_i(result_storage),     //64bit Input Data
    .din3_i(din3_i),            //8bit Input Data

    .valid_o(vld_o),            
    .matmul_o(matmul_o)         // Output 32bit * 8pcs : 256bit
);
endmodule