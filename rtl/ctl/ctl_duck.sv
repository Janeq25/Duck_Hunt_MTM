/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jan Cichoń, Arkadiusz Kurnik
 * 
 * Description:
 * calculates duck position x, y
 */


 module ctl_duck (
    input logic clk,
    input logic rst,
    input logic new_frame,
    input logic game_start,
    input logic hit,
    input logic duck_direction,
    input logic [4:0] duck_v_spd,
    input logic [4:0] duck_h_spd,
    input logic [9:0] duck_start_x,


    output logic [9:0] duck_x,
    output logic [9:0] duck_y,

    output logic duck_show,
    output logic duck_hit
 );

//internal signals
logic hit_last;

logic [5:0] frame_ctr;
logic [5:0] frame_ctr_nxt;

logic [9:0] duck_x_nxt;
logic [9:0] duck_y_nxt;
logic [10:0] expected_duck_x_nxt;
logic [10:0] expected_duck_y_nxt;

logic [4:0] duck_vertical_speed;
logic [4:0] duck_vertical_speed_nxt;

enum logic [2:0]{
    IDLE = 3'b000,  //idle
    DRAW = 3'b001,
    DUCK_RIGHT_UP = 3'b011,
    DUCK_RIGHT_DOWN = 3'b010,
    DUCK_LEFT_UP = 3'b110,
    DUCK_LEFT_DOWN = 3'b111,
    DUCK_HIT = 3'b101
} state, state_nxt;

always_ff @(posedge clk) begin : edge_detection
    if (rst || game_start) begin
        hit_last <= 1'b0;
    end
    else begin
        hit_last <= hit;
    end
end

always_ff @(posedge clk) begin : state_seq_blk
    if(rst) begin : state_seq_rst_blk
        state <= IDLE;
    end
    else begin : state_seq_run_blk
        state <= state_nxt;
    end
end

always_ff @(posedge clk) begin : out_reg_blk
    if(rst) begin : out_reg_rst_blk
        duck_x <= '0;
        duck_y <= '0;
        frame_ctr <= '0;
        duck_vertical_speed <= '0;
    end
    else begin : our_reg_run_blk
        duck_x <= duck_x_nxt;
        duck_y <= duck_y_nxt;
        frame_ctr <= frame_ctr_nxt;
        duck_vertical_speed <= duck_vertical_speed_nxt;
    end
end

always_comb begin : state_comb_blk
    case(state)
        IDLE: begin
            if(game_start) begin
                state_nxt = DRAW;
            end
            else begin
                state_nxt = IDLE;
            end
        end
        DRAW: begin
            if(duck_direction == 1) begin
                state_nxt = DUCK_RIGHT_UP;
            end
            else begin
                state_nxt = DUCK_LEFT_UP;
            end
        end
        DUCK_RIGHT_UP: begin
            expected_duck_x_nxt = duck_x_nxt + duck_h_spd;
            expected_duck_y_nxt = duck_y_nxt - duck_vertical_speed_nxt;
            
            if(~hit_last && hit) begin
                state_nxt = DUCK_HIT;
            end
            else if(expected_duck_y_nxt > 768 && expected_duck_x_nxt > 1024) begin
                state_nxt = DUCK_LEFT_DOWN;
            end
            else if(expected_duck_y_nxt > 768) begin
                state_nxt = DUCK_RIGHT_DOWN;
            end
            else if(expected_duck_x_nxt > 1024) begin
                state_nxt = DUCK_LEFT_UP;
            end
            else begin
                state_nxt = DUCK_RIGHT_UP;
            end
        end
        DUCK_RIGHT_DOWN: begin
            expected_duck_x_nxt = duck_x_nxt + duck_h_spd;
            expected_duck_y_nxt = duck_y_nxt + duck_vertical_speed_nxt;

            if(~hit_last && hit) begin
                state_nxt = DUCK_HIT;
            end
            else if(expected_duck_y_nxt > 600 && expected_duck_x_nxt > 1024) begin
                state_nxt = DUCK_LEFT_UP;
            end
            else if(expected_duck_y_nxt > 600) begin
                state_nxt = DUCK_RIGHT_UP;
            end
            else if(expected_duck_x_nxt > 1024) begin
                state_nxt = DUCK_LEFT_DOWN;
            end
            else begin
                state_nxt = DUCK_RIGHT_DOWN;
            end
        end
        DUCK_LEFT_UP: begin
            expected_duck_x_nxt = duck_x_nxt - duck_h_spd;
            expected_duck_y_nxt = duck_y_nxt - duck_vertical_speed_nxt;

            if(~hit_last && hit) begin
                state_nxt = DUCK_HIT;
            end
            else if(expected_duck_y_nxt > 768 && expected_duck_x_nxt > 1024) begin
                state_nxt = DUCK_RIGHT_DOWN;
            end
            else if(expected_duck_y_nxt > 768) begin
                state_nxt = DUCK_LEFT_DOWN;
            end
            else if(expected_duck_x_nxt > 1024) begin
                state_nxt = DUCK_RIGHT_UP;
            end
            else begin
                state_nxt = DUCK_LEFT_UP;
            end
        end
        DUCK_LEFT_DOWN: begin
            expected_duck_x_nxt = duck_x_nxt - duck_h_spd;
            expected_duck_y_nxt = duck_y_nxt + duck_vertical_speed_nxt;

            if(~hit_last && hit) begin
                state_nxt = DUCK_HIT;
            end
            else if(expected_duck_y_nxt > 600 && expected_duck_x_nxt > 1024) begin
                state_nxt = DUCK_RIGHT_UP;
            end
            else if(expected_duck_y_nxt > 600) begin
                state_nxt = DUCK_LEFT_UP;                 
            end
            else if(expected_duck_x_nxt > 1024) begin
                state_nxt = DUCK_RIGHT_DOWN;
            end
            else begin
                state_nxt = DUCK_LEFT_DOWN;
            end 
        end
        DUCK_HIT: begin 
            if(duck_y_nxt > 600) begin
                state_nxt = DRAW;
            end
            else begin
                state_nxt = DUCK_HIT;
            end 
        end
    endcase
end

always_comb begin : out_comb_blk
    case(state)
        IDLE: begin 
            duck_x_nxt = '0; 
            duck_y_nxt = '0; 
            duck_vertical_speed_nxt = duck_vertical_speed;

            duck_show = 1'b0;
            duck_hit = 1'b0;
        end
        DRAW: begin
            duck_x_nxt = duck_start_x; 
            duck_y_nxt = 768; 

            if(duck_v_spd == 0) begin
                duck_vertical_speed_nxt = 15;
            end
            else begin
                duck_vertical_speed_nxt = duck_v_spd;
            end

            duck_show = 1'b0;
            duck_hit = 1'b0;
        end
        DUCK_RIGHT_UP: begin
            if(new_frame == 1) begin
                duck_x_nxt = duck_x + duck_h_spd;
                duck_y_nxt = duck_y - duck_vertical_speed;
            end
            else begin
                duck_x_nxt = duck_x; 
                duck_y_nxt = duck_y;
            end

            duck_vertical_speed_nxt = duck_vertical_speed;

            duck_show = 1'b1;
            duck_hit = 1'b0;
        end
        DUCK_RIGHT_DOWN: begin
            if(new_frame == 1) begin
                duck_x_nxt = duck_x + duck_h_spd;
                duck_y_nxt = duck_y + duck_vertical_speed;
            end
            else begin
                duck_x_nxt = duck_x; 
                duck_y_nxt = duck_y;
            end

            duck_vertical_speed_nxt = duck_vertical_speed;

            duck_show = 1'b1;
            duck_hit = 1'b0;
        end
        DUCK_LEFT_UP: begin
            if(new_frame == 1) begin
                duck_x_nxt = duck_x - duck_h_spd;
                duck_y_nxt = duck_y - duck_vertical_speed; 
            end
            else begin
                duck_x_nxt = duck_x; 
                duck_y_nxt = duck_y; 
            end

            duck_vertical_speed_nxt = duck_vertical_speed;

            duck_show = 1'b1;
            duck_hit = 1'b0;
        end
        DUCK_LEFT_DOWN: begin
            if(new_frame == 1) begin
                duck_x_nxt = duck_x - duck_h_spd;
                duck_y_nxt = duck_y + duck_vertical_speed;
            end
            else begin
                duck_x_nxt = duck_x; 
                duck_y_nxt = duck_y; 
            end

            duck_vertical_speed_nxt = duck_vertical_speed;

            duck_show = 1'b1;
            duck_hit = 1'b0;
        end
        DUCK_HIT: begin 
            if(new_frame == 1) begin
                duck_x_nxt = duck_x; 
                duck_y_nxt = duck_y + 8;
            end
            else begin 
                duck_x_nxt = duck_x; 
                duck_y_nxt = duck_y;
            end

            duck_show = 1'b1;
            duck_hit = 1'b1;

            duck_vertical_speed_nxt = duck_vertical_speed;
        end
    endcase
end

always_comb begin
    if(new_frame) begin
        frame_ctr_nxt = frame_ctr + 1;
    end
    else begin
        frame_ctr_nxt = frame_ctr;
    end
end

//always_comb begin
    //if (frame_ctr > 60) begin //duck hidden
    //    duck_show = 1'b0;
    //    duck_hit = 1'b0;
   // end
   // else if (frame_ctr > 25) begin //duck not flapping wings
     //   duck_show = 1'b1;
      //  duck_hit = 1'b1;
   // end
   // else begin
        //duck_show = 1'b1; //duck flying
        //duck_hit = 1'b0;
   // end
//end

endmodule