/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Arkadiusz Kurnik
 * 
 * Description:
 * ammo quantity calculation
 */

 `timescale 1 ns / 1 ps

 module ctl_ammo(
    input logic clk,
    input logic rst,
    input logic reset_score,
    input logic shot_fired,
    
    output logic no_ammo,
    output logic [3:0] hex0,
    output logic [3:0] hex1
 );

//local parameters
localparam AMMO_QUANTITY = 16;

// internal signals
logic shot_last, no_ammo_nxt;
logic [3:0] hex0_nxt, hex1_nxt;
logic [6:0] ammo_ctr;
logic [6:0] ammo_ctr_nxt;

// sequential logic
always_ff @(posedge clk) begin : edge_detection
    if (rst || reset_score) begin
        shot_last <= '0;
    end
    else begin
        shot_last <= shot_fired;
    end
end

always_ff @(posedge clk) begin : ammo_counter
    if (rst || reset_score) begin
        ammo_ctr <= AMMO_QUANTITY;
        no_ammo <= '0;
    end
    else begin
        ammo_ctr <= ammo_ctr_nxt;
        no_ammo <= no_ammo_nxt;
    end
end

always_ff @(posedge clk) begin : output_register
    if(rst || reset_score) begin
        hex0 <= '0;
        hex1 <= '0;
    end
    else begin
        hex0 <= hex0_nxt;
        hex1 <= hex1_nxt;
    end
end

//combinational logic

always_comb begin
    if(~shot_last && shot_fired && ~(ammo_ctr == '0)) begin : ammo_ctr_comb
        ammo_ctr_nxt = ammo_ctr - 1;
    end
    else begin
        ammo_ctr_nxt = ammo_ctr;
    end
end

always_comb begin : conversion_to_dec
    hex0_nxt = ammo_ctr % 10;
    hex1_nxt = ammo_ctr / 10;
end

always_comb begin : out_of_ammo_decetction
    if(ammo_ctr_nxt == 0) begin
        no_ammo_nxt = '1;
    end
    else begin
        no_ammo_nxt = '0;
    end    
end

endmodule