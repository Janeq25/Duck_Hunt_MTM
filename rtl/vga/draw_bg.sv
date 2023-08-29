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

    itf_vga_no_rgb.in in,

    itf_vga.out out
);

import DH_pkg::*;


/**
 * Local variables and signals
 */

logic [11:0] rgb_nxt;
logic [11:0] rom_rgb;


/**
 * Internal logic
 */

 template_rom #(.ADDR_WIDTH(17), .DATA_WIDTH(12), .DATA_PATH("DH_bg_downscaled.dat")) u_bg_rom(
    .clk,
    .addrA({in.vcount[10:3], in.hcount[10:2]}),
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
        rgb_nxt = rom_rgb;                // - load image
    end
end

endmodule
