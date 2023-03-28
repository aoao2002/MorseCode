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
    input      [3:0] row,                 // 矩阵键盘 行
    output reg [3:0] col,                 // 矩阵键盘 列
    output reg [31:0] shown,
    output          led_error,
    output          led_back
    );
    //++++++++++++++++++++++++++++++++++++++
    // 分频部分 开始
    //++++++++++++++++++++++++++++++++++++++
    reg [19:0] cnt;                         // 计数子
    wire key_clk;
     
    always @ (posedge clk or posedge rst)
      if (rst | (~isAble))
        cnt <= 0;
      else
        cnt <= cnt + 1'b1;
        
    assign key_clk = cnt[19];                // (2^20/50M = 21)ms 
    //--------------------------------------
    // 分频部分 结束
    //--------------------------------------
     
    //++++++++++++++++++++++++++++++++++++++
    // 状态机部分 开始
    //++++++++++++++++++++++++++++++++++++++
    // 状态数较少，独热码编码
    parameter NO_KEY_PRESSED = 6'b000_001;  // 没有按键按下  
    parameter SCAN_COL0      = 6'b000_010;  // 扫描第0列 
    parameter SCAN_COL1      = 6'b000_100;  // 扫描第1列 
    parameter SCAN_COL2      = 6'b001_000;  // 扫描第2列 
    parameter SCAN_COL3      = 6'b010_000;  // 扫描第3列 
    parameter KEY_PRESSED    = 6'b100_000;  // 有按键按下
    
    reg [5:0] current_state, next_state;    // 现态、次态
     
    always @ (posedge key_clk or posedge rst)
      if (rst | (~isAble))
        current_state <= NO_KEY_PRESSED;
      else
        current_state <= next_state;
     
    // 根据条件转移状态
    always @ (*)
      case (current_state)
        NO_KEY_PRESSED :                    // 没有按键按下
            if (row != 4'hF)
              next_state = SCAN_COL0;
            else
              next_state = NO_KEY_PRESSED;
        SCAN_COL0 :                         // 扫描第0列 
            if (row != 4'hF)
              next_state = KEY_PRESSED;
            else
              next_state = SCAN_COL1;
        SCAN_COL1 :                         // 扫描第1列 
            if (row != 4'hF)
              next_state = KEY_PRESSED;
            else
              next_state = SCAN_COL2;    
        SCAN_COL2 :                         // 扫描第2列
            if (row != 4'hF)
              next_state = KEY_PRESSED;
            else
              next_state = SCAN_COL3;
        SCAN_COL3 :                         // 扫描第3列
            if (row != 4'hF)
              next_state = KEY_PRESSED;
            else
              next_state = NO_KEY_PRESSED;
        KEY_PRESSED :                       // 有按键按下
            if (row != 4'hF)
              next_state = KEY_PRESSED;
            else
              next_state = NO_KEY_PRESSED;                      
      endcase
     
    reg       key_pressed_flag;             // 键盘按下标志
    reg [3:0] col_val, row_val;             // 列值、行值
     
    // 根据次态，给相应寄存器赋值
    always @ (posedge key_clk or posedge rst)
      if (rst | (~isAble))
      begin
        col              <= 4'h0;
        key_pressed_flag <=    0;
      end
      else
        case (next_state)
          NO_KEY_PRESSED :                  // 没有按键按下
          begin
            col              <= 4'h0;
            key_pressed_flag <=    0;       // 清键盘按下标志
          end
          SCAN_COL0 :                       // 扫描第0列
            col <= 4'b1110;
          SCAN_COL1 :                       // 扫描第1列
            col <= 4'b1101;
          SCAN_COL2 :                       // 扫描第2列
            col <= 4'b1011;
          SCAN_COL3 :                       // 扫描第3列
            col <= 4'b0111;
          KEY_PRESSED :                     // 有按键按下
          begin
            col_val          <= col;        // 锁存列值
            row_val          <= row;        // 锁存行值
            key_pressed_flag <= 1;          // 置键盘按下标志  
          end
        endcase
    //--------------------------------------
    // 状态机部分 结束
    //--------------------------------------
     
     
    //++++++++++++++++++++++++++++++++++++++
    // 扫描行列值部分 开始
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
                    //这里写满位后报错信息
                        error_message1 <= ~error_message1;
                        shown <= shown;
                    end
        end
    end
            
    //--------------------------------------
    //  扫描行列值部分 结束
    //--------------------------------------
endmodule
