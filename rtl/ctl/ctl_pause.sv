/**
* Copyright (C) 2023  AGH University of Science and Technology
* MTM UEC2
* Author: Jan Cichoń
*
* Description:
*
*/

module ctl_pause(
    input logic clk,
    input logic rst,

    input logic player2_pause,
    output logic player1_pause,

    input logic sw_pause_raw,
    input logic no_ammo,

    output logic pause
);

//internal signals


//sequential block

always_ff @(posedge clk) begin
    if (rst) begin
        
    end
    else begin
        
    end
end

//combinational block

always_comb begin
    if () begin
        
    end
    else begin
        
    end
end

endmodule