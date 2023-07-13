/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jan Cichoń, Arkadiusz Kurnik
 * 
 * Description:
 *calculates dusk position x, y
 */


 module ctl_duck (
    input logic clk,
    input logic rst,
    input logic new_frame,

    output logic [10:0] duck_x,
    output logic [10:0] duck_y,

    output logic duck_show,
    output logic duck_hit
 );

 //parameters
 localparam VER_SPD = 3;
 localparam HOR_SPD = 7;

 //internal signals
 logic [5:0] frame_ctr;
 logic [5:0] frame_ctr_nxt;

 logic [9:0] duck_x_nxt;
 logic [9:0] duck_y_nxt;

 always_ff @(posedge clk) begin
    if(rst) begin
        duck_x <= '0;
        duck_y <= '0;
        frame_ctr <= '0;
    end
    else begin
        duck_x <= duck_x_nxt;
        duck_y <= duck_y_nxt;
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
    if (frame_ctr > 60) begin //duck hidden
        duck_show = 1'b0;
        duck_hit = 1'b0;
    end
    else if (frame_ctr > 25) begin //duck not flapping wings
        duck_show = 1'b1;
        duck_hit = 1'b1;
    end
    else begin
        duck_show = 1'b1; //duck flying
        duck_hit = 1'b0;
    end
 end

 always_comb begin
    if(new_frame) begin
        duck_x_nxt = duck_x + HOR_SPD;
        duck_y_nxt = duck_y + VER_SPD;
    end
    else begin
        duck_x_nxt = duck_x;
        duck_y_nxt = duck_y;
    end
 end


 endmodule