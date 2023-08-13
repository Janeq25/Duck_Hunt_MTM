/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Arkadiusz Kurnik
 * 
 * Description:
 * drawing target module
 */

`timescale 1 ns / 1 ps

module draw_target(
    input logic rst,
    input logic clk,
    input logic [9:0] duck_x,
    input logic [9:0] duck_y,
    input logic new_frame,
    input logic shot_fired,
    input logic duck_hit,
    input logic gun_is_connected,

    itf_vga.in in,
    itf_vga.out out
);//

/**
 * Local variables and signals
 */

localparam TARGET_FRAMES = 10;
localparam TARGET_WIDTH = 50;
localparam TARGET_HEIGHT = 50;

localparam BACKGROUND_COLOUR = 12'h0_0_0;
localparam TARGET_COLOUR = 12'hf_f_f;

logic shot_last;
logic [5:0] frame_ctr;
logic [5:0] frame_ctr_nxt;
logic [11:0] rgb_nxt;


/**
 * Internal logic
 */

always_ff @(posedge clk) begin : edge_detection
   if (rst) begin
       shot_last <= 1'b0;
   end
   else begin
       shot_last <= shot_fired;
   end
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
        frame_ctr <= '0;
    end
    else if(gun_is_connected && ~duck_hit && frame_ctr > 0 && frame_ctr < TARGET_FRAMES) begin
        out.hcount <= in.hcount;
        out.hsync <= in.hsync;
        out.hblnk <= in.hblnk;
        out.vcount <= in.vcount;
        out.vsync <= in.vsync;
        out.vblnk <= in.vblnk;
        out.rgb <= rgb_nxt;
        frame_ctr <= frame_ctr_nxt;
    end
    else begin
        out.hcount <= in.hcount;
        out.hsync <= in.hsync;
        out.hblnk <= in.hblnk;
        out.vcount <= in.vcount;
        out.vsync <= in.vsync;
        out.vblnk <= in.vblnk;
        out.rgb <= in.rgb;
        frame_ctr <= frame_ctr_nxt;
    end
end

always_comb begin : target_comb_blk
    if (in.hcount >= duck_x && in.vcount >= duck_y && in.hcount <= duck_x + TARGET_WIDTH && in.vcount <= duck_y + TARGET_HEIGHT) begin
        rgb_nxt = TARGET_COLOUR;
    end
    else begin
        rgb_nxt = BACKGROUND_COLOUR;
    end
end

always_comb begin : frame_counter_blk
    if(~shot_last && shot_fired) begin
        frame_ctr_nxt = frame_ctr + 1;
    end
    else if(new_frame && frame_ctr > 0 && frame_ctr < TARGET_FRAMES) begin
        frame_ctr_nxt = frame_ctr + 1;
    end
    else if(frame_ctr >= TARGET_FRAMES) begin
        frame_ctr_nxt = '0;
    end
    else begin
        frame_ctr_nxt = frame_ctr;
    end
end

endmodule
