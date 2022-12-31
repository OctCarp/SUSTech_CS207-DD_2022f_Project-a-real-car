`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/12/27 00:36:30
// Design Name: 
// Module Name: Auto_Driving
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


module Auto_Driving(
    input clk,
    input power,
    input [1:0] mode,
    input [7:0] rec,
    output [7:0] out
    //output reg p
);

wire front_detector;
wire back_detector;
wire left_detector;
wire right_detector;
reg destroy_barrier_in=1'b0;
reg place_barrier_in=1'b0;  
assign front_detector = rec[0];
assign left_detector = rec[1];
assign right_detector = rec[2];
assign back_detector = rec[3];


reg activation; 
reg [3:0] rlbf;

reg [3:0] state=4'b0000;
reg [3:0] nextstate=4'b0000;
parameter S0=4'b0000,S1=4'b0001,S2=4'b0010,S3=4'b0100,S4=4'b1000,S5=4'b1001,S6=4'b1010;

reg[8:0] cnt=0;
wire clk_20ms;
mydiv_20ms ms20(.clk(clk),.clk_20ms(clk_20ms));

always@(posedge clk)
begin
if(mode==2'b11)
    activation=1'b1;
else
    activation=1'b0;
    
end

always@(posedge clk_20ms)
if(!power)begin
    state=S0;
    rlbf=4'b0000;
end else begin
    if(!activation)begin
        state=S0;
        rlbf=4'b0000;
        //p=1;
    end else
    begin
    //p=1;
    case (state)
    S0:begin
    rlbf=4'b0000;
        if(cnt ==250)begin
            cnt= 0;
            /*if(right_detector&&!front_detector)begin
               state=S1;
            end else if(left_detector&&right_detector&&front_detector)begin
               state=S2;
            end else if(!left_detector&&right_detector&&front_detector)begin
               state=S3;
            end else if(!right_detector)begin
               state=S4;
            end else begin
               state=S1;
            end*/
            state=S1;   
        end else begin
            cnt=cnt+1'd1; 
            state=S0;             
        end
    end
    
    S1:begin
    rlbf=4'b0001;
        if (cnt ==30)begin
            cnt = 0;
            if(right_detector&&!front_detector)begin
               state=S1;
            end else if(left_detector&&right_detector&&front_detector)begin
               destroy_barrier_in=1'b1;
               state=S2;
            end else if(!left_detector&&right_detector&&front_detector)begin
               state=S3;
            end else if(!right_detector)begin
               state=S4;
            end else begin
               state=S1;
            end
        end else begin
            cnt = cnt+1'b1;
            state=S1;
        end
    end
    
    S2:begin
    rlbf=4'b0100;
    
        if(cnt ==180)begin
            cnt= 0;
            destroy_barrier_in=1'b0;
            state=S1;
        end else begin
            cnt=cnt+1'd1; 
            state=S2;             
        end
    end
    
    
    S3:begin
    rlbf=4'b0100;
        if (cnt ==90)begin
            cnt = 0;
            state=S1;
        end else begin
            cnt = cnt+1'b1;
            state=S3;
        end
    end
    
    S4:begin
    rlbf=4'b1000;
        if (cnt ==90)begin
            cnt = 0;
            state=S5;
        end else begin
            cnt = cnt+1'b1;
            state=S4;
        end
    end
    
    S5:begin
    rlbf=4'b0001;
        if (cnt ==65)begin 
            place_barrier_in=1'b1;
            cnt = cnt+1'b1;
            state=S5;
        end else if(cnt==70)begin
            cnt = 0;
            place_barrier_in=1'b0;
            state=S1;
        end else begin
            cnt = cnt+1'b1;
            state=S5;
        end
    end
    
    S6:begin
    
    
    end
    endcase
    end  
end
assign out[3:0]=rlbf;
assign out[5]= destroy_barrier_in;
assign out[4]= place_barrier_in;



endmodule
