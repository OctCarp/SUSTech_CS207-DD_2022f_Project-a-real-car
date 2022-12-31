`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/30 00:10:04
// Design Name: 
// Module Name: Turn_led
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Turn_led(
input clk,
input[1:0] turn_led,
output reg [1:0] turn_led_out
);

reg[8:0] cnt1=0;
reg[8:0] cnt2=0;
wire clk_20ms;
mydiv_20ms ms20(.clk(clk),.clk_20ms(clk_20ms));
always@(posedge clk_20ms)
begin
if(turn_led[0]==1'b1)begin
    if (cnt1 == 10) begin
       turn_led_out[0] = ~turn_led_out[0];
       cnt1 = 0;
    end else begin
       cnt1 = cnt1 + 1'b1;
    end
end else begin
    turn_led_out[0]=0;
end
if(turn_led[1]==1'b1)begin
    if (cnt2 == 10) begin
       turn_led_out[1] = ~turn_led_out[1];
       cnt2 = 0;
    end else begin
       cnt2 = cnt2 + 1'b1;
    end
end else begin
    turn_led_out[1]=0;
end

end

endmodule
