`timescale 1ns/1ps

module arithmetic_unit_tb;

  reg Ai;
  reg Bi;
  reg Cin;
  reg S0;
  reg S1;
  wire Di;
  wire Cout;
  
  arithmetic_unit dut (
    .Ai(Ai),
    .Bi(Bi),
    .Cin(Cin),
    .S0(S0),
    .S1(S1),
    .Di(Di),
    .Cout(Cout)
  );
  
  initial begin
    $display("|-----------------------------------------------------------------------|");
    $display("| Operation               | S1 S0 | Cin | Ai  | Bi  | Di  | Cout | Note |");
    $display("|-----------------------------------------------------------------------|");
    Ai = 0;
    Bi = 0;
    Cin = 0;
    S0 = 0;
    S1 = 0;
    #10;
    
    // Test 1: Transfer A
    S1 = 0; S0 = 0; Cin = 0;
    Ai = 1; Bi = 0; #10;
    $display("| Transfer A              | 0  0  | 0   | 1   | 0   | %b   | %b    | A    |", Di, Cout);
    
    // Test 2: Increment A
    S1 = 0; S0 = 0; Cin = 1;
    Ai = 1; Bi = 0; #10;
    $display("| Increment A             | 0  0  | 1   | 1   | 0   | %b   | %b    | A+1  |", Di, Cout);
    
    // Test 3: Addition
    S1 = 0; S0 = 1; Cin = 0;
    Ai = 1; Bi = 1; #10;
    $display("| Addition                | 0  1  | 0   | 1   | 1   | %b   | %b    | A+B  |", Di, Cout);
    
    // Test 4: Add with carry
    S1 = 0; S0 = 1; Cin = 1;
    Ai = 1; Bi = 1; #10;
    $display("| Addition with carry     | 0  1  | 1   | 1   | 1   | %b   | %b    | A+B+1|", Di, Cout);
    
    // Test 5: Subtract with borrow
    S1 = 1; S0 = 0; Cin = 0;
    Ai = 1; Bi = 0; #10;
    $display("| Subtract with borrow    | 1  0  | 0   | 1   | 0   | %b   | %b    | A+B' |", Di, Cout);
    
    // Test 6: Subtraction
    S1 = 1; S0 = 0; Cin = 1;
    Ai = 1; Bi = 1; #10;
    $display("| Subtraction             | 1  0  | 1   | 1   | 1   | %b   | %b    | A-B  |", Di, Cout);
    
    // Test 7: Decrement A
    S1 = 1; S0 = 1; Cin = 0;
    Ai = 1; Bi = 0; #10;
    $display("| Decrement A             | 1  1  | 0   | 1   | 0   | %b   | %b    | A-1  |", Di, Cout);
    
    // Test 8: Transfer A 
    S1 = 1; S0 = 1; Cin = 1;
    Ai = 1; Bi = 0; #10;
    $display("| Transfer A              | 1  1  | 1   | 1   | 0   | %b   | %b    | A    |", Di, Cout);
    
    $display("|-----------------------------------------------------------------------|");
    $finish;
  end
  
endmodule