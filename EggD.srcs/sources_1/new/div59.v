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
            ten <= 3'b000;
            one <= double;
        end else if (double <= 19) begin
            ten <= 3'b001;
            one <= double - 6'b001010;
        end else if (double <= 29) begin
            ten <= 3'b010;
            one <= double - 6'b010100;
        end else if (double <= 39) begin  
            ten <= 3'b011;
            one <= double - 6'b011110;
        end else if (double <= 49) begin        
            ten <= 3'b100;
            one <= double - 6'b101000;
        end else if (double <= 59) begin        
            ten <= 3'b101;
            one <= double - 6'b110010;
        end else begin
            ten <= 0;
            one <= 0;
        end
    end
    
endmodule
