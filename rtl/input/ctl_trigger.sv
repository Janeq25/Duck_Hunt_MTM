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

    input logic gun_trigger, // signal in vegative logic. 0 if trigger pressed, 1 if gun connected
    input logic gun_photodetector,

    input logic mouse_on_target,
    input logic mouse_left,

    output logic gun_is_connected,

    output logic hit,
    output logic miss,
    output logic shot_fired
 );

 // internal signals
    logic hit_nxt;
    logic miss_nxt;
    logic shot_fired_nxt;
    logic gun_is_connected_nxt;

 // signal assignments
    assign gun_is_connected_nxt = gun_photodetector | gun_trigger; //00-gun not connected or shot fired and missed in both cases we dont care, 01-gun connected shot not fired, 10-shot fired and missed
    assign shot_fired_nxt = gun_is_connected ? ~gun_trigger : mouse_left;
    assign hit_nxt = gun_is_connected ? (~gun_trigger & gun_photodetector) : (mouse_left & mouse_on_target);
    assign miss_nxt = gun_is_connected ? (~gun_trigger & ~gun_photodetector) : (mouse_left & ~mouse_on_target);

 // sequential logic

always_ff @(posedge clk) begin
    if (rst) begin
        hit <= 1'b0;
        miss <= 1'b0;
        shot_fired <= 1'b0;
        gun_is_connected <= 1'b0;
    end
    else begin
        hit <= hit_nxt;
        miss <= miss_nxt;
        shot_fired <= shot_fired_nxt;
        gun_is_connected <= gun_is_connected_nxt;
    end
end


 endmodule