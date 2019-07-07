module aluCtrl (
    aluOp,
    fn,
    aluCtrl
    );
    input wire [1:0] aluOp;
    input wire [5:0] fn;
    output reg [3:0] aluCtrl;


parameter ADDFN = 6'b100000;
parameter ADDUFN = 6'b100001;
parameter SUBFN = 6'b100010;
parameter SUBUFN = 6'b100011;
parameter ANDFN = 6'b100100;
parameter ORFN = 6'b100101;
parameter SLLFN = 6'b000000;
parameter SRLFN = 6'b000010;
parameter SLTFN = 6'b101010;

reg [3:0] fno;
/* aluCtrl: 
    0: Add
    1: addu
    2: subtract
    3: subu
    4: and
    5: or
    6: sll
    7: srl
    8: slt
//    9: lw , sw
10  9: beq
11  10: bne

*/

    always @ (fn)
    begin
        case(fn)
            ADDFN: fno = 4'b0000;
            ADDUFN: fno = 4'b0001;
            SUBFN: fno = 4'b0010;
            SUBUFN: fno = 4'b0011;
            ANDFN: fno = 4'b0100;
            ORFN: fno = 4'b0101;
            SLLFN: fno = 4'b0110;
            SRLFN: fno = 4'b0111;
            SLTFN: fno = 4'b1000;
            default: fno = 4'b0000;
        endcase
    end

/* ALUOP: 2 bits: 
00 RTYPE
01 SW LW ADDI 
10 BEQ
11 BNE
*/
    always @ (aluOp)
    begin
        case(aluOp)
            2'b00: aluCtrl = fno;
            2'b01: aluCtrl = 4'b0000;// normal ADD op but immediate source 
            2'b10: aluCtrl = 4'b1001;//9
            2'b11: aluCtrl = 4'b1010;//10
            default: aluCtrl = 4'b0000;
        endcase
    end
endmodule