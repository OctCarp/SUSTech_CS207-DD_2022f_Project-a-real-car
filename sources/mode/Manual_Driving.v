`timescale 1ns / 1ps

module Manual_Driving(
    input clk,
    input [7:0] in,
    input [1:0] mode,
    output reg [3:0] state=4'b0000,
    output [7:0] out,
    output  reg p
);
wire throttle,clutch,brake,reversegear,turnleft,turnright;
assign throttle=in[0];
assign clutch=in[6];
assign brake=in[7];
assign reversegear=in[1];
assign turnleft=in[2];
assign turnright=in[3];

reg activation;
reg[1:0] bf;
reg[1:0] tlr;

parameter T0=4'b0000,
S0=4'b0001, 
S1=4'b0010, 
S2=4'b0011, 
S3=4'b0100, 
S4=4'b0101, 
S5=4'b0110, 
S6=4'b0111; 

reg [1:0] LR;
parameter
q1=2'b00,
q2=2'b01,
q3=2'b10,
q4=2'b11;

always@(posedge clk)
begin
if(mode==2'b01)
    activation=1'b1;
else
    activation=1'b0;
    
end

always@(posedge clk)
    if(!activation) begin
        state=T0;
        bf=2'b00;
        p=1;
    end else
    case (state)
    S0:begin
    bf=2'b00;
        if(clutch) begin
            state=S5;p=1;
        end else if(brake) begin
            p=1;
        end else if(throttle)begin
            state=T0;p=0;
        end
    end

    S5: begin
    bf=2'b00;
        if(throttle) begin
            state=S1;p=1;
        end else if(!clutch) begin
            state=S0;p=1; 
        end
    end

    S1: begin
    bf=2'b00;
        if(clutch) begin 
            state=S3;p=1;
        end else if(reversegear)begin
            state=T0;p=0;
        end else if(throttle) begin
            state=S2;p=1;
        end
    end

    S2:begin
        bf=2'b01;
        if(reversegear)begin
           state=T0;p=0;
        end
        else if(brake) begin
           state=S0;p=1;
        end else if(clutch) begin
           state=S3;p=1;
        end else if(!throttle) begin
         state=S1; p=1;
        end
    end
    
    S3:begin
    bf=2'b00;
        if (!clutch) begin
            if(reversegear)begin
                state=S4;p=1;
            end else begin
                state=S2;p=1;
           end
        end
    end

    S4:begin
    bf=2'b00;
        if(clutch) begin
         state=S3;p=1;
        end else if(!reversegear) begin 
            state=T0;p=0;
        end else if(brake) begin
        state=S0;p=1;
        end else if(throttle) begin
         bf=2'b10;p=1;
        end else begin
        bf=2'b00;p=1;
        end
    end

    T0:begin
        bf=2'b00;
        state=S0;
        p=1'b1;
    end
endcase

always@(posedge clk) begin
   if(!activation) begin
        LR=q1;
        tlr=2'b00;
    end else if(state!=T0||state!=S0||state!=S5) begin
    case (LR)
    q1:begin
        tlr=2'b00;
        if(turnleft&&turnright) begin
        LR=q4;
        end else if(!turnleft&&turnright) begin
        LR=q3;
        end else if(turnleft&&!turnright) begin
        LR=q2;
        end else if(!turnleft&&!turnright) begin
        LR=q1;
        end
        end
    q2:begin
        tlr=2'b01;
        if(turnleft&&turnright) begin
        LR=q4;
        end else if(!turnleft&&turnright) begin
        LR=q3;
        end else if(turnleft&&!turnright) begin
        LR=q2;
        end else if(!turnleft&&!turnright) begin
        LR=q1;
        end
        end
    q3:begin
        tlr=2'b10;
        if(turnleft&&turnright) begin
        LR=q4;
        end else if(!turnleft&&turnright) begin
        LR=q3;
        end else if(turnleft&&!turnright) begin
        LR=q2;
        end else if(!turnleft&&!turnright) begin
        LR=q1;
        end
        end
    q4:begin
        tlr=2'b11;
        if(turnleft&&turnright) begin
        LR=q4;
        end else if(!turnleft&&turnright) begin
        LR=q3;
        end else if(turnleft&&!turnright) begin
        LR=q2;
        end else if(!turnleft&&!turnright) begin
        LR=q1;
        end
        end
    endcase
    end else begin
    LR=q1;
    end
end


assign out[1:0]=bf;
assign out[3:2]=tlr;
endmodule