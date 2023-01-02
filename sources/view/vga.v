`timescale 1ns/1ps

module vga(
    input clk,
    input rst,
	input power,
	input [1:0] mode,
	input [3:0] state,
	input [11:0] mile,
    output reg [3:0] r,
    output reg [3:0] g,
    output reg [3:0] b,
    output hs,
    output vs
    );

	parameter UP_BOUND = 31;
	parameter DOWN_BOUND = 510;
	parameter LEFT_BOUND = 144;
	parameter RIGHT_BOUND = 783;

	parameter up_pos = 267;
	parameter down_pos = 274;
	parameter left_pos = 429;
	parameter right_pos = 498;
	
	wire pclk;
	reg [1:0] count;
	reg [9:0] hcount, vcount;
	wire [7:0] p[69:0];

	wire [53:0] data;

	mile_data_ctrl m_data1 (.clk(clk), .rst(rst), .mode(mode), .m_d(mile[11:8]), .m_d_data(data[53: 48]));
	mile_data_ctrl m_data2 (.clk(clk), .rst(rst), .mode(mode), .m_d(mile[7:4]), .m_d_data(data[47: 42]));
	mile_data_ctrl m_data3 (.clk(clk), .rst(rst), .mode(mode), .m_d(mile[3:0]), .m_d_data(data[41: 36]));

	state_data_ctrl s_data(.clk(clk), .rst(rst), .power(power), .mode(mode), .state(state), .data(data[35:0]));

	char_set p_1 (
		.clk(clk),
		.rst(rst),
		.data(data[35: 30]),
		.col0(p[0]),
		.col1(p[1]),
		.col2(p[2]),
		.col3(p[3]),
		.col4(p[4]),
		.col5(p[5]),
		.col6(p[6])
	);
	char_set p_2 (
		.clk(clk),
		.rst(rst),
		.data(data[29: 24]),
		.col0(p[7]),
		.col1(p[8]),
		.col2(p[9]),
		.col3(p[10]),
		.col4(p[11]),
		.col5(p[12]),
		.col6(p[13])
	);

	char_set p_3 (
		.clk(clk),
		.rst(rst),
		.data(data[23: 18]),
		.col0(p[14]),
		.col1(p[15]),
		.col2(p[16]),
		.col3(p[17]),
		.col4(p[18]),
		.col5(p[19]),
		.col6(p[20])
	);

	char_set p_4 (
		.clk(clk),
		.rst(rst),
		.data(data[17: 12]),
		.col0(p[21]),
		.col1(p[22]),
		.col2(p[23]),
		.col3(p[24]),
		.col4(p[25]),
		.col5(p[26]),
		.col6(p[27])
	);

	char_set p_5 (
		.clk(clk),
		.rst(rst),
		.data(data[11: 6]),
		.col0(p[28]),
		.col1(p[29]),
		.col2(p[30]),
		.col3(p[31]),
		.col4(p[32]),
		.col5(p[33]),
		.col6(p[34])
	);

	char_set p_6 (
		.clk(clk),
		.rst(rst),
		.data(data[5: 0]),
		.col0(p[35]),
		.col1(p[36]),
		.col2(p[37]),
		.col3(p[38]),
		.col4(p[39]),
		.col5(p[40]),
		.col6(p[41])
	);

	char_set blank (
		.clk(clk),
		.rst(rst),
		.data(6'b11_1110),
		.col0(p[42]),
		.col1(p[43]),
		.col2(p[44]),
		.col3(p[45]),
		.col4(p[46]),
		.col5(p[47]),
		.col6(p[48])
	);

	char_set m_1 (
		.clk(clk),
		.rst(rst),
		.data(data[53: 48]),
		.col0(p[49]),
		.col1(p[50]),
		.col2(p[51]),
		.col3(p[52]),
		.col4(p[53]),
		.col5(p[54]),
		.col6(p[55])
	);

	char_set m_2 (
		.clk(clk),
		.rst(rst),
		.data(data[47: 42]),
		.col0(p[56]),
		.col1(p[57]),
		.col2(p[58]),
		.col3(p[59]),
		.col4(p[60]),
		.col5(p[61]),
		.col6(p[62])
	);

	char_set m_3 (
		.clk(clk),
		.rst(rst),
		.data(data[42: 36]),
		.col0(p[63]),
		.col1(p[64]),
		.col2(p[65]),
		.col3(p[66]),
		.col4(p[67]),
		.col5(p[68]),
		.col6(p[69])
	);
	
	assign pclk = count[1];
	always @ (posedge clk or negedge rst)
	begin
		if (!rst)
			count <= 0;
		else
			count <= count+1;
	end
	
	assign hs = (hcount < 96) ? 0 : 1;
	always @ (posedge pclk or negedge rst)
	begin
		if (!rst)
			hcount <= 0;
		else if (hcount == 799)
			hcount <= 0;
		else
			hcount <= hcount+1;
	end
	
	assign vs = (vcount < 2) ? 0 : 1;
	always @ (posedge pclk or negedge rst)
	begin
		if (!rst)
			vcount <= 0;
		else if (hcount == 799) begin
			if (vcount == 520)
				vcount <= 0;
			else
				vcount <= vcount+1;
		end
		else
			vcount <= vcount;
	end
	
	always @ (posedge pclk or negedge rst)
	begin
		if (!rst) begin
			r <= 0;
			g <= 0;
			b <= 0;
		end
		else if (vcount>=UP_BOUND && vcount<=DOWN_BOUND
				&& hcount>=LEFT_BOUND && hcount<=RIGHT_BOUND) begin
			if (vcount>=up_pos && vcount<=down_pos
				&& hcount>=left_pos && hcount<=right_pos) begin
				if (p[hcount-left_pos][vcount-up_pos]) begin
					r <= 4'b1111;
					g <= 4'b1111;
					b <= 4'b1111;
				end
				else begin
					r <= 4'b0000;
					g <= 4'b0000;
					b <= 4'b0000;
				end
			end
			else begin
				r <= 4'b0000;
				g <= 4'b0000;
				b <= 4'b0000;
			end
		end
		else begin
			r <= 4'b0000;
			g <= 4'b0000;
			b <= 4'b0000;
		end
	end

endmodule
