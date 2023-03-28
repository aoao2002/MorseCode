`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/28 21:55:48
// Design Name: 
// Module Name: TOP
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


module TOP(
    input           switch,         //解码编码控制开关 我的约束文件里也绑了，绑的是W4，和你的isable一样
    input           decoder,        //小按键五个在一起中的最上面一个
    input           clk,            //Y18
    input           rst,            // 复位信号
    input           x1,             //长码
    input           x2,             //短码
    input           d3,             //删除
    input           ENCODE,         //编码
    input   [3:0]   row,            //小键盘
    input   [7:0]   BIT_CHOOSE,     //每一位单独解码
    input   [7:0]   freq_choose,    //选择蜂鸣器频率
    input   [2:0]   speed_choose,   //蜂鸣器速度选择
    output  [3:0]   col,            //小键盘
    output  [7:0]   seg_en,         //en 信号
    output  [7:0]   seg_out,        //out 信号
    output  [3:0]   cnt,            // 计数信号 b绑定的是led灯
    output  [4:0]   code,           // 绑定的是led灯
    output          error,          //解码备案，报错led灯，帮的也是led灯
    output          led_error,      //编码超过8位报错
    output          led_back,       //编码退格到底报错
    output          BEEP ,           //蜂鸣器输出
    output state1 , state2,          //解码编码状态显示灯
    output over
   );
   
    wire     [5:0] statew;
    wire    [31:0]  shown;
    wire     clk_500;
    reg     [3:0]   cnt1; 
    wire    [47:0]  shown2;
    wire    [5:0]   state;
   
    showstate      ss(clk,switch,state1,state2);
    clk_div         CD1(clk, rst, clk_500);
    showTubes       sT1(switch, clk, clk_500, rst, shown, shown2, seg_en, seg_out);
    keyboard        k1(switch, clk, rst, d3, row, col, shown, led_error, led_back);
    beep_all_bits   beep(switch, clk, rst, decoder, shown, ENCODE, BIT_CHOOSE, freq_choose, speed_choose, statew, BEEP);
    stateChange     u2(switch,clk,decoder,rst,x1,x2,d3,cnt,state,shown2,code,error,over,statew);
endmodule
