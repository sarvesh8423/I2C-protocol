`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:       CDAC pune
// Engineer:      Anuj Baliyan
// 
// Create Date:    01:34 11/22/2020 
// Design Name:     Student
// Module Name:     step1 
// Project Name:    I2C protocol
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
module mainfile(
    inout wand i2c_scl,
    inout wand i2c_sda,
    
    input reset_n,enable,rw,
    input [7:0]data_wr,
    
    output [7:0]data_rd,
    output reg ack_error,busy
    );
	 reg access_SDA,access_SCL;
	 wire scl_reg;
	 reg sda_reg;
	     //assigning the value to inout lines SDA and SCL
	 assign i2c_scl= access_SCL?scl_reg:1'b1;
	 assign i2c_sda= (!rw & access_SDA)? sda_reg:1'b1;
	 
	 // goal is to write to device address 0x50, 0xaa
	 localparam STATE_IDLE =0;
	 localparam STATE_START =1;
	 localparam STATE_ADDR =2;
	 localparam STATE_RW =3;
	 localparam STATE_S_ACK =4;
	 localparam STATE_DATA =5;
	 localparam STATE_STOP =6;
	 localparam STATE_S_ACK2 =7;
	 reg [1:0]clk_status;  //status or mode of SCL like idle, running
	 
	 clk_generation clk_gen(clk,clk_status,scl_reg);
	 
	 reg [2:0] state;
	 reg [7:0] addr;
	 reg [2:0] count;
	 reg [7:0] data;
	 
	 initial begin
	   data <= 8'haa;
	   addr<= 7'h50;
	   end
	   
	 always @(posedge clk) begin
	    if (reset_n ==0 & enable==1) begin
			  sda_reg<= 1; 
			  access_SDA<=0; access_SCL<=0;
			  count<= 4'd0;
			  state <= STATE_IDLE;
		  end
		  if(state==STATE_IDLE) begin 
						sda_reg <= 1; 
						access_SDA<=0; access_SCL<=0;
						if(enable) begin state <= STATE_START; access_SDA<=1; end
			end
			if(state==STATE_STOP) begin 
						sda_reg <=1;
						state <= STATE_IDLE;
					end	
		  
	 end
	 
	 
	 always  @(negedge i2c_scl or posedge access_SDA) begin
       
		  case (state)
					STATE_START: begin // start
						sda_reg <=0;
						state <= STATE_ADDR;
						clk_status<=2'b10; access_SCL<=1;
						count<= 3'b111;
					end
					
					STATE_ADDR: begin // from MSB address bit 
						sda_reg <=addr[count];
						if (count == 0)	state <= STATE_RW;
						else count <= count - 1;
					end
					
					STATE_RW: begin 
						sda_reg <=rw;
						state <= STATE_S_ACK;
					end
					
					STATE_S_ACK: begin 
					  sda_reg<=1;
					  @(posedge scl_reg)
					  if(i2c_scl==0)  begin             //got ACK R/W operation to start
					         state <= STATE_DATA;
						       count <=7;
					    end
					  else if(i2c_scl==1)   begin 
					                         state <= STATE_IDLE;
					                         ack_error<=1;
					                         access_SCL<=0;
					                         access_SDA<=0;
					                         end      
						
					end
					
					STATE_DATA: begin 
						sda_reg <= data[count];
						if (count == 0) state <= STATE_S_ACK2;
						else count <= count-1;
					end
					
					STATE_S_ACK2: begin 
					  sda_reg<=1;
					  @(posedge scl_reg)
					  if(i2c_scl==0)  begin             //got ACK of data received from slave
					         state <= STATE_STOP;
					         access_SCL<=0;
					    end
					  else if(i2c_scl==1)   begin 
					                         state <= STATE_IDLE;
					                         ack_error<=1;
					                         access_SCL<=0;
					                         access_SDA<=0;
					                         end      
						
					end
				endcase
		 end
endmodule
