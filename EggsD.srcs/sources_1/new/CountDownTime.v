`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2020 04:48:11 PM
// Design Name: 
// Module Name: CountDownTime
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


module CountDownTime(
    input clk,
    input load,
    input enable,
    input reset,
    input [5:0] count_sec,
    input [5:0] count_min,
    output reg [5:0] min,
    output reg [5:0] sec
);

    always @(posedge clk or posedge reset or posedge load or posedge enable) begin
        if (reset) begin
            sec <= 0;
            min <= 0;
        end else if (load) begin
            sec <= count_sec;
            min <= count_min;
        end else if (enable) begin
            if (sec == 0) begin
                if (min == 0) begin
                end else begin
                    min <= min - 1;
                    sec <= 59;
                end
            end else begin
                sec <= sec - 1;
            end
        end
    end
    
endmodule
