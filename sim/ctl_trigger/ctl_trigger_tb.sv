/**
 *  Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 *
 * Description:
 * Testbench for vga_timing module.
 */

`timescale 1 ns / 1 ps

module ctl_trigger_tb;



/**
 *  Local parameters
 */

localparam CLK_PERIOD = 15;     // 65 MHz


/**
 * Local variables and signals
 */

logic clk;
logic rst;

logic gun_is_connected;
logic gun_photodetector;
logic gun_trigger;
logic mouse_left;
logic mouse_on_target;
logic hit;
logic miss;
logic shot_fired;




/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    gun_photodetector = 1'b0;
    gun_trigger = 1'b0;
    mouse_left = 1'b0;
    mouse_on_target = 1'b0;
    forever #(CLK_PERIOD/2) clk = ~clk;
end


/**
 * Reset generation
 */

initial begin
                       rst = 1'b0;
    #(1.25*CLK_PERIOD) rst = 1'b1;
                       rst = 1'b1;
    #(2.00*CLK_PERIOD) rst = 1'b0;
end




/**
 * Dut placement
 */

gun_conn_detector u_gun_conn_detector(
    .clk,
    .rst,

    .gun_is_connected,

    .gun_photodetector,
    .gun_trigger

);

ctl_trigger u_dut(
    .clk,
    .rst,

    .gun_photodetector,
    .gun_trigger,

    .mouse_on_target,
    .mouse_left,

    .gun_is_connected,
    .hit,
    .miss,
    .shot_fired
);

/**
 * Main test
 */


initial begin
    $monitor("for: gunDet=%b, gunTrig=%b, mouseDet=%b, mouseTrig=%b outputs: gunIsConn=%b, hit=%b, miss=%b, shot=%b \n", gun_photodetector, gun_trigger, mouse_left, mouse_on_target, gun_is_connected, hit, miss, shot_fired);
end

initial begin
    @(posedge rst);
    @(negedge rst);


    #(2.00*CLK_PERIOD) $display("connecting gun");
    #(2.00*CLK_PERIOD) gun_trigger = 1'b1;

    #(2.00*CLK_PERIOD) $display("gun misses");
    #(2.00*CLK_PERIOD) gun_photodetector = 1'b0;
    #(2.00*CLK_PERIOD) gun_trigger = 1'b0;
    #(2.00*CLK_PERIOD) gun_trigger = 1'b1;

    #(2.00*CLK_PERIOD) $display("gun hits");
    #(2.00*CLK_PERIOD) gun_photodetector = 1'b1;
    #(2.00*CLK_PERIOD) gun_trigger = 1'b0;
    #(2.00*CLK_PERIOD) gun_trigger = 1'b1;

    #(2.00*CLK_PERIOD) $display("disconnecting gun");
    #(2.00*CLK_PERIOD) gun_photodetector = 1'b0;
    #(2.00*CLK_PERIOD) gun_trigger = 1'b0;

    #(2.00*CLK_PERIOD) $display("mouse misses");
    #(2.00*CLK_PERIOD) mouse_on_target = 1'b0;
    #(2.00*CLK_PERIOD) mouse_left = 1'b1;
    #(2.00*CLK_PERIOD) mouse_left = 1'b0;

    #(2.00*CLK_PERIOD) $display("mouse hits");
    #(2.00*CLK_PERIOD) mouse_on_target = 1'b1;
    #(2.00*CLK_PERIOD) mouse_left = 1'b1;
    #(2.00*CLK_PERIOD) mouse_left = 1'b0;

    $finish;

end

endmodule
