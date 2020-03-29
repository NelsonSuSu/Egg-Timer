`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/24/2020 10:50:31 PM
// Design Name: 
// Module Name: Egg_TimerTB
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


module Egg_TimerTB(
    );
    
    wire [7:0] an;
    wire [6:0] seg;
    wire timerOn, timerEnabled, CLK1;
    reg timerEnable, cookTime, start, minutes, seconds, CLK100MHZ, reset;
    wire [5:0] min, sec;
    wire [8:0] led;
    EggsD EGG_TIMER (.an(an),
         .seg(seg),
         .TimerOn(timerOn),
         .TimerEnabled(timerEnabled),
         .TimerEnable(timerEnable),
         .CookTime(cookTime),
         .Start(start),
         .Minutes(minutes),
         .Seconds(seconds),
         .CLK100MHZ(CLK100MHZ),
         .reset(reset),
         .set_min_out(min),
         .set_sec_out(sec),
         .led(led));
                         
    initial begin 
        CLK100MHZ = 0;
        forever #5 CLK100MHZ= ~CLK100MHZ;
    end
    
    initial begin 
        timerEnable <= 0;
        cookTime <= 0;
        start <= 0;
        minutes <= 0;
        seconds <= 0;
        reset <= 0;
        
        //cycle reset 
        reset <= #2245 1;
        reset <= #3367 0;
        
        //cooktime no timer enable 
        cookTime <= #4500 1;
        cookTime <= #5675 0;
        
        //Program time to count down from 
        cookTime <= #6578 1;
        
        seconds <= #7845 1;
        seconds <= #8975 0;
        
        minutes <= #9903 1;
        minutes <= #11007 0;
        
        seconds <= #11991 1;
        seconds <= #15344 0;
        
        minutes <= #16890 1;
        minutes <= #21000 0;
        
        cookTime <= #22000 0;
                
        timerEnable <= #26000 1;
        start <= #27000 1;
        start <= #29876 0;
        
        timerEnable <= #110000 0;
        timerEnable <= #130000 1;
        
        //programing new cook time 
        cookTime <= #135000 1;
        
        seconds <= #140000 1;
        seconds <= #144000 0;
        
        seconds <= #150000 1;
        seconds <= #154000 0;
        
        seconds <= #160000 1;
        seconds <= #164000 0;
        
        cookTime <= #170000 0;
        
        start <= #172000 1;
        start <= #172120 0;
        
        reset <= #200000 1;
        reset <= #200100 0;
        
        // testing going to and staying at 0
        cookTime <= #235000 1;
        
        seconds <= #240000 1;
        seconds <= #244000 0;
        
        seconds <= #250000 1;
        seconds <= #254000 0;
        
        seconds <= #260000 1;
        seconds <= #264000 0;
        
        cookTime <= #270000 0;
        
        start <= #272000 1;
        start <= #272120 0;
             
    end 
    
endmodule
