/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jan Cichoń
 * 
 * Description:
 * input method govenor. Checks what perypherial is gun controller is connected, if not defaults to mouse input. Outputs pulses for shot, hit, miss and current input method.
 */


 module ctl_trigger(
    input logic clk,
    input logic rst,

    input logic gun_is_connected,

    input logic gun_trigger, 
    input logic gun_photodetector,

    input logic mouse_on_target,
    input logic mouse_left,

    output logic hit,
    output logic miss,
    output logic shot_fired
 );

 // internal signals
    logic trigger;
    logic trigger_last;
    logic hit_nxt;
    logic miss_nxt;
    logic shot_fired_nxt;

 // signal assignments
    assign trigger = gun_is_connected ? ~gun_trigger : mouse_left;
    assign shot_fired_nxt = trigger && ~trigger_last;


 // sequential logic
always_ff @(posedge clk) begin
    if (rst) begin
        trigger_last <= 1'b0;

        hit <= 1'b0;
        miss <= 1'b0;
        shot_fired <= 1'b0;
    end
    else begin
        trigger_last <= trigger;

        hit <= hit_nxt;
        miss <= miss_nxt;
        shot_fired <= shot_fired_nxt;
    end
end

 //combinationa logic

always_comb begin
    if (shot_fired) begin
        hit_nxt = gun_is_connected ? gun_photodetector : mouse_left;
    end
    else begin
        hit_nxt = 1'b0;
    end
end

always_comb begin
    if (shot_fired) begin
        miss_nxt = gun_is_connected ? ~gun_photodetector : ~mouse_left;
    end
    else begin
        miss_nxt = 1'b0;
    end
end



 endmodule