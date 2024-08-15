module storage(
    input wire clk_i,
    input wire rstn_i,
    input wire wr_en,
    input wire signed [63:0] matmul_temp, //The result obtained after the operation for one row in the matmul1.
    output reg signed [63:0] matmul_temp_o,
    output reg bram_done); //When discharging the results accumulated in bram, rows must be converted to columns.

    reg [63:0] bram [7:0];
    reg delay_wr_en;
    integer write_index; //Integer-type variables can also use non-blocking assignment.
    integer read_index;
    reg index_full;

    always @(posedge clk_i or negedge rstn_i) begin
        if (~rstn_i) begin
            delay_wr_en <= 0;
        end
        else begin
            delay_wr_en <= wr_en;
        end
    end
    
    always @(posedge clk_i or negedge rstn_i) begin
        if (~rstn_i) begin
            for (write_index = 0; write_index < 8; write_index = write_index + 1) begin
                bram[write_index] <= 0;
                index_full <= 0;
            end
            write_index <= 0;
            bram_done <= 0;
        end
        else begin
            if (delay_wr_en && !index_full) begin
                bram[write_index] <= matmul_temp;

                if (write_index == 7) begin
                    write_index <= 0;
                    bram_done <= 1;
                    index_full <= 1;
                    
                end
                else begin
                   write_index <= write_index + 1;
                end

            end
        end
    end

    always @(negedge clk_i or negedge rstn_i) begin
        if (~rstn_i) begin
            matmul_temp_o <= 0;
            read_index <= 0;
        end
        else begin
            if (bram_done) begin
                matmul_temp_o <= {bram[0][(7-read_index)*8 +: 8], bram[1][(7-read_index)*8 +: 8], bram[2][(7-read_index)*8 +: 8], bram[3][(7-read_index)*8 +: 8], bram[4][(7-read_index)*8 +: 8], bram[5][(7-read_index)*8 +: 8], bram[6][(7-read_index)*8 +: 8], bram[7][(7-read_index)*8 +: 8]};
                if (read_index == 8) begin
                    read_index <= 0;
                    bram_done <= 0;
                end
                else begin
                    read_index <= read_index + 1;
                end
            end
        end
    end
endmodule