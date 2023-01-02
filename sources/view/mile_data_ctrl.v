module mile_data_ctrl(
    input clk,
    input rst,
	input [1:0] mode,
	input [3:0] m_d,
    output reg [5: 0] m_d_data
    );
    parameter n0 = 4'b0000;
    parameter n1 = 4'b0001;
    parameter n2 = 4'b0010;
    parameter n3 = 4'b0011;
    parameter n4 = 4'b0100;
    parameter n5 = 4'b0101;
    parameter n6 = 4'b0110;
    parameter n7 = 4'b0111;
    parameter n8 = 4'b1000;
    parameter n9 = 4'b1001;

    always @ (posedge clk,negedge rst)
	begin
		if (!rst) begin
			m_d_data <= 6'b11_1110;
		end
        else if (mode == 2'b00) begin
		    m_d_data <= 6'b11_1110;
        end
        else begin
            case (m_d)
            n0: m_d_data <= 6'b00_0000;
            n1: m_d_data <= 6'b00_0001;
            n2: m_d_data <= 6'b00_0010;
            n3: m_d_data <= 6'b00_0011;
            n4: m_d_data <= 6'b00_0100;
            n5: m_d_data <= 6'b00_0101;
            n6: m_d_data <= 6'b00_0110;
            n7: m_d_data <= 6'b00_0111;
            n8: m_d_data <= 6'b00_1000;
            n9: m_d_data <= 6'b00_1001;
            endcase
        end
	end

endmodule