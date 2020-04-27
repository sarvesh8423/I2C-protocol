`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:48:58 04/26/2020 
// Design Name: 
// Module Name:    step1 
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
module step1(
    input wire clk,
    input wire reset,
    output reg i2c_sda,
    output reg i2c_scl
    );
	 
	 // goal is to write to device address 0x50, 0xaa
	 localparam STATE_IDLE =0;
	 localparam STATE_START =1;
	 localparam STATE_ADDR =2;
	 localparam STATE_RW =3;
	 localparam STATE_WACK =4;
	 localparam STATE_DATA =5;
	 localparam STATE_STOP =6;
	 localparam STATE_WACK2 =7;
	 
	 reg [7:0] state;
	 reg [6:0] addr;
	 reg [7:0] count;
	 reg [7:0] data;
	 always  @(posedge clk) begin
        if (reset ==1) begin
		     state <=0;
			  i2c_sda<= 1;
			  i2c_scl<= 1;
			  addr<= 7'h50;
			  count<= 8'd0;
			  data <= 8'haa;
		  end
		  else begin
				case (state)
				
					STATE_IDLE: begin // idle 
						i2c_sda <= 1;
						 state <= STATE_START;
					end
					
					STATE_START: begin // start
						i2c_sda <=1;
						state <= STATE_ADDR;
						count <= 6;
					end
					
					STATE_ADDR: begin // MSB address bit
						i2c_sda <=addr[count];
						if (count == 0)	state <= STATE_RW;
						else count <= count - 1;
					end
					
					STATE_RW: begin 
						i2c_sda <=1;
						state <= STATE_WACK;
					end
					
					STATE_WACK: begin 
						state <= STATE_DATA;
						count <=7;
					end
					
					STATE_DATA: begin 
						i2c_sda <= data[count];
						if (count == 0) state <= STATE_WACK2;
						else count <= count-1;
					end
					
					STATE_WACK2: begin 
						state <= STATE_STOP;
					end
						
					STATE_STOP: begin 
						i2c_sda <=1;
						state <= STATE_IDLE;
					end	
				endcase
			end
		 end
endmodule

//but this circuit has a issue it's run at 500MHz but the maximum frequency is 400KHz and recomended is 100KHz.



