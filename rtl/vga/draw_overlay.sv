/**
* Copyright (C) 2023  AGH University of Science and Technology
* MTM UEC2
* Author: Jan Cichoń
*
* Description:
* Displays text_rects to the screen. Governs the connections to the font_rom between text_rects.
*/

module draw_overlay(
    input logic clk,
    input logic rst,

    input logic pause,
    input logic p2_connected,
    input logic looser,
    input logic no_ammo,

    itf_vga.in in,
    itf_vga.out out

);

//params
localparam DUCK_HEIGHT = 48;
localparam DUCK_WIDTH = 64;
localparam SCREEN_WIDTH = 1024;
localparam SCREEN_HEIGHT = 768;

localparam HELP_X = 0;
localparam HELP_Y = 0;
localparam HELP_SIZE_X = 20;
localparam HELP_SIZE_Y = 12;
localparam HELP_DATA = {" connections help:  ",
                        " gun connection:    ",
                        " br bl wb wg x  x JA",
                        " x  x  x  x  x  x   ",
                        "                    ",
                        " player2 conn:      ",
                        " br bl wb wg x  x JC",
                        " wh bl or x  x  x   ",
                        "                    ",
                        " player2 conn2:     ",
                        " rd gr bl pu x  x JB",
                        " wh bl or x  mg  x  "};
localparam HELP_COLOR = 12'hf_f_f;

localparam PAUSE_X = SCREEN_WIDTH/2;
localparam PAUSE_Y = 100;
localparam PAUSE_SIZE_X = 8;
localparam PAUSE_SIZE_Y = 1;
localparam PAUSE_DATA = " PAUSED ";
localparam PAUSE_COLOR = 12'h7_7_7;

localparam WINNER_X = SCREEN_WIDTH/2;
localparam WINNER_Y = 150;
localparam WINNER_SIZE_X = 8;
localparam WINNER_SIZE_Y = 1;
localparam WINNER_DATA = " WINNER ";
localparam WINNER_COLOR = 12'h0_f_0;

localparam LOOSER_X = SCREEN_WIDTH/2;
localparam LOOSER_Y = 150;
localparam LOOSER_SIZE_X = 8;
localparam LOOSER_SIZE_Y = 1;
localparam LOOSER_DATA = " LOOSER ";
localparam LOOSER_COLOR = 12'hf_0_0;

localparam PLAYER2_X = 800;
localparam PLAYER2_Y = 400;
localparam PLAYER2_SIZE_X = 9;
localparam PLAYER2_SIZE_Y = 1;
localparam PLAYER2_DATA = " PLAYER2 ";
localparam PLAYER2_COLOR = 12'h7_7_7;

localparam CONNECTED_X = 800;
localparam CONNECTED_Y = 450;
localparam CONNECTED_SIZE_X = 11;
localparam CONNECTED_SIZE_Y = 1;
localparam CONNECTED_DATA = " CONNECTED ";
localparam CONNECTED_COLOR = 12'hf_0_f;

localparam DISCONNECTED_X = 800;
localparam DISCONNECTED_Y = 450;
localparam DISCONNECTED_SIZE_X = 14;
localparam DISCONNECTED_SIZE_Y = 1;
localparam DISCONNECTED_DATA = " DISCONNECTED ";
localparam DISCONNECTED_COLOR = 12'h0_f_f;

localparam SW15_X = 0;
localparam SW15_Y = 700;
localparam SW15_SIZE_X = 15;
localparam SW15_SIZE_Y = 1;
localparam SW15_DATA = " SW15 for HELP ";
localparam SW15_COLOR = 12'hf_0_0;

localparam NO_AMMO_X = 0;
localparam NO_AMMO_Y = 500;
localparam NO_AMMO_SIZE_X = 32;
localparam NO_AMMO_SIZE_Y = 2;
localparam NO_AMMO_DATA = {" OUT OF AMMO?                   ",
                           " PRESS MIDDLE BUTTON TO RELOAD! "};
localparam NO_AMMO_COLOR = 12'hc_0_0;

//internal signals
logic [11:0] rgb_nxt;
logic [11:0] help_rgb;
logic [11:0] pause_rgb;
logic [11:0] winner_rgb;
logic [11:0] looser_rgb;
logic [11:0] player2_rgb;
logic [11:0] connected_rgb;
logic [11:0] disconnected_rgb;
logic [11:0] sw15_rgb;
logic [11:0] no_ammo_rgb;


logic [6:0] char_code_help;
logic [3:0] char_line_help;
logic [6:0] char_code_pause;
logic [3:0] char_line_pause;
logic [6:0] char_code_winner;
logic [3:0] char_line_winner;
logic [6:0] char_code_looser;
logic [3:0] char_line_looser;
logic [6:0] char_code_player2;
logic [3:0] char_line_player2;
logic [6:0] char_code_connected;
logic [3:0] char_line_connected;
logic [6:0] char_code_disconnected;
logic [3:0] char_line_disconnected;
logic [6:0] char_code_sw15;
logic [3:0] char_line_sw15;
logic [6:0] char_code_no_ammo;
logic [3:0] char_line_no_ammo;

logic [10:0] addr;
logic [7:0] char_pixels;



//interfaces
itf_vga delayed();

//font memory
font_rom u_font_rom (
    .clk,
    .addr,
    .char_pixels
);

//signal sync
delay #(.CLK_DEL(2), .WIDTH(38)) u_delay (
    .clk(clk),
    .rst(rst),
    .din({in.hcount, in.hblnk, in.hsync, in.vcount, in.vblnk, in.vsync, in.rgb}),
    .dout({delayed.hcount, delayed.hblnk, delayed.hsync, delayed.vcount, delayed.vblnk, delayed.vsync, delayed.rgb})
);

//strings to diplay
draw_char_rect #(
    .RECT_X(HELP_X),
    .RECT_Y(HELP_Y),
    .SIZE_X(HELP_SIZE_X),
    .SIZE_Y(HELP_SIZE_Y),
    .DATA(HELP_DATA),
    .FONT_COLOR(HELP_COLOR)
)
 u_help_rect (
    .clk,
    .rst,


    .char_line(char_line_help),
    .char_pixels,
    .char_code(char_code_help),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(help_rgb)

);

draw_char_rect #(
    .RECT_X(PAUSE_X),
    .RECT_Y(PAUSE_Y),
    .SIZE_X(PAUSE_SIZE_X),
    .SIZE_Y(PAUSE_SIZE_Y),
    .DATA(PAUSE_DATA),
    .FONT_COLOR(PAUSE_COLOR)
)
 u_title_rect (
    .clk,
    .rst,


    .char_line(char_line_pause),
    .char_pixels,
    .char_code(char_code_pause),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(pause_rgb)

);

draw_char_rect #(
    .RECT_X(WINNER_X),
    .RECT_Y(WINNER_Y),
    .SIZE_X(WINNER_SIZE_X),
    .SIZE_Y(WINNER_SIZE_Y),
    .DATA(WINNER_DATA),
    .FONT_COLOR(WINNER_COLOR)
)
 u_winner_rect (
    .clk,
    .rst,


    .char_line(char_line_winner),
    .char_pixels,
    .char_code(char_code_winner),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(winner_rgb)

);

draw_char_rect #(
    .RECT_X(LOOSER_X),
    .RECT_Y(LOOSER_Y),
    .SIZE_X(LOOSER_SIZE_X),
    .SIZE_Y(LOOSER_SIZE_Y),
    .DATA(LOOSER_DATA),
    .FONT_COLOR(LOOSER_COLOR)
)
 u_looser_rect (
    .clk,
    .rst,


    .char_line(char_line_looser),
    .char_pixels,
    .char_code(char_code_looser),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(looser_rgb)

);

draw_char_rect #(
    .RECT_X(PLAYER2_X),
    .RECT_Y(PLAYER2_Y),
    .SIZE_X(PLAYER2_SIZE_X),
    .SIZE_Y(PLAYER2_SIZE_Y),
    .DATA(PLAYER2_DATA),
    .FONT_COLOR(PLAYER2_COLOR)
)
 u_player2_rect (
    .clk,
    .rst,


    .char_line(char_line_player2),
    .char_pixels,
    .char_code(char_code_player2),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(player2_rgb)

);

draw_char_rect #(
    .RECT_X(CONNECTED_X),
    .RECT_Y(CONNECTED_Y),
    .SIZE_X(CONNECTED_SIZE_X),
    .SIZE_Y(CONNECTED_SIZE_Y),
    .DATA(CONNECTED_DATA),
    .FONT_COLOR(CONNECTED_COLOR)
)
 u_connected_rect (
    .clk,
    .rst,


    .char_line(char_line_connected),
    .char_pixels,
    .char_code(char_code_connected),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(connected_rgb)

);

draw_char_rect #(
    .RECT_X(DISCONNECTED_X),
    .RECT_Y(DISCONNECTED_Y),
    .SIZE_X(DISCONNECTED_SIZE_X),
    .SIZE_Y(DISCONNECTED_SIZE_Y),
    .DATA(DISCONNECTED_DATA),
    .FONT_COLOR(DISCONNECTED_COLOR)
)
 u_dieconnected_rect (
    .clk,
    .rst,


    .char_line(char_line_disconnected),
    .char_pixels,
    .char_code(char_code_disconnected),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(disconnected_rgb)

);

draw_char_rect #(
    .RECT_X(SW15_X),
    .RECT_Y(SW15_Y),
    .SIZE_X(SW15_SIZE_X),
    .SIZE_Y(SW15_SIZE_Y),
    .DATA(SW15_DATA),
    .FONT_COLOR(SW15_COLOR)
)
 u_sw15_rect (
    .clk,
    .rst,


    .char_line(char_line_sw15),
    .char_pixels,
    .char_code(char_code_sw15),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in(in.rgb),
    .rgb_out(sw15_rgb)

);

draw_char_rect #(
    .RECT_X(NO_AMMO_X),
    .RECT_Y(NO_AMMO_Y),
    .SIZE_X(NO_AMMO_SIZE_X),
    .SIZE_Y(NO_AMMO_SIZE_Y),
    .DATA(NO_AMMO_DATA),
    .FONT_COLOR(NO_AMMO_COLOR)
)
 u_no_ammo_rect (
    .clk,
    .rst,


    .char_line(char_line_no_ammo),
    .char_pixels,
    .char_code(char_code_no_ammo),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(no_ammo_rgb)

);



//sequential block

always_ff @(posedge clk) begin
    if (rst) begin
        out.rgb <= '0;
        out.hblnk <= '0;
        out.hcount <= '0;
        out.hsync <= '0;
        out.vblnk <= '0;
        out.vcount <= '0;
        out.vsync <= '0;
    end
    else begin
        out.rgb <= rgb_nxt;
        out.hsync <= delayed.hsync;
        out.hblnk <= delayed.hblnk;
        out.hcount <= delayed.hcount;
        out.vsync <= delayed.vsync;
        out.vblnk <= delayed.vblnk;
        out.vcount <= delayed.vcount;

    end
end

//govern font_rom access and display text according to incoming signals
always_comb begin
    if (pause) begin
        if (delayed.hcount > SCREEN_WIDTH/2 && delayed.vcount > SCREEN_HEIGHT/2 && delayed.hcount < (SCREEN_WIDTH/2)+DUCK_WIDTH && delayed.vcount < (SCREEN_HEIGHT/2)+DUCK_HEIGHT) begin
            rgb_nxt = 12'hf_f_f;
            addr = '0;
        end
        else if (delayed.hcount > HELP_X && delayed.vcount > HELP_Y && delayed.hcount < HELP_X+(HELP_SIZE_X*8) && delayed.vcount < HELP_Y+(HELP_SIZE_Y*16)) begin
            rgb_nxt = help_rgb;
            addr = {char_code_help, char_line_help};
        end
        else if (delayed.hcount > PAUSE_X && delayed.vcount > PAUSE_Y && delayed.hcount < PAUSE_X+(PAUSE_SIZE_X*8) && delayed.vcount < PAUSE_Y+(PAUSE_SIZE_Y*16)) begin
            rgb_nxt = pause_rgb;
            addr = {char_code_pause, char_line_pause};
        end
        else if (delayed.hcount > WINNER_X && delayed.vcount > WINNER_Y && delayed.hcount < WINNER_X+(WINNER_SIZE_X*8) && delayed.vcount < WINNER_Y+(WINNER_SIZE_Y*16) && ~looser) begin
            rgb_nxt = winner_rgb;
            addr = {char_code_winner, char_line_winner};
        end
        else if (delayed.hcount > WINNER_X && delayed.vcount > WINNER_Y && delayed.hcount < WINNER_X+(WINNER_SIZE_X*8) && delayed.vcount < WINNER_Y+(WINNER_SIZE_Y*16) && looser) begin
            rgb_nxt = looser_rgb;
            addr = {char_code_looser, char_line_looser};
        end
        else if (delayed.hcount > PLAYER2_X && delayed.vcount > PLAYER2_Y && delayed.hcount < PLAYER2_X+(PLAYER2_SIZE_X*8) && delayed.vcount < PLAYER2_Y+(PLAYER2_SIZE_Y*16)) begin
            rgb_nxt = player2_rgb;
            addr = {char_code_player2, char_line_player2};
        end
        else if (delayed.hcount > CONNECTED_X && delayed.vcount > CONNECTED_Y && delayed.hcount < CONNECTED_X+(CONNECTED_SIZE_X*8) && delayed.vcount < CONNECTED_Y+(CONNECTED_SIZE_Y*16) && p2_connected) begin
            rgb_nxt = connected_rgb;
            addr = {char_code_connected, char_line_connected};
        end
        else if (delayed.hcount > DISCONNECTED_X && delayed.vcount > DISCONNECTED_Y && delayed.hcount < DISCONNECTED_X+(DISCONNECTED_SIZE_X*8) && delayed.vcount < DISCONNECTED_Y+(DISCONNECTED_SIZE_Y*16) && ~p2_connected) begin
            rgb_nxt = disconnected_rgb;
            addr = {char_code_disconnected, char_line_disconnected};
        end
        else if (delayed.hcount > NO_AMMO_X && delayed.vcount > NO_AMMO_Y && delayed.hcount < NO_AMMO_X+(NO_AMMO_SIZE_X*8) && delayed.vcount < NO_AMMO_Y+(NO_AMMO_SIZE_Y*16) && no_ammo) begin
            rgb_nxt = no_ammo_rgb;
            addr = {char_code_no_ammo, char_line_no_ammo};
        end
        else begin
            rgb_nxt = 12'h0_0_0;
            addr = '0;
        end
    end
    else begin
        if (delayed.hcount > SW15_X && delayed.vcount > SW15_Y && delayed.hcount < SW15_X+(SW15_SIZE_X*8) && delayed.vcount < SW15_Y+(SW15_SIZE_Y*16)) begin
            rgb_nxt = sw15_rgb;
            addr = {char_code_sw15, char_line_sw15};
        end
        else begin
            rgb_nxt = in.rgb;
            addr = '0;
        end
    end
end

endmodule