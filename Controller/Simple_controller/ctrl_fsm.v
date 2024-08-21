module ctrl_fsm (
    input wire clk_i,
    input wire rstn_i,
    input wire start_i,

    output wire [2:0] w_addr_o,
    output wire w_en_o,

    output wire [2:0] x_addr_o,
    output wire x_en_o,

    output wire mac_en_o,
    output wire mac_valid_o,
    output wire done_o);

    localparam IDLE = 2'b00;
    localparam RUN  = 2'b01;
    localparam DONE = 2'b10;

    reg [1:0] present_state, next_state;
    
    reg [3:0] cnt_mac;
    reg [2:0] w_addr;
    reg w_en;
    reg [2:0] x_addr;
    reg x_en;
    reg mac_en;
    reg mac_valid;
    reg done;

    assign w_addr_o = w_addr;
    assign w_en_o = w_en;
    assign x_addr_o = x_addr;
    assign x_en_o = x_en;
    assign mac_en_o = mac_en;
    assign mac_valid_o = mac_valid;
    assign done_o = done;

    //Logic that controls movement of the state
    always @(posedge clk_i or negedge rstn_i) begin
        if (~rstn_i) begin
            present_state <= IDLE;
        end
        else begin
            present_state <= next_state;
        end
    end

    //Logic representing the relationship between these three states: IDLE, RUN, and DONE
    always @(posedge clk_i or negedge rstn_i) begin
        case (present_state)
        IDLE : begin
            if (start_i) begin
                next_state <= RUN;
            end
            else begin
                next_state <= IDLE;
            end
        end
        RUN : begin
            if(cnt_mac == 8) begin
                next_state <= DONE;
            end
            else begin
                next_state <= RUN;
            end
        end 
        DONE : begin
            next_state <= DONE;
        end
        default: next_state <= IDLE; 
        endcase
    end

    //Reason for the existence of a controller:
    //How control signals are placed for each situation and counting
    always @(posedge clk_i or negedge rstn_i) begin
        if (~rstn_i) begin
            present_state <= IDLE;
            next_state <= IDLE;
            cnt_mac <= 0;
            w_addr <= 0;
            w_en <= 0;
            x_addr <= 0;
            x_en <= 0;
            mac_en <= 0;
            mac_valid <= 0;
            done <= 0;
        end
        else begin
            case (present_state)
            IDLE : begin
                cnt_mac <= 0;
                w_addr <= 0;
                w_en <= 0;
                x_addr <= 0;
                x_en <= 0;
                mac_en <= 0;
                mac_valid <= 0;
                done <= 0;
            end
            RUN : begin //When the start_i signal is activated, it moves to RUN state.
                w_en <= 1;
                x_en <= 1;
                if (w_en && x_en) begin
                    cnt_mac <= cnt_mac + 1;
                    w_addr <= w_addr + 1;
                    x_addr <= x_addr + 1;
                    mac_en <= 1;
                    mac_valid <= 1;
                    done <= 0;
                        if (cnt_mac == 8) begin
                            cnt_mac <= 0;
                            w_addr <= 0;
                            w_en <= 0;
                            x_addr <= 0;
                            x_en <= 0;
                            mac_en <= 0;
                            mac_valid <= 0;
                            done <= 1;
                    end
                end
            end
            DONE : begin
                cnt_mac <= 0;
                w_addr <= 0;
                w_en <= 0;
                x_addr <= 0;
                x_en <= 0;
                mac_en <= 0;
                mac_valid <= 0;
                done <= 0;
            end
            default: begin
                cnt_mac <= 0;
                w_addr <= 0;
                w_en <= 0;
                x_addr <= 0;
                x_en <= 0;
                mac_en <= 0;
                mac_valid <= 0;
                done <= 0;
            end
            endcase
        end
    end
endmodule