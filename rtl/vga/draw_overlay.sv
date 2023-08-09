/**
* Copyright (C) 2023  AGH University of Science and Technology
* MTM UEC2
* Author: Jan Cichoń
*
* Description:
*
*/

module draw_overlay(
    input logic clk,
    input logic rst,

    input logic gun_calibration,

    itf_vga.in in,
    itf_vga.out out

);

//params
localparam DUCK_HEIGHT = 48;
localparam DUCK_WIDTH = 64;
localparam SCREEN_WIDTH = 1024;
localparam SCREEN_HEIGHT = 768;

//internal signals
logic [11:0] rgb_nxt;

//sequential block

always_ff @(posedge clk) begin
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

//combinational block

always_comb begin
    if (gun_calibration) begin
        rgb_nxt = (in.hcount > SCREEN_WIDTH/2 && in.vcount > SCREEN_HEIGHT/2 && in.hcount < (SCREEN_WIDTH/2)+DUCK_WIDTH && in.vcount < (SCREEN_HEIGHT/2)+DUCK_HEIGHT) ? 12'hf_f_f : 12'h0_0_0;
    end
    else begin
        rgb_nxt = in.rgb;
    end
end

endmodule