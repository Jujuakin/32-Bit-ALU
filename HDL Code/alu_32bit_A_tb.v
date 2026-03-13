`include "alu_32bit_A.v"

module alu_32bit_A_tb;

    parameter CLOCK_PERIOD = 10; 
    
    reg [31:0] A;
    reg [31:0] B;
    reg Cin;
    reg S0, S1, S2, S3;
    reg Din_L, Din_R;
    
    wire [31:0] F;
    wire Cout;
    
    alu_32bit_A dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .S0(S0),
        .S1(S1),
        .S2(S2),
        .S3(S3),
        .Din_L(Din_L),
        .Din_R(Din_R),
        .F(F),
        .Cout(Cout)
    );
    
    initial begin
        A = 32'h0;
        B = 32'h0;
        Cin = 1'b0;
        S0 = 1'b0;
        S1 = 1'b0;
        S2 = 1'b0;
        S3 = 1'b0;
        Din_L = 1'b0;
        Din_R = 1'b0;
        
        $dumpfile("alu_32bit_A_tb.vcd");
        $dumpvars(0, alu_32bit_A_tb);
        
        #(CLOCK_PERIOD * 2);
        
        $display("|-----------------------------------------------------------------------------------------|");
        $display("| Operation               | S3 S2 S1 S0 | Cin | A Value    | B Value    | F Value    | Cout |");
        $display("|-----------------------------------------------------------------------------------------|");
        
        // Test 1: Transfer A
        A = 32'hA5A5A5A5; B = 32'h5A5A5A5A;
        {S3, S2, S1, S0} = 4'b0000; Cin = 1'b0;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| Transfer A              | 0  0  0  0  | 0   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 2: Increment A
        A = 32'hFFFFFFFF; B = 32'h00000000;
        {S3, S2, S1, S0} = 4'b0000; Cin = 1'b1;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| Increment A             | 0  0  0  0  | 1   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 3: Addition
        A = 32'h12345678; B = 32'h87654321;
        {S3, S2, S1, S0} = 4'b0001; Cin = 1'b0;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| Addition A+B            | 0  0  0  1  | 0   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 4: Add with carry
        A = 32'h12345678; B = 32'h87654321;
        {S3, S2, S1, S0} = 4'b0001; Cin = 1'b1;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| Add with carry          | 0  0  0  1  | 1   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 5: Subtract with borrow
        A = 32'h99999999; B = 32'h11111111;
        {S3, S2, S1, S0} = 4'b0010; Cin = 1'b0;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| Subtract with borrow    | 0  0  1  0  | 0   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 6: Subtraction
        A = 32'h99999999; B = 32'h11111111;
        {S3, S2, S1, S0} = 4'b0010; Cin = 1'b1;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| Subtraction A-B         | 0  0  1  0  | 1   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 7: Decrement A
        A = 32'h00000001; B = 32'h00000000;
        {S3, S2, S1, S0} = 4'b0011; Cin = 1'b0;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| Decrement A             | 0  0  1  1  | 0   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 8: Transfer A 
        A = 32'hA5A5A5A5; B = 32'h00000000;
        {S3, S2, S1, S0} = 4'b0011; Cin = 1'b1;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| Transfer A              | 0  0  1  1  | 1   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 9: AND
        A = 32'hF0F0F0F0; B = 32'h0FF00FF0;
        {S3, S2, S1, S0} = 4'b0100; Cin = 1'b0;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| AND                     | 0  1  0  0  | 0   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 10: OR
        A = 32'hF0F0F0F0; B = 32'h0FF00FF0;
        {S3, S2, S1, S0} = 4'b0101; Cin = 1'b0;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| OR                      | 0  1  0  1  | 0   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 11: XOR
        A = 32'hF0F0F0F0; B = 32'h0FF00FF0;
        {S3, S2, S1, S0} = 4'b0110; Cin = 1'b0;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| XOR                     | 0  1  1  0  | 0   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 12: NOT A
        A = 32'hF0F0F0F0; B = 32'h00000000;
        {S3, S2, S1, S0} = 4'b0111; Cin = 1'b0;
        Din_L = 1'b0; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| NOT A                   | 0  1  1  1  | 0   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 13: Shift Right
        A = 32'hF0F0F0F0; B = 32'h00000000;
        {S3, S2, S1, S0} = 4'b1000; Cin = 1'b0;
        Din_L = 1'b0; Din_R = 1'b1;
        #CLOCK_PERIOD;
        $display("| Shift Right             | 1  0  0  0  | 0   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        // Test 14: Shift Left
        A = 32'hF0F0F0F0; B = 32'h00000000;
        {S3, S2, S1, S0} = 4'b1100; Cin = 1'b0;
        Din_L = 1'b1; Din_R = 1'b0;
        #CLOCK_PERIOD;
        $display("| Shift Left              | 1  1  0  0  | 0   | 0x%8h | 0x%8h | 0x%8h | %b    |", 
                 A, B, F, Cout);
        
        $display("|-----------------------------------------------------------------------------------------|");
        $finish;
    end

endmodule