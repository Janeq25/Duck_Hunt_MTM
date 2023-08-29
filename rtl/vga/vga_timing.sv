/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 * 
 * Conversion to 1024x768: Jan Cichon
 *
 * Description:
 * Vga timing controller.
 */

`timescale 1 ns / 1 ps

module vga_timing (
    input  logic clk,
    input  logic rst,

    itf_vga_no_rgb.out out,

    output logic new_frame
);

import DH_pkg::*;


/**
 * Local variables and signals
 */

logic [10:0] vcount_nxt;
logic [10:0] hcount_nxt;
logic vsync_nxt;
logic vblnk_nxt;
logic hsync_nxt;
logic hblnk_nxt;
logic new_frame_nxt;


/**
 * Internal logic
 */

  always_ff @( posedge clk) begin : timer
    if (rst) begin
      out.vcount <= '0;
      out.hcount <= '0;
      out.vsync <= 1'b0;
      out.hsync <= 1'b0;
      out.vblnk <= 1'b0;
      out.hblnk <= 1'b0;
      new_frame <= 1'b0;
    end
    else begin
      out.vcount <= vcount_nxt;
      out.hcount <= hcount_nxt;
      out.vsync <= vsync_nxt;
      out.hsync <= hsync_nxt;
      out.vblnk <= vblnk_nxt;
      out.hblnk <= hblnk_nxt;
      new_frame <= new_frame_nxt;
    end
  end


  always_comb begin : my_hcounter
    if (out.hcount >= H_TOTAL-1) begin
      hcount_nxt = '0;
    end
    else begin
      hcount_nxt = out.hcount + 1;
    end
  end

  always_comb begin : my_vcounter
    if (out.hcount == H_TOTAL-1) begin
      if (out.vcount >= V_TOTAL-1) begin
        vcount_nxt = 0;
      end
      else begin
        vcount_nxt = out.vcount + 1;
      end
    end
    else begin
      vcount_nxt = out.vcount;
    end
  end


  always_comb begin : my_hblnk
    if (out.hcount >= H_B_START && out.hcount <= H_B_END-1) begin
      hblnk_nxt = 1'b1;
    end else begin
      hblnk_nxt = 1'b0;
    end
  end

  always_comb begin : my_vblnk
    if ((out.vcount >= V_B_START && out.vcount <= V_B_END-1 && ~(out.vcount == V_B_END-1 && out.hcount == H_TOTAL-1)) || (out.vcount == V_B_START-1 && out.hcount == H_TOTAL-1)) begin
      vblnk_nxt = 1'b1;
    end else begin
      vblnk_nxt = 1'b0;
    end
  end

  always_comb begin : my_hsync
    if (out.hcount >= H_S_START && out.hcount <= H_S_END-1) begin
      hsync_nxt = 1'b1;
    end else begin
      hsync_nxt = 1'b0;
    end
  end

  always_comb begin : my_vsync
    if ((out.vcount >= V_S_START && out.vcount <= V_S_END-1 && ~(out.vcount == V_S_END-1 && out.hcount == H_TOTAL-1)) || (out.vcount == V_S_START-1 && out.hcount == H_TOTAL-1)) begin
      vsync_nxt = 1'b1;
    end else begin
      vsync_nxt = 1'b0;
    end
  end

  always_comb begin : new_frame_comb
    if (out.vblnk && ~vblnk_nxt) begin
      new_frame_nxt = 1'b1;
    end
    else begin
      new_frame_nxt = 1'b0;
    end
  end

endmodule
