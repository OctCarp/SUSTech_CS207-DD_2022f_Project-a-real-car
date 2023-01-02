`timescale 1ns / 1ps

module Semi_Auto_Driving(
    input clk,
    input power,
    input [7:0] in,
    input [1:0] mode,
    input [7:0] rec,
    output [7:0] out
);
wire gofront,goback,turnleft,turnright;
assign gofront=in[0];
assign goback=in[1];
assign turnleft=in[2];
assign turnright=in[3];


wire front_detector;
wire back_detector;
wire left_detector;
wire right_detector;   
assign front_detector = rec[0];
assign left_detector = rec[1];
assign right_detector = rec[2];
assign back_detector = rec[3];
 
reg activation; 
reg [3:0] rlbf;

reg [3:0] state=4'b0000;
reg [3:0] nextstate=4'b0000;
parameter S0=4'b0000,S1=4'b0001,S2=4'b0010,S3=4'b0100,S4=4'b1000;

reg[8:0] cnt=0;
wire clk_20ms;
mydiv_20ms ms20(.clk(clk),.clk_20ms(clk_20ms));

always@(posedge clk)
begin
if(mode==2'b10)
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
    end else
    begin
    case (state)
    
    S0:begin
    rlbf=4'b0000;
        if(gofront)begin
            state=S1;
        end else if(goback)begin
            state=S2;
        end else if(turnleft)begin
            state=S3;
        end else if(turnright)begin
            state=S4;
        end else begin
            state=S0;
        end
    end
    
    S1:begin
    rlbf=4'b0001;
        if (cnt ==30)begin
            cnt = 0;
            if(((!left_detector||!right_detector)&&!front_detector)||(!left_detector&&!right_detector))begin
               state=S0;
            end else if(left_detector&&right_detector&&front_detector)begin
               state=S2;
            end else if(!left_detector&&right_detector&&front_detector)begin
               state=S3;
            end else if(left_detector&&!right_detector&&front_detector)begin
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
            state=S1;
        end else begin
            cnt = cnt+1'b1;
            state=S4;
        end
    end
    
    endcase
    end  
end
assign out[3:0]=rlbf;  

endmodule
