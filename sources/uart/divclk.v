//
//分频模块
/*
clk:输入时钟100MHZ
clk_ms:输出时钟 1KHz
clk_20ms:输出时钟50HZ
clk_x 输出时钟9600HZ
clk_16x 输出时钟9600hz*16
*/

module divclk(clk,clk_ms,btnclk,clk_16x,clk_x);
input clk;
output clk_ms,btnclk,clk_16x,clk_x;
reg[31:0] cnt1=0;
reg[31:0] cnt2=0;
reg[31:0] cnt3=0;
reg[31:0] cntclk_cnt=0;
reg clk_ms=0;
reg btnclk=0;
reg clk_16x=0;
reg clk_x=0;
always@(posedge clk)//系统时钟分频 100M/1000 = 100000   1000HZ
begin
    if(cnt1==26'd50000)
    begin
        clk_ms=~clk_ms;
        cnt1=0;
    end
    else
        cnt1=cnt1+1'b1;
end
always@(posedge clk)//20MS: 100M/50 = 2000 000   50HZ
begin
    if(cntclk_cnt==500000)
    begin
        btnclk=~btnclk;
        cntclk_cnt=0;
    end
    else
        cntclk_cnt=cntclk_cnt+1'b1;
end
always@(posedge clk)//100M/153600 = 651       9.6K*16=153.6k
begin
    if(cnt2=='d326)
    begin
        clk_16x<=~clk_16x;
        cnt2<='d0;
    end
    else
        cnt2=cnt2+1'b1;
end
always@(posedge clk)//100M/9600 = 10416.67       9600HZ
begin
    if(cnt3=='d5208)
    begin
        clk_x<=~clk_x;
        cnt3<= 0;
    end
    else
        cnt3=cnt3+1'b1;
end
endmodule

