module alu(
    aluSrc,
    data1, // data from register 1 
    data2, // data from register 2 
    imm, // immediate value
    aluCtrl,
    result,
    zero,
    overflow
);

    input wire aluSrc;
    input wire [31:0] data1;
    input wire [31:0] data2;
    input wire [31:0] imm;
    input wire [3:0] aluCtrl;

    output reg [31:0] result;
    output wire zero;
    output wire overflow;
    
    wire [31:0] d2;
    wire [31:0] sum;
    wire carry;


    assign zero = (result == 31'b0) ? 1 : 0;

    assign op = (aluCtrl == 2) ? 1 : (aluCtrl == 3) ? 1 : 0; // aluctrl : 2,3 subtract // operation for the adder  
    assign d2 = (aluSrc == 0) ? data2 : imm;
    assign overflow = (aluCtrl == 0) ? carry: (aluCtrl == 2) ? carry : 0; // overflow incase of signed subtract or add 

    fullAddSub32 addsub(.num1(data1), .num2(d2), .op(op), .sumO(sum), .carryO(carry));


/* aluctl: 
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
/*
Quoting from "MIPS32 Architecture For Programmers Volume II":
addu, subu
The term "unsigned" in the instruction name is a misnomer;
this operation is 32-bit modulo arithmetic that does not trap on overflow.
This instruction is appropriate for unsigned arithmetic, such as address arithmetic,
or integer arithmetic environments that ignore overflow, such as C language arithmetic.
*/
    always @ (aluCtrl or data1 or data2 or imm)
    begin 
        case (aluCtrl)
            4'b0000: result <= sum;
            4'b0001: result <= sum;
            4'b0010: result <= sum;
            4'b0011: result <= sum;
            4'b0100: result <= data1 & data2;
            4'b0101: result <= data1 | data2;
            4'b0110: result <= data1 << data2;
            4'b0111: result <= data1 >> data2;
            4'b1000: result <= (data1 < data2) ? 1 : 0;
            4'b1001:  // bne  
                begin
                    if(data1 == data2)
                    begin 
                        result <= 1; //  PC + 4 + imm<<2 = PCNEXT + imm 
                    end
                    else    result <= 0;
                end
            4'b1010:  // bne  
                begin
                    if(data1 != data2)
                    begin 
                        result <= 1; //  PC + 4 + imm<<2 = PCNEXT + imm 
                    end
                    else    result <= 0;
                end
            default: result <= 0;
        endcase
    end
endmodule
