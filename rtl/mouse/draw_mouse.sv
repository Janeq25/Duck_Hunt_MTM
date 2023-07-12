`timescale 1 ns / 1 ps

module draw_mouse(
    input logic clk,
    input logic rst,

    input logic [11:0] x_pos,
    input logic [11:0] y_pos,

    vga_if.in in,
    vga_if.out out
);

logic [11:0] x_pos_synced;
logic [11:0] y_pos_synced;

// syncing clock

always_ff @(posedge clk) begin
    x_pos_synced <= x_pos;
    y_pos_synced <= y_pos;
end

MouseDisplay u_MouseDisplay(
    .pixel_clk(clk),
    .xpos(x_pos_synced),
    .ypos(y_pos_synced),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .blank(in.vblnk | in.hblnk),

    .rgb_in(in.rgb),
    .rgb_out(out.rgb),

    .enable_mouse_display_out()
);

always_ff @(posedge clk) begin
    if(rst) begin
        out.hsync <= '0;
        out.vsync <= '0;

        out.hblnk <= '0;
        out.vblnk <= '0;
        
        out.hcount <= '0;
        out.vcount <= '0;
    end
    else begin
        out.hsync <= in.hsync;
        out.vsync <= in.vsync;

        out.hblnk <= in.hblnk;
        out.vblnk <= in.vblnk;
        
        out.hcount <= in.hcount;
        out.vcount <= in.vcount;
    end
end

endmodule