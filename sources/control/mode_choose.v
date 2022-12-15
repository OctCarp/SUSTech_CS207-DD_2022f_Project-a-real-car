module mode_choose (
    input clk,
    input power,
    input choose,
    output reg[1:0] mode
    );
    reg[1:0] state;
    
    parameter m1=2'b01,m2=2'b10,m3=2'b11,idle=2'b00;
    
    always@(posedge choose, negedge power) begin
       if(!power)begin
            state=idle;
        end
        case(state)
        idle: state=m1;
        m1: state=m2;
        m2: state=m3;
        m3: state=m1;
        endcase
        mode=state;
    end
endmodule
