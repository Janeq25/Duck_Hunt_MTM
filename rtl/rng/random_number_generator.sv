/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Arkadiusz Kurnik
 * 
 * Description:
 * random number generator module
 */

`timescale 1 ns / 1 ps

module random_number_generator(
    input logic clk,
    input logic rst,
    
    output logic direction,
    output logic [9:0] duck_start_pos, 
    output logic [4:0] duck_vertical_speed
 );

/**
 * Local variables and signals
 */
static logic feedback;

logic Q15, Q14, Q13, Q12, Q11, Q10, Q9, Q8, Q7, Q6, Q5, Q4, Q3, Q2, Q1, Q0;

logic direction_nxt;
logic [9:0] duck_start_pos_nxt; 
logic [4:0] duck_vertical_speed_nxt;

logic Q5_val, Q0_val;
logic [1:0] Q6_val, Q1_val;
logic [2:0] Q7_val, Q2_val;
logic [3:0] Q8_val, Q3_val;
logic [4:0] Q9_val, Q4_val;
logic [5:0] Q10_val;
logic [6:0] Q11_val;
logic [7:0] Q12_val;
logic [8:0] Q13_val;
logic [9:0] Q14_val;


/**
 * Internal logic
 */

flip_flop u_flip_flop_Q15(
    .clk,
    .rst,

    .D(feedback),
    .Q(Q15)
);

flip_flop u_flip_flop_Q14(
    .clk,
    .rst,

    .D(Q15),
    .Q(Q14)
);

flip_flop u_flip_flop_Q13(
    .clk,
    .rst,

    .D(Q14),
    .Q(Q13)
);

flip_flop u_flip_flop_Q12(
    .clk,
    .rst,

    .D(Q13),
    .Q(Q12)
);

flip_flop u_flip_flop_Q11(
    .clk,
    .rst,

    .D(Q12),
    .Q(Q11)
);

flip_flop u_flip_flop_Q10(
    .clk,
    .rst,

    .D(Q11),
    .Q(Q10)
);

flip_flop u_flip_flop_Q9(
    .clk,
    .rst,

    .D(Q10),
    .Q(Q9)
);

flip_flop u_flip_flop_Q8(
    .clk,
    .rst,

    .D(Q9),
    .Q(Q8)
);

flip_flop u_flip_flop_Q7(
    .clk,
    .rst,

    .D(Q8),
    .Q(Q7)
);

flip_flop u_flip_flop_Q6(
    .clk,
    .rst,

    .D(Q7),
    .Q(Q6)
);

flip_flop u_flip_flop_Q5(
    .clk,
    .rst,

    .D(Q6),
    .Q(Q5)
);

flip_flop u_flip_flop_Q4(
    .clk,
    .rst,

    .D(Q5),
    .Q(Q4)
);

flip_flop u_flip_flop_Q3(
    .clk,
    .rst,

    .D(Q4),
    .Q(Q3)
);

flip_flop u_flip_flop_Q2(
    .clk,
    .rst,

    .D(Q3),
    .Q(Q2)
);

flip_flop u_flip_flop_Q1(
    .clk,
    .rst,

    .D(Q2),
    .Q(Q1)
);

flip_flop u_flip_flop_Q0(
    .clk,
    .rst,

    .D(Q1),
    .Q(Q0)
);

always_ff @(posedge clk) begin : rewrite_outputs
    if(rst) begin
        direction <= '0;
        duck_start_pos <= '0;
        duck_vertical_speed <= '0;
    end
    else begin
        direction <= direction_nxt;
        duck_start_pos <= duck_start_pos_nxt;
        duck_vertical_speed <= duck_vertical_speed_nxt;
    end 
end

always_comb begin : XNOR_blk
    feedback = Q15 ~^ Q14 ~^ Q12 ~^ Q3;
end

always_comb begin : direction_variable_blk
    direction_nxt = Q15;
end

always_comb begin : duck_start_pos_varable_blk
    if(Q14 == 1) begin
        Q14_val = 512;
    end
    else begin
        Q14_val = 0;
    end
    if(Q13 == 1) begin
        Q13_val = 256;
    end
    else begin
        Q13_val = 0;
    end
    if(Q12 == 1) begin
        Q12_val = 128;
    end
    else begin
        Q12_val = 0;
    end
    if(Q11 == 1) begin
        Q11_val = 64;
    end
    else begin
        Q11_val = 0;
    end
    if(Q10 == 1) begin
        Q10_val = 32;
    end
    else begin
        Q10_val = 0;
    end
    if(Q9 == 1) begin
        Q9_val = 16;
    end
    else begin
        Q9_val = 0;
    end
    if(Q8 == 1) begin
        Q8_val = 8;
    end
    else begin
        Q8_val = 0;
    end
    if(Q7 == 1) begin
        Q7_val = 4;
    end
    else begin
        Q7_val = 0;
    end
    if(Q6 == 1) begin
        Q6_val = 2;
    end
    else begin
        Q6_val = 0;
    end
    if(Q5 == 1) begin
        Q5_val = 1;
    end
    else begin
        Q5_val = 0;
    end

    duck_start_pos_nxt = Q5_val + Q6_val + Q7_val +  Q8_val + Q9_val + Q10_val + Q11_val + Q12_val + Q13_val + Q14_val;
end

always_comb begin : duck_vertical_speed_varable_blk
    if(Q4 == 1) begin
        Q4_val = 16;
    end
    else begin
        Q4_val = 0;
    end
    if(Q3 == 1) begin
        Q3_val = 8;
    end
    else begin
        Q3_val = 0;
    end
    if(Q2 == 1) begin
        Q2_val = 4;
    end
    else begin
        Q2_val = 0;
    end
    if(Q1 == 1) begin
        Q1_val = 2;
    end
    else begin
        Q1_val = 0;
    end
    if(Q0 == 1) begin
        Q0_val = 1;
    end
    else begin
        Q0_val = 0;
    end

    duck_vertical_speed_nxt = Q4_val + Q3_val + Q2_val + Q1_val + Q0_val;
end

 endmodule
