`timescale 1ns / 1ps

module mydiv_ms(clk,clk_ms);
    input clk;
    output clk_ms;
    reg clk_ms = 0;
    reg[31:0] ms_cnt=0;

    always@(posedge clk)
    begin
        if (ms_cnt == 26'd50000)
        begin
            clk_ms = ~clk_ms;
            ms_cnt = 0;
        end
        else
            ms_cnt = ms_cnt + 1'b1;
    end
endmodule
