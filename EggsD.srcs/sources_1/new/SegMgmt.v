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
    output reg [7:0] an,
//    output reg [3:0] an,
    output reg [6:0] seg,
    input [1:0] state,
    input finished
    );
    
    wire [3:0] MIN_ONE, SEC_ONE;
    wire [2:0] MIN_TEN, SEC_TEN;
    div59 DIV_MIN(.double(mins),
        .one(MIN_ONE), 
        .ten(MIN_TEN));
    
    div59 DIV_SEC(.double(secs), 
        .one(SEC_ONE), 
        .ten(SEC_TEN));
    
    wire [6:0] seg0, seg1, seg2, seg3;
    bcdto7segment BCD_MIN_ONE(.x(MIN_ONE), .seg(seg0));
    bcdto7segment BCD_MIN_TEN(.x({1'b0, MIN_TEN}), .seg(seg1));
    bcdto7segment BCD_SEC_ONE(.x(SEC_ONE), .seg(seg2));
    bcdto7segment BCD_SEC_TEN(.x({1'b0, SEC_TEN}), .seg(seg3));
    
    parameter u = 7'b1100011, d = 7'b1000010, h = 7'b1101000, f = 7'b0111000;
    
    reg [2:0] counter = 0;
    
    always @(posedge clk) begin
        case(counter)
            3'b000: begin
                an <= 8'b11111110;
                seg <= seg0;
            end
            3'b001: begin
                an <= 8'b11111101;
                seg <= seg1;
            end
            3'b010: begin
                an <= 8'b11111011;
                seg <= seg2;
            end
            3'b011: begin
                an <= 8'b11110111;
                seg <= seg3;
            end
            3'b100: begin
                if (finished)
                    seg <= f;
                else
                    seg <= 7'b1111111;
                an <= 8'b11101111;
            end
            3'b101: begin
                if (state == 0)
                    seg <= d;
                else
                    seg <= 7'b1111111;
                an <= 8'b1101111;
            end
            3'b110: begin
                if (state == 1)
                    seg <= u;
                else
                    seg <= 7'b1111111;
                an <= 8'b10111111;
            end
            3'b111: begin
                if (state == 2)
                    seg <= h;
                else
                    seg <= 7'b1111111;
                an <= 8'b01111111;
            end
        endcase
        
        if (counter != 3'b111)
//        if (counter != 3'b011)
            counter <= counter + 3'b001;
        else
            counter <= 3'b0000;
    end
    
    
endmodule
