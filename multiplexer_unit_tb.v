`timescale 1ns/1ps

module multiplexer_unit_tb;

  reg [1:0] S;
  reg [1:0] S_low;
  reg Di;
  reg arithmetic_cout;
  reg Ei;
  reg Shift_R;
  reg Shift_L;
  reg Cin;
  wire Fi;
  wire Cout;
  
  multiplexer_unit mux (
    .S(S),
    .S_low(S_low),
    .Di(Di),
    .arithmetic_cout(arithmetic_cout),
    .Ei(Ei),
    .Shift_R(Shift_R),
    .Shift_L(Shift_L),
    .Cin(Cin),
    .Fi(Fi),
    .Cout(Cout)
  );
  
  initial begin
    $display("|--------------------------------------------------------------------------|");
    $display("| Operation     | S[1:0] | S_low | Cin | Inputs         | Fi  | Cout | Note|");
    $display("|--------------------------------------------------------------------------|");
        S = 2'b00;
    S_low = 2'b00;
    Di = 0;
    arithmetic_cout = 0;
    Ei = 0;
    Shift_R = 0;
    Shift_L = 0;
    Cin = 0;
    #10;
    
    // Test 1: Select Di
    S = 2'b00;
    S_low = 2'b00;
    Di = 1; Ei = 0; Shift_R = 0; Shift_L = 0; arithmetic_cout = 1; Cin = 0; #10;
    $display("| Arithmetic    | 00     | 00    | 0   | Di=1           | %b   | %b    |     |", Fi, Cout);
    
    // Test 2: Transfer A 
    S = 2'b00;
    S_low = 2'b11;
    Di = 1; Ei = 0; Shift_R = 0; Shift_L = 0; arithmetic_cout = 1; Cin = 1; #10;
    $display("| Transfer A    | 00     | 11    | 1   | Di=1           | %b   | %b    | Var2|", Fi, Cout);
    
    // Test 3: Select Ei
    S = 2'b01;
    S_low = 2'b00;
    Di = 0; Ei = 1; Shift_R = 0; Shift_L = 0; arithmetic_cout = 1; Cin = 0; #10;
    $display("| Logic         | 01     | 00    | 0   | Ei=1           | %b   | %b    |     |", Fi, Cout);
    
    // Test 4: Select Shift_R
    S = 2'b10;
    S_low = 2'b00;
    Di = 0; Ei = 0; Shift_R = 1; Shift_L = 0; arithmetic_cout = 1; Cin = 0; #10;
    $display("| Shift Right   | 10     | 00    | 0   | Shift_R=1      | %b   | %b    |     |", Fi, Cout);
    
    // Test 5: Select Shift_L
    S = 2'b11;
    S_low = 2'b00;
    Di = 0; Ei = 0; Shift_R = 0; Shift_L = 1; arithmetic_cout = 1; Cin = 0; #10;
    $display("| Shift Left    | 11     | 00    | 0   | Shift_L=1      | %b   | %b    |     |", Fi, Cout);
    
    $display("|--------------------------------------------------------------------------|");
    $finish;
  end
  
endmodule