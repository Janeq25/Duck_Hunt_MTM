/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Arkadiusz Kurnik
 * 
 * Description:
 * drawing crosshair module
 */

`timescale 1 ns / 1 ps

// localparam RECTANGLE_POS_X = 150;
// localparam RECTANGLE_POS_Y = 100;
localparam RECTANGLE_WIDTH = 50;
localparam RECTANGLE_HEIGHT = 50;
localparam RECTANGLE_COLOUR = 12'h0_f_0;

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


always_ff @(posedge clk) begin: rectangle_ff_blk
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

always_comb begin: rectangle_comb_blk
    if ((in.hcount >= xpos_sync) && (in.hcount < xpos_sync + RECTANGLE_WIDTH) && (in.vcount >= ypos_sync) && (in.vcount < ypos_sync + RECTANGLE_HEIGHT)) begin
        rgb_nxt = RECTANGLE_COLOUR;
    end
    else begin
        rgb_nxt = in.rgb;
    end
end

endmodule
