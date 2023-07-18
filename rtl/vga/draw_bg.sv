/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Draw background.
 */


`timescale 1 ns / 1 ps


module draw_bg (
    input  logic clk,
    input  logic rst,
    input  logic new_frame,

    itf_vga.in in,

    itf_vga.out out
);

import vga_pkg::*;


/**
 * Local variables and signals
 */

logic [11:0] rgb_nxt;
logic [11:0] rom_rgb;
logic [8:0] frame_ctr;
logic [8:0] frame_ctr_nxt;
logic [7:0] addr_vert;
logic [8:0] addr_hor;

/**
 * signal assignments
 */
 assign addr_vert = 8'((in.vcount[10:3] >> (2'h3 - frame_ctr[8:7])) + 8'd512);
 assign addr_hor = 9'(in.hcount[10:2] >> (2'h3 - frame_ctr[8:7]));

/**
 * Internal logic
 */

 template_rom #(.ADDR_WIDTH(17), .DATA_WIDTH(12), .DATA_PATH("DH_bg_downscaled_title.dat")) u_bg_rom(
    .clk,
    .addrA({addr_vert, addr_hor}),
    .en(1'b1),
    .dout(rom_rgb)
);

always_ff @(posedge clk) begin : bg_ff_blk
    if (rst) begin
        out.vcount <= '0;
        out.vsync  <= '0;
        out.vblnk  <= '0;
        out.hcount <= '0;
        out.hsync  <= '0;
        out.hblnk  <= '0;
        out.rgb    <= '0;
    end else begin
        out.vcount <= in.vcount;
        out.vsync  <= in.vsync;
        out.vblnk  <= in.vblnk;
        out.hcount <= in.hcount;
        out.hsync  <= in.hsync;
        out.hblnk  <= in.hblnk;
        out.rgb    <= rgb_nxt;
    end
end



always_comb begin : bg_comb_blk
    if (in.vblnk || in.hblnk) begin             // Blanking region:
        rgb_nxt = 12'h0_0_0;                    // - make it it black.
    end else begin                              // Active region:
        if (in.vcount == 0)                     // - top edge:
            rgb_nxt = 12'hf_f_0;                // - - make a yellow line.
        else if (in.vcount == VER_PIXELS - 1)   // - bottom edge:
            rgb_nxt = 12'hf_0_0;                // - - make a red line.
        else if (in.hcount == 0)                // - left edge:
            rgb_nxt = 12'h0_f_0;                // - - make a green line.
        else if (in.hcount == HOR_PIXELS - 1)   // - right edge:
            rgb_nxt = 12'h0_0_f;                // - - make a blue line.
        else                                    // The rest of active display pixels:
            rgb_nxt = rom_rgb;                // - load image
    end
end

always_ff @(posedge clk) begin
    if (rst) begin
        frame_ctr <= '0;
    end
    else begin
        frame_ctr <= frame_ctr_nxt;
    end
end

always_comb begin
    if (new_frame && ~(frame_ctr[8:5] >= 15)) begin
        frame_ctr_nxt = frame_ctr + 1;
    end
    else begin
        frame_ctr_nxt = frame_ctr;
    end
end

endmodule
