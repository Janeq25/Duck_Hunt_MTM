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
    input logic new_frame,

    input logic lock,

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

    logic trigger_delayed_last;
    logic shot_fired_delayed;
    logic shot_fired_delayed_nxt;
    logic trigger_delayed;
    logic gun_trigger_delayed;



 // signal assignments
    assign trigger = gun_is_connected ? (~gun_trigger & ~lock) : (mouse_left & ~lock);
    assign shot_fired_nxt = ~trigger && trigger_last; // signals sent to other modules (slightly before reading if shot connected to give time for controller to set)


 // trigger delay for controller sync

    delay #(.CLK_DEL(10), .WIDTH(1)) gun_trigger_delay (
        .clk(new_frame),
        .rst,
        .din(gun_trigger),
        .dout(gun_trigger_delayed)
    );

    assign trigger_delayed = gun_is_connected ? (~gun_trigger_delayed & ~lock): (mouse_left & ~lock);
    assign shot_fired_delayed_nxt = ~trigger_delayed && trigger_delayed_last; // delayed internal signals

 // sequential logic
always_ff @(posedge clk) begin
    if (rst) begin
        trigger_last <= 1'b0;
        trigger_delayed_last <= 1'b0;

        hit <= 1'b0;
        miss <= 1'b0;
        shot_fired <= 1'b0;
        shot_fired_delayed <= 1'b0;
    end
    else begin
        trigger_last <= trigger;
        trigger_delayed_last <= trigger_delayed;

        hit <= hit_nxt;
        miss <= miss_nxt;
        shot_fired <= shot_fired_nxt;
        shot_fired_delayed <= shot_fired_delayed_nxt;
    end
end

 //combinational logic   


always_comb begin
    if (shot_fired_delayed) begin
        hit_nxt = gun_is_connected ? gun_photodetector : mouse_on_target;
    end
    else begin
        hit_nxt = 1'b0;
    end
end

always_comb begin
    if (shot_fired_delayed) begin
        miss_nxt = gun_is_connected ? ~gun_photodetector : ~mouse_on_target;
    end
    else begin
        miss_nxt = 1'b0;
    end
end



 endmodule