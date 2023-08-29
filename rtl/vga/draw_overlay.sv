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
    input logic player2_connected,
    input logic no_ammo,

    input logic [3:0] score_p1,
    input logic [3:0] score_p2,

    itf_vga.in in,
    itf_vga.out out

);

import DH_pkg::*;


//params

localparam HELP_X = 0;
localparam HELP_Y = 0;
localparam HELP_SIZE_X = 20;
localparam HELP_SIZE_Y = 29;
localparam HELP_DATA = {" Aim for the ducks  ",
                        " using mouse or gun.",
                        "                    ",
                        " Your score and ammo",
                        " (in that order)    ",
                        " are shown on boards",
                        " display.           ",
                        "                    ",
                        " Can you hit all    ",
                        " your bullets?      ",
                        "                    ",
                        " Good Luck!         ",
                        "                    ",
                        "                    ",
                        "                    ",
                        "                    ",
                        "                    ",
                        " wiring diagram:    ",
                        " gun connection:    ",
                        " br bl wb wg x  x JA",
                        " x  x  x  x  x  x   ",
                        "                    ",
                        " JC and JB connect: ",
                        " x  x  bl bl bl bl  ",
                        " x  x  x  x  bl bl  ",
                        "                    ",
                        " basys1      basys2 ",
                        " JB(bl)  ->  JC(yl) ",
                        " JC(yl)  <-  JB(bl) "};
localparam HELP_COLOR = 12'hf_f_f;

localparam PAUSE_X = HOR_PIXELS/2;
localparam PAUSE_Y = 100;
localparam PAUSE_SIZE_X = 8;
localparam PAUSE_SIZE_Y = 1;
localparam PAUSE_DATA = " PAUSED ";
localparam PAUSE_COLOR = 12'h7_7_7;

localparam WINNER_X = HOR_PIXELS/2;
localparam WINNER_Y = 130;
localparam WINNER_SIZE_X = 9;
localparam WINNER_SIZE_Y = 1;
localparam WINNER_DATA = " WINNER! ";
localparam WINNER_COLOR = 12'h0_f_0;

localparam LOOSER_X = (HOR_PIXELS/2) - 20;
localparam LOOSER_Y = 130;
localparam LOOSER_SIZE_X = 14;
localparam LOOSER_SIZE_Y = 1;
localparam LOOSER_DATA = " TRY AGAIN :) ";
localparam LOOSER_COLOR = 12'hf_0_0;

localparam PLAYER2_X = 800;
localparam PLAYER2_Y = 500;
localparam PLAYER2_SIZE_X = 9;
localparam PLAYER2_SIZE_Y = 1;
localparam PLAYER2_DATA = " PLAYER2 ";
localparam PLAYER2_COLOR = 12'h7_7_7;

localparam CONNECTED_X = 800;
localparam CONNECTED_Y = 520;
localparam CONNECTED_SIZE_X = 11;
localparam CONNECTED_SIZE_Y = 1;
localparam CONNECTED_DATA = " CONNECTED ";
localparam CONNECTED_COLOR = 12'hf_0_f;

localparam DISCONNECTED_X = 800;
localparam DISCONNECTED_Y = 520;
localparam DISCONNECTED_SIZE_X = 14;
localparam DISCONNECTED_SIZE_Y = 1;
localparam DISCONNECTED_DATA = " DISCONNECTED ";
localparam DISCONNECTED_COLOR = 12'h0_f_f;

localparam PLAYER1_SCORE_X = 800;
localparam PLAYER1_SCORE_Y = 300;
localparam PLAYER1_SCORE_SIZE_X = 14;
localparam PLAYER1_SCORE_SIZE_Y = 1;
localparam PLAYER1_SCORE_DATA = " PLAYER1 SCORE ";
localparam PLAYER1_SCORE_COLOR = 12'h7_7_7;

localparam PLAYER1_SCORE_NUMBER_X = 800;
localparam PLAYER1_SCORE_NUMBER_Y = 320;
localparam PLAYER1_SCORE_NUMBER_SIZE_X = 3;
localparam PLAYER1_SCORE_NUMBER_COLOR = 12'hf_f_0;

localparam PLAYER2_SCORE_X = 800;
localparam PLAYER2_SCORE_Y = 400;
localparam PLAYER2_SCORE_SIZE_X = 14;
localparam PLAYER2_SCORE_SIZE_Y = 1;
localparam PLAYER2_SCORE_DATA = " PLAYER2 SCORE ";
localparam PLAYER2_SCORE_COLOR = 12'h7_7_7;

localparam PLAYER2_SCORE_NUMBER_X = 800;
localparam PLAYER2_SCORE_NUMBER_Y = 420;
localparam PLAYER2_SCORE_NUMBER_SIZE_X = 3;
localparam PLAYER2_SCORE_NUMBER_COLOR = 12'hf_f_0;


localparam SW15_X = 0;
localparam SW15_Y = 700;
localparam SW15_SIZE_X = 21;
localparam SW15_SIZE_Y = 2;
localparam SW15_DATA = {" SW15 for HELP       ",
                        " MIDDLE BTN to START "};
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
logic [11:0] player1_score_rgb;
logic [11:0] player2_score_rgb;
logic [11:0] player1_score_number_rgb;
logic [11:0] player2_score_number_rgb;


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
logic [6:0] char_code_player1_score;
logic [3:0] char_line_player1_score;
logic [6:0] char_code_player2_score;
logic [3:0] char_line_player2_score;
logic [3:0] char_line_player1_score_number;
logic [6:0] char_code_player1_score_number;
logic [6:0] char_code_player2_score_number;
logic [3:0] char_line_player2_score_number;


logic [10:0] addr;
logic [7:0] char_pixels;

logic looser;
always_comb begin
    if (player2_connected) begin
        looser = (score_p1 < score_p2);
    end
    else begin
        looser = (score_p1 < 15);
    end
end


//interfaces
itf_vga delayed();

//font memory
font_rom u_font_rom (
    .clk,
    .rst,
    .addr,
    .char_pixels
);

//signal sync
delay #(.CLK_DEL(3), .WIDTH(38)) u_delay (
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
 u_disconnected_rect (
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

draw_char_ram #(
    .RECT_X(PLAYER1_SCORE_NUMBER_X),
    .RECT_Y(PLAYER1_SCORE_NUMBER_Y),
    .SIZE_X(PLAYER1_SCORE_NUMBER_SIZE_X),
    .FONT_COLOR(PLAYER1_SCORE_NUMBER_COLOR)
)
 u_player1_score_number_rect (
    .clk,
    .rst,

    .char_line(char_line_player1_score_number),
    .char_pixels,
    .char_code(char_code_player1_score_number),

    .chars({7'(7'h30 + score_p1%10), 7'(7'h30 + score_p1/10), 7'b0}),

    .hcount(in.hcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(player1_score_number_rgb)

);

draw_char_rect #(
    .RECT_X(PLAYER1_SCORE_X),
    .RECT_Y(PLAYER1_SCORE_Y),
    .SIZE_X(PLAYER1_SCORE_SIZE_X),
    .SIZE_Y(PLAYER1_SCORE_SIZE_Y),
    .DATA(PLAYER1_SCORE_DATA),
    .FONT_COLOR(PLAYER1_SCORE_COLOR)
)
 u_player1_score_rect (
    .clk,
    .rst,


    .char_line(char_line_player1_score),
    .char_pixels,
    .char_code(char_code_player1_score),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(player1_score_rgb)

);

draw_char_ram #(
    .RECT_X(PLAYER2_SCORE_NUMBER_X),
    .RECT_Y(PLAYER2_SCORE_NUMBER_Y),
    .SIZE_X(PLAYER2_SCORE_NUMBER_SIZE_X),
    .FONT_COLOR(PLAYER2_SCORE_NUMBER_COLOR)
)
 u_player2_score_number_rect (
    .clk,
    .rst,

    .char_line(char_line_player2_score_number),
    .char_pixels,
    .char_code(char_code_player2_score_number),

    .chars({7'(7'h30 + score_p2%10), 7'(7'h30 + score_p2/10), 7'b0}),

    .hcount(in.hcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(player2_score_number_rgb)

);

draw_char_rect #(
    .RECT_X(PLAYER2_SCORE_X),
    .RECT_Y(PLAYER2_SCORE_Y),
    .SIZE_X(PLAYER2_SCORE_SIZE_X),
    .SIZE_Y(PLAYER2_SCORE_SIZE_Y),
    .DATA(PLAYER2_SCORE_DATA),
    .FONT_COLOR(PLAYER2_SCORE_COLOR)
)
 u_player2_score_rect (
    .clk,
    .rst,


    .char_line(char_line_player2_score),
    .char_pixels,
    .char_code(char_code_player2_score),

    .hcount(in.hcount),
    .vcount(in.vcount),
    .delayed_hcount(delayed.hcount),
    .delayed_vcount(delayed.vcount),
    .rgb_in('0),
    .rgb_out(player2_score_rgb)

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
        if (delayed.hcount > HOR_PIXELS/2 && delayed.vcount > VER_PIXELS/2 && delayed.hcount < (HOR_PIXELS/2)+DUCK_WIDTH && delayed.vcount < (VER_PIXELS/2)+DUCK_HEIGHT) begin
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
        else if (delayed.hcount > WINNER_X && delayed.vcount > WINNER_Y && delayed.hcount < WINNER_X+(WINNER_SIZE_X*8) && delayed.vcount < WINNER_Y+(WINNER_SIZE_Y*16) && ~looser && no_ammo) begin
            rgb_nxt = winner_rgb;
            addr = {char_code_winner, char_line_winner};
        end
        else if (delayed.hcount > LOOSER_X && delayed.vcount > LOOSER_Y && delayed.hcount < LOOSER_X+(LOOSER_SIZE_X*8) && delayed.vcount < LOOSER_Y+(LOOSER_SIZE_Y*16) && looser && no_ammo) begin
            rgb_nxt = looser_rgb;
            addr = {char_code_looser, char_line_looser};
        end
        else if (delayed.hcount > PLAYER2_X && delayed.vcount > PLAYER2_Y && delayed.hcount < PLAYER2_X+(PLAYER2_SIZE_X*8) && delayed.vcount < PLAYER2_Y+(PLAYER2_SIZE_Y*16)) begin
            rgb_nxt = player2_rgb;
            addr = {char_code_player2, char_line_player2};
        end
        else if (delayed.hcount > CONNECTED_X && delayed.vcount > CONNECTED_Y && delayed.hcount < CONNECTED_X+(CONNECTED_SIZE_X*8) && delayed.vcount < CONNECTED_Y+(CONNECTED_SIZE_Y*16) && player2_connected) begin
            rgb_nxt = connected_rgb;
            addr = {char_code_connected, char_line_connected};
        end
        else if (delayed.hcount > DISCONNECTED_X && delayed.vcount > DISCONNECTED_Y && delayed.hcount < DISCONNECTED_X+(DISCONNECTED_SIZE_X*8) && delayed.vcount < DISCONNECTED_Y+(DISCONNECTED_SIZE_Y*16) && ~player2_connected) begin
            rgb_nxt = disconnected_rgb;
            addr = {char_code_disconnected, char_line_disconnected};
        end
        else if (delayed.hcount > PLAYER1_SCORE_X && delayed.vcount > PLAYER1_SCORE_Y && delayed.hcount < PLAYER1_SCORE_X+(PLAYER1_SCORE_SIZE_X*8) && delayed.vcount < PLAYER1_SCORE_Y+(PLAYER1_SCORE_SIZE_Y*16)) begin
            rgb_nxt = player1_score_rgb;
            addr = {char_code_player1_score, char_line_player1_score};
        end
        else if (delayed.hcount > PLAYER1_SCORE_NUMBER_X && delayed.vcount > PLAYER1_SCORE_NUMBER_Y && delayed.hcount < PLAYER1_SCORE_NUMBER_X+(PLAYER1_SCORE_NUMBER_SIZE_X*8) && delayed.vcount < PLAYER1_SCORE_NUMBER_Y+16) begin
            rgb_nxt = player1_score_number_rgb;
            addr = {char_code_player1_score_number, char_line_player1_score_number};
        end
        else if (delayed.hcount > PLAYER2_SCORE_X && delayed.vcount > PLAYER2_SCORE_Y && delayed.hcount < PLAYER2_SCORE_X+(PLAYER2_SCORE_SIZE_X*8) && delayed.vcount < PLAYER2_SCORE_Y+(PLAYER2_SCORE_SIZE_Y*16)) begin
            rgb_nxt = player2_score_rgb;
            addr = {char_code_player2_score, char_line_player2_score};
        end
        else if (delayed.hcount > PLAYER2_SCORE_NUMBER_X && delayed.vcount > PLAYER2_SCORE_NUMBER_Y && delayed.hcount < PLAYER2_SCORE_NUMBER_X+(PLAYER2_SCORE_NUMBER_SIZE_X*8) && delayed.vcount < PLAYER2_SCORE_NUMBER_Y+16) begin
            rgb_nxt = player2_score_number_rgb;
            addr = {char_code_player2_score_number, char_line_player2_score_number};
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