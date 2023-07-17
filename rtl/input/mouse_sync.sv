/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author:Jan Cichoń
 *
 * Description:
 * Draw rectangle
 */

 `timescale 1 ns / 1 ps

 module mouse_sync (
    input logic clk,

    input logic [9:0] xpos_in,
    input logic [9:0] ypos_in,
    input logic mouse_left_in,

    output logic [9:0] xpos_out,
    output logic [9:0] ypos_out,
    output logic mouse_left_out

 );

always_ff @(posedge clk) begin
    xpos_out <= xpos_in;
    ypos_out <= ypos_in;
    mouse_left_out <= mouse_left_in;
end

 endmodule