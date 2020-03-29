`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2020 04:48:11 PM
// Design Name: 
// Module Name: IncrementTime
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


module IncrementTime(
    input clk,
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

    wire slowpoke;
    slow_clk SLOW_CLK(.clk(clk), .reset(reset), .enable(enable), .slow_clk(slowpoke)); //10ms slow clk
    
    wire min_clk, sec_clk;
    debouncer debounce_min(.clk(clk), 
        .pb(minutes), 
        .reset(reset), 
        .enable(~load), 
        .pb_out(min_clk));
    
    debouncer debounce_sec(.clk(clk), 
        .pb(seconds), 
        .reset(reset), 
        .enable(~load), 
        .pb_out(sec_clk));

    always @(posedge reset or posedge load or posedge sec_clk or posedge min_clk or posedge enable) begin
        if (reset) begin
            sec <= 6'b000000;
            min <= 0;
        end else if (load) begin
            sec <= count_sec;
            min <= count_min;
        end else if (enable) begin
            if (min_clk & sec_clk) begin
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
            end else if (sec_clk) begin
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
            end else if (min_clk) begin
                if (min == 59) begin
                    min <= 0;
                end else begin
                    min <= min + 1;
                end
            end
        end
    end
endmodule
