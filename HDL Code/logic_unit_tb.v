`timescale 1ns/1ps
module logic_unit_tb;
  reg Ai;
  reg Bi;
  reg S0;
  reg S1;
  wire Ei;
  logic_unit dut (
    .Ai(Ai),
    .Bi(Bi),
    .S0(S0),
    .S1(S1),
    .Ei(Ei)
  );
  
  initial begin
    Ai = 0;
    Bi = 0;
    S0 = 0;
    S1 = 0;
    #10;
    
    // Test case 1: AND operation (S1=0, S0=0)
    $display("Test Case 1: AND operation (S1=0, S0=0)");
    S1 = 0; S0 = 0;
    
    Ai = 0; Bi = 0; #10;
    if (Ei !== 0) begin
      $display("ERROR: Test Case 1.1 Failed. Ei = %b, Expected: Ei = 0", Ei);
      $finish;
    end
    
    Ai = 0; Bi = 1; #10;
    if (Ei !== 0) begin
      $display("ERROR: Test Case 1.2 Failed. Ei = %b, Expected: Ei = 0", Ei);
      $finish;
    end
    
    Ai = 1; Bi = 0; #10;
    if (Ei !== 0) begin
      $display("ERROR: Test Case 1.3 Failed. Ei = %b, Expected: Ei = 0", Ei);
      $finish;
    end
    
    Ai = 1; Bi = 1; #10;
    if (Ei !== 1) begin
      $display("ERROR: Test Case 1.4 Failed. Ei = %b, Expected: Ei = 1", Ei);
      $finish;
    end
    $display("Test Case 1: passed");
    
    // Test case 2: OR operation (S1=0, S0=1)
    $display("Test Case 2: OR operation (S1=0, S0=1)");
    S1 = 0; S0 = 1;
    
    Ai = 0; Bi = 0; #10;
    if (Ei !== 0) begin
      $display("ERROR: Test Case 2.1 Failed. Ei = %b, Expected: Ei = 0", Ei);
      $finish;
    end
    
    Ai = 0; Bi = 1; #10;
    if (Ei !== 1) begin
      $display("ERROR: Test Case 2.2 Failed. Ei = %b, Expected: Ei = 1", Ei);
      $finish;
    end
    
    Ai = 1; Bi = 0; #10;
    if (Ei !== 1) begin
      $display("ERROR: Test Case 2.3 Failed. Ei = %b, Expected: Ei = 1", Ei);
      $finish;
    end
    
    Ai = 1; Bi = 1; #10;
    if (Ei !== 1) begin
      $display("ERROR: Test Case 2.4 Failed. Ei = %b, Expected: Ei = 1", Ei);
      $finish;
    end
    $display("Test Case 2: passed");
    
    // Test case 3: XOR operation (S1=1, S0=0)
    $display("Test Case 3: XOR operation (S1=1, S0=0)");
    S1 = 1; S0 = 0;
    
    Ai = 0; Bi = 0; #10;
    if (Ei !== 0) begin
      $display("ERROR: Test Case 3.1 Failed. Ei = %b, Expected: Ei = 0", Ei);
      $finish;
    end
    
    Ai = 0; Bi = 1; #10;
    if (Ei !== 1) begin
      $display("ERROR: Test Case 3.2 Failed. Ei = %b, Expected: Ei = 1", Ei);
      $finish;
    end
    
    Ai = 1; Bi = 0; #10;
    if (Ei !== 1) begin
      $display("ERROR: Test Case 3.3 Failed. Ei = %b, Expected: Ei = 1", Ei);
      $finish;
    end
    
    Ai = 1; Bi = 1; #10;
    if (Ei !== 0) begin
      $display("ERROR: Test Case 3.4 Failed. Ei = %b, Expected: Ei = 0", Ei);
      $finish;
    end
    $display("Test Case 3: passed");
    
    // Test case 4: NOT operation (S1=1, S0=1)
    $display("Test Case 4: NOT operation (S1=1, S0=1)");
    S1 = 1; S0 = 1;
    
    Ai = 0; Bi = 0; #10;
    if (Ei !== 1) begin
      $display("ERROR: Test Case 4.1 Failed. Ei = %b, Expected: Ei = 1", Ei);
      $finish;
    end
    
    Ai = 0; Bi = 1; #10;
    if (Ei !== 1) begin
      $display("ERROR: Test Case 4.2 Failed. Ei = %b, Expected: Ei = 1", Ei);
      $finish;
    end
    
    Ai = 1; Bi = 0; #10;
    if (Ei !== 0) begin
      $display("ERROR: Test Case 4.3 Failed. Ei = %b, Expected: Ei = 0", Ei);
      $finish;
    end
    
    Ai = 1; Bi = 1; #10;
    if (Ei !== 0) begin
      $display("ERROR: Test Case 4.4 Failed. Ei = %b, Expected: Ei = 0", Ei);
      $finish;
    end
    $display("Test Case 4: passed");
    
    $display("All logic unit tests passed!");
    $finish;
  end
  
endmodule