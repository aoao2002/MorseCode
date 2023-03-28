`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/24 16:05:18
// Design Name: 
// Module Name: LED
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


module LED(
input switch,
input clk,rst,
input[5:0] state,

output reg [7:0] seg_out
    );
   parameter s0=6'b000000, se=6'b000001, st=6'b000010,si=6'b000011, sa=6'b000100,sn=6'b000101, sm=6'b000110, ss=6'b000111, su=6'b001000, sr=6'b001001, sw=6'b001010,sd=6'b001011, sk=6'b001100,
      sg=6'b001101,so=6'b001110, sh=6'b001111, sv=6'b010000,sf=6'b010001,s4_3=6'b010010, sl=6'b010011,s4_5=6'b010100,sp=6'b010101,sj=6'b010110,sb=6'b010111,sx=6'b011000,sc=6'b011001,sy=6'b011010,
      sz=6'b011011,sq=6'b011100,s4_14=6'b011101,s4_15=6'b011110,s_five=6'b011111, s_four=6'b100000, s_three=6'b100001,s_two=6'b100010, s_one=6'b100011, s_six=6'b100100,s_seven=6'b100101,
      s_eight=6'b100110, s_nine=6'b100111, s_ten=6'b101000, s5_2=6'b101001, s5_4=6'b101010,s5_5=6'b101011,s5_6=6'b101100, s5_8=6'b101101,s5_9=6'b101110, s5_10=6'b101111, s5_11=6'b110000,
      s5_12=6'b110001, s5_13=6'b110010, s5_14=6'b110011, s5_17=6'b110100, s5_18=6'b110101, s5_19=6'b110110, s5_20=6'b110111, s5_21=6'b111000,s5_22=6'b111001,s5_23=6'b111010, s5_25=6'b111011,
      s5_26=6'b111100, s5_27=6'b111101, s5_29=6'b111110;
 always@(negedge clk,posedge rst)
       begin 
       
           if(rst)
              seg_out<=8'b1111_1111;
           else if(switch)
               seg_out<=8'b1111_1111;
           else    
         begin
         case(state)
         sa: seg_out<=8'b0000_1000 ;
         sb: seg_out<=8'b0000_0011 ;
         sc: seg_out<=8'b0100_0110 ;
         sd: seg_out<=8'b0010_0001 ;
         se: seg_out<=8'b0000_0110 ;
         sf: seg_out<=8'b0000_1110 ;
         sg: seg_out<=8'b0100_0010 ;
         sh: seg_out<=8'b0000_1001 ;
         si: seg_out<=8'b0111_0000 ;
         sj: seg_out<=8'b0111_0001 ;
         sk: seg_out<=8'b0000_1010 ;
         sl: seg_out<=8'b0100_0111 ;
         sm: seg_out<=8'b0100_1000 ;
         sn: seg_out<=8'b0010_1011 ;
         so: seg_out<=8'b0010_0011 ;
         sp: seg_out<=8'b0000_1100 ;
         sq: seg_out<=8'b0001_1000 ;
         sr: seg_out<=8'b0100_1110 ;
         ss: seg_out<=8'b0011_0110 ;
         st: seg_out<=8'b0000_0111 ;
         su: seg_out<=8'b0100_0001 ;
         sv: seg_out<=8'b0110_0011 ;
         sw: seg_out<=8'b0000_0001 ;
         sx: seg_out<=8'b1001_1011 ;
         sy: seg_out<=8'b0001_0001 ;
         sz: seg_out<=8'b0010_0101 ;
         s_one: seg_out<=8'b0111_1001 ;
         s_two: seg_out<=8'b0010_0100 ;
         s_three:  seg_out<=8'b0011_0000 ;
         s_four:   seg_out<=8'b0001_1001 ;
         s_five:   seg_out<=8'b0001_0010 ;
         s_six:    seg_out<=8'b0000_0010 ;
         s_seven:  seg_out<=8'b0101_1000 ;
         s_eight:  seg_out<=8'b0000_0000 ;
         s_nine:   seg_out<=8'b0001_0000 ;
         s_ten:    seg_out<=8'b0100_0000 ;
         default:    seg_out<=8'b11111111;
      endcase
     end 
       
 end        
    
endmodule
