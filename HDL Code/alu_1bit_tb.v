`timescale 1ns/1ps
module alu_1bit_tb;

  reg Ai;
  reg Bi;
  reg Ai_minus_1;
  reg Ai_plus_1;
  reg Cin;
  reg S0;
  reg S1;
  reg S2;
  reg S3;
  wire Fi;
  wire Cout;
  
  alu_1bit dut (
    .Ai(Ai),
    .Bi(Bi),
    .Ai_minus_1(Ai_minus_1),
    .Ai_plus_1(Ai_plus_1),
    .Cin(Cin),
    .S0(S0),
    .S1(S1),
    .S2(S2),
    .S3(S3),
    .Fi(Fi),
    .Cout(Cout)
  );
  
  task set_operation;
    input [3:0] opcode;
    begin
      {S3, S2, S1, S0} = opcode;
      #5;
    end
  endtask
  
  initial begin
    $display("|---------------------------------------------------------------------------------------------------------|");
    $display("| Operation               | S3 S2 S1 S0 | Cin | Ai  | Bi  | Ai-1 | Ai+1 | Fi  | Cout | Result            |");
    $display("|---------------------------------------------------------------------------------------------------------|");
    
    Ai = 0;
    Bi = 0;
    Ai_minus_1 = 0;
    Ai_plus_1 = 0;
    Cin = 0;
    S0 = 0;
    S1 = 0;
    S2 = 0;
    S3 = 0;
    #10;
    
    // Test 1: Transfer A
    set_operation(4'b0000);
    Cin = 0;
    Ai = 1; Bi = 0; #10;
    $display("| Transfer A              | 0  0  0  0  | 0   | 1   | 0   | 0    | 0    | %b   | %b    | Fi = Ai           |", Fi, Cout);
    
    // Test 2: Increment A
    set_operation(4'b0000);
    Cin = 1;
    Ai = 1; Bi = 0; #10;
    $display("| Increment A             | 0  0  0  0  | 1   | 1   | 0   | 0    | 0    | %b   | %b    | Fi = 0, Cout = 1  |", Fi, Cout);
    
    // Test 3: Add
    set_operation(4'b0001);
    Cin = 0;
    Ai = 1; Bi = 1; #10;
    $display("| Add A+B                 | 0  0  0  1  | 0   | 1   | 1   | 0    | 0    | %b   | %b    | Fi = 0, Cout = 1  |", Fi, Cout);
    
    // Test 4: Subtraction
    set_operation(4'b0010);
    Cin = 1;
    Ai = 1; Bi = 1; #10;
    $display("| Subtraction A-B         | 0  0  1  0  | 1   | 1   | 1   | 0    | 0    | %b   | %b    | Fi = 0, Cout = 1  |", Fi, Cout);
    
    // Test 5: AND operation
    set_operation(4'b0100);
    Cin = 0;
    Ai = 1; Bi = 1; #10;
    $display("| AND operation           | 0  1  0  0  | 0   | 1   | 1   | 0    | 0    | %b   | %b    | Fi = A & B = 1    |", Fi, Cout);
    
    // Test 6: OR operation
    set_operation(4'b0101);
    Cin = 0;
    Ai = 1; Bi = 0; #10;
    $display("| OR operation            | 0  1  0  1  | 0   | 1   | 0   | 0    | 0    | %b   | %b    | Fi = A | B = 1    |", Fi, Cout);
    
    // Test 7: XOR operation
    set_operation(4'b0110);
    Cin = 0;
    Ai = 1; Bi = 0; #10;
    $display("| XOR operation           | 0  1  1  0  | 0   | 1   | 0   | 0    | 0    | %b   | %b    | Fi = A ^ B = 1    |", Fi, Cout);
    
    // Test 8: NOT operation
    set_operation(4'b0111);
    Cin = 0;
    Ai = 1; Bi = 0; #10;
    $display("| NOT operation           | 0  1  1  1  | 0   | 1   | 0   | 0    | 0    | %b   | %b    | Fi = ~A = 0       |", Fi, Cout);
    
    // Test 9: Shift Right
    set_operation(4'b1000);
    Cin = 0;
    Ai = 0; Ai_minus_1 = 1; #10;
    $display("| Shift Right             | 1  0  0  0  | 0   | 0   | 0   | 1    | 0    | %b   | %b    | Fi = Ai-1 = 1     |", Fi, Cout);
    
    // Test 10: Shift Left
    set_operation(4'b1100);
    Cin = 0;
    Ai = 0; Ai_plus_1 = 1; #10;
    $display("| Shift Left              | 1  1  0  0  | 0   | 0   | 0   | 0    | 1    | %b   | %b    | Fi = Ai+1 = 1     |", Fi, Cout);
    
    $display("|---------------------------------------------------------------------------------------------------------|");
    $finish;
  end
  
endmodule