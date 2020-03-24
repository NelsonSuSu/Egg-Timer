`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2020 12:25:10 AM
// Design Name: 
// Module Name: div59
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


module div59(
    input [5:0] double,
    output reg [3:0] one,
    output reg [2:0] ten
    );
    
    always @(double) begin
        if (double <= 9) begin
            ten <= 0;
            one <= double;
        end else if (double <= 19) begin
            ten <= 1;
            one <= double - 2'd10;
        end else if (double <= 29) begin
            ten <= 2;
            one <= double - 2'd20;
        end else if (double <= 39) begin  
            ten <= 3;
            one <= double - 2'd30;
        end else if (double <= 49) begin        
            ten <= 4;
            one <= double - 2'd40;
        end else if (double <= 59) begin        
            ten <= 5;
            one <= double - 2'd50;
        end   
    end
endmodule
