`timescale 1ns / 1ps

module mydiv_2ms(clk,clk_2ms);
    input clk;
    output reg clk_2ms;
    reg[31:0] cnt=0;

    always@(posedge clk)
    begin
        if (cnt == 100000)
        begin
            clk_2ms = ~clk_2ms;
            cnt = 0;
        end
        else
            cnt = cnt + 1'b1;
    end
endmodule
