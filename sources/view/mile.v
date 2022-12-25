`timescale 1ns / 1ps

module mile(
    input[1:0] mode,
    input clk,
    input[7:0] sig,

    output [7:0] led_seg,
    output [2:0] an
);
    parameter idle = 0, on=1;
    reg state;
    reg [8:0] cnt_2ms;
    reg [7:0] cnt_mile;
    reg [11:0] bcd;
    wire bcd_valid;
    wire clk_2ms;
    
    mydiv_2ms dive_2ms(.clk(clk),.clk_2ms(clk_2ms));
    led led(.clk(clk_2ms),.rst(state),.in(bcd),.seg(led_seg),.an(an));

    always @(posedge clk_2ms) begin
        case (state)
            idle: if (mode==2'b01) state<=on;
            on : if(mode!=2'b01) state<=idle;
        endcase
    end

    always@(posedge clk_2ms)begin
        if(state==idle)begin
            cnt_2ms<=0; cnt_mile<=0;
        end else if(cnt_2ms==500) begin
            cnt_2ms<=0;
            cnt_mile<=cnt_mile+1;
        end else if(sig[0]) cnt_2ms<=cnt_2ms+2'b10;
        else if(sig[1]) cnt_2ms<=cnt_2ms+1'b1;
      end
     
     reg[3:0] Hundreds,Tens,Ones;
     integer i;
     always@(cnt_mile)
     begin
         Hundreds=4'd0;
         Tens=4'd0;
         Ones=4'd0;
         
         for(i=7;i>=0;i=i-1)
         begin
             if(Hundreds>=5)
             Hundreds=Hundreds+3;
             if(Tens>=5)
             Tens=Tens+3;
             if(Ones>=5)
             Ones=Ones+3;
             Hundreds=Hundreds<<1;
             Hundreds[0]=Tens[3];
             Tens=Tens<<1;
             Tens[0]=Ones[3];
             Ones=Ones<<1;
             Ones[0]=cnt_mile[i];
         end
         bcd={Hundreds,Tens,Ones};
     end
endmodule
