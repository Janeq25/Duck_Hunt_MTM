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
    logic hit_nxt;
    logic miss_nxt;
    logic shot_fired_nxt;
    logic gun_trigger_delay;
    logic gun_photodetector_delay;
    logic mouse_on_target_delay;
    logic mouse_left_delay;

 // signal assignments
    assign shot_fired_nxt = gun_is_connected ? ~gun_trigger_delay : mouse_left_delay;
    assign hit_nxt = gun_is_connected ? (~gun_trigger_delay & gun_photodetector_delay) : (mouse_left_delay & mouse_on_target_delay);
    assign miss_nxt = gun_is_connected ? (~gun_trigger_delay & ~gun_photodetector_delay) : (mouse_left_delay & ~mouse_on_target_delay);

 // sequential logic

always_ff @(posedge clk) begin
    if (rst) begin
        hit <= 1'b0;
        miss <= 1'b0;
        shot_fired <= 1'b0;
    end
    else begin
        hit <= hit_nxt;
        miss <= miss_nxt;
        shot_fired <= shot_fired_nxt;
    end
end

always_ff @(posedge clk) begin
    if (rst) begin
        gun_trigger_delay <= 1'b0;
        gun_photodetector_delay <= 1'b0;
        mouse_on_target_delay <= 1'b0;
        mouse_left_delay <= 1'b0;
    end
    else begin
        gun_trigger_delay <= gun_trigger;
        gun_photodetector_delay <= gun_photodetector;
        mouse_on_target_delay <= mouse_on_target;
        mouse_left_delay <= mouse_left;
    end
end

 endmodule