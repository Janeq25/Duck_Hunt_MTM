/*
 * Title: UEC2 2022/2023 Project "Duck Hunt"
 * Authors: Jan Cichon, Arkadiusz Kurnik 
 * 
 * Module Description: Top structural module
 */

`timescale 1 ns / 1 ps

module top_DH_basys3 ( //connections order the same as in constraints file
    input logic clk,
    // input logic [15:0] sw,
    // input logic [15:0] led,
    // output logic [6:0] seg,
    // output logic dp,
    // output logic [3:0] an,
    input logic btnC,
    input logic btnU,
    input logic btnL,
    input logic btnR,
    input logic btnD,
    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue

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

    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync)
 );



endmodule
