module fetch(
    pc,
    instruction,
    );
	input wire 	[31:0] 	pc;
	output wire [31:0] 	instruction;

	parameter NMEM = 15;   // Number of memory entries,
							// not the same as the memory size
    parameter IM_DATA = "IM.mips"; // file to read data from // instruction memory 

    reg [31:0] mem [0:127]; // 32-bit memory with 128 entries
    initial begin
		$readmemh(IM_DATA, mem, 0, NMEM-1); // reading hexa
//		$readmemb(IM_DATA, mem, 0, NMEM-1); // binary
	end

    assign instruction = mem[pc[8:2]][31:0];
endmodule

