//////////////////////////////////////////////////////////////////////////////
/*
 Module name:   template_rom
 Author:        Robert Szczygiel
 Version:       1.1
 Last modified: 2022-07-12
 Coding style: Xilinx recommended + ANSI ports
 Description:  Template for ROM module as recommended by Xilinx
 Modification: added path to file as parameter
 Modification Author: Jan Cichon

 ** This example shows the use of the Vivado rom_style attribute
 **
 ** Acceptable values are:
 ** block : Instructs the tool to infer RAMB type components.
 ** distributed : Instructs the tool to infer LUT ROMs.
 **
 */
//////////////////////////////////////////////////////////////////////////////
module template_rom
	#(parameter
		ADDR_WIDTH = 8,
		DATA_WIDTH = 16,
		DATA_PATH = "template_rom.data"
	)
	(
		input wire clk, // posedge active clock
		input wire en,  // enable, can be removed if not needed
		input wire [ADDR_WIDTH - 1 : 0 ] addrA,
		output logic [DATA_WIDTH - 1 : 0 ] dout
	);

	(* rom_style = "block" *) // block || distributed

	logic [DATA_WIDTH-1:0] rom [2**ADDR_WIDTH-1:0]; // rom memory

	initial
		$readmemh(DATA_PATH, rom);

	always_ff @(posedge clk) begin : rom_read_blk
		if (en)
			dout <= rom[addrA];
	end

endmodule


