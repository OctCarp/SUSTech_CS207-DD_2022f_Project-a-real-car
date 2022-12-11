`timescale 1ns / 1ps

/*
数据输入输出规则：

EGO1发送给软件的8bit数据，前4bit一次对应四种操作：前进、后退、左转、右转。最高bit为验证位，必须保持1，否则软件会主动断连。

EGO1接收到的8bit数据，前4bit对应前左右后四个传感器的信号，实时更新，后4bit暂时没用。（其中后方信号因为没啥用，所以暂时没开）

*/
module uart_top(
    input clk,//时钟输入
    input rst,
    input[7:0] data_in, //数据输入
    output[7:0] data_rec,//段码
    input rxd,  //数据接收 
    output txd //数据发送
); 

wire clk_ms,clk_20ms,clk_16x,clk_x;
wire data_ready;//数据是否准备好
wire data_error;
wire send_ready;

reg send = 0;
always @(posedge clk_ms) 
    send = ~send;
    
//调用分频模块
//clk 输入时钟50Mhz
//clk_ms 输出时钟1Khz
//clk_20ms 输出时钟50Hz
//clk_x 输出时钟9600Hz
//clk_16x 输出时钟9600hz*16
divclk my_divclk(
    .clk(clk),
    .clk_ms(clk_ms),
    .btnclk(clk_20ms),
    .clk_16x(clk_16x),
    .clk_x(clk_x)
);

uart_tx tx(//调用串口发送模块
    .clk_x(clk_x),
    .rst(rst),
    .data_in({1'b1,data_in[6:0]}),
    .send(send),
    .trans_done(send_ready),
    .txd(txd)
    );
uart_rx rx(
    .clk_16x(clk_16x),
    .rst(rst),
    .rxd(rxd),
    .data_rec(data_rec),
    .data_ready(data_ready),
    .data_error(data_error)
);
endmodule

