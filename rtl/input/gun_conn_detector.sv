/**
* Copyright (C) 2023  AGH University of Science and Technology
* MTM UEC2
* Author: Jan Cichoń
*
* Description:
* Detects if gun controller is connected
*/

module gun_conn_detector(
    input logic clk,
    input logic rst,

    input logic gun_trigger, // signal in vegative logic. 0 if trigger pressed, 1 if gun connected
    input logic gun_photodetector,

    output logic gun_is_connected
);

//internal signals
logic gun_is_connected_nxt;

//sequential block

always_ff @(posedge clk) begin
    if (rst) begin
        gun_is_connected <= 1'b0;
    end
    else begin
        gun_is_connected <= gun_is_connected_nxt;
    end
end

//combinational block

assign gun_is_connected_nxt = gun_photodetector | gun_trigger; //00-gun not connected or shot fired and missed in both cases we dont care, 01-gun connected shot not fired, 10-shot fired and missed


endmodule