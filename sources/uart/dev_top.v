`timescale 1ns / 1ps

module SimulatedDevice(
    input sys_clk, //bind to P17 pin (100MHz system clock)
    input rst,
    input rx, //bind to N5 pin
    output tx, //bind to T4 pin
    
    input[7:0] signal,
    output[7:0] _rec
    );
  
    uart_top md(.clk(sys_clk), .rst(0), .data_in(signal), .data_rec(_rec), .rxd(rx), .txd(tx));
    
endmodule
