/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Arkadiusz Kurnik
 * 
 * Description:
 * drawing crosshair module
 */

 `timescale 1 ns / 1 ps

 localparam CROSSHAIR_COLOUR = 12'hf_0_0;
 
 module draw_crosshair(
     input logic rst,
     input logic clk,
     input logic [11:0] xpos,
     input logic [11:0] ypos,
     input logic gun_is_connected,
 
     itf_vga.in in,
     itf_vga.out out
 );//
 
 import vga_pkg::*;
 
 /**
  * Local variables and signals
  */
 
 logic [11:0] rgb_nxt;
 
 logic [11:0] xpos_sync;
 logic [11:0] ypos_sync;
 
 /**
  * Internal logic
  */
 
 always_ff @(posedge clk) begin
     xpos_sync <= xpos;
     ypos_sync <= ypos;
 end
 
 
 always_ff @(posedge clk) begin: crosshair_ff_blk
     if(rst) begin
         out.hcount <= '0;
         out.hsync <= '0;
         out.hblnk <= '0;
         out.vcount <= '0;
         out.vsync <= '0;
         out.vblnk <= '0;
         out.rgb <= '0;
     end
     else if(gun_is_connected) begin
         out.hcount <= in.hcount;
         out.hsync <= in.hsync;
         out.hblnk <= in.hblnk;
         out.vcount <= in.vcount;
         out.vsync <= in.vsync;
         out.vblnk <= in.vblnk;
         out.rgb <= in.rgb;
     end
     else begin
         out.hcount <= in.hcount;
         out.hsync <= in.hsync;
         out.hblnk <= in.hblnk;
         out.vcount <= in.vcount;
         out.vsync <= in.vsync;
         out.vblnk <= in.vblnk;
         out.rgb <= rgb_nxt;
     end
 end
 
 always_comb begin: crosshair_comb_blk
     if ((((in.hcount > xpos_sync - 20) || (xpos_sync < 20)) && (in.hcount < xpos_sync + 20) && (in.vcount == ypos_sync)) || (((in.vcount > ypos_sync - 20) || (ypos_sync < 20)) && (in.vcount < ypos_sync + 20) && (in.hcount == xpos_sync))) begin
         rgb_nxt = CROSSHAIR_COLOUR;
     end
     else begin
         rgb_nxt = in.rgb;
     end
 end
 
 endmodule