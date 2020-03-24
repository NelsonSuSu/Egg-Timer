`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2020 10:05:38 PM
// Design Name: 
// Module Name: run_count_time
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


module run_count_time(
    input clk,
    input [1:0] state,
    input reset,
    input [5:0] count_sec,
    input [5:0] count_min,
    output reg [5:0] min,
    output reg [5:0] sec
    );
    
    wire enable;
    assign enable = (state != 2'b10);
    
    always @(posedge clk or posedge enable or posedge reset) begin
        if (reset) begin
            sec <= 0;
            min <= 0;
        end else if (enable) begin
            sec <= count_sec;
            min <= count_min;
        end else if (clk) begin
            if (sec == 0) begin
                if (min == 0) begin
                    //Do Nothing
                end else begin
                    min <= min - 1;
                    sec <= 59;
                end
            end else begin
                sec <= sec -1;
            end
        end
    end
        
endmodule
