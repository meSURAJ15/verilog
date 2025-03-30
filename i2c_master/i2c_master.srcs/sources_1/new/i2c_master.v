`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 25.03.2025 20:26:46
// Design Name: 
// Module Name: i2c_master
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module i2c_master(


   input clk,
   input rst,
   input [6:0] addr_top,
   input [7:0] data_in_top,
   input enable,
   input rd_wr, //top module signal
   output reg [7:0] data_out,
   output wire ready,
   
   inout sda,
   inout scl
    );
  parameter idle_state = 0;
  parameter start_state = 1;
  parameter address_state  = 2;
  parameter read_ack_state = 3; 
  parameter write_data_state = 4;
  parameter write_ack_state = 5;
  parameter read_data_state = 6;
  parameter read_ack_2_state = 7;
  parameter stop_state = 8;
  
  reg [7:0] state;
  reg [7:0] temp_addr;
  reg [7:0] temp_data;
  reg [7:0] counter1 = 0;
  reg [7:0} counter2 = 0;
  reg wr_enb;
  reg sda_out;
  reg i2c_clk;
  reg i2c_scl_enable = 0 ;
  
  //logic clock generation
  always @ (posedge clk) begin
  
  if (counter1 == (div_const / 2) - 1) begin
        i2c_clk = ~i2c_clk;
        counter1 = 0;
     end  
     else 
     counter1 = counter1 + 1; //logic for clock generation
   end
   
   assign scl = (i2c_scl_enable == 0) ? 1: i2c_clk;
   
   //logic i2c_scl_enable
   
   always @(posedge i2c_clk, posedge rst) begin
   if (rst==1) begin
   i2c_scl_enable <= 0;
   end
   else if (state == idle_state || state == start_state || state == stop_state) begin
      i2c_scl_enable <=0;
      end
      else i2c_scl_enable <= 1; //state == read_state
      
   end
  
  always @(posedge i2c_clk, posedge clk) 
    begin
     case(state)
            idle_state:
                      begin
                         if (enable) 
                                begin
                                      state <= start_state;
                                      temp_addr <= {addr_top,rd_wr};
                                      temp_data <= data_in_top;
                                end
                               else state <= idle_state;
                               end                                 
     endcase
    end
                            
 //logic for genrating the output 
  always@(negedge i2c_clk,posedge rst)begin
    if(rst == 1)
      begin
         wr_enb <= 1;
         sda_out <= 1;
      end
      else 
          begin
             case (state)
                 start_state : begin
                    wr_enb <= 1;
                    sda_out <= 0;
                    end
              endcase
           end
     end
     
              
              
   end
  
  
   
    
endmodule
