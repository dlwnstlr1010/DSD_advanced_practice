module top(
    input wire clk_i,
    input wire rstn_i,
    input wire start_i,

    output wire done_o,
    output wire [31:0] acc_o);

    //mac variable
    wire w_mac_en;
    wire dsp_valid;
    wire [7:0] w_x_data;
    wire [7:0] w_w_data;
    wire [31:0] w_acc;
    
    //bram variable
    wire [2:0] w_w_addr;
    wire w_w_en;
    wire [2:0] w_x_addr;
    wire w_x_en;

    //controller variable
    wire w_done;

    assign done_o = w_done;
    assign acc_o = w_acc;

    
    ctrl_fsm ctrl_fsm_inst(
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .start_i(start_i),

        .w_addr_o(w_w_addr),
        .w_en_o(w_w_en),

        .x_addr_o(w_x_addr),
        .x_en_o(w_x_en),

        .mac_en_o(w_mac_en),
        .mac_valid_o(dsp_valid),

        .done_o(w_done));

    xilinx_true_dual_port_no_change_1_clock_ram #(
        .RAM_WIDTH(8),                       // Specify RAM data width
        .RAM_DEPTH(8),                       // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"),     // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("C:/Users/dlwns/solo/Advanced_practice3/Advanced_practice3_1/Advanced_practice3_1/Advanced_practice3_1.srcs/w_bram.txt") // Specify name/location of RAM initialization file if using one (leave blank if not)
    ) w_bram (
        .clka(clk_i),
        .rsta(),
        .rstb(),
        .dina(),
        .dinb(),
        .ena(w_w_en),
        .enb(),
        .addra(w_w_addr),
        .addrb(),
        .wea(),
        .web(),
        .regcea(),
        .regceb(),
        .douta(w_w_data),
        .doutb());

    xilinx_true_dual_port_no_change_1_clock_ram #(
        .RAM_WIDTH(8),                       // Specify RAM data width
        .RAM_DEPTH(8),                       // Specify RAM depth (number of entries)
        .RAM_PERFORMANCE("LOW_LATENCY"),     // Select "HIGH_PERFORMANCE" or "LOW_LATENCY" 
        .INIT_FILE("C:/Users/dlwns/solo/Advanced_practice3/Advanced_practice3_1/Advanced_practice3_1/Advanced_practice3_1.srcs/x_bram.txt") // Specify name/location of RAM initialization file if using one (leave blank if not)
    ) x_bram (
        .clka(clk_i),
        .rsta(),
        .rstb(),
        .dina(),
        .dinb(),
        .ena(w_x_en),
        .enb(),
        .addra(w_x_addr),
        .addrb(),
        .wea(),
        .web(),
        .regcea(),
        .regceb(),
        .douta(w_x_data),
        .doutb());

    mac mac_inst(
        .clk_i(clk_i),
        .rstn_i(rstn_i),
        .dsp_enable_i(w_mac_en),
        .dsp_valid_i(dsp_valid),
        .dsp_input_i(w_w_data),
        .dsp_weight_i(w_x_data),
        .dsp_output_o(w_acc));
endmodule