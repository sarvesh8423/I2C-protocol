`timescale 1ns/1ps
module clk_generation(input ref_clk,input [1:0]clk_state,output reg clk10us);
  
  integer count;
  localparam count_upto=10000/2; //(1GHz/100KHz)/2
  
  localparam idle0=2'b00;           // if needed to make clk idle at 0
  localparam idle1=2'b11;           // if needed to make clk idle=1
  localparam counting=2'b01;        // continue generating clk of 10us period.
  localparam count_restart=2'b10;   //reset or restart when clk_state=2
  wire [1:0]state;
  
  

  always@(posedge ref_clk) begin
        casex(clk_state)
          count_restart: begin count<=0; clk10us<=1; end
          counting: begin 
                        if(count==count_upto) begin
                          count<=0; clk10us<=~clk10us;
                        end 
                        else 
                          count<=count+1; 
                  end
          idle0: clk10us<=0;
          idle1: clk10us<=1;
        endcase
    end
endmodule
