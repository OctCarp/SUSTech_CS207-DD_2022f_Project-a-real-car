module led(
    input wire clk,
    input wire rst,
    input wire [11:0] in,

    output reg [7:0] seg,
    output reg [2:0] an
);
	parameter   _0 = 8'b1111_1100;
	parameter   _1 = 8'b0110_0000;
	parameter   _2 = 8'b1101_1010;
	parameter   _3 = 8'b1111_0010;
	parameter   _4 = 8'b0110_0110;
	parameter   _5 = 8'b1011_0110;
	parameter   _6 = 8'b1011_1110;
	parameter   _7 = 8'b1110_0000;
	parameter   _8 = 8'b1111_1110;
	parameter   _9 = 8'b1110_0110;
	parameter   _err = ~8'hcf;
       
    reg [1:0] bit; 
    reg [3:0] hex_in;
    
    always @ (posedge clk or negedge rst)   begin
        if (!rst)   begin
            bit = 0;
        end else if(bit==2'b10)begin
            bit =0;
        end else begin
            bit = bit + 1;
        end
    end

    always @ (*)    begin
        case (bit)
            2'b00:  begin
                an  <=  4'b001;
                hex_in  <=  in[3:0];
            end
            2'b01:  begin
                an  <=  4'b010;
                hex_in  <=  in[7:4];
            end
            2'b10:  begin
                an  <=  3'b100;
                hex_in  <=  in[11:8];
            end
        endcase
    end
    
    always @ (*) begin
        case (hex_in)
            4'h0: seg <= _0;
            4'h1: seg <= _1;
            4'h2: seg <= _2;
            4'h3: seg <= _3;
            4'h4: seg <= _4;
            4'h5: seg <= _5;
            4'h6: seg <= _6;
            4'h7: seg <= _7;
            4'h8: seg <= _8;
            4'h9: seg <= _9;
        endcase
    end
            
endmodule
