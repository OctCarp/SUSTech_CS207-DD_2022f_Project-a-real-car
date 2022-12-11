`timescale 1ns / 1ps

module SimulatedDevice(
    input sys_clk, //bind to P17 pin (100MHz system clock)
    input rx, //bind to N5 pin
    output tx, //bind to T4 pin
    
    input turn_left_signal,
    input turn_right_signal,
    input move_forward_signal,
    input move_backward_signal,
    input place_barrier_signal,
    input destroy_barrier_signal,
    output front_detector,
    output back_detector,
    output left_detector,
    output right_detector
    );
    wire [7:0] in = {2'b10, destroy_barrier_signal, place_barrier_signal, turn_right_signal, turn_left_signal, move_backward_signal, move_forward_signal};
    wire [7:0] rec;
    assign front_detector = rec[0];
    assign left_detector = rec[1];
    assign right_detector = rec[2];
    assign back_detector = rec[3];
    
    uart_top md(.clk(sys_clk), .rst(0), .data_in(in), .data_rec(rec), .rxd(rx), .txd(tx));
    
endmodule
