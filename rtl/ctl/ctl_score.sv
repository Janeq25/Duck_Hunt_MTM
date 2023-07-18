/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Arkadiusz Kurnik
 * 
 * Description:
 * calculates score for 7seg display
 */

 `timescale 1 ns / 1 ps

 module ctl_score(
    input logic clk,
    input logic rst,
    input logic reset_score,
    input logic hit,

    output logic [3:0] hex2,
    output logic [3:0] hex3
 );

logic [3:0] hex2_nxt, hex3_nxt, hex2_predicted, hex3_predicted;

always_ff @(posedge clk) begin
    if(rst) begin
        hex2 <= 4'b0;
        hex3 <= 4'b0;
    end
    else begin
        hex2 <= hex2_nxt;
        hex3 <= hex3_nxt;
    end
end

always_comb begin
    if(reset_score == 1) begin
        hex2_nxt = 4'b0;
        hex3_nxt = 4'b0;
    end
    else if(hit == 1) begin
        hex2_predicted = hex2 + 1;
        hex3_predicted = hex3 + 1;

        if(hex2_predicted > 9 && hex3_predicted > 9) begin
            hex2_nxt = 0;
            hex3_nxt = 0;
        end
        else if(hex2_predicted > 9) begin
            hex2_nxt = 0;
            hex3_nxt = hex3 + 1;
        end
        else begin
            hex2_nxt = hex2 + 1;
            hex3_nxt = hex3;
        end
    end
    else begin
        hex2_nxt = hex2;
        hex2_nxt = hex3;
    end
end


 endmodule