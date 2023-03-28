`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2021/12/28 22:23:42
// Design Name: 
// Module Name: showTubes
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


module showTubes(
    input switch, clk, clk_500, rst,
    input [31:0] shown,
    input [47:0] shown2,
    output reg [7:0] seg_en, 
    output reg [7:0] seg_out
    );
    
    reg [3:0] scan_cnt;
    always@(posedge clk_500, posedge rst)
    begin
        if(rst)
        begin
            scan_cnt <= 4'b0;
        end
        else
        begin
            if(scan_cnt == 4'd8)
                scan_cnt <= 4'b1;
            else
                scan_cnt <= scan_cnt + 1;
        end
    end
        
    always @(scan_cnt)
    begin
        case(scan_cnt)
            4'd0:   seg_en = ~8'b0000_0000;
            4'd1:   seg_en = ~8'b0000_0001;
            4'd2:   seg_en = ~8'b0000_0010;
            4'd3:   seg_en = ~8'b0000_0100;
            4'd4:   seg_en = ~8'b0000_1000;
            4'd5:   seg_en = ~8'b0001_0000;
            4'd6:   seg_en = ~8'b0010_0000;
            4'd7:   seg_en = ~8'b0100_0000;
            4'd8:   seg_en = ~8'b1000_0000;
            default:seg_en = ~8'b0000_0000;
        endcase
    end
        
    reg [3:0] fourbit = 4'b0;
    always @(posedge clk, posedge rst)
    begin
    if(rst | (~switch))
        fourbit <= 4'b0;
    else
        case(scan_cnt)
            4'd1:   fourbit <= shown[3:0];
            4'd2:   fourbit <= shown[7:4];
            4'd3:   fourbit <= shown[11:8];
            4'd4:   fourbit <= shown[15:12];
            4'd5:   fourbit <= shown[19:16];
            4'd6:   fourbit <= shown[23:20];
            4'd7:   fourbit <= shown[27:24];
            4'd8:   fourbit <= shown[31:28];
            default:fourbit <= 4'h0;
        endcase
    end

    wire [63:0] ledtube;
    wire clk_500M;
    LED l1(switch,clk,rst,shown2[5:0],ledtube[7:0]);
    LED l2(switch,clk,rst,shown2[11:6],ledtube[15:8]);
    LED l3(switch,clk,rst,shown2[17:12],ledtube[23:16]);
    LED l4(switch,clk,rst,shown2[23:18],ledtube[31:24]);
    LED l5(switch,clk,rst,shown2[29:24],ledtube[39:32]);
    LED l6(switch,clk,rst,shown2[35:30],ledtube[47:40]);
    LED l7(switch,clk,rst,shown2[41:36],ledtube[55:48]);
    LED l8(switch,clk,rst,shown2[47:42],ledtube[63:56]);
    clk_div c1(clk,rst,clk_500M);

    always@(*)
    begin
    if(switch)
        case(fourbit)
            4'ha:   seg_out = 8'b1100_0000; //0
            4'h1:   seg_out = 8'b1111_1001; //1
            4'h2:   seg_out = 8'b1010_0100; //2
            4'h3:   seg_out = 8'b1011_0000; //3
            4'h4:   seg_out = 8'b1001_1001; //4
            4'h5:   seg_out = 8'b1001_0010; //5
            4'h6:   seg_out = 8'b1000_0010; //6
            4'h7:   seg_out = 8'b1111_1000; //7
            4'h8:   seg_out = 8'b1000_0000; //8
            4'h9:   seg_out = 8'b1001_0000; //9
            default:seg_out = 8'b1111_1111; //不显示
        endcase
    else
        case(scan_cnt)
            4'd8:   seg_out <= ledtube[7:0];
            4'd7:   seg_out <= ledtube[15:8];
            4'd6:   seg_out <= ledtube[23:16];
            4'd5:   seg_out <= ledtube[31:24];
            4'd4:   seg_out <= ledtube[39:32];
            4'd3:   seg_out <= ledtube[47:40];
            4'd2:   seg_out <= ledtube[55:48];
            4'd1:   seg_out <= ledtube[63:56];
            default:seg_out = 8'b1111_1111; //不显示
         endcase
    end
    

endmodule
