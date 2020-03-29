`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2020 10:05:38 PM
// Design Name: 
// Module Name: slow_clk
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


module slow_clk(
    input clk,
    input reset,
    input enable,
    output reg slow_clk
    );
    
    reg [32:0] counter = 0;
    
    always @ (posedge clk or posedge reset) begin
        if (reset) begin
            counter <= 0;
            slow_clk <= 0;
        end else if (enable) begin
            if (counter == 23'd25000) begin
                counter <= 0;
                slow_clk <= ~slow_clk;
            end else begin
                counter <= counter + 1;
            end
        end
    end
            
endmodule
