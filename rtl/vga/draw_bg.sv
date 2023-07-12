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

    // input  logic [10:0] in.vcount,
    // input  logic        in.vsync,
    // input  logic        in.vblnk,
    // input  logic [10:0] in.hcount,
    // input  logic        in.hsync,
    // input  logic        in.hblnk,
    itf_vga.in in,

    // output logic [10:0] vcount_out,
    // output logic        vsync_out,
    // output logic        vblnk_out,
    // output logic [10:0] hcount_out,
    // output logic        hsync_out,
    // output logic        hblnk_out,
    // output logic [11:0] rgb_out
    itf_vga.out out
);

import vga_pkg::*;


/**
 * Local variables and signals
 */

logic [11:0] rgb_nxt;
logic [11:0] rom_rgb;


/**
 * Internal logic
 */

 template_rom #(.ADDR_WIDTH(22), .DATA_WIDTH(12), .DATA_PATH("DH_bg.dat")) u_bg_rom(
    .clk,
    .addrA({in.vcount, in.hcount}),
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

endmodule
