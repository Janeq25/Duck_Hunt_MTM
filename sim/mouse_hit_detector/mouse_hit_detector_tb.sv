/**
 *  Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for vga_timing module.
 */

`timescale 1 ns / 1 ps

module mouse_hit_detector_tb;

import DH_pkg::*;


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

logic dut_out;
logic [19:0] dut_in;

itf_vga_no_rgb timing ();
itf_vga duck ();


/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    dut_in = '0;
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
    forever #(CLK_PERIOD/2) dut_in = dut_in + 1;
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

mouse_hit_detector #( .TARGET_HEIGHT(DUCK_HEIGHT), .TARGET_WIDTH(DUCK_WIDTH)) u_dut(
    .clk,
    .rst,

    .mouse_on_target(dut_out),

    .mouse_x(dut_in[9:0]),
    .mouse_y(dut_in[19:10]),
    .target_x(10'd500),
    .target_y(10'd500)
);

/**
 * Main test
 */

initial begin
    forever #(CLK_PERIOD/2) begin
        if (dut_out) begin
            $display("intersected target at x=%d, y=%d \n",  dut_in[9:0], dut_in[19:10]);
        end
    end
end

initial begin
    @(posedge rst);
    @(negedge rst);

    wait (timing.vsync == 1'b0);
    @(negedge timing.vsync)
    @(negedge timing.vsync)

    $finish;
end

endmodule
