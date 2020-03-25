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
    output reg [5:0] sec,
    output reg finished
);

    always @(posedge clk or posedge reset or posedge load or posedge enable) begin
        if (reset) begin
            sec <= 0;
            min <= 0;
            finished <= 0;
        end else if (load) begin
            sec <= count_sec;
            min <= count_min;
        end else if (enable) begin
            if (sec == 6'b000000) begin
                if (min == 6'b000000) begin
                    finished <= 1;
                end else begin
                    min <= min - 6'b000001;
                    sec <= 6'b111011;
                end
            end else begin
                sec <= sec - 6'b000001;
            end
        end
    end
    
endmodule
