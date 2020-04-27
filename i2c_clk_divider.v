`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:26:24 04/26/2020 
// Design Name: 
// Module Name:    i2c_clk_divider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module i2c_clk_divider(
    input wire reset,
    input wire ref_clk,
    output reg i2c_clk
    );
parameter DELAY = 1000;

reg [9:0] count = 0;
initial i2c_clk =0;
always @ (posedge ref_clk) begin
		
			if (count == ((DELAY/2)-1)) begin
			    i2c_clk= ~i2c_clk;
				 count = 0;
			end
			else begin
				count = count+1;
				end
		end
		
		

endmodule
