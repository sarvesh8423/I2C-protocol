`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:51:04 04/27/2020 
// Design Name: 
// Module Name:    i2c_fifo_master 
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
module i2c_fifo_master(
    input wire logic_clk_in,
	 input wire i2c_clk_in,
    input wire reset_in,
    input wire [6:0] addr_in,
    input wire [7:0] data_in,
    inout wire i2c_sda_inout,
    inout wire i2c_scl_inout,
    output wire ready_out,
	 output wire fifo_full,
	 input wire start
        );

wire [14:0] fifo_data_in;
wire [14:0] fifo_data_out;

assign fifo_data_in = {addr_in , data_in };
wire fifo_empty;

i2c_fif0 i2c_fifo (
  .rst(reset_in), // input rst
  .wr_clk(logic_clk_in), // input wr_clk
  .rd_clk(i2c_clk_in), // input rd_clk
  .din(fifo_data_in), // input [17 : 0] din
  .wr_en(start), // input wr_en
  .rd_en(fifo_master_start), // input rd_en
  .dout(fifo_data_out), // output [17 : 0] dout
  .full(fifo_full), // output full
  .empty(fifo_empty) // output empty
);


wire fifo_master_start;
wire fifo_master_ready;
assign fifo_master_start = ~fifo_empty & fifo_master_ready;

step3 master (
  .clk(logic_clk_in), // input clk
  .reset(reset_in), // input rst
  .start(fifo_master_start), 
  .addr(fifo_data_out[14:8]), // input wr_en
  .data(fifo_data_in[7:0]), // input rd_en
  .i2c_sda(i2c_sda_inout), // output [17 : 0] dout
  .i2c_scl(i2c_scl_inout), // output full
  .ready(fifo_master_ready) // output empty
	);


endmodule
