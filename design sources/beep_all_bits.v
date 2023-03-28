`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/28 22:25:49
// Design Name: 
// Module Name: beep_all_bits
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


module beep_all_bits(
    input           isAble,
    input           clk,
    input           rst,
    input           decoder,
    input   [31:0]  shown,
    input           ENCODE,
    input   [7:0]   BIT_CHOOSE,
    input   [7:0]   freq_choose,
    input   [2:0]   speed_choose,
    input   [5:0]   state,
    output          BEEP
    );
//++++++++++++++++++++++++++++++++++++++
 // 蜂鸣器解码部分 开始
//++++++++++++++++++++++++++++++++++++++
    
	 parameter s0=6'b000000, se=6'b000001, st=6'b000010,si=6'b000011, sa=6'b000100,sn=6'b000101, sm=6'b000110, ss=6'b000111, su=6'b001000, sr=6'b001001, sw=6'b001010,sd=6'b001011, sk=6'b001100,
  sg=6'b001101,so=6'b001110, sh=6'b001111, sv=6'b010000,sf=6'b010001,s4_3=6'b010010, sl=6'b010011,s4_5=6'b010100,sp=6'b010101,sj=6'b010110,sb=6'b010111,sx=6'b011000,sc=6'b011001,sy=6'b011010,
  sz=6'b011011,sq=6'b011100,s4_14=6'b011101,s4_15=6'b011110,s_five=6'b011111, s_four=6'b100000, s_three=6'b100001,s_two=6'b100010, s_one=6'b100011, s_six=6'b100100,s_seven=6'b100101,
  s_eight=6'b100110, s_nine=6'b100111, s_ten=6'b101000, s5_2=6'b101001, s5_4=6'b101010,s5_5=6'b101011,s5_6=6'b101100, s5_8=6'b101101,s5_9=6'b101110, s5_10=6'b101111, s5_11=6'b110000,
  s5_12=6'b110001, s5_13=6'b110010, s5_14=6'b110011, s5_17=6'b110100, s5_18=6'b110101, s5_19=6'b110110, s5_20=6'b110111, s5_21=6'b111000,s5_22=6'b111001,s5_23=6'b111010, s5_25=6'b111011,
   s5_26=6'b111100, s5_27=6'b111101, s5_29=6'b111110;
 //
 reg rst_n;
wire decoder_xiao;
//定义音符时序周期数
localparam         M0     = 98800,
                   M1    = 95600,
                   M2    = 85150,
                   M3    = 75850,
                   M4    = 71600,
                   M5  = 63750,
                   M6    = 56800,
                   M7    = 50600;

//信号定义
reg        [16:0]        cnt0        ;    //计数每个音符对应的时序周期
reg        [10:0]        cnt1        ;    //计数每个音符重复次数
reg        [5 :0]        cnt2        ;    //计数曲谱中音符个数

reg        [16:0]        pre_set        ;    //预装载值
wire    [16:0]        pre_div        ;    //占空比

reg        [10:0]        cishu        ;    //定义不同音符重复不同次数
wire    [10:0]        cishu_div    ;    //音符重复次数占空比

reg                 flag        ;    //歌曲种类标志：0小星星，1两只老虎
//消抖
reg delaya1;
buttonEliminateShaking t1(clk,rst,decoder,decoder_xiao);
always@(posedge clk, posedge rst)begin
    if(rst)
     delaya1<=1'b0;
    else 
      delaya1<=decoder_xiao; 
   end
//
wire decoder1=decoder_xiao&&(~delaya1);
//
always@(posedge clk or posedge rst or posedge isAble)
    if(rst)
    begin
        rst_n <= 1'b0;
    end
    else if(isAble)
        rst_n <= 1'b0;
    else 
    begin
        if(decoder1)
            rst_n  <= 1'b1;
    end

    
   
//不同的蜂鸣
    always@(*)  
    begin
    case(state)
        sa,sb,sc,sd,se,sf,sg,sh,si,sj,sk,sl,sm,sn,so,sp,sq,sr,ss,st,su,sv,sw,sx,sy,sz,s_one,s_two,s_three,s_four,s_five,s_six,s_seven,s_eight,s_nine,s_ten: flag=1'b0;//成功编译
        default:  flag = 1'b1; //未成功编译
    endcase
    end   
//    

   
   //计数每个音符的周期，也就是表示音符的一个周期
   always @(posedge clk or negedge rst_n) begin
       if(!rst_n) begin
           cnt0 <= 0;
       end
       else begin
           if(cnt0 == pre_set - 1)
               cnt0 <= 0;
           else
               cnt0 <= cnt0 + 1;
       end
   end
   
   //计数每个音符重复次数，也就是表示一个音符的响鸣持续时长
   always @(posedge clk or negedge rst_n) begin
       if(!rst_n) begin
           cnt1 <= 0;
       end
      
       else begin
           if(cnt0 == pre_set - 1)begin
               if(cnt1 == cishu)
                   cnt1 <= 0;
               else
                   cnt1 <= cnt1 + 1;
           end
       end
   end
   
   //计数有多少个音符，也就是曲谱中有共多少个音符
   always @(posedge clk or negedge rst_n) begin
       if(!rst_n) begin
           cnt2 <= 0;
       end
       else if(decoder1)
           cnt2<=0;
        else begin
           if(cnt1 == cishu && cnt0 == pre_set - 1) begin
               if(cnt2==15) cnt2<=15;
               else   cnt2 <= cnt2 + 1;
           end
       end
   end
   
   //定义音符重复次数
   always @(*) begin
       case(pre_set)
           M0:cishu = 242;
           M1:cishu = 250;
           M2:cishu = 281;
           M3:cishu = 315;
           M4:cishu = 334;
           M5:cishu = 375;
           M6:cishu = 421;
           M7:cishu = 472;
       endcase
   end
   
   //曲谱定义
   always @(*) begin
       if(flag == 1'b0) 
       begin
           case(cnt2)    //小星星歌谱
               0 : pre_set = M1;
               1 : pre_set = M1;
               2 : pre_set = M5;
               3 : pre_set = M5;
               4 : pre_set = M6;
               5 : pre_set = M6;
               6 : pre_set = M5;
               7 : pre_set = M0;
               8 : pre_set = M4;
               9 : pre_set = M4;
               10: pre_set = M3;
               11: pre_set = M3;
               12: pre_set = M2;
               13: pre_set = M2;
               14: pre_set = M1;
               15: pre_set = M0;
            endcase
        end
        else 
        begin
        case(cnt2)    //两只老虎歌谱
            0 : pre_set = M1;
            1 : pre_set = M2;
            2 : pre_set = M3;
            3 : pre_set = M1;
            4 : pre_set = M1;
            5 : pre_set = M2;
            6 : pre_set = M3;
            7 : pre_set = M1;
            8 : pre_set = M3;
            9 : pre_set = M4;
            10: pre_set = M5;
            11: pre_set = M0;
            12: pre_set = M3;
            13: pre_set = M4;
            14: pre_set = M5;
            15: pre_set = M0;
        endcase
        end
    end  
    
    assign pre_div = pre_set >> 1;    //除以2
    assign cishu_div = cishu * 4 / 5;

    

//--------------------------------------
// 蜂鸣器解码部分 结束
//--------------------------------------

    
//++++++++++++++++++++++++++++++++++++++
// 蜂鸣器控制 开始
//++++++++++++++++++++++++++++++++++++++

    reg [27:0] speed_period;

    always @(*)
        case(speed_choose)
            3'b100: speed_period = 28'd5000_0000;
            3'b010: speed_period = 28'd2500_0000;
            3'b001: speed_period = 28'd1250_0000;
            default: speed_period = 28'd5000_0000;
        endcase

    reg [17:0] time_cnt, time_cnt_n, freq, freq_n;    //每个音调的分频值，以及用来算周期的计数器

    always @(posedge clk, posedge rst)
    if(rst)
    begin
        time_cnt <= 1'b0;
    end
    else if(~isAble)
        time_cnt <= 1'b0;
    else
        time_cnt <= time_cnt_n;
    
    always @(*)
        if(time_cnt == freq)
            time_cnt_n = 1'b0;
        else
            time_cnt_n = time_cnt + 1'b1;
            
    always @(*)
        case(freq_choose)
            8'b0000_0001:   freq_n = 18'd187864;
            8'b0000_0010:   freq_n = 18'd170271;
            8'b0000_0100:   freq_n = 18'd151676;
            8'b0000_1000:   freq_n = 18'd143164;
            8'b0001_0000:   freq_n = 18'd127551;
            8'b0010_0000:   freq_n = 18'd113636;
            8'b0100_0000:   freq_n = 18'd101235;
            8'b1000_0000:   freq_n = 18'd95556;
            default:        freq_n = 18'd0;
        endcase

    reg [17:0] time_cnt_oneBit, time_cnt_oneBit_n, freq_oneBit, freq_n_oneBit;
    always @(posedge clk, posedge rst)
    if(rst)
    begin
        time_cnt_oneBit <= 1'b0;
    end
    else if(~isAble)
        time_cnt_oneBit <= 1'b0;
    else
        time_cnt_oneBit <= time_cnt_oneBit_n;
    
    always @(*)
        if(time_cnt_oneBit == freq_oneBit)
            time_cnt_oneBit_n = 1'b0;
        else
            time_cnt_oneBit_n = time_cnt_oneBit + 1'b1;

    always @(*)
        case(freq_choose)
            8'b0000_0001:   freq_n_oneBit = 18'd187864;
            8'b0000_0010:   freq_n_oneBit = 18'd170271;
            8'b0000_0100:   freq_n_oneBit = 18'd151676;
            8'b0000_1000:   freq_n_oneBit = 18'd143164;
            8'b0001_0000:   freq_n_oneBit = 18'd127551;
            8'b0010_0000:   freq_n_oneBit = 18'd113636;
            8'b0100_0000:   freq_n_oneBit = 18'd101235;
            8'b1000_0000:   freq_n_oneBit = 18'd95556;
            default:        freq_n_oneBit = 18'd0;
        endcase

    reg beep_reg, beep_reg_n;
    assign BEEP = beep_reg;
    
    always @(posedge clk, posedge rst)
        if(rst)
            beep_reg <= 1'b0;
        else if(~isAble)
            if(!rst_n) begin
                beep_reg <= 1'b1;
            end
            else if(pre_set != M0) begin
                if(cnt1 < cishu_div) begin
                    if(cnt0 < pre_div) begin
                            beep_reg <= 1'b1;
                    end
                    else begin
                            beep_reg <= 1'b0;
                    end
                end
                else begin
                    beep_reg <= 1'b1;
                end
            end
            else
                beep_reg <= 1'b1;
        else
            beep_reg <= beep_reg_n;
    
    always @(*)
        if(time_cnt == freq && time_cnt_oneBit == freq_oneBit)
            beep_reg_n = ~beep_reg;
        else
            beep_reg_n = beep_reg;

//--------------------------------------
// 蜂鸣器控制 结束
//--------------------------------------

//++++++++++++++++++++++++++++++++++++++
// 一次性解码所有比特位 开始
//++++++++++++++++++++++++++++++++++++++



    wire encode1;
    buttonEliminateShaking encodeES(clk,rst,ENCODE,encode1);
    reg delay_all;
    wire encode2 = encode1 && (~delay_all);
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay_all <= 1'b0;
        else if(~isAble)
            delay_all <= 1'b0;
        else 
            delay_all <= encode1; 
    end

    reg [150:0] tranInfo;   //把shown转化成0101串，0停0.5s，1响0.5s
    reg [3:0] bitInfo;
    reg [3:0] cnt_1;
    reg [7:0] cnt_2; 
    reg [7:0] cnt_3;
    reg [27:0] cnt_4;
    
    always@(posedge clk, posedge rst)
    begin
        if(rst)
        begin
            cnt_2 <= 8'd0;
            cnt_4 <= 28'd5000_0000;
        end
        else if(~isAble)
        begin
            cnt_2 <= 8'd0;
            cnt_4 <= 28'd5000_0000;
        end
        else
            if(encode2)
            begin
                cnt_2 <= 8'd0;
                cnt_4 <= 28'd0;
            end
            else
                if(cnt_1 == 4'd8)
                    if(cnt_2 < cnt_3)
                        if(cnt_4 == speed_period)  //此处可调整速度
                        begin
                            cnt_4 <= 28'd0;
                            cnt_2 <= cnt_2 + 1;
                        end
                        else
                            cnt_4 <= cnt_4 + 1;
    end
    
    reg cur;
    always@(*)
    case(cnt_2)
        8'd0:   cur = tranInfo[0];
        8'd1:   cur = tranInfo[1];
        8'd2:   cur = tranInfo[2];
        8'd3:   cur = tranInfo[3];
        8'd4:   cur = tranInfo[4];
        8'd5:   cur = tranInfo[5];
        8'd6:   cur = tranInfo[6];
        8'd7:   cur = tranInfo[7];
        8'd8:   cur = tranInfo[8];
        8'd9:   cur = tranInfo[9];
        8'd10:   cur = tranInfo[10];
        8'd11:   cur = tranInfo[11];
        8'd12:   cur = tranInfo[12];
        8'd13:   cur = tranInfo[13];
        8'd14:   cur = tranInfo[14];
        8'd15:   cur = tranInfo[15];
        8'd16:   cur = tranInfo[16];
        8'd17:   cur = tranInfo[17];
        8'd18:   cur = tranInfo[18];
        8'd19:   cur = tranInfo[19];
        8'd20:   cur = tranInfo[20];
        8'd21:   cur = tranInfo[21];
        8'd22:   cur = tranInfo[22];
        8'd23:   cur = tranInfo[23];
        8'd24:   cur = tranInfo[24];
        8'd25:   cur = tranInfo[25];
        8'd26:   cur = tranInfo[26];
        8'd27:   cur = tranInfo[27];
        8'd28:   cur = tranInfo[28];
        8'd29:   cur = tranInfo[29];
        8'd30:   cur = tranInfo[30];
        8'd31:   cur = tranInfo[31];
        8'd32:   cur = tranInfo[32];
        8'd33:   cur = tranInfo[33];
        8'd34:   cur = tranInfo[34];
        8'd35:   cur = tranInfo[35];
        8'd36:   cur = tranInfo[36];
        8'd37:   cur = tranInfo[37];
        8'd38:   cur = tranInfo[38];
        8'd39:   cur = tranInfo[39];
        8'd40:   cur = tranInfo[40];
        8'd41:   cur = tranInfo[41];
        8'd42:   cur = tranInfo[42];
        8'd43:   cur = tranInfo[43];
        8'd44:   cur = tranInfo[44];
        8'd45:   cur = tranInfo[45];
        8'd46:   cur = tranInfo[46];
        8'd47:   cur = tranInfo[47];
        8'd48:   cur = tranInfo[48];
        8'd49:   cur = tranInfo[49];
        8'd50:   cur = tranInfo[50];
        8'd51:   cur = tranInfo[51];
        8'd52:   cur = tranInfo[52];
        8'd53:   cur = tranInfo[53];
        8'd54:   cur = tranInfo[54];
        8'd55:   cur = tranInfo[55];
        8'd56:   cur = tranInfo[56];
        8'd57:   cur = tranInfo[57];
        8'd58:   cur = tranInfo[58];
        8'd59:   cur = tranInfo[59];
        8'd60:   cur = tranInfo[60];
        8'd61:   cur = tranInfo[61];
        8'd62:   cur = tranInfo[62];
        8'd63:   cur = tranInfo[63];
        8'd64:   cur = tranInfo[64];
        8'd65:   cur = tranInfo[65];
        8'd66:   cur = tranInfo[66];
        8'd67:   cur = tranInfo[67];
        8'd68:   cur = tranInfo[68];
        8'd69:   cur = tranInfo[69];
        8'd70:   cur = tranInfo[70];
        8'd71:   cur = tranInfo[71];
        8'd72:   cur = tranInfo[72];
        8'd73:   cur = tranInfo[73];
        8'd74:   cur = tranInfo[74];
        8'd75:   cur = tranInfo[75];
        8'd76:   cur = tranInfo[76];
        8'd77:   cur = tranInfo[77];
        8'd78:   cur = tranInfo[78];
        8'd79:   cur = tranInfo[79];
        8'd80:   cur = tranInfo[80];
        8'd81:   cur = tranInfo[81];
        8'd82:   cur = tranInfo[82];
        8'd83:   cur = tranInfo[83];
        8'd84:   cur = tranInfo[84];
        8'd85:   cur = tranInfo[85];
        8'd86:   cur = tranInfo[86];
        8'd87:   cur = tranInfo[87];
        8'd88:   cur = tranInfo[88];
        8'd89:   cur = tranInfo[89];
        8'd90:   cur = tranInfo[90];
        8'd91:   cur = tranInfo[91];
        8'd92:   cur = tranInfo[92];
        8'd93:   cur = tranInfo[93];
        8'd94:   cur = tranInfo[94];
        8'd95:   cur = tranInfo[95];
        8'd96:   cur = tranInfo[96];
        8'd97:   cur = tranInfo[97];
        8'd98:   cur = tranInfo[98];
        8'd99:   cur = tranInfo[99];
        8'd100:   cur = tranInfo[100];
        8'd101:   cur = tranInfo[101];
        8'd102:   cur = tranInfo[102];
        8'd103:   cur = tranInfo[103];
        8'd104:   cur = tranInfo[104];
        8'd105:   cur = tranInfo[105];
        8'd106:   cur = tranInfo[106];
        8'd107:   cur = tranInfo[107];
        8'd108:   cur = tranInfo[108];
        8'd109:   cur = tranInfo[109];
        8'd110:   cur = tranInfo[110];
        8'd111:   cur = tranInfo[111];
        8'd112:   cur = tranInfo[112];
        8'd113:   cur = tranInfo[113];
        8'd114:   cur = tranInfo[114];
        8'd115:   cur = tranInfo[115];
        8'd116:   cur = tranInfo[116];
        8'd117:   cur = tranInfo[117];
        8'd118:   cur = tranInfo[118];
        8'd119:   cur = tranInfo[119];
        8'd120:   cur = tranInfo[120];
        8'd121:   cur = tranInfo[121];
        8'd122:   cur = tranInfo[122];
        8'd123:   cur = tranInfo[123];
        8'd124:   cur = tranInfo[124];
        8'd125:   cur = tranInfo[125];
        8'd126:   cur = tranInfo[126];
        8'd127:   cur = tranInfo[127];
        8'd128:   cur = tranInfo[128];
        8'd129:   cur = tranInfo[129];
        8'd130:   cur = tranInfo[130];
        8'd131:   cur = tranInfo[131];
        8'd132:   cur = tranInfo[132];
        8'd133:   cur = tranInfo[133];
        8'd134:   cur = tranInfo[134];
        8'd135:   cur = tranInfo[135];
        8'd136:   cur = tranInfo[136];
        8'd137:   cur = tranInfo[137];
        8'd138:   cur = tranInfo[138];
        8'd139:   cur = tranInfo[139];
        8'd140:   cur = tranInfo[140];
        8'd141:   cur = tranInfo[141];
        8'd142:   cur = tranInfo[142];
        8'd143:   cur = tranInfo[143];
        8'd144:   cur = tranInfo[144];
        8'd145:   cur = tranInfo[145];
        8'd146:   cur = tranInfo[146];
        8'd147:   cur = tranInfo[147];
        8'd148:   cur = tranInfo[148];
        8'd149:   cur = tranInfo[149];
        8'd150:   cur = tranInfo[150];
        default:  cur = 1'b0;
    endcase
    
    always @(posedge clk, posedge rst)
    if(rst)
        freq <= 18'd0;
    else if(encode2)
        freq <= 18'd0;
    else if(~isAble)
        freq <= 18'd0;
    else
        if(cnt_1 == 4'd8)
            if(cnt_2 < cnt_3)
                case(cur)
                    1'b1:   freq <= freq_n;
                    1'b0:   freq <= 18'd0;
                endcase
            else
                freq <= 18'd0;
        else
            freq <= 18'd0;
    
    always @(posedge clk, posedge rst)
    begin
        if(rst)
            cnt_1 <= 4'd8;
        else if(~isAble)
            cnt_1 <= 4'd8;
        else
            if(encode2)
                cnt_1 <= 4'd0;
            else
                if(cnt_1 < 4'd8)
                    cnt_1 <= cnt_1 + 1;
                else
                    cnt_1 <= cnt_1;
    end
    
    always@(*)
    if(rst)
        bitInfo = 4'd0;
    else if(~isAble)
        bitInfo = 4'd0;
    else
        case(cnt_1)
            4'd0:   bitInfo = shown[3:0];
            4'd1:   bitInfo = shown[7:4];
            4'd2:   bitInfo = shown[11:8];
            4'd3:   bitInfo = shown[15:12];
            4'd4:   bitInfo = shown[19:16];
            4'd5:   bitInfo = shown[23:20];
            4'd6:   bitInfo = shown[27:24];
            4'd7:   bitInfo = shown[31:28];
            default:bitInfo = 4'h0;
        endcase
    
    always @(posedge clk, posedge rst)
    begin
    if(rst)
    begin
        cnt_3 <= 8'd0;
        tranInfo <= 151'd0;
    end
    else if(encode2)
    begin
        cnt_3 <= 8'd0;
        tranInfo <= 151'd0;
    end
    else if(~isAble)
    begin
        cnt_3 <= 8'd0;
        tranInfo <= 151'd0;
    end    
    else
        case(bitInfo)
            4'h1:   begin tranInfo <= {tranInfo[133:0], 17'b0000_1101_1011_0110_1};  cnt_3 <= cnt_3 + 17; end
            4'h2:   begin tranInfo <= {tranInfo[135:0], 15'b0000_1101_1011_0101};    cnt_3 <= cnt_3 + 16; end
            4'h3:   begin tranInfo <= {tranInfo[135:0], 15'b0000_1101_1010_101};     cnt_3 <= cnt_3 + 15; end
            4'h4:   begin tranInfo <= {tranInfo[136:0], 14'b0000_1101_0101_01};      cnt_3 <= cnt_3 + 14; end
            4'h5:   begin tranInfo <= {tranInfo[137:0], 13'b0000_1010_1010_1};       cnt_3 <= cnt_3 + 13; end
            4'h6:   begin tranInfo <= {tranInfo[136:0], 14'b0000_1010_1010_11};      cnt_3 <= cnt_3 + 14; end
            4'h7:   begin tranInfo <= {tranInfo[135:0], 15'b0000_1010_1011_011};     cnt_3 <= cnt_3 + 15; end
            4'h8:   begin tranInfo <= {tranInfo[134:0], 16'b0000_1010_1101_1011};    cnt_3 <= cnt_3 + 16; end
            4'h9:   begin tranInfo <= {tranInfo[133:0], 17'b0000_1011_0110_1101_1};  cnt_3 <= cnt_3 + 17; end
            4'ha:   begin tranInfo <= {tranInfo[132:0], 18'b0000_1101_1011_0110_11}; cnt_3 <= cnt_3 + 18; end
            default:begin tranInfo <= tranInfo; cnt_3 <= cnt_3; end
        endcase
    end

//--------------------------------------
// 一次性解码所有比特位 结束
//--------------------------------------


//++++++++++++++++++++++++++++++++++++++
// 每一位比特位分别解码 开始
//++++++++++++++++++++++++++++++++++++++

    wire bit71, bit61, bit51, bit41, bit31, bit21, bit11,bit01;
    buttonEliminateShaking bit0_ES(clk,rst,BIT_CHOOSE[0],bit01);
    buttonEliminateShaking bit1_ES(clk,rst,BIT_CHOOSE[1],bit11);
    buttonEliminateShaking bit2_ES(clk,rst,BIT_CHOOSE[2],bit21);
    buttonEliminateShaking bit3_ES(clk,rst,BIT_CHOOSE[3],bit31);
    buttonEliminateShaking bit4_ES(clk,rst,BIT_CHOOSE[4],bit41);
    buttonEliminateShaking bit5_ES(clk,rst,BIT_CHOOSE[5],bit51);
    buttonEliminateShaking bit6_ES(clk,rst,BIT_CHOOSE[6],bit61);
    buttonEliminateShaking bit7_ES(clk,rst,BIT_CHOOSE[7],bit71);
    
//--------------------——————————
    reg delay0;
    wire bit02 = bit01 && (~delay0);
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay0 <= 1'b0;
        else if(~isAble)
            delay0 <= 1'b0;
        else 
            delay0 <= bit01; 
    end
    
    reg delay1;
    wire bit12 = bit11 && (~delay1);
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay1 <= 1'b0;
        else if(~isAble)
            delay1 <= 1'b0;
        else 
            delay1 <= bit11; 
    end
    
    reg delay2;
    wire bit22 = bit21 && (~delay2);
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay2 <= 1'b0;
        else if(~isAble)
            delay2 <= 1'b0;
        else 
            delay2 <= bit21; 
    end
    
    reg delay3;
    wire bit32 = bit31 && (~delay3);
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay3 <= 1'b0;
        else if(~isAble)
            delay3 <= 1'b0;
        else 
            delay3 <= bit31; 
    end
    
    reg delay4;
    wire bit42 = bit41 && (~delay4);
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay4 <= 1'b0;
        else if(~isAble)
            delay4 <= 1'b0;
        else 
            delay4 <= bit41; 
    end
    
    reg delay5;
    wire bit52 = bit51 && (~delay5);
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay5 <= 1'b0;
        else if(~isAble)
            delay5 <= 1'b0;
        else 
            delay5 <= bit51; 
    end
    
    reg delay6;
    wire bit62 = bit61 && (~delay6);
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay6 <= 1'b0;
        else if(~isAble)
            delay6 <= 1'b0;
        else 
            delay6 <= bit61; 
    end
    
    reg delay7;
    wire bit72 = bit71 && (~delay7);
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay7 <= 1'b0;
        else if(~isAble)
            delay7 <= 1'b0;
        else 
            delay7 <= bit71; 
    end
    //————————————————————
    
    reg [17:0] tranInfo_oneBit;   //把shown转化成0101串，0停0.5s，1响0.5s
    reg [3:0] bitInfo_oneBit;
    reg [3:0] cnt_1_oneBit;
    reg [7:0] cnt_2_oneBit; 
    reg [7:0] cnt_3_oneBit;
    reg [27:0] cnt_4_oneBit;
    wire press = bit02 | bit12 | bit22 | bit32 | bit42 | bit52 | bit62 | bit72;
        
    always@(posedge clk, posedge rst)
    begin
        if(rst)
        begin
            cnt_2_oneBit <= 8'd0;
            cnt_4_oneBit <= 28'd5000_0000;
        end
        else if(~isAble)
        begin
            cnt_2_oneBit <= 8'd0;
            cnt_4_oneBit <= 28'd5000_0000;
        end
        else
            if(press)
            begin
                cnt_2_oneBit <= 8'd0;
                cnt_4_oneBit <= 28'd0;
            end
            else
                if(cnt_1_oneBit == 4'd8)
                    if(cnt_2_oneBit < cnt_3_oneBit)
                        if(cnt_4_oneBit == speed_period)  //此处可调整速度
                        begin
                            cnt_4_oneBit <= 28'd0;
                            cnt_2_oneBit <= cnt_2_oneBit + 1;
                        end
                        else
                            cnt_4_oneBit <= cnt_4_oneBit + 1;
    end
        
    reg cur_oneBit;
    always@(*)
    case(cnt_2_oneBit)
        8'd0:   cur_oneBit = tranInfo_oneBit[0];
        8'd1:   cur_oneBit = tranInfo_oneBit[1];
        8'd2:   cur_oneBit = tranInfo_oneBit[2];
        8'd3:   cur_oneBit = tranInfo_oneBit[3];
        8'd4:   cur_oneBit = tranInfo_oneBit[4];
        8'd5:   cur_oneBit = tranInfo_oneBit[5];
        8'd6:   cur_oneBit = tranInfo_oneBit[6];
        8'd7:   cur_oneBit = tranInfo_oneBit[7];
        8'd8:   cur_oneBit = tranInfo_oneBit[8];
        8'd9:   cur_oneBit = tranInfo_oneBit[9];
        8'd10:   cur_oneBit = tranInfo_oneBit[10];
        8'd11:   cur_oneBit = tranInfo_oneBit[11];
        8'd12:   cur_oneBit = tranInfo_oneBit[12];
        8'd13:   cur_oneBit = tranInfo_oneBit[13];
        8'd14:   cur_oneBit = tranInfo_oneBit[14];
        8'd15:   cur_oneBit = tranInfo_oneBit[15];
        8'd16:   cur_oneBit = tranInfo_oneBit[16];
        8'd17:   cur_oneBit = tranInfo_oneBit[17];
        default:    cur_oneBit = 1'b0;
    endcase
        
    always @(posedge clk, posedge rst)
    if(rst)
        freq_oneBit <= 18'd0;
    else if(press)
        freq_oneBit <= 18'd0;
    else if(~isAble)
        freq_oneBit <= 18'd0;
    else
        if(cnt_1_oneBit == 4'd8)
            if(cnt_2_oneBit < cnt_3_oneBit)
                case(cur_oneBit)
                    1'b1:   freq_oneBit <= freq_n_oneBit;
                    1'b0:   freq_oneBit <= 18'd0;
                endcase
            else
               freq_oneBit <= 18'd0;
        else
            freq_oneBit <= 18'd0;
        
    always @(posedge clk, posedge rst)
    begin
        if(rst)
            cnt_1_oneBit <= 4'd8;
        else if(~isAble)
            cnt_1_oneBit <= 4'd8;
        else
            if(press)
                if(bit02)
                   cnt_1_oneBit <= 4'd0; 
                else if(bit12)
                    cnt_1_oneBit <= 4'd1;
                else if(bit22)
                    cnt_1_oneBit <= 4'd2;
                else if(bit32)
                    cnt_1_oneBit <= 4'd3;
                else if(bit42)
                    cnt_1_oneBit <= 4'd4;
                else if(bit52)
                    cnt_1_oneBit <= 4'd5;
                else if(bit62)
                    cnt_1_oneBit <= 4'd6;
                else if(bit72)
                    cnt_1_oneBit <= 4'd7;
                else
                    cnt_1_oneBit <= 4'd8;
            else
                if(cnt_1_oneBit != 4'd8)
                    cnt_1_oneBit <= 4'd8;
                else
                    cnt_1_oneBit <= cnt_1_oneBit;
    end
        
    always@(*)
        if(rst)
            bitInfo_oneBit = 4'd0;
        else if(~isAble)
            bitInfo_oneBit = 4'd0;
        else
        case(cnt_1_oneBit)
            4'd0:   bitInfo_oneBit = shown[3:0];
            4'd1:   bitInfo_oneBit = shown[7:4];
            4'd2:   bitInfo_oneBit = shown[11:8];
            4'd3:   bitInfo_oneBit = shown[15:12];
            4'd4:   bitInfo_oneBit = shown[19:16];
            4'd5:   bitInfo_oneBit = shown[23:20];
            4'd6:   bitInfo_oneBit = shown[27:24];
            4'd7:   bitInfo_oneBit = shown[31:28];
            default:bitInfo_oneBit = 4'h0;
        endcase
        
    always @(posedge rst, posedge clk)
    begin
    if(rst)
    begin
        cnt_3_oneBit <= 8'd0;
        tranInfo_oneBit <= 18'd0;
    end
    else if(press)
    begin
        cnt_3_oneBit <= 8'd0;
        tranInfo_oneBit <= 18'd0;
    end
    else if(~isAble)
    begin
        cnt_3_oneBit <= 8'd0;
        tranInfo_oneBit <= 18'd0;
    end        
    else
        case(bitInfo_oneBit)
            4'h1:   begin tranInfo_oneBit <= 18'b0000_1101_1011_0110_1;  cnt_3_oneBit <= cnt_3_oneBit + 17; end
            4'h2:   begin tranInfo_oneBit <= 18'b0000_1101_1011_0101;    cnt_3_oneBit <= cnt_3_oneBit + 16; end
            4'h3:   begin tranInfo_oneBit <= 18'b0000_1101_1010_101;     cnt_3_oneBit <= cnt_3_oneBit + 15; end
            4'h4:   begin tranInfo_oneBit <= 18'b0000_1101_0101_01;      cnt_3_oneBit <= cnt_3_oneBit + 14; end
            4'h5:   begin tranInfo_oneBit <= 18'b0000_1010_1010_1;       cnt_3_oneBit <= cnt_3_oneBit + 13; end
            4'h6:   begin tranInfo_oneBit <= 18'b0000_1010_1010_11;      cnt_3_oneBit <= cnt_3_oneBit + 14; end
            4'h7:   begin tranInfo_oneBit <= 18'b0000_1010_1011_011;     cnt_3_oneBit <= cnt_3_oneBit + 15; end
            4'h8:   begin tranInfo_oneBit <= 18'b0000_1010_1101_1011;    cnt_3_oneBit <= cnt_3_oneBit + 16; end
            4'h9:   begin tranInfo_oneBit <= 18'b0000_1011_0110_1101_1;  cnt_3_oneBit <= cnt_3_oneBit + 17; end
            4'ha:   begin tranInfo_oneBit <= 18'b0000_1101_1011_0110_11; cnt_3_oneBit <= cnt_3_oneBit + 18; end
            default:begin tranInfo_oneBit <= tranInfo_oneBit;            cnt_3_oneBit <= cnt_3_oneBit; end
        endcase
    end
    

        
//--------------------------------------
// 每一位比特位分别解码 结束
//--------------------------------------     


endmodule
