/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Jan Cichoń
 * 
 * Description:
 * outputs signal if mouse aims at rectangle on screen
 */

 module mouse_hit_detector #(parameter TARGET_WIDTH = 10, TARGET_HEIGHT = 10)(
    input logic clk,
    input logic rst,

    input logic [9:0] target_x,
    input logic [9:0] target_y,

    input logic [9:0] mouse_x,
    input logic [9:0] mouse_y,

    output logic mouse_on_target

 );

 //internal signals
  logic mouse_on_target_nxt;

 //sequential block

always_ff @(posedge clk) begin
    if (rst) begin
        mouse_on_target <= 1'b0;
    end
    else begin
        mouse_on_target <= mouse_on_target_nxt;
    end
end

 //combinational block

always_comb begin
    if (mouse_x >= target_x && mouse_y >=target_y && mouse_x <= (target_x + TARGET_WIDTH) && mouse_y <= (target_y + TARGET_HEIGHT)) begin
        mouse_on_target_nxt = 1'b1;
    end
    else begin
        mouse_on_target_nxt = 1'b0;
    end
end
 endmodule