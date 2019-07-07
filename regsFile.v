// mips allows two registers reads and one write per clock cycle
/* 32 register each 32 bit width , 5bit to index */
/* registers names */
/*
Register Number	Conventional Name	Usage
$0	$zero	Hard-wired to 0
$1	$at	Reserved for pseudo-instructions
$2 - $3	$v0, $v1	Return values from functions
$4 - $7	$a0 - $a3	Arguments to functions - not preserved by subprograms
$8 - $15	$t0 - $t7	Temporary data, not preserved by subprograms
$16 - $23	$s0 - $s7	Saved registers, preserved by subprograms
$24 - $25	$t8 - $t9	More temporary registers, not preserved by subprograms
$26 - $27	$k0 - $k1	Reserved for kernel. Do not use.
$28	$gp	Global Area Pointer (base of global data segment)
$29	$sp	Stack Pointer
$30	$fp	Frame Pointer
$31	$ra	Return Address
*/
module regsFile( 
    rgr1,
    rgr2,
    write,
    rgw1,
    rgw1data,
//    clk,
//    reset,
    rg1data,
    rg2data
);

    input [4:0] rgr1;
    input [4:0] rgr2;
    input [4:0]     rgw1;
    input [31:0]  rgw1data;
//    input clk;
//    input reset;
    input write;
    output reg [31:0] rg1data;
    output reg [31:0] rg2data;
    
    reg [31:0] regMem [31:0]; // register memory
    

/*
    assign rg1data = regMem[rgr1];
    assign rg2data = regMem[rgr2];
*/

  always @(rgr1 or rgr2)
  begin
    rg1data = regMem[rgr1];
    rg2data = regMem[rgr2];
  end

  always @(posedge write)
  begin
    if(rgw1 == 5'b0) regMem[0] = 5'b0;
    else regMem[rgw1] = rgw1data;
  end

    ///write to register
    integer i;

    initial 
    begin
      //  $monitor("%d %d %d %d ", regMem[0],regMem[1],regMem[2],regMem[3]);
        //set all register values to reg number 
        for( i = 0; i < 32; i = i + 1 )
            regMem[i] = i;
    end

/*
  always @(posedge clk or negedge reset)
    begin
        regMem[0] = 32'b0; //register 0 is hardwired to zero;
        if(reset == 1'b0)
        begin 
            regMem[0] = 32'b0;
            // set all registers to their defaults 
            for( i = 0; i < 32; i = i + 1 )
                regMem[i] = i;
        end
        else if(write == 1'b1 && rgw1 != 5'd0) //$zero register is hardwired to zero
            regMem[rgw1] = rgw1data;
    end
*/
endmodule