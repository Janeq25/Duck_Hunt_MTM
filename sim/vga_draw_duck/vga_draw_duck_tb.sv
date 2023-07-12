/**
 *  Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for vga_timing module.
 */

`timescale 1 ns / 1 ps

module vga_draw_duck_tb;

import vga_pkg::*;


/**
 *  Local parameters
 */

localparam CLK_PERIOD = 15;     // 65 MHz


/**
 * Local variables and signals
 */

logic clk;
logic rst;
logic new_frame;

itf_vga timing ();
itf_vga duck ();


/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    timing.rgb = 12'ha_a_a;
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

vga_timing u_vga_timing(
    .clk,
    .rst,
    
    .out(timing.out),
    .new_frame(new_frame)
);

draw_duck dut (
    .clk,
    .rst,

    .duck_hit(1'b0),
    .duck_show(1'b0),
    .duck_x(11'd800),
    .duck_y(11'd600),

    .in(timing.in),
    .new_frame,
    .out(duck.out)
);


/**
 * Main test
 */

initial begin
    @(posedge rst);
    @(negedge rst);

    wait (timing.vsync == 1'b0);
    @(negedge timing.vsync)
    @(negedge timing.vsync)

    $finish;
end

endmodule
