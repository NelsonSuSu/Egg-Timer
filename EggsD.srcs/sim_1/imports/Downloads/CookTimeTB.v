`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2020 10:21:45 PM
// Design Name: 
// Module Name: CookTimeTB
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


module CookTimeTB(

    );
    //Sim Time to 0.5us
    reg reset, isTimeBeingSet, seconds_press, minutes_press, clk, load;
    reg [5:0] current_seconds, current_minutes;
    wire [5:0] minutesOut, secondsOut;
    
    UpTime CookTimeTB(.reset(reset),
        .load(load),
        .enable(isTimeBeingSet),
        .seconds(seconds_press),
        .minutes(minutes_press),
        .count_sec(current_seconds),
        .count_min(current_minutes),
        .min(minutesOut),
        .sec(secondsOut));
        
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
                       
    initial begin
        reset = 1;
        #10 reset = 0;
        
        current_seconds = 35;
        current_minutes = 34;
        
        isTimeBeingSet = 0;
        seconds_press = 1;
        minutes_press = 0;
        #5 load = 1;
        #5 load = 0;
        #20 isTimeBeingSet = 1;
 

        #10 seconds_press = 0;
        #10 seconds_press = 1;
        #10 seconds_press = 0;
        #10 seconds_press = 1;
        #10 seconds_press = 0;
        
        #10 minutes_press = 1;
        #10 minutes_press = 0;
        #10 minutes_press = 1;
        #10 minutes_press = 0;
        
        #10 minutes_press = 1;
        #10 seconds_press = 1;
        #10 seconds_press = 0;
        #10 minutes_press = 0;
        
        #50 isTimeBeingSet = 0;
        
        #10 minutes_press = 1;
        #10 minutes_press = 0;
        #10 seconds_press = 1;
        #10 seconds_press = 0;
        
        #30 current_seconds = 13;
        current_minutes = 12;
        #5 load = 1;
        #5 load = 0;
        #5 isTimeBeingSet = 1;
        #19 seconds_press = 1;
        
        
        #4 reset = 1;
        
        #5 seconds_press = 0;
        
        #5 isTimeBeingSet = 0;
        
        #10 reset = 0;
        
        #30 current_seconds = 22;
        current_minutes = 14;
        
        #5 isTimeBeingSet = 1;
        
        

    end 
    
    
endmodule
