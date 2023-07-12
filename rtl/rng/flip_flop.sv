/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Arkadiusz Kurnik
 * 
 * Description:
 * flip-flop module
 */

`timescale 1 ns / 1 ps

 module flip_flop(
    input logic clk,
    input logic rst,
    input logic D,

    output logic Q
 );

always_ff @(posedge clk) begin : flip_flop_blk
    if(rst) begin
        Q <= '0;
    end
    else begin
        Q <= D;
    end
end

 endmodule

