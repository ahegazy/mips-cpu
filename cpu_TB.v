`timescale 10ns/1ns
module cpu_TB;


reg clk,reset;
reg memOpDone;
wire [31:0] dataBus;

wire [31:0] addressBus;
wire memRWPin;

reg [31:0] MemData;


/* instance */
cpu MipsCpu( //cpu input/output pins
    .dataBus(dataBus),
    .clk(clk), 
    .reset(reset),
    .memRWPin(memRWPin), // 1: write, 0: read
    .memOpDone(memOpDone),
    .addressBus(addressBus)
    );


assign dataBus = memRWPin ? 32'bz : MemData;

/*Initializing inputs*/
initial 
begin 
 //initialize here 
	clk = 0;
	reset = 1;
end 


/*Monitor values*/
initial 
begin 
//  $display ("\t\ttime,\t\tPC,\tstage,\trt:d,\trs:d,\trd:d,\timm,\talusrc\tRegister File");
//  $monitor ("%d, %d, %d, %d:%d, %d:%d, %d:%d,%d %d %p", $time, MipsCpu.pc, MipsCpu.stage,MipsCpu.rt,MipsCpu.rdata1,MipsCpu.rs,MipsCpu.rdata2,MipsCpu.rd, MipsCpu.rgwdata,MipsCpu.imm ,MipsCpu.aluSrc,MipsCpu.RegisterFile.regMem);

  $display ("\t\ttime,\tPC,\tstage,\tRegister File");
  $monitor ("%d, %d, %d, %p", $time, MipsCpu.pc, MipsCpu.stage,MipsCpu.RegisterFile.regMem);
end

//Generate clock 
always 
#1 clk = ~clk;

event reset_done;
/*Generating input values */
task rst();
  begin
  @(negedge clk);
    reset = 0;
	#5
  @(negedge clk);
		begin 
		reset = 1;
		->reset_done;
		end
	
end 
endtask

initial 
begin 
	#1 rst();
end

always @(posedge clk)
begin 
    #1
    if(memRWPin == 1'b1)
    begin
        /* write from cpu to memory  */
        #1
        $display ("Memory Access TO address: %d , data: %d", addressBus, dataBus);
        MemData <= dataBus;
        #1
        memOpDone <= 1'b1;
        #3
        memOpDone <= 1'b0;
    end
    else if(memRWPin == 1'b0)
    begin
        /* write from memory to cpu  */
//        MemData <= 32'd302; 
        #1
        $display ("Memory Access FROM address:%d , data: %d", addressBus,dataBus);
        memOpDone <= 1'b1;
        #3
        memOpDone <= 1'b0;
    end
end

initial
begin 
  @(reset_done)
  begin

    #500; // wait for a while let the instructions in mipsIM.txt run 
	$stop;
  end
end 
endmodule