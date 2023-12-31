/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jan Cichon
 *
 * Description:
 * Calculates codes of characters given as input in "chars". Used for dynamicly changing numbers
 */


module draw_char_ram #(
    parameter RECT_X = 123,
    parameter RECT_Y = 123,
    parameter SIZE_X = 4,
    parameter FONT_COLOR = 12'hf_0_0
)
    (
    input logic rst,
    input logic clk,

    input logic [10:0] hcount,

    input logic [10:0] delayed_hcount,
    input logic [10:0] delayed_vcount,

    input logic [11:0] rgb_in,
    output logic [11:0] rgb_out,


    input logic [7:0] char_pixels,
    output logic [3:0] char_line,
    output logic [6:0] char_code,

    input logic [SIZE_X-1:0][6:0] chars

);


//internal signls

logic [3:0] char_line_nxt;
logic [11:0] rgb_nxt;
logic [2:0] char_pixel;
logic [6:0] char_code_nxt;




always_ff @(posedge clk)  begin : output_register
    if (rst) begin
        char_line <= '0;
        rgb_out <= '0;
        char_code <= '0;
    end
    else begin
        char_line <= char_line_nxt;
        rgb_out <= rgb_nxt;
        char_code <= char_code_nxt;
    end
end

assign char_code_nxt = chars[((hcount - RECT_X)>>3)][6:0];

assign char_line_nxt = 4'(delayed_vcount - RECT_Y);
assign char_pixel = 3'(delayed_hcount - RECT_X);

always_comb begin : calculate_pixel_value
    if (char_pixels[3'b111 - char_pixel] && delayed_hcount >= RECT_X && delayed_hcount < RECT_X + (SIZE_X*8) && delayed_vcount >= RECT_Y && delayed_vcount < RECT_Y + 16) begin
        rgb_nxt = FONT_COLOR;
    end
    else begin
        rgb_nxt = rgb_in;
    end
end

endmodule