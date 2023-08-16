# Copyright (C) 2023  AGH University of Science and Technology
# MTM UEC2
# Author: Piotr Kaczmarczyk
#
# Description:
# Project detiles required for generate_bitstream.tcl
# Make sure that project_name, top_module and target are correct.
# Provide paths to all the files required for synthesis and implementation.
# Depending on the file type, it should be added in the corresponding section.
# If the project does not use files of some type, leave the corresponding section commented out.

#-----------------------------------------------------#
#                   Project details                   #
#-----------------------------------------------------#
# Project name                                  -- EDIT
set project_name DH_project

# Top module name                               -- EDIT
set top_module top_DH_basys3

# FPGA device
set target xc7a35tcpg236-1

#-----------------------------------------------------#
#                    Design sources                   #
#-----------------------------------------------------#
# Specify .xdc files location                   -- EDIT
set xdc_files {
    constraints/top_DH_basys3.xdc
    constraints/clk_wiz_0.xdc
    constraints/clk_wiz_0_late.xdc
}

# Specify SystemVerilog design files location   -- EDIT
set sv_files {
    rtl/top_DH_basys3.sv
    ../rtl/top_DH.sv
    ../rtl/vga/itf_vga.sv
    ../rtl/vga/vga_timing.sv
    ../rtl/vga/draw_bg.sv
    ../rtl/vga/vga_pkg.sv
    ../rtl/vga/template_rom.sv
    ../rtl/vga/draw_duck.sv
    ../rtl/vga/draw_crosshair.sv
    ../rtl/vga/draw_target.sv
    ../rtl/vga/draw_overlay.sv
    ../rtl/ctl_text/char_rect.sv
    ../rtl/ctl_text/draw_char_rect.sv
    ../rtl/rng/flip_flop.sv
    ../rtl/rng/random_number_generator.sv
    ../rtl/ctl/ctl_duck.sv
    ../rtl/ctl/ctl_score.sv
    ../rtl/ctl/ctl_ammo.sv
    ../rtl/ctl/ctl_reload.sv
    ../rtl/ctl/ctl_pause.sv
    ../rtl/input/ctl_trigger.sv
    ../rtl/input/gun_conn_detector.sv
    ../rtl/input/mouse_hit_detector.sv
    
 

}

# Specify Verilog design files location         -- EDIT
set verilog_files {
    ../rtl/clk/clk_wiz_0_clk_wiz.v
    ../rtl/clk/clk_wiz_0.v
    ../rtl/score_display/disp_hex_mux.v
    ../rtl/ctl_text/font_rom.v
    ../rtl/ctl_text/delay.v
    ../rtl/input/debounce.v
}

# Specify VHDL design files location            -- EDIT
set vhdl_files {
    ../rtl/input/MouseCtl.vhd
    ../rtl/input/Ps2Interface.vhd
}

# Specify files for a memory initialization     -- EDIT
set mem_files {
    ../rtl/vga/DH_bg_downscaled.dat
    ../rtl/vga/DH_duckA.dat
    ../rtl/vga/DH_duckB.dat
}
