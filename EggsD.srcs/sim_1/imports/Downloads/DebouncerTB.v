`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/21/2020 08:48:15 PM
// Design Name: 
// Module Name: debouncer_tb
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


module DebouncerTB(

    );
    //sim @ 2us
    reg press, clk, reset, enable;
    wire press_debounced;
    
//    defparam DEB.DIVIDER100HZ = 10;
    debouncer TEST (.pb(press),
       .clk(clk),
       .enable(enable),
       .reset(reset),
       .pb_out(press_debounced));
                   
    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        enable <= 1;
        reset <= 1;
        reset <= #210 0;
        
        press <= 0;
        press <= #406 1;
        press <= #506 0;
        press <= #814 1;
        press <= #920 0;
        press <= #1020 1;
        press <= #1400 0;
        press <= #1726 1;
        
        reset <= #1962 1;
        
        
        
    end
    
endmodule