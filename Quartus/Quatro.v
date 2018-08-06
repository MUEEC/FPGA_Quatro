module Quatro(
	input CLK_50A,
	input CLK_50B,
	input [3:0] KEY,	
	input [9:0] SW,
	output [9:0] LEDR,
	output [6:0] HEX0,
	output 		 HEX0_DP,
	output [6:0] HEX1,
	output 		 HEX1_DP,
	output [6:0] HEX2,
	output 		 HEX2_DP,
	output [6:0] HEX3,
	output 		 HEX3_DP,
	output [6:0] HEX4,
	output 		 HEX4_DP,
	output [6:0] HEX5,
	output 		 HEX5_DP,
	output		 HDMI_CLK,
	output		 HDMI_D0,
	output		 HDMI_D1,
	output		 HDMI_D2
	);
	
	/**** Clock circuitry (25 ms cycle) ****/

	reg slow_clk;
	reg [32:0] counter;
	wire reset;
	
	always @ (posedge CLK_50A)
		counter <= (counter == 33'd1250000) ? 0 : counter + 33'd1;
			
	
	wire clk_en = (counter == 33'd0);
	
	
	/**** Counter in 7 segment displays ****/
	reg [47:0] hex_counter;
	
	always @ (posedge CLK_50A)
	if (clk_en)
	begin
		if (reset)
			hex_counter <= 48'd0;
		else
			hex_counter <= hex_counter + 48'd1;
	end
	
	SSeg BYTE5(.bin(hex_counter[47:40]), .neg(1'b0), .enable(1'b1), .segs(HEX5));
	SSeg BYTE4(.bin(hex_counter[39:32]), .neg(1'b0), .enable(1'b1), .segs(HEX4));
	SSeg BYTE3(.bin(hex_counter[31:24]), .neg(1'b0), .enable(1'b1), .segs(HEX3));
	SSeg BYTE2(.bin(hex_counter[23:16]), .neg(1'b0), .enable(1'b1), .segs(HEX2));
	SSeg BYTE1(.bin(hex_counter[15:8]), .neg(1'b0), .enable(1'b1), .segs(HEX1));
	SSeg BYTE0(.bin(hex_counter[7:0]), .neg(1'b0), .enable(1'b1), .segs(HEX0));
	
	/**** Switches and LED ****/
	//assign LEDR = SW;
	assign LEDR[0] = SW[0], LEDR[1] = SW[1], LEDR[2] = SW[2];
	
	
	/**** Buttons ****/
	assign reset = (~KEY[3] || ~KEY[2] || ~KEY[1] || ~KEY[0]); //I know, this is boring but I ran out of ideas

endmodule
