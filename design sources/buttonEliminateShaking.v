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
    //ʹ�÷������Ѱ�ť�źŷ���BUTTONλ�ã�button_outΪ������ϵ��ź�
    //������ģ���м��button_out�������أ���ʵ�ְ�ť���µĹ���
    reg [21:0]  time_cnt;        //�������������ӳٵĶ�ʱ������
    reg [21:0]  time_cnt_n;      //time_cnt�Ĵ�̬
    reg         button_in;           //���ܰ����ź�
    reg         button_out_n;        //ket_out�Ĵ�̬
    wire        button_press;        //����Ƿ񱻰���
    
    //���ö�ʱ��Ϊ20ms
    parameter SET_TIME_20MS = 22'd200_0000;
    
    //��С���̵����븳ֵ��key_in
    always@(posedge clk_100M, posedge rst)
    begin
        if(rst)
            button_in <= 1'b0;
        else
            button_in <= BUTTON;
    end
    
    //��ⰴ���Ƿ񱻰���
    assign button_press = button_in ^ BUTTON;
    
    //��time_cnt��ֵ
    always @(posedge clk_100M, posedge rst)
    begin
        if(rst)
            time_cnt <= 21'b0;
        else
            time_cnt <= time_cnt_n;
    end
    
    //��time_cnt_n
    always@(*)
    begin
        if(time_cnt == SET_TIME_20MS || button_press)
            time_cnt_n = 21'b0;
        else
            time_cnt_n = time_cnt + 1'b1;
    end
    
    //��key_out��ֵ
    always @(posedge clk_100M, posedge rst)
    begin
        if(rst)
            button_out <= 1'b0;
        else
            button_out <= button_out_n;
    end
    
    //��key_out_n
    always @(*)
    begin
        if(time_cnt == SET_TIME_20MS)
            button_out_n = button_in;
        else
            button_out_n = button_out;
    end
    
endmodule
