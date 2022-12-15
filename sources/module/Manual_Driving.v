`timescale 1ns / 1ps

module Manual_Driving(
    input clk,
    input [7:0] in,//从top传过来的原始8位信�?
    input [1:0] mode,//模式选择信号 当mode信号�?01时，�?活手动驾驶模式，否则手动驾驶模块为待�?活状�?
    output [7:0] out,//返回给top模块的手动驾驶操作信�?
    output  reg p//返回给top模块的电源信号，如果power==1‘b0，则断电，否则不影响其正常工�?
);
wire throttle,clutch,brake,reversegear;
assign throttle=in[0];//油门
assign clutch=in[6];//离合
assign brake=in[7];//刹车
assign reversegear=in[1];//倒挡

reg activation;//判断是否�?活手动驾驶状�?
reg[1:0] bf;

reg [3:0] state=4'b0000;//初始化state
reg [3:0] nextstate=4'b0000;//下一个状�?
parameter T0=4'b0000,// T0 0000  待激活�??
S0=4'b0001, // S0 0001  Not_Starting_State
S1=4'b0010, // S1 0010  Starting_Start
S2=4'b0011, // S2 0100  Moving_State
S3=4'b0100, // switch
S4=4'b0101, //reverse
S5=4'b0110, //need throttle
S6=4'b0111; //reverse move

always@(posedge clk)
begin
if(mode==2'b01)
    activation=1'b1;
else
    activation=1'b0;
end

always@(posedge clk)//throttle,clutch,brake,reversegear如果四个装置有变动，判断会进入什么状�?
    if(!activation) begin
        state=T0;
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
         state<=S1; p=1;
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

assign out[1:0]=bf;

endmodule