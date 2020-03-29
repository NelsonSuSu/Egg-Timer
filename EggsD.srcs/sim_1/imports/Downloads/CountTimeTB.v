`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/22/2020 09:00:37 PM
// Design Name: 
// Module Name: CountTimeTB
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


module CountTimeTB(
 
    );
    
    reg CLK1HZ, reset, isTimeBeingSet, enable;
    reg [5:0] minutesIn, secondsIn;
    wire [5:0] minutesOut, secondsOut;
    wire finished;
    
    CountDownTime CountTimeDUT (.clk(CLK1HZ),
        .enable(enable),
        .count_min(minutesIn),
        .count_sec(secondsIn),
        .reset(reset),
        .load(isTimeBeingSet),
        .min(minutesOut),
        .sec(secondsOut),
        .finished(finished));
                            
    initial begin 
        CLK1HZ = 0;
        forever #5 CLK1HZ = ~CLK1HZ;
    end
    
    initial begin 
        reset = 1;
        #10 reset = 0;
        isTimeBeingSet = 0;
        #10 isTimeBeingSet = 1;
        
        #15 secondsIn = 7'b0111011;
        #15 minutesIn = 7'b0111011;
        #30 isTimeBeingSet = 0;
        enable = 1;
        #30 enable = 0;
        
        #15 secondsIn = 7'b0000100;
        #15 minutesIn = 7'b0000000;
        
        #39 isTimeBeingSet = 1;
        
        #15 secondsIn = 7'b0000100;
        #15 minutesIn = 7'b0000000;
        
        #1 isTimeBeingSet = 0;
        enable = 1;
        #10 enable = 0;
        
        #60 isTimeBeingSet = 1;
        #15 secondsIn = 7'b000000;
        minutesIn = 7'b000001;
        
        #5 isTimeBeingSet = 0;
        enable = 1;
        #30 enable = 0;
        
        #60 isTimeBeingSet = 1;
        #15 secondsIn = 7'b0111011;
        minutesIn = 7'b000001;
        reset = 1;
        
        
    end
    
    
endmodule
