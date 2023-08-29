/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jan Cichoń
 * 
 * Description:
 * loads displays and animates duck
 */


 module draw_duck(
    input logic clk,
    input logic rst,
    input logic new_frame,

    input logic duck_show,
    input logic duck_hit, //duck stops moving
    input logic duck_direction,

    input logic [9:0] duck_x,
    input logic [9:0] duck_y,

    itf_vga.in in,
    itf_vga.out out
 );

 import DH_pkg::*;

 // internal signals
    logic [11:0] rom_duckA;
    logic [11:0] rom_duckB;
    logic [11:0] rgb_nxt;
    logic [3:0] frame_ctr;
    logic [3:0] frame_ctr_nxt;
    logic [4:0] addr_top;
    logic [5:0] addr_bottom;

 // signal assignments
    assign addr_top = 5'(in.vcount - duck_y);
    assign addr_bottom = duck_direction ? 6'(in.hcount - duck_x) : 6'h3f - 6'(in.hcount - duck_x);


 template_rom #(.ADDR_WIDTH(11), .DATA_WIDTH(12), .DATA_PATH("DH_duckA.dat")) u_duckA_rom(
    .clk,
    .addrA({addr_top, addr_bottom}),
    .en(1'b1),
    .dout(rom_duckA)
);

template_rom #(.ADDR_WIDTH(11), .DATA_WIDTH(12), .DATA_PATH("DH_duckB.dat")) u_duckB_rom(
    .clk,
    .addrA({addr_top, addr_bottom}),
    .en(1'b1),
    .dout(rom_duckB)
);

always_ff @(posedge clk) begin
    if(rst) begin
        out.hblnk <= 1'b0;
        out.hsync <= 1'b0;
        out.hcount <= '0;
        out.vblnk <= 1'b0;
        out.vsync <= 1'b0;
        out.vcount <= '0;
        out.rgb <= '0;
        frame_ctr <= '0;
    end
    else begin
        out.hblnk <= in.hblnk;
        out.hsync <= in.hsync;
        out.hcount <= in.hcount;
        out.vblnk <= in.vblnk;
        out.vsync <= in.vsync;
        out.vcount <= in.vcount;
        out.rgb <= rgb_nxt;
        frame_ctr <= frame_ctr_nxt;
    end
end

always_comb begin 
    if(new_frame) begin
        frame_ctr_nxt = frame_ctr + 1;
    end
    else begin
        frame_ctr_nxt = frame_ctr;
    end
end

always_comb begin
    if (duck_show && in.hcount > duck_x && in.vcount > duck_y && in.hcount < duck_x+DUCK_WIDTH && in.vcount < duck_y+DUCK_HEIGHT) begin

        if(frame_ctr < 8 && ~duck_hit) begin
            rgb_nxt = rom_duckB == 12'hf_0_0 ? in.rgb : rom_duckB;
        end
        else begin
            rgb_nxt = rom_duckA == 12'hf_0_0 ? in.rgb : rom_duckA;
        end
    end
    else begin
        rgb_nxt = in.rgb;
    end
end

 endmodule