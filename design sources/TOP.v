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
    input           switch,         //���������ƿ��� �ҵ�Լ���ļ���Ҳ���ˣ������W4�������isableһ��
    input           decoder,        //С���������һ���е�������һ��
    input           clk,            //Y18
    input           rst,            // ��λ�ź�
    input           x1,             //����
    input           x2,             //����
    input           d3,             //ɾ��
    input           ENCODE,         //����
    input   [3:0]   row,            //С����
    input   [7:0]   BIT_CHOOSE,     //ÿһλ��������
    input   [7:0]   freq_choose,    //ѡ�������Ƶ��
    input   [2:0]   speed_choose,   //�������ٶ�ѡ��
    output  [3:0]   col,            //С����
    output  [7:0]   seg_en,         //en �ź�
    output  [7:0]   seg_out,        //out �ź�
    output  [3:0]   cnt,            // �����ź� b�󶨵���led��
    output  [4:0]   code,           // �󶨵���led��
    output          error,          //���뱸��������led�ƣ����Ҳ��led��
    output          led_error,      //���볬��8λ����
    output          led_back,       //�����˸񵽵ױ���
    output          BEEP ,           //���������
    output state1 , state2,          //�������״̬��ʾ��
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
