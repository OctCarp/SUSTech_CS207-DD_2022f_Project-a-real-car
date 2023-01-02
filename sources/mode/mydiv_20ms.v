`timescale 1ns / 1ps

module mydiv_20ms(clk,clk_20ms);
    input clk;
    output clk_20ms;
    reg clk_20ms = 0;
    reg[31:0] ms_cnt=0;
    
    always@(posedge clk)
    begin
        if (ms_cnt == 26'd500000)
        begin
            clk_20ms = ~clk_20ms;
            ms_cnt = 0;
        end
        else
            ms_cnt = ms_cnt + 1'b1;
    end
endmodule
