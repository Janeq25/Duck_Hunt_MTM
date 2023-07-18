/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Arkadiusz Kurnik
 * 
 * Description:
 * random number generator module
 */

 `timescale 1 ns / 1 ps


module ctl_score_tb;


/**
 *  Local parameters
 */

 localparam CLK_PERIOD = 15;     // 65 MHz

/**
 * Local variables and signals
 */

logic clk, rst, reset_score, hit;
logic [3:0] digit_3, digit_2; 
/**
 * Signals generation
 */

initial begin
    clk = 1'b0;
    hit = 1'b0;
    
    forever #(CLK_PERIOD/2) begin
        clk = ~clk;
        hit = ~hit;
    end 
end

initial begin
    forever #(3*CLK_PERIOD/2) hit = ~hit;
end


/**
 * Submodules instances
 */

ctl_score dut (
    .clk,
    .rst,
    .reset_score,
    .hit,

    .hex2(digit_2),
    .hex3(digit_3)
);


/**
 * Main test
 */

initial begin
    rst = 1'b0;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;

    $timeformat(-9, 3, "ns", 10);

    $display("Simulation START");
    $monitor("%0t: hex3=%d hex2=%d", $realtime, digit_3, digit_2);

    #450
    
    $display("reset_score test");
    # 30 reset_score = 1'b1; //time offset 60ns
    # 30 reset_score = 1'b0;

    #1010
    $display("Simulation is over");
    $finish;
    
end

endmodule
