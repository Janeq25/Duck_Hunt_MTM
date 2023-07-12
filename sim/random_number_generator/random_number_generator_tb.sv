/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Arkadiusz Kurnik
 * 
 * Description:
 * random number generator module
 */

 `timescale 1 ns / 1 ps


module random_number_generator_tb;


/**
 *  Local parameters
 */

localparam CLK_PERIOD = 10;     // 100 MHz

/**
 * Local variables and signals
 */

logic clk, rst, direction_nxt;
logic [9:0] duck_start_pos_nxt; 
logic [4:0] duck_vertical_speed_nxt;
/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


/**
 * Submodules instances
 */

random_number_generator dut (
    .clk,
    .rst,
    .direction(direction_nxt),
    .duck_start_pos(duck_start_pos_nxt),
    .duck_vertical_speed(duck_vertical_speed_nxt)
);


/**
 * Main test
 */

initial begin
    rst = 1'b0;
    # 30 rst = 1'b1;
    # 30 rst = 1'b0;

    $display("Simulation START");
    $monitor("%0t: direction=%d duck_start_pos=%d duck_vertical_speed=%d", $realtime, direction_nxt, duck_start_pos_nxt, duck_vertical_speed_nxt);

    $timeformat(-9, 3, "ns", 10);
    
    #100000
    $display("Simulation is over");
    $finish;
    
end

endmodule
