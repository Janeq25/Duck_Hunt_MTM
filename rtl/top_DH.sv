/*
 * Title: UEC2 2022/2023 Project "Duck Hunt"
 * Authors: Jan Cichon, Arkadiusz Kurnik 
 * 
 * Module Description: Top structural module
 */

 `timescale 1 ns / 1 ps

 module top_DH(
    input logic clk, //main clock 65MHz
    input logic clk100MHz, //mouse clock 100MHz
    input logic rst,

    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
 );


 // interfaces
   itf_vga timing_to_draw_bg();
   itf_vga draw_bg_to_out();

 // local signals
   logic new_frame;

 // signal assignments
 assign vs = draw_bg_to_out.vsync;
 assign hs = draw_bg_to_out.hsync;
 assign {r,g,b} = draw_bg_to_out.rgb;

 // modules

 // ---vga section---

 vga_timing u_vga_timing(
   .clk,
   .rst,

   .new_frame,
   .out(timing_to_draw_bg.out)
 );

 draw_bg u_draw_bg(
   .clk,
   .rst,

   .in(timing_to_draw_bg.in),
   .out(draw_bg_to_out.out)
 );

 // -----------------

 endmodule