/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jan Cichoń
 * 
 * Description:
 * vga signals interface
 */

`timescale 1 ns / 1 ps

interface itf_vga_no_rgb();

logic [10:0] vcount;
logic        vsync;
logic        vblnk;
logic [10:0] hcount;
logic        hsync;
logic        hblnk;



modport in(
    input  vcount,
    input  vsync,
    input  vblnk,
    input  hcount,
    input  hsync,
    input  hblnk
    );

modport out(
    output vcount,
    output vsync,
    output vblnk,
    output hcount,
    output hsync,
    output hblnk
    );


endinterface