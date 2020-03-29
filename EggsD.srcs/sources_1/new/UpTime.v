`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2020 04:48:11 PM
// Design Name: 
// Module Name: UpTime
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


module UpTime(
    input load,
    input enable,
    input reset,
    input minutes,
    input seconds,
    input [5:0] count_sec,
    input [5:0] count_min,
    output reg [5:0] min,
    output reg [5:0] sec
);


    always @(posedge reset or posedge load or posedge minutes or posedge seconds or posedge enable) begin
        if (reset) begin
            sec <= 6'b000000;
            min <= 0;
        end else if (load) begin
            sec <= count_sec;
            min <= count_min;
        end else if (enable) begin
            if (minutes & seconds) begin
                if (min == 59 & sec == 59) begin
                    min <= 0;
                    sec <= 0;
                end else if (min <= 58 & sec <= 58) begin
                    min <= min + 1;
                    sec <= sec + 1;
                end else if (min == 59 & sec <= 58) begin
                    min <= 0;
                    sec <= sec + 1;
                end else if (min <= 57 & sec == 59) begin
                    min <= min + 2;
                    sec <= 0;
                end
            end else if (seconds) begin
                if (sec == 59) begin
                    if (min == 59) begin
                        min <= 0;
                        sec <= 0;
                    end else begin
                        min <= min + 1;
                        sec <= 0;
                    end
                end else begin
                    sec <= sec + 1;
                end
            end else if (minutes) begin
                if (min == 59) begin
                    min <= 0;
                end else begin
                    min <= min + 1;
                end
            end
        end
    end
endmodule
