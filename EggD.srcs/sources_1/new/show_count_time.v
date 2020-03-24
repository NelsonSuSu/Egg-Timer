`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2020 10:05:38 PM
// Design Name: 
// Module Name: show_count_time
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


module show_count_time(
    input reset,
    input [5:0] count_sec,
    input [5:0] count_min,
    output reg [5:0] sec,
    output reg [5:0] min
    );
    
    always @(reset or count_sec or count_min) begin
        if (reset) begin
            sec <= 0;
            min <= 0;
        end else begin
            sec <= count_sec;
            min <= count_min;
        end
    end
    
endmodule
