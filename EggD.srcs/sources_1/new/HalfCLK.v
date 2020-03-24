`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2020 11:28:13 PM
// Design Name: 
// Module Name: HalfCLK
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


module HalfCLK(
    input clk,
    input reset,
    output reg clk_out
    );
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            clk_out <= 0;
        end else if (clk) begin
            clk_out <= ~clk_out;
        end
    end
    
endmodule
