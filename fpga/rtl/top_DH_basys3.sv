/**
 * San Jose State University
 * EE178 Lab #4
 * Author: prof. Eric Crabilla
 *
 * Modified by:
 * 2023  AGH University of Science and Technology
 * MTM UEC2
 * Piotr Kaczmarczyk
 *
 * Description:
 * Top level synthesizable module including the project top and all the FPGA-referred modules.
 */

`timescale 1 ns / 1 ps

module top_vga_basys3 (
    input  wire clk,

    input  wire btnC,
    input  wire btnU,

    output wire Vsync,
    output wire Hsync,
    output wire [3:0] vgaRed,
    output wire [3:0] vgaGreen,
    output wire [3:0] vgaBlue,

    inout logic PS2Clk,
    inout logic PS2Data,

    input logic sw,
    output logic JA1,
    output logic JA2,
    input logic RsRx,
    output logic RsTx,

    output logic [6:0] seg,
    output logic [3:0] an,
    output logic dp

);


/**
 * Local variables and signals
 */

// wire clk_in, clk_fb, clk_ss, clk_out;
//wire locked;
wire pclk;
wire pclk_mirror;
wire clk_100MHz;

// (* KEEP = "TRUE" *)
// (* ASYNC_REG = "TRUE" *)
// logic [7:0] safe_start = 0;
// // For details on synthesis attributes used above, see AMD Xilinx UG 901:
// // https://docs.xilinx.com/r/en-US/ug901-vivado-synthesis/Synthesis-Attributes


/**
 * Signals assignments
 */

//assign JA1 = pclk_mirror;


/**
 * FPGA submodules placement
 */

clk_wiz_0 u_clk_wiz_0(
    .clk(clk),
    .clk100MHz(clk_100MHz),
    .clk40MHz(pclk),
    .locked(locked)
);


ODDR pclk_oddr (
    .Q(pclk_mirror),
    .C(pclk),
    .CE(1'b1),
    .D1(1'b1),
    .D2(1'b0),
    .R(1'b0),
    .S(1'b0)
);


/**
 *  Project functional top module
 */

top_vga u_top_vga (
    .clk(pclk),
    .rst(btnC),
    .r(vgaRed),
    .g(vgaGreen),
    .b(vgaBlue),
    .hs(Hsync),
    .vs(Vsync),
    .ps2_clk(PS2Clk),
    .ps2_data(PS2Data),
    .clk100MHz(clk_100MHz),
    .loopback_enable(sw),
    .rx(RsRx),
    .tx(RsTx),
    .rx_monitor(JA1),
    .tx_monitor(JA2),
    .button_top(btnU),
    .sseg({seg, dp}),
    .an(an)
);

endmodule
