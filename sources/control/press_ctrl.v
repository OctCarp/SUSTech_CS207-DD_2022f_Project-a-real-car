`timescale 1ns / 1ps

module press_ctrl(
    input clk,
    input rst_on,
    output reg clk_on
    );

    wire clk_ms;
    mydiv_ms ms(.clk(clk),.clk_ms(clk_ms));
    
    reg[10:0] cnt=0;
    always@(posedge clk_ms, negedge rst_on)begin
        if (!rst_on)begin
            cnt<= 10'b0;clk_on<=0;
        end
        else if (cnt == 1000)begin
         clk_on=1;
            cnt<= 0;
           end
           else begin
           cnt=cnt+1'b1;
           end
    end
endmodule
