/**
 * Copyright (C) 2023  AGH University of Science and Technology
 * MTM UEC2
 * Author: Piotr Kaczmarczyk
 * 
 * Conversion to 1024x768: Jan Cichon
 *
 *
 * Description:
 * Package with vga related constants.
 */

package vga_pkg;

// Parameters for VGA Display 1024 x 768 @ 60fps using a 65 MHz clock;
localparam HOR_PIXELS = 1024;
localparam VER_PIXELS = 768;

// Add VGA timing parameters here and refer to them in other modules.

localparam H_TOTAL = 1344;
localparam V_TOTAL = 806 + 1;

localparam H_B_START = 1023;
localparam H_S_START = H_B_START + 24;
localparam H_S_END = H_S_START + 136;
localparam H_B_END = H_B_START + 320;

localparam V_B_START = 767 + 1;
localparam V_S_START = V_B_START + 3;
localparam V_S_END = V_S_START + 6;
localparam V_B_END = V_B_START + 38;

// Parameters for game settings
localparam AMMO_QUANTITY = 15;

endpackage
