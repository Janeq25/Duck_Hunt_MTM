/*
 * Title: UEC2 2022/2023 Project "Duck Hunt"
 * Authors: Jan Cichon, Arkadiusz Kurnik 
 * 
 * Module Description: Top structural module
 */

 `timescale 1 ns / 1 ps

 module top_DH(
    input logic clk, //main clock 65MHz
    input logic rst,

    input logic reload_btn_raw,

    output logic vs,
    output logic hs,
    output logic [3:0] r,
    output logic [3:0] g,
    output logic [3:0] b,
    output logic [3:0] an,
    output logic [6:0] seg,
    output logic dp,

    output logic [14:0] led,
    input logic sw_pause_raw,

    inout logic ps2_clk,
    inout logic ps2_data,

    input logic gun_trigger_raw,
    input logic gun_photodetector_raw,

    output logic player1_reload,
    output logic player1_pause,
    output logic [3:0] player1_score,
    input logic player2_reload_raw,
    input logic player2_pause_raw,
    input logic [3:0] player2_score_raw


 );

 //packages
 import DH_pkg::*;

 // interfaces
   itf_vga_no_rgb timing_to_draw_bg();
   itf_vga draw_bg_to_draw_duck();
   itf_vga draw_duck_to_draw_crosshair();
   itf_vga draw_crosshair_to_draw_target();
   itf_vga draw_target_to_draw_overlay();
   itf_vga draw_overlay_to_out();


   
 // local signals
   logic new_frame;

 // ctl_duck signals
   logic duck_direction;
   logic direction;
   logic [4:0] vertical_speed;
   logic [9:0] duck_start_x_coordinate;
   logic [9:0] duck_x;
   logic [9:0] duck_y;
   logic duck_hit;
   logic duck_show;

 //mouse signals
   logic [11:0] xpos;
   logic [11:0] ypos;
   logic mouse_left_raw;
   logic mouse_left;
   logic mouse_on_target;

  //gun signals
   logic gun_trigger;
   logic gun_photodetector;

   logic gun_is_connected;
   logic hit;
   logic miss;
   logic shot_fired;

  // 7 seg display signals
   logic [3:0] digit_3, digit_2, digit_1, digit_0;
   logic no_ammo;

  // control signals
   logic pause;
   logic reload;
   logic player2_connected;
  
  // multiplayer signals
   logic [3:0] score_ctr;
   logic [3:0] ammo_ctr;
   logic player2_pause;
   logic player2_reload;
   logic [3:0] player2_score;


 // signal assignments
 assign vs = draw_overlay_to_out.vsync;
 assign hs = draw_overlay_to_out.hsync;
 assign {r,g,b} = draw_overlay_to_out.rgb;


 assign led = {ammo_ctr>14,ammo_ctr>13,ammo_ctr>12,ammo_ctr>11,ammo_ctr>10,ammo_ctr>9,ammo_ctr>8,ammo_ctr>7,ammo_ctr>6,ammo_ctr>5,ammo_ctr>4,ammo_ctr>3,ammo_ctr>2,ammo_ctr>1,ammo_ctr>0};
 assign player1_score = score_ctr;
 
 // modules

 // --- input section ---

 // --- multiplayer debounce ---

 debounce u_reload (
  .clk,
  .reset(rst),
  .sw(reload_btn_raw),
  .db_level(reload_btn),
  .db_tick()
 );

 debounce u_player2_pause (
  .clk,
  .reset(rst),
  .sw(player2_pause_raw),
  .db_level(player2_pause),
  .db_tick()
 );

 debounce u_player2_reload (
  .clk,
  .reset(rst),
  .sw(player2_reload_raw),
  .db_level(player2_reload),
  .db_tick()
 );

 debounce u_player2_score0 (
  .clk,
  .reset(rst),
  .sw(player2_score_raw[0]),
  .db_level(player2_score[0]),
  .db_tick()
 );
 
 debounce u_player2_score1 (
  .clk,
  .reset(rst),
  .sw(player2_score_raw[1]),
  .db_level(player2_score[1]),
  .db_tick()
 );

 debounce u_player2_score2 (
  .clk,
  .reset(rst),
  .sw(player2_score_raw[2]),
  .db_level(player2_score[2]),
  .db_tick()
 );

 debounce u_player2_score3 (
  .clk,
  .reset(rst),
  .sw(player2_score_raw[3]),
  .db_level(player2_score[3]),
  .db_tick()
 );

 MouseCtl u_MouseCtl (
    .clk(clk),
    .rst(rst),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),

    .xpos(xpos),
    .ypos(ypos),
    .left(mouse_left_raw),
    
    .zpos(),
    .middle(),
    .right(),
    .new_event(),
    .value(),
    .setx('0),
    .sety('0),
    .setmax_x('0),
    .setmax_y('0)
    );

  debounce u_mouse_debounce(
    .clk,
    .reset(rst),
    .sw(mouse_left_raw),
    .db_level(),
    .db_tick(mouse_left)
  );

  mouse_hit_detector #(.TARGET_HEIGHT(DUCK_HEIGHT), .TARGET_WIDTH(DUCK_WIDTH)) u_mouse_hit_detector(
    .clk,
    .rst,

    .mouse_on_target,

    .mouse_x(xpos[9:0]),
    .mouse_y(ypos[9:0]),

    .target_x(duck_x),
    .target_y(duck_y)
  );

  gun_conn_detector u_gun_conn_detector(
    .clk,
    .rst,

    .gun_is_connected,
    
    .gun_photodetector,
    .gun_trigger
  );

  debounce u_gun_trigger_debounce(
    .clk,
    .reset(rst),
    .sw(gun_trigger_raw),
    .db_level(gun_trigger),
    .db_tick()
  );

  debounce u_gun_photodetector_debounce(
    .clk,
    .reset(rst),
    .sw(gun_photodetector_raw),
    .db_level(gun_photodetector),
    .db_tick()
  );

  ctl_trigger u_ctl_trigger(
    .clk,
    .rst,
    .new_frame,
    .lock(pause),

    .gun_is_connected,
    .gun_photodetector,
    .gun_trigger,

    .mouse_left(mouse_left),
    .mouse_on_target,

    .hit,
    .miss,
    .shot_fired
  );


 // ---vga section---

 vga_timing u_vga_timing(
   .clk,
   .rst,

   .new_frame,
   .out(timing_to_draw_bg.out)
 );

 draw_bg u_draw_bg(
   .clk,
   .rst,

   .in(timing_to_draw_bg.in),
   .out(draw_bg_to_draw_duck.out)
 );

 

 draw_duck u_draw_duck(
  .clk,
  .rst,
  .new_frame,

  .duck_hit,
  .duck_show,
  .duck_x,
  .duck_y,
  .duck_direction(direction),

  .in(draw_bg_to_draw_duck.in),
  .out(draw_duck_to_draw_crosshair.out)

 );

 draw_crosshair u_draw_crosshair(
  .rst,
  .clk,
  .xpos,
  .ypos,
  .gun_is_connected,
  
  .in(draw_duck_to_draw_crosshair.in),
  .out(draw_crosshair_to_draw_target.out)
 );

 draw_target u_draw_target(
  .rst,
  .clk,
  .duck_x,
  .duck_y,
  .new_frame,
  .shot_fired,
  .duck_hit,
  .gun_is_connected,

  .in(draw_crosshair_to_draw_target.in),
  .out(draw_target_to_draw_overlay.out)
);

draw_overlay u_draw_overlay (
  .clk,
  .rst,

  .pause,
  .player2_connected,
  .no_ammo,
  .score_p1(player1_score),
  .score_p2(player2_score),

  .in(draw_target_to_draw_overlay.in),
  .out(draw_overlay_to_out.out)
);


  // ---ctrl section-----

 random_number_generator u_random_number_generator(
   .clk,
   .rst,

   .direction(duck_direction),
   .duck_start_pos(duck_start_x_coordinate),
   .duck_vertical_speed(vertical_speed)
 );

 ctl_duck u_ctl_duck(
  .clk,
  .rst,
  .new_frame,
  .game_start(reload),
  .hit,
  .duck_direction(duck_direction),
  .duck_v_spd(vertical_speed),
  .duck_h_spd(H_SPEED),
  .duck_start_x(duck_start_x_coordinate),

  .duck_show,
  .duck_hit,
  .direction,
  .duck_x,
  .duck_y
 );

 ctl_score u_ctl_score(
    .clk,
    .rst,
    .reset_score(reload),
    .hit,

    .hex2(digit_2),
    .hex3(digit_3),
    .score_ctr
);

ctl_ammo u_ctl_ammo(
  .clk,
  .rst,
  .reset_score(reload),
  .shot_fired,
  
  .no_ammo,
  .hex0(digit_0),
  .hex1(digit_1),
  .ammo_ctr
);

 ctl_pause u_ctl_pause(
  .clk,
  .rst,

  .player2_pause,
  .player1_pause,

  .sw_pause_raw,
  .no_ammo,
  .pause
 );

 ctl_reload u_ctl_reload(
  .clk,
  .rst,

  .player1_reload,
  .player2_reload,

  .btn_reload_raw(reload_btn),
  .player2_connected,
  .reload

 );

 // -----------------

 disp_hex_mux u_disp_hex_mux (
    .clk,
    .reset(rst),
    .hex0(digit_0), //ammo x1
    .hex1(digit_1), //ammo x10
    .hex2(digit_2), //score x1
    .hex3(digit_3), //score x10
    .dp_in(4'b1011), //dot
    .an,
    .sseg({dp, seg})
);

 endmodule