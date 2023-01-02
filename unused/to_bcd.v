//this module is learn from webstie
`timescale 1ns / 1ps

module to_bcd(
    input clk,
    input rst_n,
    input [7:0] data_bin,
    output reg [11:0] data_bcd,
    output reg data_bcd_valid,
    input en
    );
   
    
reg [2:0] state, next_state;
reg [3:0] num;
reg flag;
reg [11:0] bcd_buf;
reg  [7:0] data_bin_reg;
parameter IDLE = 3'd1;
parameter SHIFT = 3'd2;
parameter JUDGE = 3'd3;
parameter ADD = 3'd4;
parameter DONE = 3'd5;
reg [1:0] wait_cnt;

always@(posedge clk or negedge rst_n)begin
    if(!rst_n)begin
        bcd_buf <= 12'd0; 
        data_bcd <= 12'd0;
        state <= IDLE;
        num <= 4'd0;
        data_bcd_valid <= 0;
    end
    else begin
        case(state)
            IDLE:begin
                num <= 4'd0;
                data_bcd_valid <= 0;
                data_bin_reg <= data_bin ;
                bcd_buf <= 12'd0; 
                data_bcd <= 12'd0;
                if(en)
                    state <= SHIFT;
                else
                    state <= IDLE;
            end
            SHIFT:begin
                bcd_buf <= bcd_buf << 1;
                data_bin_reg <= data_bin_reg << 1;
                bcd_buf[0] <= data_bin_reg[7];
                num <= num + 4'd1;
                if(num == 4'd7)begin
                    state <= DONE;
                end
                else 
                    state <= JUDGE;
            end
            JUDGE:begin
                if(bcd_buf[11:8]>4 || bcd_buf[7:4]>4 || bcd_buf[3:0]>4)
                    state <=  ADD;
                else 
                    state <= SHIFT;
            end
            ADD:begin
                if(bcd_buf[11:8]>4)
                    bcd_buf[11:8] <= bcd_buf[11:8] + 4'd3;
                if(bcd_buf[7:4]>4)
                    bcd_buf[7:4] <= bcd_buf[7:4] + 4'd3;
                if(bcd_buf[3:0]>4)
                    bcd_buf[3:0] <= bcd_buf[3:0] + 4'd3;
                state <= SHIFT;            
            end
            DONE:begin
               state <=  IDLE;   
               data_bcd <= bcd_buf; 
               data_bcd_valid <= 1'd1;       
            end
            default:begin
                bcd_buf <= bcd_buf; 
                data_bcd <= data_bcd; 
                data_bcd_valid <= 1'd0;
                state <= IDLE;
                num <= 3'd0;
            end
        endcase
    end
end
endmodule
