/*
Control instructions <http://alumni.cs.ucr.edu/~vladimir/cs161/mips.html> 
*/
module control(
    opcode,
    dstReg,
    jmp,
    branch,
    MemRead,
    MemtoReg,
    ALUop,
    MemWrite,
    ALUSrc,
    RegWrite
);
// opcodes :
/* R-TYPE : opcode 000000*/
parameter ADD = 6'b000000;
parameter ADDU = 6'b000000;
parameter SUB = 6'b000000;
parameter SUBU = 6'b000000;
parameter AND = 6'b000000;
parameter OR = 6'b000000;
parameter SLL = 6'b000000;
parameter SRL = 6'b000000;
parameter SLT = 6'b000000;

parameter ADDI = 6'b001000;
parameter LW = 6'b100011;
parameter SW = 6'b101011;
parameter BEQ = 6'b000100;
parameter BNE = 6'b000101;
parameter J = 6'b000010;

    input wire [5:0] opcode;
    output reg [1:0] ALUop;
    output reg dstReg; // 0 rt, 1 rd 
    output reg jmp;
    output reg branch;
    output reg MemRead;
    output reg MemWrite;
    output reg MemtoReg;
    output reg ALUSrc;
    output reg RegWrite;
    
/* ALUOP: 2 bits: 
00 RTYPE
01 SW LW addi
10 BEQ
11 BNE
*/
    always @ (opcode)
    begin
        case(opcode)
            ADD:
            begin
                ALUSrc = 0;
                ALUop = 2'b00;
                jmp = 0;
                dstReg = 1; //rd 
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            ADDI:
            begin
                ALUSrc = 1;
                ALUop = 2'b01;
                jmp = 0;
                dstReg = 0; //rt 
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            ADDU:
            begin
                ALUSrc = 0;
                ALUop = 2'b00;
                jmp = 0;
                dstReg = 1; //rd 
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            SUB:
            begin
                ALUSrc = 0;
                ALUop = 2'b00;
                jmp = 0;
                dstReg = 1; //rd                 
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            SUBU:
            begin
                ALUSrc = 0;
                ALUop = 2'b00;
                jmp = 0;
                dstReg = 1; //rd                 
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            AND:
            begin
                ALUSrc = 0;
                ALUop = 2'b00;
                jmp = 0;
                branch = 0;
                dstReg = 1; //rd 
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            OR:
            begin
                ALUSrc = 0;
                ALUop = 2'b00;
                jmp = 0;
                dstReg = 1; //rd 
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            SLL:
            begin
                ALUSrc = 0;
                ALUop = 2'b00;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                dstReg = 1; //rd 
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            SRL:
            begin
                ALUSrc = 0;
                ALUop = 2'b00;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                dstReg = 1; //rd 
                MemWrite = 0;
                RegWrite = 1;
            end            
            LW:
            begin
                ALUSrc = 1;
                ALUop = 2'b01;
                jmp = 0;
                branch = 0;
                MemRead = 1;
                dstReg = 0; //rt 
                MemtoReg = 1;
                MemWrite = 0;
                RegWrite = 1;
            end            
            SW:
            begin
                ALUSrc = 1;
                ALUop = 2'b01;
                dstReg = 0; //don't care  
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 1;
                RegWrite = 0;
            end            
            BEQ:
            begin
                ALUSrc = 0;
                ALUop = 2'b10;
                jmp = 0;
                dstReg = 0; //don't care 
                branch = 1;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 0;
            end            
            BNE:
            begin
                ALUSrc = 0;
                ALUop = 2'b11;
                jmp = 0;
                branch = 1;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                dstReg = 0; //don't care  
                RegWrite = 0;
            end            
            J:
            begin
                ALUSrc = 0;
                ALUop = 2'b00;
                jmp = 1;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                dstReg = 0; //don't care  
                MemWrite = 0;
                RegWrite = 0;
            end            
            default:
                begin
                ALUSrc = 0;
                ALUop = 2'b00;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                dstReg = 0; //don't care  
                RegWrite = 0;
            end            
        endcase
    end
    /*
    assign R_TYPE = (opcode == 0) ? 1 : 0;
    assign lw = (opcode == LW) ? 1 : 0;
    assign sw = (opcode == SW) ? 1 : 0;
    assign beq = (opcode == BEQ) ? 1 : 0;
    assign bne = (opcode == BNE) ? 1 : 0;
    assign addi = (opcode == ADDI) ? 1 : 0;

    /*
    destination register 0 means TYPE I dst : (rt:0) , ALUSrc: 0 means data in (rt:0)
    destination register 0 means TYPE R dst : (rd:1)
    ALUSrc: 1 means immediate data (im:1)
    */
    /*
    assign dstReg = R_TYPE;
    assign ALUop[1] = R_TYPE;
    assign ALUop[0] = beq | bne;
    assign ALUSrc = lw | sw | addi;
    assign branch = beq | bne;
//    assign ifflush = beq | bne;
    assign MemRead = lw;
    assign MemWrite = sw;
    assign MemtoReg = lw;
    assign RegWrite = R_TYPE | lw | addi;

//    assign branchne = bne;

/*
parameter RT 0 // destination register 0 means TYPE I dst : rt, ALUSrc: 0 means data in rt
parameter RD 1 // destination register 0 means TYPE R dst : rd
parameter im 1 // ALUSrc: 1 means immediate data 

    always @(opcode)
        begin
            case(opcode):
            ADD:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = ADD_alu;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            ADDI:
            begin
                dstReg = RD;
                ALUSrc = im;
                ALUop = ADD_alu;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            ADDU:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = ADD_alu;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            SUB:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = SUB_alu;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            SUBU:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = SUB_alu;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            AND:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = AND_alu;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            OR:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = OR_alu;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            SLL:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = SLL_alu;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            SRL:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = SRL_alu;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end
            SLT:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = SLT_alu;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 1;
            end            
            LW:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = LW_alu;
                jmp = 0;
                branch = 0;
                MemRead = 1;
                MemtoReg = 1;
                MemWrite = 0;
                RegWrite = 1;
            end            
            SW:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = SW_alu;
                jmp = 0;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 1;
                RegWrite = 0;
            end            
            BEQ:            
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = BEQ_alu;
                jmp = 0;
                branch = 1;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 0;
            end            

            BNE:
            begin
                dstReg = RD;
                ALUSrc = RT;
                ALUop = BNE_alu;
                jmp = 0;
                branch = 1;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 0;
            end            
            J:
            begin
                dstReg = 0;
                ALUSrc = 0;
                ALUop = jmp_alu;
                jmp = 1;
                branch = 0;
                MemRead = 0;
                MemtoReg = 0;
                MemWrite = 0;
                RegWrite = 0;
            end            
            default:;
        end
    end
*/
endmodule
