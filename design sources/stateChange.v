`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/23 22:12:33
// Design Name: 
// Module Name: stateChange_1
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


module stateChange(
    input                   switch,
    input                   clk,
    input                   decoder,
    input                   rst,
    input                   x1,
    input                   x2,
    input                   d3,
    output  reg     [3:0]   cnt,
    output  reg     [5:0]   state,
    output  reg     [47:0]  shown,
    output  wire    [4:0]   code,
    output  reg             error,
    output  reg             over,
    output  reg     [5:0]   statew
    );
    
  
    reg[3:0] cnt1;  
    reg code1, code2 ,code3, code4, code5; 
    wire clk_2s;  
    reg reverse;  
    reg over_n;
    reg [5:0] n, n1; 
    reg delay1, delay2, delay3;
    reg delay4; 
    wire decoder1;  
    wire x_in11; 
    wire x_in22; 
    wire x_delete1;  
    assign code={code1,code2,code3,code4,code5} ; 
    
    clk_long2(clk,rst,clk_2s);
    buttonEliminateShaking t1(clk,rst,x1,x_in11);
    buttonEliminateShaking t2(clk,rst,x2,x_in22);
    buttonEliminateShaking t3(clk,rst,d3,x_delete1);
    buttonEliminateShaking t4(clk,rst,decoder,decoder1);
     
    parameter s0=6'b000000, se=6'b000001, st=6'b000010,si=6'b000011, sa=6'b000100,sn=6'b000101, sm=6'b000110, ss=6'b000111, su=6'b001000, sr=6'b001001, sw=6'b001010,sd=6'b001011, sk=6'b001100,
    sg=6'b001101,so=6'b001110, sh=6'b001111, sv=6'b010000,sf=6'b010001,s4_3=6'b010010, sl=6'b010011,s4_5=6'b010100,sp=6'b010101,sj=6'b010110,sb=6'b010111,sx=6'b011000,sc=6'b011001,sy=6'b011010,
    sz=6'b011011,sq=6'b011100,s4_14=6'b011101,s4_15=6'b011110,s_five=6'b011111, s_four=6'b100000, s_three=6'b100001,s_two=6'b100010, s_one=6'b100011, s_six=6'b100100,s_seven=6'b100101,
    s_eight=6'b100110, s_nine=6'b100111, s_ten=6'b101000, s5_2=6'b101001, s5_4=6'b101010,s5_5=6'b101011,s5_6=6'b101100, s5_8=6'b101101,s5_9=6'b101110, s5_10=6'b101111, s5_11=6'b110000,
    s5_12=6'b110001, s5_13=6'b110010, s5_14=6'b110011, s5_17=6'b110100, s5_18=6'b110101, s5_19=6'b110110, s5_20=6'b110111, s5_21=6'b111000,s5_22=6'b111001,s5_23=6'b111010, s5_25=6'b111011,
    s5_26=6'b111100, s5_27=6'b111101, s5_29=6'b111110;
    always@(posedge clk, posedge rst)begin
        if(rst)
            delay1<=1'b0;
        else 
            delay1<=x_in11; 
    end
    
    always@(posedge clk, posedge rst)
    begin
        if(rst)
            delay2<=1'b0;
        else 
            delay2<=x_in22; 
    end
       
        always@(posedge clk, posedge rst)begin
           if(rst)
            delay3<=1'b0;
           else 
             delay3<=x_delete1; 
          end
          
          always@(posedge clk, posedge rst)begin
                   if(rst)
                    delay4<=1'b0;
                   else 
                     delay4<=decoder1; 
                  end  
          
       wire x_in1=x_in11&&(~delay1);
       wire x_in2=x_in22&&(~delay2);
       wire x_delete=x_delete1&&(~delay3);
       wire x_decoder=decoder1&&(~delay4);
       
       
//       always@(posedge clk)begin
//         if(~x_decoder)
//            statew<=state;
//         else
//           statew<=statew;   
       
//       end
       
          
    always@(posedge clk)begin
       if(clk_2s)
         reverse<=1'b1;
       else
          reverse<=1'b0;
     end
    
    
    always @(posedge clk, posedge rst) begin
        if(rst)
        begin
           state <= s0;
           statew <= s0;
        end
       else
       begin
            state <= n;
            statew <= n1;
       end
    end
   
    
   always @(posedge clk, posedge rst) begin
        if(rst)
        begin
            n <= s0;
            n1 <= s0;
        end
        else if(switch)
        begin
               n <= s0;  
               n1 <= s0;
        end  
        else if(x_decoder|cnt>4'b0101)
        begin
            n<=s0;    
            n1 <= n1;
        end
        else
        begin
         case(n)
         s0: if(x_in1) n<=st; else if(x_in2) n<=se; else if(x_delete) n<=s0;
         se: if(x_in1) n<=sa; else if(x_in2) n<=si; else if(x_delete) n<=s0;
         st: if(x_in1) n<=sm; else if(x_in2) n<=sn; else if(x_delete) n<=s0;
         si: if(x_in1) n<=su; else if(x_in2) n<=ss; else if(x_delete) n<=se;
         sa: if(x_in1) n<=sw; else if(x_in2) n<=sr; else if(x_delete) n<=se;
         sn: if(x_in1) n<=sk; else if(x_in2) n<=sd; else if(x_delete) n<=st;
         sm: if(x_in1) n<=so; else if(x_in2) n<=sg; else if(x_delete) n<=st;
         ss: if(x_in1) n<=sv; else if(x_in2) n<=sh; else if(x_delete) n<=si;
         su: if(x_in1) n<=s4_3; else if(x_in2) n<=sf; else if(x_delete) n<=si;
         sr: if(x_in1) n<=s4_5; else if(x_in2) n<=sl; else if(x_delete) n<=sa;
         sw: if(x_in1) n<=sj; else if(x_in2) n<=sp; else if(x_delete) n<=sa;
         sd: if(x_in1) n<=sx; else if(x_in2) n<=sb; else if(x_delete) n<=sn;
         sk: if(x_in1) n<=sy; else if(x_in2) n<=sc; else if(x_delete) n<=sn;
         sg: if(x_in1) n<=sq; else if(x_in2) n<=sz; else if(x_delete) n<=sm;
         so: if(x_in1) n<=s4_15; else if(x_in2) n<=s4_14; else if(x_delete) n<=sm;  
         sh:if(x_in1) n<=s_four; else if(x_in2) n<=s_five; else if(x_delete) n<=ss;
         sv:if(x_in1) n<=s_three; else if(x_in2) n<=s5_2; else if(x_delete) n<=ss;
         sf:if(x_in1) n<=s5_5; else if(x_in2) n<=s5_4; else if(x_delete) n<=su;
         s4_3:if(x_in1) n<=s_two; else if(x_in2) n<=s5_6; else if(x_delete) n<=su;
         sl:if(x_in1) n<=s5_9; else if(x_in2) n<=s5_8; else if(x_delete) n<=sr;
         s4_5:if(x_in1) n<=s5_11; else if(x_in2) n<=s5_10; else if(x_delete) n<=sr;
         sp:if(x_in1) n<=s5_13; else if(x_in2) n<=s5_12; else if(x_delete) n<=sw;
         sj: if(x_in1) n<=s_one; else if(x_in2) n<=s5_14; else if(x_delete) n<=sw;
         sb:if(x_in1) n<=s5_17; else if(x_in2) n<=s_six; else if(x_delete) n<=sd;
         sx: if(x_in1) n<=s5_19; else if(x_in2) n<=s5_18; else if(x_delete) n<=sd;
         sc: if(x_in1) n<=s5_21; else if(x_in2) n<=s5_20; else if(x_delete) n<=sk;
         sy:if(x_in1) n<=s5_23; else if(x_in2) n<=s5_22; else if(x_delete) n<=sk;
         sz: if(x_in1) n<=s5_25; else if(x_in2) n<=s_seven; else if(x_delete) n<=sg;
         sq: if(x_in1) n<=s5_27; else if(x_in2) n<=s5_26; else if(x_delete) n<=sg;
         s4_14: if(x_in1) n<=s5_29; else if(x_in2) n<=s_eight; else if(x_delete) n<=so;
         s4_15: if(x_in1) n<=s_ten; else if(x_in2) n<=s_nine; else if(x_delete) n<=so;
         s_five: if(x_delete) n<=sh;
         s_four: if(x_delete) n<=sh;
         s5_2: if(x_delete) n<=sv;
         s_three: if(x_delete) n<=sv;
         s5_4: if(x_delete) n<=sf;
         s5_5: if(x_delete) n<=sf;
         s5_6: if(x_delete) n<=s4_3;
         s_two: if(x_delete) n<=s4_3;
         s5_8: if(x_delete) n<=sl;
         s5_9: if(x_delete) n<=sl;
         s5_10: if(x_delete) n<=s4_5;
         s5_11: if(x_delete) n<=s4_5;
         s5_12: if(x_delete) n<=sp;
         s5_13: if(x_delete) n<=sp;
         s5_14: if(x_delete) n<=sj;
         s_one: if(x_delete) n<=sj;
         s_six: if(x_delete) n<=sb;
         s5_17:if(x_delete) n<=sb;
         s5_18: if(x_delete) n<=sx;
         s5_19: if(x_delete) n<=sx;
         s5_20: if(x_delete) n<=sc;
         s5_21:if(x_delete) n<=sc;
         s5_22: if(x_delete) n<=sy;
         s5_23: if(x_delete) n<=sy;
         s_seven: if(x_delete) n<=sz;
         s5_25: if(x_delete) n<=sz;
         s5_26: if(x_delete) n<=sq;
         s5_27: if(x_delete) n<=sq;
         s_eight: if(x_delete) n<=s4_14;
         s5_29: if(x_delete) n<=s4_14;
         s_nine: if(x_delete) n<=s4_15;
         s_ten: if(x_delete) n<=s4_15;
         default: n <= s0;
         endcase
         
         case(n)
                  s0: if(x_in1) n1<=st; else if(x_in2) n1<=se; else if(x_delete) n1<=s0;
                  se: if(x_in1) n1<=sa; else if(x_in2) n1<=si; else if(x_delete) n1<=s0;
                  st: if(x_in1) n1<=sm; else if(x_in2) n1<=sn; else if(x_delete) n1<=s0;
                  si: if(x_in1) n1<=su; else if(x_in2) n1<=ss; else if(x_delete) n1<=se;
                  sa: if(x_in1) n1<=sw; else if(x_in2) n1<=sr; else if(x_delete) n1<=se;
                  sn: if(x_in1) n1<=sk; else if(x_in2) n1<=sd; else if(x_delete) n1<=st;
                  sm: if(x_in1) n1<=so; else if(x_in2) n1<=sg; else if(x_delete) n1<=st;
                  ss: if(x_in1) n1<=sv; else if(x_in2) n1<=sh; else if(x_delete) n1<=si;
                  su: if(x_in1) n1<=s4_3; else if(x_in2) n1<=sf; else if(x_delete) n1<=si;
                  sr: if(x_in1) n1<=s4_5; else if(x_in2) n1<=sl; else if(x_delete) n1<=sa;
                  sw: if(x_in1) n1<=sj; else if(x_in2) n1<=sp; else if(x_delete) n1<=sa;
                  sd: if(x_in1) n1<=sx; else if(x_in2) n1<=sb; else if(x_delete) n1<=sn;
                  sk: if(x_in1) n1<=sy; else if(x_in2) n1<=sc; else if(x_delete) n1<=sn;
                  sg: if(x_in1) n1<=sq; else if(x_in2) n1<=sz; else if(x_delete) n1<=sm;
                  so: if(x_in1) n1<=s4_15; else if(x_in2) n1<=s4_14; else if(x_delete) n1<=sm;  
                  sh:if(x_in1) n1<=s_four; else if(x_in2) n1<=s_five; else if(x_delete) n1<=ss;
                  sv:if(x_in1) n1<=s_three; else if(x_in2) n1<=s5_2; else if(x_delete) n1<=ss;
                  sf:if(x_in1) n1<=s5_5; else if(x_in2) n1<=s5_4; else if(x_delete) n1<=su;
                  s4_3:if(x_in1) n1<=s_two; else if(x_in2) n1<=s5_6; else if(x_delete) n1<=su;
                  sl:if(x_in1) n1<=s5_9; else if(x_in2) n1<=s5_8; else if(x_delete) n1<=sr;
                  s4_5:if(x_in1) n1<=s5_11; else if(x_in2) n1<=s5_10; else if(x_delete) n1<=sr;
                  sp:if(x_in1) n1<=s5_13; else if(x_in2) n1<=s5_12; else if(x_delete) n1<=sw;
                  sj: if(x_in1) n1<=s_one; else if(x_in2) n1<=s5_14; else if(x_delete) n1<=sw;
                  sb:if(x_in1) n1<=s5_17; else if(x_in2) n1<=s_six; else if(x_delete) n1<=sd;
                  sx: if(x_in1) n1<=s5_19; else if(x_in2) n1<=s5_18; else if(x_delete) n1<=sd;
                  sc: if(x_in1) n1<=s5_21; else if(x_in2) n1<=s5_20; else if(x_delete) n1<=sk;
                  sy:if(x_in1) n1<=s5_23; else if(x_in2) n1<=s5_22; else if(x_delete) n1<=sk;
                  sz: if(x_in1) n1<=s5_25; else if(x_in2) n1<=s_seven; else if(x_delete) n1<=sg;
                  sq: if(x_in1) n1<=s5_27; else if(x_in2) n1<=s5_26; else if(x_delete) n1<=sg;
                  s4_14: if(x_in1) n1<=s5_29; else if(x_in2) n1<=s_eight; else if(x_delete) n1<=so;
                  s4_15: if(x_in1) n1<=s_ten; else if(x_in2) n1<=s_nine; else if(x_delete) n1<=so;
                  s_five: if(x_delete) n1<=sh;
                  s_four: if(x_delete) n1<=sh;
                  s5_2: if(x_delete) n1<=sv;
                  s_three: if(x_delete) n1<=sv;
                  s5_4: if(x_delete) n1<=sf;
                  s5_5: if(x_delete) n1<=sf;
                  s5_6: if(x_delete) n1<=s4_3;
                  s_two: if(x_delete) n1<=s4_3;
                  s5_8: if(x_delete) n1<=sl;
                  s5_9: if(x_delete) n1<=sl;
                  s5_10: if(x_delete) n1<=s4_5;
                  s5_11: if(x_delete) n1<=s4_5;
                  s5_12: if(x_delete) n1<=sp;
                  s5_13: if(x_delete) n1<=sp;
                  s5_14: if(x_delete) n1<=sj;
                  s_one: if(x_delete) n1<=sj;
                  s_six: if(x_delete) n1<=sb;
                  s5_17:if(x_delete) n1<=sb;
                  s5_18: if(x_delete) n1<=sx;
                  s5_19: if(x_delete) n1<=sx;
                  s5_20: if(x_delete) n1<=sc;
                  s5_21:if(x_delete) n1<=sc;
                  s5_22: if(x_delete) n1<=sy;
                  s5_23: if(x_delete) n1<=sy;
                  s_seven: if(x_delete) n1<=sz;
                  s5_25: if(x_delete) n1<=sz;
                  s5_26: if(x_delete) n1<=sq;
                  s5_27: if(x_delete) n1<=sq;
                  s_eight: if(x_delete) n1<=s4_14;
                  s5_29: if(x_delete) n1<=s4_14;
                  s_nine: if(x_delete) n1<=s4_15;
                  s_ten: if(x_delete) n1<=s4_15;
                  default: n1 <= s0;
                  endcase
         end
        end
    
  
  always@(posedge clk, posedge rst)
     begin  
     
         if(rst)
         begin
          shown<=48'b0; 
          cnt1<=4'b0;
          end
         else if(switch) 
            begin
                 shown<=48'b0; 
                 cnt1<=4'b0;
                 end
         else 
            if(x_decoder)
              begin
            cnt1<=cnt1+1'b1;
              
                case(cnt1)
                4'b0000: shown[5:0]<=state;
                4'b0001: shown[11:6]<=state;
                4'b0010: shown[17:12]<=state;
                4'b0011: shown[23:18]<=state;
                4'b0100: shown[29:24]<=state;
                4'b0101: shown[35:30]<=state;
                4'b0110: shown[41:36]<=state;
                4'b0111: shown[47:42]<=state;
               
                endcase
          end
  
             end
      always@(posedge clk)
         begin
             if(cnt1>4'd8)
               over<=1'b1;
              else
                over<=over_n;
         end
  
      always@(posedge clk)
       begin
           if(clk_2s)
              over_n<=1'b0;
           else
               over_n<=over_n;   
       
       end
     
     
  
  
     always@(posedge clk,posedge rst) begin
      
        if(rst )
          begin
           {code1,code2,code3,code4,code5}<=5'b00000;
            end
         else if(switch)   
             {code1,code2,code3,code4,code5}<=5'b00000;
          else if(x_decoder)
               {code1,code2,code3,code4,code5}<=5'b00000;
         else
           begin
            
           case(cnt)
            4'd0: if(x_in1) code1<=1'b1;   //0   4
            4'd1: if(x_in1) code2<=1'b1;else if(x_delete) code1<=1'b0;  //1     3
            4'd2: if(x_in1) code3<=1'b1;else if(x_delete) code2<=1'b0;  //2       2
            4'd3:if(x_in1) code4<=1'b1;else if(x_delete) code3<=1'b0;   //3    1
            4'd4: if(x_in1) code5<=1'b1;else if(x_delete) code4<=1'b0;  //4    5
            4'd5: begin
             {code1,code2,code3,code4,code5} <= {code1,code2,code3,code4,code5}; if(x_delete) code5<=1'b0; end
            default: {code1,code2,code3,code4,code5}<=5'b00000;
            endcase
            end
     end
  
  
  
     always @(posedge clk, posedge rst) 
       begin
      
         if(rst)
           cnt<=4'b0000;
          else if(switch) 
            cnt<=4'b0000;
         else if(x_decoder|cnt>4'b0101)
            cnt<=4'b0000;
         else  
              
       begin
                if(x_in1)
                   cnt<=cnt+1'b1;
                else if(x_in2)
                   cnt<=cnt+1'b1;
                else if(x_delete)
                   cnt<=cnt-1'b1;
               end 
       end   
       
endmodule