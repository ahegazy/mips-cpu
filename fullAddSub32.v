module fullAddSub32(
  num1,
  num2,
  op,
  sumO,
  carryO
  );

  input [31:0] num1;
  input [31:0] num2;
  input op; /* 0 add, 1 subtract */ 
  output [31:0] sumO;
  output carryO;
  
  wire [31:0] sum;
  wire [31:0] carry;
  wire [31:0] num2C;

  assign num2C = (op == 1'b1) ? ~num2 : num2;
  genvar i;
  generate 
  for(i=0;i<32;i=i+1)
  begin
    if(i==0) 
      fullAdder addr(num1[i],num2C[i], op,sum[i],carry[i]);
    else
      fullAdder addr(num1[i],num2C[i],carry[i-1],sum[i],carry[i]);
    end
   endgenerate

  assign carryO = (op == 1'b1) ? ~carry[31] : carry[31];
  //assign sumO = (op == 1'b0) ? sum : (carryO == 1'b1) ? (~(sum)+1'b1) : sum;
  assign sumO = sum;
  
  endmodule
