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
    
    input choo_m,
    input rst_off,
    
    output on,
    
    output[7:0] mile_seg,
    output[2:0] an,
    output[1:0] mode_led,
    output[1:0] turn_led,

    output [3:0] red,
    output [3:0] green,
    output [3:0] blue,
    output hs,
    output vs
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
    wire [11:0] mile_bcd;
    wire [3:0] m1_state;
    assign mode_led=mode;
    

    wire clk_on;
    wire [7:0] ori_sig = {brake_in,clutch_in, destroy_barrier_in, place_barrier_in, turn_right_in, turn_left_in, move_backward_in, move_forward_in};
    wire [7:0] sig;
    wire [7:0] sig1;
    wire [7:0] sig2;
    wire [7:0] sig3;
    
    wire [7:0] rec;
    press_ctrl pre(.clk(sys_clk_in),.rst_on(rst_on),.clk_on(clk_on));
    power_ctrl pow(.clk(sys_clk_in),.clk_on(clk_on),.rst_off(rst_off),.power(on),.m1_off(m1_off));
    mode_choose choose(.clk(sys_clk_in),.choose(choo_m),.power(on),.mode(mode));
    mile mile(.mode(mode), .clk(sys_clk_in), .sig(sig), .led_seg(mile_seg),.an(an),.bcd_out(mile_bcd));
    
    Turn_led t_led(.clk(sys_clk_in),.turn_led(sig[3:2]),.turn_led_out(turn_led));
    
    assign front_detector_out = rec[0];
    assign left_detector_out = rec[1];
    assign right_detector_out = rec[2];
    assign back_detector_out = rec[3];
    
    assign sig=sig1+sig2+sig3;
    
    Manual_Driving drive(.clk(sys_clk_in),.in(ori_sig),.mode(mode),.out(sig1),.p(m1_off),.state(m1_state));
    Semi_Auto_Driving sdrive(.clk(sys_clk_in),.power(on),.in(ori_sig),.mode(mode),.rec(rec),.out(sig2));
    Auto_Driving adrive(.clk(sys_clk_in),.power(on),.mode(mode),.rec(rec),.out(sig3));
    
    vga v(.clk(sys_clk_in), .rst(1), .power(on), .mode(mode), .state(m1_state), .mile(mile_bcd), .r(red), .g(green), .b(blue), .vs(vs), .hs(hs));

    SimulatedDevice device(.sys_clk(sys_clk_in),.rst(0), .rx(rx_in), .tx(tx_out), .signal(sig), ._rec(rec));
    
endmodule
