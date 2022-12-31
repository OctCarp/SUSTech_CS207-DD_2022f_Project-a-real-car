module mode_choose (
    input clk,
    input power,
    input choose,
    output reg[1:0] mode
    );
    wire clk_ms;
    
    mydiv_ms ms(clk,clk_ms);
    
    parameter m1=2'b01,m2=2'b10,m3=2'b11,idle=2'b00;
    
    reg[10:0] cnt=0;
    
    always@(posedge clk_ms)begin
            if(!power) begin
                 mode<=idle;
            end else if (!choose)begin
                cnt<=0;
            end else if (cnt == 500)begin
                cnt<= 0;
               if(mode>=2'b11)mode<=m1;
               else mode<=mode+1;
            end else begin
               cnt<=cnt+1'b1;
            end
        end
endmodule