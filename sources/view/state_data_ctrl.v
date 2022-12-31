module state_data_ctrl(
    input clk,
    input rst,
    input power,
	input [1:0] mode,
	input [3:0] state,
    output reg [35: 0] data
);
    parameter non_act = 4'b0000;
    parameter none_s = 4'b0001;
    parameter none_s_2 = 4'b0110;
    parameter start = 4'b0010;
    parameter move = 4'b0011;
    parameter switch = 4'b0100;
    parameter reverse = 4'b0101;

    always @ (posedge clk,negedge rst)
	begin
		if (!rst) begin
			data <= 6'b11_1110;
		end
        else if (!power) begin
		    data <= 35'b011000_001111_001111_111110_111110_111110;//off
        end
        else begin
            case (mode)
            2'b01: begin
                case (state)
                non_act: begin
                    data <= 35'b010001_001010_010111_001101_111110_111110;//hand
                end
                none_s: begin
                    data <= 35'b010111_100100_001010_111110_111110_111110;//n/a
                end
                none_s_2: begin
                    data <= 35'b010111_100100_001010_111110_111110_111110;//n/a
                end 
                start: begin
                    data <= 35'b011100_011101_001010_011011_011101_111110;//start
                end 
                move: begin
                    data <= 35'b010110_011000_011111_001110_001111_100000;//movefw
                end
                switch: begin
                    data <= 35'b011100_100000_010010_011101_001100_010001;//swicth
                end 
                reverse: begin
                    data <= 35'b011011_001110_011111_111110_111110_111110;//rev
                end
                default: begin
                    data <= 35'b010001_001010_010111_001101_111110_111110;//hand
                end
                endcase
            end
            2'b10: begin
                data <= 35'b011100_001110_010110_010010_111110_111110;//semi
            end
            2'b11: begin
                data <= 35'b001010_011110_011101_011000_111110_111110;//auto
            end
            default: begin
                data <= 35'b011000_010111_111110_111110_111110_111110;//on
            end
            endcase
        end
	end

endmodule