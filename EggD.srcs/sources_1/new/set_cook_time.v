`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2020 10:05:38 PM
// Design Name: 
// Module Name: set_cook_time
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


module set_cook_time(
    input clk,
    input minutes,
    input seconds,
    input [1:0] state,
    input reset,
    output reg [5:0] min,
    output reg [5:0] sec
    );
    
    wire min_clk, sec_clk;
    debouncer debounce_min(.clk(clk), .pb(minutes), .reset(reset | state != 2'b00), .enable(state == 2'b00), .pb_out(min_clk));
    debouncer debounce_sec(.clk(clk), .pb(seconds), .reset(reset | state != 2'b00), .enable(state == 2'b00), .pb_out(sec_clk));
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            min <= 0;
            sec <= 0;
        end else if (min_clk & sec_clk) begin
            if (min == 59 & sec == 59) begin
                min <= 0;
                sec <= 0;
            end else if (min <= 58 & sec <= 58) begin
                min <= min + 1;
                sec <= sec + 1;
            end else if (min == 59 & sec <= 59) begin
                min <= 0;
                sec <= sec + 1;
            end else if (min <= 59 & sec == 59) begin
                min <= min + 1;
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
    
endmodule
