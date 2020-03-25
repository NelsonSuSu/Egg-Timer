`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/25/2020 04:53:34 PM
// Design Name: 
// Module Name: EggsD
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


module EggsD(
    input CLK100MHZ,
    input reset,
    input TimerEnable,
    input CookTime,
    input Start,
    input Minutes,
    input Seconds,
    output reg TimerOn,
    output TimerEnabled,
//    output [7:0] an,
    output [3:0] an,
    output [6:0] seg
    );
    
    reg [1:0] state, nxt_state;
    parameter CountDown = 0, CountUp = 1, Hold = 2;
    wire CLK5MHZ, CLK1HZ;
    
    clk_wiz_0 clk5MHZ(.clk_in1(CLK100MHZ),
        .reset(reset),
        .clk_out1(CLK5MHZ));
        
    clk_div_5M clk1HZ(.clk_in(CLK5MHZ),
        .reset(reset),
        .enable(state == CountDown),
        .clk_out(CLK1HZ));
    
    reg [5:0] set_min, set_sec;
    wire [5:0] up_min, up_sec, down_min, down_sec, hold_min, hold_sec;
    wire finished;
    
    //TimerEnabled Logic
    assign TimerEnabled = TimerEnable;
    
    //FSM Logic
    always @(state or CookTime or Start or TimerEnable or finished) begin
        case(state)
            CountDown: begin
                if (CookTime) nxt_state <= CountUp;
                else if (TimerEnable & ~finished) nxt_state <= CountDown;
                else nxt_state <= Hold;
            end
            CountUp : begin
                if (CookTime) nxt_state <= CountUp;
                else if (TimerEnable) nxt_state <= CountDown;
                else nxt_state <= Hold;
            end
            Hold : begin
                if (CookTime) nxt_state <= CountUp;
                else if (TimerEnable & Start) nxt_state <= CountDown;
                else nxt_state <= Hold;
            end
            default: nxt_state <= Hold;
        endcase
    end
    
    //State Transition      
    always @(posedge CLK5MHZ or posedge reset) begin
        if (reset) begin
            state <= Hold;
        end else begin
            state <= nxt_state;
        end
    end
    
    //TimerOn Logic
    always @(posedge CLK5MHZ) begin
        if (finished)
            TimerOn <= 0;
        else
            TimerOn <= TimerEnable & CLK1HZ;
    end
    
    always @(posedge CLK5MHZ) begin
        case(state)
            CountDown: begin
                set_sec <= down_sec;
                set_min <= down_min;
            end
            CountUp: begin
                set_sec <= up_sec;
                set_min <= up_min;
            end
            Hold: begin
                set_sec <= hold_sec;
                set_min <= hold_min;
            end
        endcase
   end
   
    IncrementTime incrementTime(
        .clk(CLK5MHZ),
        .load(state != CountUp),
        .enable(state == CountUp),
        .reset(reset),
        .minutes(Minutes),
        .seconds(Seconds),
        .count_sec(set_sec),
        .count_min(set_min),
        .min(up_min),
        .sec(up_sec));
    
    CountDownTime countDownTime(
        .clk(CLK1HZ),
        .load(state != CountDown),
        .enable(state == CountDown),
        .reset(reset),
        .count_sec(set_sec),
        .count_min(set_min),
        .min(down_min),
        .sec(down_sec),
        .finished(finished));
        
    assign hold_sec = set_sec;
    assign hold_min = set_min;
        
    SegMgmt segMGMT(
        .clk(CLK5MHZ),
        .mins(set_min),
        .secs(set_sec),
        .an(an),
        .seg(seg));    
    
endmodule
