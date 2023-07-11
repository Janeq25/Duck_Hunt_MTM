/**
 *  Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for vga_timing module.
 */

`timescale 1 ns / 1 ps

module vga_timing_tb;

import vga_pkg::*;


/**
 *  Local parameters
 */

localparam CLK_PERIOD = 15;     // 65 MHz


/**
 * Local variables and signals
 */

logic clk, clk_100MHz;
logic rst;
logic new_frame;

itf_vga i ();


/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


/**
 * Reset generation
 */

initial begin
                       rst = 1'b0;
    #(1.25*CLK_PERIOD) rst = 1'b1;
                       rst = 1'b1;
    #(2.00*CLK_PERIOD) rst = 1'b0;
end


/**
 * Dut placement
 */

vga_timing dut(
    .clk,
    .rst,
    
    .out(i.out),
    .new_frame(new_frame)
);

/**
 * Tasks and functions
 */

 // check for counter overflow. Unknown state will occur nly before reset so it is allowed and accounted
always_comb begin
    assert (i.vcount <= V_TOTAL || $isunknown(i.vcount)) else $error("%m vcount above max value");
    assert (i.hcount <= H_TOTAL || $isunknown(i.hcount)) else $error("%m hcount above max value");
end



/**
 * Assertions
 */

// check if signals are correct
assert property (@(posedge i.hblnk) disable iff (rst) i.hcount == H_B_START || $isunknown(i.hcount)) else $error("%m wrong position of hblank start");
assert property (@(negedge i.hblnk) disable iff (rst) i.hcount == H_B_END || $isunknown(i.hcount)) else $error("%m wrong position of hblank end");

assert property (@(posedge i.hsync) disable iff (rst) i.hcount == H_S_START || $isunknown(i.hcount)) else $error("%m wrong position of hsync start");
assert property (@(negedge i.hsync) disable iff (rst) i.hcount == H_S_END || $isunknown(i.hcount)) else $error("%m wrong position of hsync end");

assert property (@(posedge i.vblnk) disable iff (rst) i.vcount == V_B_START-1 || $isunknown(i.vcount)) else $error("%m wrong position of vblank start");
assert property (@(negedge i.vblnk) disable iff (rst) i.vcount == V_B_END-1 || $isunknown(i.vcount)) else $error("%m wrong position of vblank end");

assert property (@(posedge i.vsync) disable iff (rst) i.vcount == V_S_START-1 || $isunknown(i.vcount)) else $error("%m wrong position of vsync start");
assert property (@(negedge i.vsync) disable iff (rst) i.vcount == V_S_END-1 || $isunknown(i.vcount)) else $error("%m wrong position of vsync end");




/**
 * Main test
 */

initial begin
    @(posedge rst);
    @(negedge rst);

    wait (i.vsync == 1'b0);
    @(negedge i.vsync)
    @(negedge i.vsync)

    $finish;
end

endmodule
