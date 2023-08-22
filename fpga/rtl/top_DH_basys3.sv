/*
 * Title: UEC2 2022/2023 Project "Duck Hunt"
 * Authors: Jan Cichon, Arkadiusz Kurnik 
 * 
 * Module Description: Top structural module
 */

`timescale 1 ns / 1 ps

module top_DH_basys3 ( //connections order the same as in constraints file
    input logic clk,
    input logic sw,
    output logic [14:0] led,
    output logic [6:0] seg,
    output logic dp,
    output logic [3:0] an,
    input logic btnC,
    input logic btnU,
    
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,
    inout logic PS2Clk,
    inout logic PS2Data,
    input wire JA4, //trigger
    input wire JA3, //photodetector

    output logic [5:0] JB,
    input logic [5:0] JC

);

 // signals
 logic clk100MHz;
 logic clk65MHz;

 // modules
 
 clk_wiz_0 u_clk_wiz_0(
     .clk100MHz,
     .clk65MHz,
     // Status and control signals
    .locked(),
    // Clock in ports
    .clk
    );


 top_DH u_top_DH(
    .clk(clk65MHz),
    .clk100MHz(clk100MHz),
    .rst(btnU),

    .reload_btn(btnC),

    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),

    .an,
    .dp,
    .seg,
    .led,

    .ps2_clk(PS2Clk),
    .ps2_data(PS2Data),

    .gun_trigger_raw(JA4),
    .gun_photodetector_raw(JA3),

    .sw_pause_raw(sw),

    .player1_pause(JB[4]),
    .player1_reload(JB[5]),
    .player1_score(JB[3:0]),
    .player2_pause_raw(JC[4]),
    .player2_reload_raw(JC[5]),
    .player2_score_raw(JC[3:0])
 );



endmodule
