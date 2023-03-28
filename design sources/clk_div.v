`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/19 18:15:20
// Design Name: 
// Module Name: clk_div
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


module clk_div(
    input clk, rst, 
    output reg clk_out
    );
    parameter period = 200000;
//    parameter period = 100000000;
    reg [17:0] cnt;
    always@(posedge clk, posedge rst)
    begin
        if(rst)
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
endmodule
