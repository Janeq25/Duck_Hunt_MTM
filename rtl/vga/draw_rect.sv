    `timescale 1 ns / 1 ps

module draw_target(
    input logic rst,
    input logic clk,

    itf_vga.in in,
    itf_vga.out out
);//

import vga_pkg::*;

/**
 * Local variables and signals
 */

logic [11:0] rgb_nxt;

localparam RECTANGLE_POS_X = 150;
localparam RECTANGLE_POS_Y = 100;
localparam RECTANGLE_WIDTH = 50;
localparam RECTANGLE_HEIGHT = 50;
localparam BACKGROUND_COLOUR = 12'h0_0_0;
localparam TARGET_COLOUR = 12'hf_f_f;

/**
 * Internal logic
 */

always_ff @(posedge clk) begin: rectangle_ff_blk
    if (rst) begin
        out.hcount <= '0;
        out.hsync <= '0;
        out.hblnk <= '0;
        out.vcount <= '0;
        out.vsync <= '0;
        out.vblnk <= '0;
        out.rgb <= '0;
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
    if (in.hcount >= RECTANGLE_POS_X && in.vcount >= RECTANGLE_POS_Y && in.hcount <= RECTANGLE_POS_X + RECTANGLE_WIDTH && in.vcount <= RECTANGLE_POS_Y + RECTANGLE_HEIGHT) begin
        rgb_nxt = TARGET_COLOUR;
    end
    else begin
        rgb_nxt = BACKGROUND_COLOUR;
    end
end

endmodule
