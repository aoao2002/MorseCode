`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/27 19:36:08
// Design Name: 
// Module Name: clk_long2
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




module clk_long2(
    input switch,
    input  clk, rst, 
    output reg clk_out
    );
    parameter period = 200000000;
//    parameter period = 100000000;
    reg [17:0] cnt;
    always@(posedge clk, posedge rst)
 
    begin
      if(~switch)begin
        if(rst )
        begin
            cnt <= 0;
            clk_out <= 0;
        end
        else
            if(cnt == ((period >> 1) - 1))
            begin
                clk_out <= ~clk_out;
                cnt <= 0;
            end
            else
                cnt <= cnt + 1;
    end
    end
endmodule
