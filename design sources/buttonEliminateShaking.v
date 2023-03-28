`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/23 18:26:28
// Design Name: 
// Module Name: buttonEliminateShaking
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

module buttonEliminateShaking(
    input clk_100M,
    input rst,
    input BUTTON,
    output reg button_out
    );
    //使用方法：把按钮信号放在BUTTON位置，button_out为消抖完毕的信号
    //在其余模块中检测button_out的上升沿，来实现按钮按下的功能
    reg [21:0]  time_cnt;        //用来计数按键延迟的定时计数器
    reg [21:0]  time_cnt_n;      //time_cnt的次态
    reg         button_in;           //接受按键信号
    reg         button_out_n;        //ket_out的次态
    wire        button_press;        //检测是否被按下
    
    //设置定时器为20ms
    parameter SET_TIME_20MS = 22'd200_0000;
    
    //把小键盘的输入赋值给key_in
    always@(posedge clk_100M, posedge rst)
    begin
        if(rst)
            button_in <= 1'b0;
        else
            button_in <= BUTTON;
    end
    
    //检测按键是否被按下
    assign button_press = button_in ^ BUTTON;
    
    //给time_cnt赋值
    always @(posedge clk_100M, posedge rst)
    begin
        if(rst)
            time_cnt <= 21'b0;
        else
            time_cnt <= time_cnt_n;
    end
    
    //算time_cnt_n
    always@(*)
    begin
        if(time_cnt == SET_TIME_20MS || button_press)
            time_cnt_n = 21'b0;
        else
            time_cnt_n = time_cnt + 1'b1;
    end
    
    //给key_out赋值
    always @(posedge clk_100M, posedge rst)
    begin
        if(rst)
            button_out <= 1'b0;
        else
            button_out <= button_out_n;
    end
    
    //算key_out_n
    always @(*)
    begin
        if(time_cnt == SET_TIME_20MS)
            button_out_n = button_in;
        else
            button_out_n = button_out;
    end
    
endmodule
