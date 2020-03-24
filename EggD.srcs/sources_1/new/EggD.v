`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2020 10:00:48 PM
// Design Name: 
// Module Name: EggD
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


module EggD(
    input CLK100MHZ,
    input reset,
    input TimerEnable,
    input CookTime,
    input Start,
    input Minutes,
    input Seconds,
    output TimerOn,
    output TimerEnabled,
    output [3:0] an,
    output [6:0] seg
    );
    
    reg [1:0] state, nxt_state;
    parameter SetCookTime = 0, ShowCountTime = 1, RunCountTime = 2, IncrementCountTime = 3;
    
    //Clocks
    wire CLK5MHZ, CLK1HZ, CLK1_2HZ;
    clk_wiz_0 clk5mhz(.clk_out1(CLK5MHZ), .reset(reset), .clk_in1(CLK100MHZ));
    MHZtoHZ clk1hz(.clk(CLK5MHZ), .reset(reset), .clk_out(CLK1HZ));
    HalfCLK clk1_2hz(.clk(CLK1HZ), .reset(reset), .clk_out(CLK1_2HZ));
    
    //FSM assignment
    always @(state) begin
        case(state)
            SetCookTime: begin
                if (CookTime) nxt_state <= SetCookTime;
                else nxt_state <= ShowCountTime;
            end
            ShowCountTime: begin
                if (CookTime) nxt_state <= SetCookTime;
                else if (TimerEnable & Start) nxt_state <= RunCountTime;
                else nxt_state <= ShowCountTime;
            end
            RunCountTime: begin
                if (CookTime) nxt_state <= IncrementCountTime;
                else if (TimerEnable) nxt_state <= RunCountTime;
                else nxt_state <= ShowCountTime;
            end
            IncrementCountTime: begin
                if (CookTime) nxt_state <= IncrementCountTime;
                else nxt_state <= RunCountTime;
            end
        endcase
    end
    
    //State Transition
    always @(posedge CLK5MHZ or posedge reset) begin
        if (reset) begin
            state <= ShowCountTime;
        end else begin
            state <= nxt_state;
        end
    end
    
    wire [5:0] COOK_min, COOK_sec;
    wire [5:0] COUNT_min, COUNT_sec;
    wire [5:0] RUN_min, RUN_sec;
    wire [5:0] INCREMENT_min, INCREMENT_sec;
    reg [5:0] INPUT_min, INPUT_sec;
    
    //FSM Modules
    set_cook_time SET_COOK_TIME(.clk(CLK5MHZ), .minutes(Minutes), .seconds(Seconds), 
        .state(state), .reset(reset), .min(COOK_min), .sec(COOK_sec));
    
    run_count_time RUN_COUNT_TIME(.clk(CLK1HZ), .state(state), .reset(reset), .count_sec(INPUT_sec), .count_min(INPUT_min),
        .min(RUN_min), .sec(RUN_sec));
    
    increment_count_time INCREMENT_COUNT_TIME(.clk(CLK1HZ), .minutes(Minutes), .seconds(Seconds), .state(state),
        .reset(reset), .cur_min(INPUT_min), .cur_sec(INPUT_sec), .min(INCREMENT_min), .sec(INCREMENT_sec));
    
    show_count_time SHOW_COUNT_TIME(.reset(reset), .count_sec(INPUT_sec), .count_min(INPUT_min), .sec(COUNT_sec), .min(COUNT_min));
    
    
    //Counter Value Logic
    always @(state) begin
        if (state == SetCookTime) begin
            INPUT_min <= COOK_min;
            INPUT_sec <= COOK_sec;
        end else if (state == RunCountTime) begin
            INPUT_min <= RUN_min;
            INPUT_sec <= RUN_sec;
        end else if (state == IncrementCountTime) begin
            INPUT_min <= INCREMENT_min;
            INPUT_sec <= INCREMENT_sec;
        end else begin
            INPUT_min <= COUNT_min;
            INPUT_sec <= COUNT_sec;
        end
    end
    
    //TimerEnabled Logic
    assign TimerEnabled = TimerEnable;
    
    //TimerOn Logic
    assign TimerOn = (COUNT_min != 2'd00 | COUNT_sec != 2'd00) & TimerEnable & CLK1HZ; 
    
    //MUX logic
    seg_mgmt SEG_MGMT(.clk(CLK1_2HZ), .mins(INPUT_min), .secs(INPUT_sec), .an(an), .seg(seg));
    
endmodule
