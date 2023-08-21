/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jan Cichon
 *
 * Description:
 * Rom for characters to be displayed on the screen
 */

module char_rect #(
    parameter SIZE_X=4,
    parameter SIZE_Y=4,
    parameter DATA= ""
)
    (
    input logic clk,
    input logic rst,

    //input logic [7:0] char_xy,
    input logic [$clog2(SIZE_X)-1:0] char_x,
    input logic [$clog2(SIZE_Y)-1:0] char_y,
    output logic [6:0] char_code
);


logic [(SIZE_X*SIZE_Y)-1:0][7:0] text_rect = {<<8{DATA}}; 

//internal signals
logic [7:0] char_code_nxt;

always_ff @(posedge clk) begin
    if (rst) begin
        char_code <= '0;
    end
    else begin
        char_code <= char_code_nxt[6:0];
    end
end



always_comb begin
    //char_code_nxt = {text_rect[{char_xy[7:4],char_xy[3:0]}], text_rect[{char_xy[7:4],char_xy[3:0]+1}], text_rect[{char_xy[7:4],char_xy[3:0]+2}], text_rect[{char_xy[7:4],char_xy[3:0]+3}], text_rect[{char_xy[7:4],char_xy[3:0]+4}], text_rect[{char_xy[7:4],char_xy[3:0]+5}], text_rect[{char_xy[7:4],char_xy[3:0]+6}], text_rect[{char_xy[7:4],char_xy[3:0]+7}]};
    char_code_nxt = text_rect[(char_y*SIZE_X) + char_x][7:0];
end

endmodule