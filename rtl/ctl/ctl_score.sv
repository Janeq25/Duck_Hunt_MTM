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
    output logic [3:0] hex3,
    output logic [3:0] score_ctr
 );

// internal signals
logic hit_last;
logic [3:0] hex2_nxt;
logic [3:0] hex3_nxt;

logic [3:0] score_ctr_nxt;

// sequential logic
always_ff @(posedge clk) begin : edge_detection
    if (rst || reset_score) begin
        hit_last <= 1'b0;
    end
    else begin
        hit_last <= hit;
    end
end

always_ff @(posedge clk) begin : score_counter
    if (rst || reset_score) begin
        score_ctr <= '0;
    end
    else begin
        score_ctr <= score_ctr_nxt;
    end
end

always_ff @(posedge clk) begin : output_register
    if(rst || reset_score) begin
        hex2 <= '0;
        hex3 <= '0;
    end
    else begin
        hex2 <= hex2_nxt;
        hex3 <= hex3_nxt;
    end
end

//combinational logic

always_comb begin
    if (~hit_last && hit) begin : score_ctr_comb
        score_ctr_nxt = score_ctr + 1;
    end
    else begin
        score_ctr_nxt = score_ctr;
    end
end

always_comb begin : conversion_to_dec
    hex2_nxt = score_ctr % 10;
    hex3_nxt = score_ctr / 10;
end

endmodule