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
    Ai = 0;
    Bi = 0;
    Cin = 0;
    S0 = 0;
    S1 = 0;
    #10;

    // Test Case 1: Transfer A (S1=0, S0=0, Cin=0) - Result should be Ai
    $display("Test Case 1: Transfer A (S1=0, S0=0, Cin=0)");
    S1 = 0; S0 = 0; Cin = 0;

    Ai = 0; Bi = 0; #10;
    if (Di !== 0 || Cout !== 0) begin
      $display("ERROR: Test Case 1.1 Failed. Di = %b, Cout = %b, Expected: Di = 0, Cout = 0", Di, Cout);
      $finish;
    end

    Ai = 1; Bi = 0; #10;
    if (Di !== 1 || Cout !== 0) begin
      $display("ERROR: Test Case 1.2 Failed. Di = %b, Cout = %b, Expected: Di = 1, Cout = 0", Di, Cout);
      $finish;
    end

    Ai = 1; Bi = 1; #10;
    if (Di !== 1 || Cout !== 0) begin
      $display("ERROR: Test Case 1.3 Failed. Di = %b, Cout = %b, Expected: Di = 1, Cout = 0", Di, Cout);
      $finish;
    end
    $display("Test Case 1: passed");

    // Test Case 2: Increment A (S1=0, S0=0, Cin=1) - Result should be Ai + 1
    $display("Test Case 2: Increment A (S1=0, S0=0, Cin=1)");
    S1 = 0; S0 = 0; Cin = 1;

    Ai = 0; Bi = 0; #10;
    if (Di !== 1 || Cout !== 0) begin
      $display("ERROR: Test Case 2.1 Failed. Di = %b, Cout = %b, Expected: Di = 1, Cout = 0", Di, Cout);
      $finish;
    end

    Ai = 1; Bi = 0; #10;
    if (Di !== 0 || Cout !== 1) begin
      $display("ERROR: Test Case 2.2 Failed. Di = %b, Cout = %b, Expected: Di = 0, Cout = 1", Di, Cout);
      $finish;
    end
    $display("Test Case 2: passed");

    // Test Case 3: Addition (S1=0, S0=1, Cin=0) - Result should be Ai + Bi
    $display("Test Case 3: Addition (S1=0, S0=1, Cin=0)");
    S1 = 0; S0 = 1; Cin = 0;

    Ai = 0; Bi = 0; #10;
    if (Di !== 0 || Cout !== 0) begin
      $display("ERROR: Test Case 3.1 Failed. Di = %b, Cout = %b, Expected: Di = 0, Cout = 0", Di, Cout);
      $finish;
    end

    Ai = 0; Bi = 1; #10;
    if (Di !== 1 || Cout !== 0) begin
      $display("ERROR: Test Case 3.2 Failed. Di = %b, Cout = %b, Expected: Di = 1, Cout = 0", Di, Cout);
      $finish;
    end

    Ai = 1; Bi = 1; #10;
    if (Di !== 0 || Cout !== 1) begin
      $display("ERROR: Test Case 3.3 Failed. Di = %b, Cout = %b, Expected: Di = 0, Cout = 1", Di, Cout);
      $finish;
    end
    $display("Test Case 3: passed");

    // Test Case 4: Add with Carry (S1=0, S0=1, Cin=1) - Result should be Ai + Bi + 1
    $display("Test Case 4: Add with carry (S1=0, S0=1, Cin=1)");
    S1 = 0; S0 = 1; Cin = 1;

    Ai = 0; Bi = 0; #10;
    if (Di !== 1 || Cout !== 0) begin
      $display("ERROR: Test Case 4.1 Failed. Di = %b, Cout = %b, Expected: Di = 1, Cout = 0", Di, Cout);
      $finish;
    end

    Ai = 1; Bi = 1; #10;
    if (Di !== 1 || Cout !== 1) begin
      $display("ERROR: Test Case 4.2 Failed. Di = %b, Cout = %b, Expected: Di = 1, Cout = 1", Di, Cout);
      $finish;
    end
    $display("Test Case 4: passed");

    // Test Case 5: Subtract with Borrow (S1=1, S0=0, Cin=0) - Result should be Ai + ~Bi
    $display("Test Case 5: Subtract with borrow (S1=1, S0=0, Cin=0)");
    S1 = 1; S0 = 0; Cin = 0;

    Ai = 1; Bi = 0; #10;
    if (Di !== 0 || Cout !== 1) begin
      $display("ERROR: Test Case 5.1 Failed. Di = %b, Cout = %b, Expected: Di = 0, Cout = 1", Di, Cout);
      $finish;
    end

    Ai = 1; Bi = 1; #10;
    if (Di !== 1 || Cout !== 0) begin
      $display("ERROR: Test Case 5.2 Failed. Di = %b, Cout = %b, Expected: Di = 1, Cout = 0", Di, Cout);
      $finish;
    end
    $display("Test Case 5: passed");

    // Test Case 6: Subtraction (S1=1, S0=0, Cin=1) - Result should be Ai + ~Bi + 1
    $display("Test Case 6: Subtraction (S1=1, S0=0, Cin=1)");
    S1 = 1; S0 = 0; Cin = 1;

    Ai = 0; Bi = 0; #10;
    if (Di !== 0 || Cout !== 1) begin
      $display("ERROR: Test Case 6.1 Failed. Di = %b, Cout = %b, Expected: Di = 0, Cout = 1", Di, Cout);
      $finish;
    end

    Ai = 1; Bi = 1; #10;
    if (Di !== 0 || Cout !== 1) begin
      $display("ERROR: Test Case 6.2 Failed. Di = %b, Cout = %b, Expected: Di = 0, Cout = 1", Di, Cout);
      $finish;
    end

    Ai = 1; Bi = 0; #10;
    if (Di !== 0 || Cout !== 1) begin
      $display("ERROR: Test Case 6.3 Failed. Di = %b, Cout = %b, Expected: Di = 0, Cout = 1", Di, Cout);
      $finish;
    end
    $display("Test Case 6: passed");

    // Test Case 7: Decrement A (S1=1, S0=1, Cin=0) - Result should be Ai - 1
    $display("Test Case 7: Decrement A (S1=1, S0=1, Cin=0)");
    S1 = 1; S0 = 1; Cin = 0;

    Ai = 1; Bi = 0; #10;
    if (Di !== 0 || Cout !== 1) begin
      $display("ERROR: Test Case 7.1 Failed. Di = %b, Cout = %b, Expected: Di = 0, Cout = 1", Di, Cout);
      $finish;
    end

    Ai = 0; Bi = 0; #10;
    if (Di !== 1 || Cout !== 0) begin
      $display("ERROR: Test Case 7.2 Failed. Di = %b, Cout = %b, Expected: Di = 1, Cout = 0", Di, Cout);
      $finish;
    end
    $display("Test Case 7: passed");

    // Test Case 8: Transfer A (S1=1, S0=1, Cin=1) - Result should be Ai
    $display("Test Case 8: Transfer A (S1=1, S0=1, Cin=1)");
    S1 = 1; S0 = 1; Cin = 1;

    Ai = 0; Bi = 0; #10;
    if (Di !== 0 || Cout !== 1) begin
      $display("ERROR: Test Case 8.1 Failed. Di = %b, Cout = %b, Expected: Di = 0, Cout = 1", Di, Cout);
      $finish;
    end

    Ai = 1; Bi = 0; #10;
    if (Di !== 1 || Cout !== 1) begin
      $display("ERROR: Test Case 8.2 Failed. Di = %b, Cout = %b, Expected: Di = 1, Cout = 1", Di, Cout);
      $finish;
    end
    $display("Test Case 8: passed");

    $display("All arithmetic unit tests passed!");
    $finish;
  end
  
endmodule