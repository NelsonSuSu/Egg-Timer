`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2020 12:22:04 AM
// Design Name: 
// Module Name: seg_mgmt
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


module seg_mgmt(
    input clk,
    input [5:0] mins,
    input [5:0] secs,
    output reg [3:0] an,
    output reg [6:0] seg
    );
    
    wire [3:0] MIN_ONE, SEC_ONE;
    wire [2:0] MIN_TEN, SEC_TEN;
    div59 DIV_MIN(.double(output_min), .one(MIN_ONE), .ten(MIN_TEN));
    div59 DIV_SEC(.double(output_sec), .one(SEC_ONE), .ten(SEC_TEN));
    
    wire [6:0] seg0, seg1, seg2, seg3;
    bcdto7segment BCD_MIN_ONE(.x(MIN_ONE), .seg(seg0));
    bcdto7segment BCD_MIN_TEN(.x(MIN_TEN), .seg(seg1));
    bcdto7segment BCD_SEC_ONE(.x(SEC_ONE), .seg(seg2));
    bcdto7segment BCD_SEC_TEN(.x(SEC_ONE), .seg(seg3));
    
    reg [2:0] counter = 0;
    wire an0 = 8'b11111110, an1 = 8'b11111101, an2 = 8'b11111011, an3 = 8'b11110111;
    
    always @(posedge clk) begin
        case(counter)
            0: begin
                an <= an0;
                seg <= seg0;
            end
            1: begin
                an <= an1;
                seg <= seg1;
            end
            2: begin
                an <= an2;
                seg <= seg2;
            end
            3: begin
                an <= an3;
                seg <= seg3;
            end
        endcase
        if (counter != 3)
            counter <= counter + 1;
        else
            counter <= 0;
    end
    
endmodule
