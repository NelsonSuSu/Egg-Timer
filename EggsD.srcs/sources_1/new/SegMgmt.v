`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2020 05:53:45 PM
// Design Name: 
// Module Name: SegMgmt
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


module SegMgmt(
    input clk,
    input [5:0] mins,
    input [5:0] secs,
//    output reg [7:0] an,
    output reg [3:0] an,
    output reg [6:0] seg
    );
    
    wire [3:0] MIN_ONE, SEC_ONE;
    wire [2:0] MIN_TEN, SEC_TEN;
    div59 DIV_MIN(.double(mins), .one(MIN_ONE), .ten(MIN_TEN));
    div59 DIV_SEC(.double(secs), .one(SEC_ONE), .ten(SEC_TEN));
    
    wire [6:0] seg0, seg1, seg2, seg3;
    bcdto7segment BCD_MIN_ONE(.x(MIN_ONE), .seg(seg0));
    bcdto7segment BCD_MIN_TEN(.x({1'b0, MIN_TEN}), .seg(seg1));
    bcdto7segment BCD_SEC_ONE(.x(SEC_ONE), .seg(seg2));
    bcdto7segment BCD_SEC_TEN(.x({1'b0, SEC_TEN}), .seg(seg3));
    
    reg [1:0] counter = 0;
    
    always @(posedge clk) begin
        case(counter)
            2'b00: begin
//                an <= 8'b11111110;
                an <= 4'b1110;
                seg <= seg0;
            end
            2'b01: begin
//                an <= 8'b11111101;
                an <= 4'b1101;
                seg <= seg1;
            end
            2'b10: begin
//                an <= 8'b11111011;
                an <= 4'b1011;
                seg <= seg2;
            end
            2'b11: begin
//                an <= 8'b11110111;
                seg <= 4'b0111;
                seg <= seg3;
            end
            default: begin
//                an <= 8'b11111111;
                an <= 4'b1111;                
                seg <= 7'b1111111;
            end
        endcase
        
        if (counter != 2'b11)
            counter <= counter + 2'b01;
        else
            counter <= 2'b00;
    end
    
    
endmodule
