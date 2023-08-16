/**
* Copyright (C) 2023  AGH University of Science and Technology
* MTM UEC2
* Author: Jan Cichoń
*
* Description:
* generates pause signal from user input, internal state of game (no_ammo) or player2 board
*/

module ctl_pause(
    input logic clk,
    input logic rst,

    input logic player2_pause,
    output logic player1_pause,

    input logic sw_pause_raw,
    input logic no_ammo,

    output logic pause
);

//internal signals
logic player1_pause_nxt;
logic pause_nxt;
logic sw_pause;

// submodules
debounce u_sw_pause_debounce (
    .clk,
    .reset(rst),
    .sw(sw_pause_raw),
    .db_level(sw_pause),
    .db_tick()
);


//sequential block

always_ff @(posedge clk) begin
    if (rst) begin
        player1_pause <= 1'b0;
        pause <= 1'b0;
    end
    else begin
        player1_pause <= player1_pause_nxt;
        pause <= pause_nxt;
    end
end

//combinational block

assign player1_pause_nxt = sw_pause;
assign pause_nxt = sw_pause | player2_pause | no_ammo;

endmodule