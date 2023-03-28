`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/29 21:13:56
// Design Name: 
// Module Name: showstate
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


module showstate(
input clk,
input switch,
output reg state1,
output reg state2
    );
  always@(clk)
     begin
         if(~switch)
            begin
                state1<=1'b1;
                state2<=1'b0;
             end   
          else
            begin
                 state2<=1'b1;
                 state1<=1'b0;
            end
          
     end  
    
endmodule
