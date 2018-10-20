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
	output		 HDMI_D2,
	input			 HDMI_HPD,
	output		 IRDA_SD,
	input			 IRDA_RX,
	output		 IRDA_TX	
	);
	
	/**** Clock circuitry (25 ms cycle) ****/

	reg slow_clk;
	reg [25:0] counter;
	wire reset;
	
	always @ (posedge CLK_50A)
		counter <= (counter == 26'd25_000_000) ? 0 : counter + 26'd1;
			
	
	wire clk_en = (counter == 26'd0);

	assign HEX0_DP = 1;
	assign HEX1_DP = 1;
	assign HEX2_DP = 1;
	assign HEX3_DP = 1;
	assign HEX4_DP = 1;
	assign HEX5_DP = 1; 
	
	/**** Counter in 7 segment displays ****/
	reg [3:0] hex_counter;
	
	always @ (posedge CLK_50A)
	if (clk_en)
	begin
		if (reset)
			hex_counter <= 4'd0;
		else
			hex_counter <= hex_counter + 4'd1;
	end
	
	SSeg BYTE0(.bin(hex_counter), .neg(1'b0), .enable(1'b1), .segs(HEX0));
	
	assign HEX1 = HEX0;
	assign HEX2 = HEX0;
	assign HEX3 = HEX0;
	assign HEX4 = HEX0;
	assign HEX5 = HEX0;
	
	/**** Switches and LED ****/
	assign LEDR = SW;
	
	/**** Buttons ****/
	assign reset = (~KEY[3] || ~KEY[2] || ~KEY[1] || ~KEY[0]); //I know, this is boring but I ran out of ideas

endmodule
