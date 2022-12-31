`timescale 1ns / 1ps

module mydiv_25M(clk,clk_25M);
    input clk;
    output clk_25M;
    reg clk_25M = 0;
    reg [2:0] cnt_25M = 3'b000;

    always@(posedge clk)
    begin
        if (cnt_25M == 3'b100)
        begin
            clk_25M = ~clk_25M;
            cnt_25M = 0;
        end
        else
            cnt_25M = cnt_25M + 1'b1;
    end
endmodule
