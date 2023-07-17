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

logic [3:0] dut_out;
logic [3:0] dut_in;

logic gun_is_connected;




/**
 * Clock generation
 */

initial begin
    clk = 1'b0;
    dut_in = '0;
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
    forever #(10*CLK_PERIOD/2) dut_in = dut_in + 1;
end




/**
 * Dut placement
 */

gun_conn_detector u_gun_conn_detector(
    .clk,
    .rst,

    .gun_is_connected,

    .gun_photodetector(dut_in[0]),
    .gun_trigger(dut_in[1])

);

ctl_trigger u_dut(
    .clk,
    .rst,

    .gun_photodetector(dut_in[0]),
    .gun_trigger(~dut_in[1]),

    .mouse_on_target(dut_in[2]),
    .mouse_left(dut_in[3]),

    .gun_is_connected,
    .hit(dut_out[1]),
    .miss(dut_out[2]),
    .shot_fired(dut_out[3])
);

assign dut_out[0] = gun_is_connected;

/**
 * Main test
 */


initial begin
    $monitor("for: gunDet=%b, gunTrig=%b, mouseDet=%b, mouseTrig=%b outputs: gunIsConn=%b, hit=%b, miss=%b, shot=%b \n", dut_in[0], dut_in[1], dut_in[2], dut_in[3], dut_out[0], dut_out[1], dut_out[2], dut_out[3]);
end

initial begin
    @(posedge rst);
    @(negedge rst);

    @(negedge dut_in[3]);
    $finish;

end

endmodule
