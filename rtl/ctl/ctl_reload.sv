/**
* Copyright (C) 2023  AGH University of Science and Technology
* MTM UEC2
* Author: Jan Cichoń
*
* Description:
* generates reload signal from user input or player2 board
*/

module ctl_reload (
    input logic clk,
    input logic rst,

    output logic player1_reload,
    input logic player2_reload,

    input logic btn_reload_raw,
    output logic player2_connected,

    output logic reload

);

//internal signals
logic btn_reload;
logic player1_reload_nxt;
logic player2_connected_nxt;
logic reload_nxt;
logic player2_reload_last;
logic player2_reload_pulse;

// player2 reload falling edge detection
always_ff @(posedge clk) begin
    if (rst) begin
        player2_reload_last <= 1'b0;
    end
    else begin
        player2_reload_last <= player2_reload;
    end
end

assign player2_reload_pulse = player2_reload_last && ~player2_reload;

// submodules

debounce u_btn_reload_debounce(
    .clk,
    .reset(rst),
    .sw(btn_reload_raw),
    .db_level(btn_reload),
    .db_tick()
);

//sequential block


always_ff @(posedge clk) begin
    if (rst) begin
        player1_reload <= 1'b0;
        player2_connected <= 1'b0;
        reload <= 1'b0;
    end
    else begin
        player1_reload <= player1_reload_nxt;
        player2_connected <= player2_connected_nxt;
        reload <= reload_nxt;
    end
end

//combinational block

assign player2_connected_nxt = player2_reload;
assign player1_reload_nxt = ~btn_reload;
assign reload_nxt = btn_reload | player2_reload_pulse;


endmodule