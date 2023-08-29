/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jan Cichon
 *
 * Description:
 * Calculates adress of char that needs to be displayed and pulls it from char_rect
 */


module draw_char_rect #(
    parameter RECT_X = 123,
    parameter RECT_Y = 123,
    parameter SIZE_X = 4,
    parameter SIZE_Y = 4,
    parameter FONT_COLOR = 12'hf_0_0,
    parameter DATA = ""
    )
    (
    input logic rst,
    input logic clk,

    input logic [10:0] hcount,
    input logic [10:0] vcount,

    input logic [10:0] delayed_hcount,
    input logic [10:0] delayed_vcount,

    input logic [11:0] rgb_in,
    output logic [11:0] rgb_out,


    input logic [7:0] char_pixels,
    output logic [3:0] char_line,
    output logic [6:0] char_code

);


//internal signls

logic [$clog2(SIZE_X+1)-1:0] char_x;
logic [$clog2(SIZE_Y+1)-1:0] char_y;
logic [$clog2(SIZE_X+1)-1:0] char_x_nxt;
logic [$clog2(SIZE_Y+1)-1:0] char_y_nxt;
logic [3:0] char_line_nxt;
logic [11:0] rgb_nxt;
logic [2:0] char_pixel;




//internal module for text storage

char_rect #(
    .SIZE_X(SIZE_X),
    .SIZE_Y(SIZE_Y),
    .DATA(DATA)
) u_char_rect(
    .clk,
    .rst,
    .char_code,
    .char_x,
    .char_y
);



always_ff @(posedge clk)  begin : output_register
    if (rst) begin
        char_line <= '0;
        rgb_out <= '0;
        char_x <= '0;
        char_y <= '0;
    end
    else begin
        char_line <= char_line_nxt;
        rgb_out <= rgb_nxt;
        char_x <= char_x_nxt;
        char_y <= char_y_nxt;
    end
end

assign char_x_nxt = (hcount - RECT_X)>>3;
assign char_y_nxt = (vcount - RECT_Y)>>4;

assign char_line_nxt = 4'(delayed_vcount - RECT_Y);
assign char_pixel = 3'(delayed_hcount - RECT_X);

always_comb begin : calculate_pixel_value
    if (char_pixels[3'b111 - char_pixel] && delayed_hcount >= RECT_X && delayed_hcount < RECT_X + (SIZE_X*8) && delayed_vcount >= RECT_Y && delayed_vcount < RECT_Y + (SIZE_Y*16)) begin
        rgb_nxt = FONT_COLOR;
    end
    else begin
        rgb_nxt = rgb_in;
    end
end

endmodule