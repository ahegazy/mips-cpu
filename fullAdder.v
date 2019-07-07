module halfAdder(
  num1,
  num2,
  sum,
  carry
  );
  input num1;
  input num2;
  output sum;
  output carry;
  
  assign sum = num1 ^ num2;
  assign carry = num1 & num2;

endmodule

module fullAdder(
  num1,
  num2,
  carryI,
  sum,
  carryO
  );
  input num1;
  input num2;
  input carryI;
  output sum;
  output carryO;
  
  assign sum = (num1 ^ num2) ^ carryI;
  assign carryO = (num1 & carryI) | (num1 & num2) | (num2 & carryI);
//  assign carryO = ((num1 ^ num2) & carryI) | (num1 & num2);

endmodule