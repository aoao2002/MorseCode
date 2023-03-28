`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/28 22:22:16
// Design Name: 
// Module Name: keyboard
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


module keyboard(
    input           isAble, 
    input           clk,
    input           rst,
    input           BACK,
    input      [3:0] row,                 // ������� ��
    output reg [3:0] col,                 // ������� ��
    output reg [31:0] shown,
    output          led_error,
    output          led_back
    );
    //++++++++++++++++++++++++++++++++++++++
    // ��Ƶ���� ��ʼ
    //++++++++++++++++++++++++++++++++++++++
    reg [19:0] cnt;                         // ������
    wire key_clk;
     
    always @ (posedge clk or posedge rst)
      if (rst | (~isAble))
        cnt <= 0;
      else
        cnt <= cnt + 1'b1;
        
    assign key_clk = cnt[19];                // (2^20/50M = 21)ms 
    //--------------------------------------
    // ��Ƶ���� ����
    //--------------------------------------
     
    //++++++++++++++++++++++++++++++++++++++
    // ״̬������ ��ʼ
    //++++++++++++++++++++++++++++++++++++++
    // ״̬�����٣����������
    parameter NO_KEY_PRESSED = 6'b000_001;  // û�а�������  
    parameter SCAN_COL0      = 6'b000_010;  // ɨ���0�� 
    parameter SCAN_COL1      = 6'b000_100;  // ɨ���1�� 
    parameter SCAN_COL2      = 6'b001_000;  // ɨ���2�� 
    parameter SCAN_COL3      = 6'b010_000;  // ɨ���3�� 
    parameter KEY_PRESSED    = 6'b100_000;  // �а�������
    
    reg [5:0] current_state, next_state;    // ��̬����̬
     
    always @ (posedge key_clk or posedge rst)
      if (rst | (~isAble))
        current_state <= NO_KEY_PRESSED;
      else
        current_state <= next_state;
     
    // ��������ת��״̬
    always @ (*)
      case (current_state)
        NO_KEY_PRESSED :                    // û�а�������
            if (row != 4'hF)
              next_state = SCAN_COL0;
            else
              next_state = NO_KEY_PRESSED;
        SCAN_COL0 :                         // ɨ���0�� 
            if (row != 4'hF)
              next_state = KEY_PRESSED;
            else
              next_state = SCAN_COL1;
        SCAN_COL1 :                         // ɨ���1�� 
            if (row != 4'hF)
              next_state = KEY_PRESSED;
            else
              next_state = SCAN_COL2;    
        SCAN_COL2 :                         // ɨ���2��
            if (row != 4'hF)
              next_state = KEY_PRESSED;
            else
              next_state = SCAN_COL3;
        SCAN_COL3 :                         // ɨ���3��
            if (row != 4'hF)
              next_state = KEY_PRESSED;
            else
              next_state = NO_KEY_PRESSED;
        KEY_PRESSED :                       // �а�������
            if (row != 4'hF)
              next_state = KEY_PRESSED;
            else
              next_state = NO_KEY_PRESSED;                      
      endcase
     
    reg       key_pressed_flag;             // ���̰��±�־
    reg [3:0] col_val, row_val;             // ��ֵ����ֵ
     
    // ���ݴ�̬������Ӧ�Ĵ�����ֵ
    always @ (posedge key_clk or posedge rst)
      if (rst | (~isAble))
      begin
        col              <= 4'h0;
        key_pressed_flag <=    0;
      end
      else
        case (next_state)
          NO_KEY_PRESSED :                  // û�а�������
          begin
            col              <= 4'h0;
            key_pressed_flag <=    0;       // ����̰��±�־
          end
          SCAN_COL0 :                       // ɨ���0��
            col <= 4'b1110;
          SCAN_COL1 :                       // ɨ���1��
            col <= 4'b1101;
          SCAN_COL2 :                       // ɨ���2��
            col <= 4'b1011;
          SCAN_COL3 :                       // ɨ���3��
            col <= 4'b0111;
          KEY_PRESSED :                     // �а�������
          begin
            col_val          <= col;        // ������ֵ
            row_val          <= row;        // ������ֵ
            key_pressed_flag <= 1;          // �ü��̰��±�־  
          end
        endcase
    //--------------------------------------
    // ״̬������ ����
    //--------------------------------------
     
     
    //++++++++++++++++++++++++++++++++++++++
    // ɨ������ֵ���� ��ʼ
    //++++++++++++++++++++++++++++++++++++++

    parameter c1 = 100000000;
    reg [26:0] cnt1;
    reg led_error_reg,error_message1,error_message2;
    
    assign led_error = led_error_reg;
    
    always @(*)
        if(cnt1 < c1)
            led_error_reg = 1'b1;
        else
            led_error_reg = 1'b0;

    always @(posedge clk, posedge rst)
    begin
        if(rst | (~isAble))
        begin
            cnt1 <= c1;
            error_message2 <= 1'b0;
        end
        else
            if(error_message2 != error_message1)
            begin
                cnt1 <= 27'b0;
                error_message2 <= ~error_message2;
            end
            else
                if(cnt1 < c1)
                    cnt1 <= cnt1 + 1;
                else
                    cnt1 <= cnt1;
    end
    

    reg led_back_reg, back_message1, back_message2;
    reg [26:0] cnt2;
    parameter c2 = 100000000;
    assign led_back = led_back_reg;
    
    always @(*)
        if(~isAble)
            led_back_reg = 1'b0;
        else
        if(cnt2 < c2)
            led_back_reg = 1'b1;
        else
            led_back_reg = 1'b0;

    always @(posedge clk, posedge rst)
    begin
        if(rst)
        begin
            cnt2 <= c2;
            back_message2 <= 1'b0;
        end
        else if(~isAble)
        begin
            cnt2 <= c2;
            back_message2 <= 1'b0;
        end
        else
            if(back_message2 != back_message1)
            begin
                cnt2 <= 27'b0;
                back_message2 <= ~back_message2;
            end
            else
                if(cnt2 < c2)
                    cnt2 <= cnt2 + 1;
                else
                    cnt2 <= cnt2;
    end
    
    wire back1;
    buttonEliminateShaking back_ES(clk,rst,BACK,back1);
    
    reg delay1;
    wire back2 = back1 && (~delay1);
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay1 <= 1'b0;
        else if(~isAble)
            delay1 <= 1'b0;
        else 
            delay1 <= back1; 
    end

    reg delay2;
    wire key_pressed_flag_2 = key_pressed_flag && (~delay2);
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay2 <= 1'b0;
        else if(~isAble)
            delay2 <= 1'b0;
        else 
            delay2 <= key_pressed_flag; 
    end

    always @(posedge clk, posedge rst)
    begin
        if(rst)
        begin
            back_message1 <= 1'b0;
            error_message1 <= 1'b0;
            shown <= 32'b0;
        end
        else if(~isAble)
        begin
            back_message1 <= 1'b0;
            error_message1 <= 1'b0;
            shown <= 32'b0;
        end
        else
        begin
            if(back2)
            begin
                if(shown[3:0] != 4'h0)
                    shown <= {4'h0, shown[31:4]};
                else
                begin
                    back_message1 <= ~back_message1;
                    shown <= shown;
                end
            end
            else
                if (key_pressed_flag_2)
                    if(shown[31:28] == 4'h0)
                      case ({col_val, row_val})
                        8'b1110_1110 : shown <= {shown[27:0], 4'h1};
                        8'b1110_1101 : shown <= {shown[27:0], 4'h4};
                        8'b1110_1011 : shown <= {shown[27:0], 4'h7};
                         
                        8'b1101_1110 : shown <= {shown[27:0], 4'h2};
                        8'b1101_1101 : shown <= {shown[27:0], 4'h5};
                        8'b1101_1011 : shown <= {shown[27:0], 4'h8};
                        8'b1101_0111 : shown <= {shown[27:0], 4'ha};
                         
                        8'b1011_1110 : shown <= {shown[27:0], 4'h3};//0011
                        8'b1011_1101 : shown <= {shown[27:0], 4'h6};//0110
                        8'b1011_1011 : shown <= {shown[27:0], 4'h9};
                        default:       shown <= shown;     
                      endcase
                    else
                    begin
                    //����д��λ�󱨴���Ϣ
                        error_message1 <= ~error_message1;
                        shown <= shown;
                    end
        end
    end
            
    //--------------------------------------
    //  ɨ������ֵ���� ����
    //--------------------------------------
endmodule
