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
    output [7:0] an,
    output [6:0] seg,
    output [5:0] set_min_out,
    output [5:0] set_sec_out,
    output reg finished,
    output reg [8:0] led,
    output reg beep
    );
    
    reg [1:0] state, nxt_state;
    parameter CountDown = 0, CountUp = 1, Hold = 2;
    wire CLK5MHZ, CLK1HZ, CLK10HZ;
    clk_wiz_0 clk5MHZ(.clk_in1(CLK100MHZ),
        .reset(reset),
        .clk_out1(CLK5MHZ));
        
    clk_div_5M clk1HZ(.clk_in(CLK5MHZ),
        .reset(reset),
        .enable(state == CountDown),
        .clk_out(CLK1HZ));
        
    clk10hz clk10HZ(.clk_in(CLK5MHZ),
        .reset(reset),
        .enable(state == CountDown),
        .clk_out(CLK10HZ));
    
    integer ledcounter = 0;
    always @(posedge CLK10HZ) begin
        if (state != CountDown) begin
            ledcounter <= 0;
             led <= 9'b000000000;
        end else begin
            if (ledcounter != 9)
                ledcounter <= ledcounter + 1;
            else 
                ledcounter <= 0;
            case(ledcounter)
                0: led <= 9'b000000000;
                1: led <= 9'b000000001;
                2: led <= 9'b000000011;
                3: led <= 9'b000000111;
                4: led <= 9'b000001111;
                5: led <= 9'b000011111;
                6: led <= 9'b000111111;
                7: led <= 9'b001111111;
                8: led <= 9'b011111111;
                9: led <= 9'b111111111;
                default: led <= 9'b000000000;
            endcase
        end
    end
    
    //finished countdown beeper
    always @(posedge CLK5MHZ) begin
        if (finished) 
            beep <= ~beep;
        else
            beep <= 0;
    end
    
    reg [5:0] set_min, set_sec;
    wire [5:0] up_min, up_sec, down_min, down_sec, hold_min, hold_sec;
//    wire finished;
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
                else if (TimerEnable & Start & ~CookTime) nxt_state <= CountDown;
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
        if (set_min == 0 & set_sec == 0)
            finished <= 1;
        else 
            finished <= 0;
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
        .load(state == Hold),
        .enable(state == CountDown),
        .reset(reset),
        .count_sec(set_sec),
        .count_min(set_min),
        .min(down_min),
        .sec(down_sec));
    
    always @(posedge CLK5MHZ or posedge reset) begin
        if (reset) begin
            set_sec <= 0;
            set_min <= 0;
        end else begin
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
                default: begin
                    set_sec <= set_sec;
                    set_min <= set_min;
                end
            endcase
        end
   end
    
    assign hold_sec = set_sec;
    assign hold_min = set_min;
    
    assign set_sec_out = set_sec;
    assign set_min_out = set_min;
        
    SegMgmt segMGMT(
        .clk(CLK5MHZ),
        .mins(set_min),
        .secs(set_sec),
        .an(an),
        .seg(seg),
        .state(state),
        .finished(finished));    
    
endmodule
