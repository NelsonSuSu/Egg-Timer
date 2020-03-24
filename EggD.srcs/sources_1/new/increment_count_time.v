`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2020 10:05:38 PM
// Design Name: 
// Module Name: increment_count_time
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


module increment_count_time(
    input clk,
    input minutes,
    input seconds,
    input [1:0] state,
    input reset,
    input cur_min,
    input cur_sec,
    output reg [5:0] min,
    output reg [5:0] sec
    );
    
    wire min_clk, sec_clk, enable;
    assign enable = (state != 2'b11);
    
    debouncer debounce_min(.clk(clk), .pb(minutes), .reset(reset | enable), .enable(~enable), .pb_out(min_clk));
    debouncer debounce_sec(.clk(clk), .pb(seconds), .reset(reset | enable), .enable(~enable), .pb_out(sec_clk));
    
    always @(posedge min_clk or posedge sec_clk or posedge enable or posedge reset) begin
        if (reset) begin
            min <= 0;
            sec <= 0;
        end else if (enable) begin
            min <= cur_min;
            sec <= cur_sec;
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

