`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2020 10:07:35 PM
// Design Name: 
// Module Name: debouncer
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


module debouncer(
    input clk,
    input pb,
    output pb_out,
    input reset,
    input enable
    );
    
    reg Q1, Q2_bar;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q1 <= 0;
            Q2_bar <= 1;
        end else if (enable) begin
            Q1 <= pb;
            Q2_bar <= ~Q1;
        end
    end
    
    assign pb_out = Q1 & Q2_bar;
    
endmodule
