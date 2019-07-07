module cpu( //cpu input/output pins
    dataBus,
    clk, 
    reset,
    memRWPin, // 1: write, 0: read
    memOpDone,
    addressBus
    );
    output reg [31:0] addressBus;
    inout [31:0] dataBus;
    input clk;
    input reset;
    /*control pins */
    output reg memRWPin;
    input memOpDone; // memory operation done 

    reg [2:0] stage;  // FSM signal to indicate the current stage
    /* CPU stages  fetch IF > decode ID > execute EX > access memory MEM> writeback WB */

    parameter IF = 3'd0;
    parameter ID = 3'd1;
    parameter EX = 3'd2;
    parameter MEM = 3'd3;
    parameter WB = 3'd4;


    /* PC_regs */
    reg [31:0] pc;
    wire [31:0] pc_next;
    reg [31:0] NextAdd;
    wire pcOverflow;  

    /* fetch stage*/
    reg [31:0] fetchPC;
    wire [31:0] fetchedInst;

    /* instruction fields */
    reg [31:0] instruction;
    wire [5:0] opcode;
    wire [4:0] rs;
    wire [4:0] rd;
    wire [4:0] rt;
    wire [15:0] addrim; //address offset / immediate 
    wire [31:0] immediate;
    wire [25:0] instidx; // jump address distination shifted to left two bits <add 00 at lsb in execute>
    wire [4:0] sa; // shift amount for shift instructions 
    wire [5:0] fn;
    wire [4:0] rgw;

    /*Control Unit */
    wire contDstReg;
    wire contJmp;
    wire contBranch;
    wire contMemRead;
    wire contMemtoReg;
    wire contALUSrc;
    wire contRegWrite;
    wire contMemWrite;
    wire [1:0] contAluop;

    /*register File */
    reg RegWrite;
    wire [31:0] rdata1;
    wire [31:0] rdata2;
    reg [31:0] rgwdata;

    /* ALU  */
    reg [1:0 ]aluOp;
    reg [31:0] data1;
    reg [31:0] data2;
    reg [31:0] imm;
    reg aluSrc;
    wire [3:0] aluCtrl;
    wire [31:0] result;
    wire zero;
    wire overflow;

    /**/
    reg MemopInProg;
    reg [31:0] MemData;

    assign dataBus = memRWPin ? MemData : 32'bz;

    assign opcode = instruction[31:26];
    assign rs = instruction[25:21];
    assign rt = instruction[20:16];
    assign rd = instruction[15:11];
    assign addrim = instruction[15:0];
    assign instidx = instruction[25:0];
    assign sa = instruction[10:6];
    assign fn = instruction[5:0];
    assign rgw = contDstReg ? rd : rt;
//    assign immediate = {{16{1'b0}}, addrim};
    assign immediate = addrim;
    /* get next program coutner item index */
    fullAddSub32 NexTinst(.num1(pc), .num2(NextAdd), .op(1'b0), .sumO(pc_next), .carryO(pcOverflow));
    fetch fetchIns (
        .pc(pc),
        .instruction(fetchedInst)
        ); // fetch the next instruction

    control controlUnit(
        .opcode(opcode),
        .dstReg(contDstReg),
        .jmp(contJmp),
        .branch(contBranch),
        .MemRead(contMemRead),
        .MemtoReg(contMemtoReg),
        .ALUop(contAluop),
        .MemWrite(contMemWrite),
        .ALUSrc(contALUSrc),
        .RegWrite(contRegWrite)
    );
    
    regsFile RegisterFile ( 
    .rgr1(rs),
    .rgr2(rt),
    .write(RegWrite), //output from control unit
    .rgw1(rgw),
    .rgw1data(rgwdata),
//    .clk(clk),
//    .reset(reset),
    .rg1data(rdata1),
    .rg2data(rdata2)
    );

    aluCtrl aluControl (
    .aluOp(aluOp),
    .fn(fn),
    .aluCtrl(aluCtrl)
    );

    alu alu(
    .aluSrc(aluSrc),
    .data1(data1), 
    .data2(data2),
    .imm(imm), 
    .aluCtrl(aluCtrl),
    .result(result),
    .zero(zero),
    .overflow(overflow)
    );

    
    always @(posedge clk or negedge reset)
    begin
        if(reset == 1'b0)
        begin
            pc <= 32'b0;
            stage <= IF;
            NextAdd <= 32'd4; // the added amount to the address
            memRWPin <= 1'bz;
            MemData <= 32'b0;
            data1 <= 0;
            data2 <= 0;
        end
        else
            case(stage)
                IF:
                    begin
                        RegWrite <= 1'b0;
                        instruction <= fetchedInst;
                        stage <= ID;
                        memRWPin <= 1'bz;
                        data1 <= 0;
                        data2 <= 0;
                    end
                ID:
                    begin
                        aluOp <= contAluop;
                        aluSrc <= contALUSrc;
                        data1 <= rdata1;
                        data2 <= rdata2;
                        imm <= immediate;
                        memRWPin <= 1'bz;
                        stage <= EX; 
                    end
                EX:
                    begin
                        memRWPin <= 1'bz;
                        if(contJmp == 1'b1) 
                        begin 
                            pc <= instidx << 2;
                            stage <= IF;
                        end
                        else if (contBranch == 1'b1)
                        begin 
                            if(zero == 1'b0) // zero means $r1 and $r2 condition is satisfied
                                NextAdd <= addrim << 2;
                                pc <= pc_next;
                                stage <= IF;
                        end
                        else if (contMemRead == 1'b1 | contMemWrite == 1'b1) stage <= MEM;
                        else if (contRegWrite == 1'b1) 
                        begin 
                            stage <= WB;
                            rgwdata <= result;
/*                          // already accounted for it using assign   
                            if (contDstReg == 1'b0)
                                rgw <= rt;//the register to write into
                            else rgw <= rd;
*/
                        end 
                        else
                            begin 
                                NextAdd <= 4'd4;
                                pc <= pc_next;
                                stage <= IF;
                            end
                    end
                MEM:
                    begin
                        data1 <= 0;
                        data2 <= 0;
                        if (MemopInProg == 1'b1)
                            begin
                            if (memOpDone == 1'b1)
                            begin
                                MemopInProg <= 1'b0;
                                if(contMemtoReg == 1'b1)
                                begin
                                    rgwdata <= dataBus;
                                    stage <= WB;
/*                          // already accounted for it using assign   
                                    if (contDstReg == 1'b1)
                                        rgw <= rd;//the register to write into
                                    else rgw <= rt;
*/
                                end
                                else
                                begin
                                    stage <= IF;
                                    NextAdd <= 4'd4;
                                    pc <= pc_next;
                                end
                            end 
                        end
                        else if(contMemWrite == 1'b1)
                            begin
                                addressBus <= rdata1;
                                MemData <= rdata2;
                                memRWPin <= 1'b1;
                                MemopInProg <= 1'b1;
                                stage <= MEM;
                            end
                        else if (contMemRead == 1'b1)
                            begin
                                addressBus <= rdata1;
                                memRWPin <= 1'b0;
                                MemopInProg <= 1'b1;
                                stage <= MEM;
                            end
                    end
                WB:
                    begin
                        data1 <= 0;
                        data2 <= 0;
                        memRWPin <= 1'bz;
                        RegWrite <= 1'b1;
                        stage <= IF;
                        pc <= pc_next;
                    end
                default:    
                begin 
                    stage <= IF; 
                    pc <= pc_next;
                    RegWrite <= 1'b0;
                end
            endcase
    end

endmodule 