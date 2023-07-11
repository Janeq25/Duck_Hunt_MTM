/*
 * Title: UEC2 2022/2023 Project "Duck Hunt"
 * Authors: Jan Cichon, Arkadiusz Kurnik 
 * 
 * Module Description: Top structural module
 */

 `timescale 1 ns / 1 ps

 module top_DH(
    input logic clk, //main clock 65MHz
    input logic clk100MHz, //mouse clock 100MHz
    input logic rst,

    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b
 );


 // interfaces


 // local signals
    assign vs = 1'b0;
    assign hs = 1'b0;
    assign r = '0;
    assign g = '0;
    assign b = '0;

 // modules


 endmodule