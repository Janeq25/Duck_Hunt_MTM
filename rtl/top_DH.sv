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
    output logic [3:0] b,

    output logic [15:0] led,

    input logic gun_trigger,
    input logic gun_photodetector
 );


 // interfaces
   itf_vga timing_to_draw_bg();
   itf_vga draw_bg_to_draw_duck();
   itf_vga draw_duck_to_out();

 // local signals
   logic new_frame;

   logic [10:0] duck_x;
   logic [10:0] duck_y;
   logic duck_show;
   logic duck_hit;

 // signal assignments
 assign vs = draw_duck_to_out.vsync;
 assign hs = draw_duck_to_out.hsync;
 assign {r,g,b} = draw_duck_to_out.rgb;

 assign led[15:2] = '0;
 assign led[0] = gun_trigger;
 assign led[1] = gun_photodetector;

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
   .out(draw_bg_to_draw_duck.out)
 );

 draw_duck u_draw_duck(
  .clk,
  .rst,
  .new_frame,

  .duck_hit,
  .duck_show,
  .duck_x,
  .duck_y,

  .in(draw_bg_to_draw_duck.in),
  .out(draw_duck_to_out.out)

 );

  // ---ctrl section-----

 random_number_generator u_random_number_generator(
   .clk(clk100MHz),
   .rst,

   .direction(),
   .duck_start_pos(),
   .duck_vertical_speed()
 );

 ctl_duck u_ctl_duck(
  .clk,
  .rst,
  .new_frame,

  .duck_show,
  .duck_hit,
  .duck_x,
  .duck_y
 );

 // -----------------

 endmodule