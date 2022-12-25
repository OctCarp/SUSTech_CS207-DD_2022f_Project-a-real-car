`timescale 1ns / 1ps

module Global_top(
    input sys_clk_in, //bind to P17 pin (100MHz system clock)
    input rx_in, //bind to N5 pin
    output tx_out, //bind to T4 pin
    
    input rst_on,
    input turn_left_in,
    input turn_right_in,
    input move_forward_in,
    input move_backward_in,
    input place_barrier_in,
    input destroy_barrier_in,
    input clutch_in,
    input brake_in,
    
    output front_detector_out,
    output left_detector_out,
    output right_detector_out,
    output back_detector_out,

    input turn_l,
    input turn_r,
    
    input choo_m,
    input rst_off,
    
    output on,
    
    output[7:0] mile_seg,
    output[2:0] an,
    output[1:0] mode_led,
    output[1:0] turn_led
    );

    wire turn_left_signal;
    wire turn_right_signal;
    wire move_forward_signal;
    wire move_backward_signal;
    wire place_barrier_signal;
    wire destroy_barrier_signal;
    wire front_detector;
    wire back_detector;
    wire left_detector;
    wire right_detector;
    wire m1_off;
    
    wire[1:0] mode;
    assign mode_led=mode;
    
    
    wire clk_on;
    wire [7:0] ori_sig = {brake_in,clutch_in, destroy_barrier_in, place_barrier_in, turn_right_in, turn_left_in, move_backward_in, move_forward_in};
    wire [7:0] sig;
    assign turn_led[0]=sig[2];
    assign turn_led[1]=sig[3];
    wire [7:0] rec;
    press_ctrl pre(.clk(sys_clk_in),.rst_on(rst_on),.clk_on(clk_on));
    power_ctrl pow(.clk(sys_clk_in),.clk_on(clk_on),.rst_off(rst_off),.power(on),.m1_off(m1_off));
    mode_choose choose(.clk(sys_clk_in),.choose(choo_m),.power(on),.mode(mode));
    mile mile(.mode(mode), .clk(sys_clk_in), .sig(sig), .led_seg(mile_seg),.an(an));
    
    Manual_Driving drive(.clk(sys_clk_in),.in(ori_sig),.mode(mode),.out(sig),.p(m1_off));
    
    assign front_detector_out = rec[0];
    assign left_detector_out = rec[1];
    assign right_detector_out = rec[2];
    assign back_detector_out = rec[3];
    
    SimulatedDevice device(.sys_clk(sys_clk_in),.rst(0), .rx(rx_in), .tx(tx_out), .signal(sig), ._rec(rec));
    
endmodule
