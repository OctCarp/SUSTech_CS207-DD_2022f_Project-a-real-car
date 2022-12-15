`timescale 1ns / 1ps

module power_ctrl(
    input clk,
    input clk_on,
    input rst_off,
    input m1_off,
    output reg power
    );
    
    reg pow=0;
    always@(posedge clk)begin
    power=pow;
        case(pow)
           0: if(clk_on) pow<=1;
           1: if(rst_off||!m1_off ) pow<=0;
    endcase
    end
endmodule
