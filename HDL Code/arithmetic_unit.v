module arithmetic_unit (
    input Ai,
    input Bi,
    input Cin,
    input S0,
    input S1,
    output Di,
    output Cout
);
    wire mux_out;
    
    assign mux_out = (S1 == 0 && S0 == 0) ? 1'b0 :
                     (S1 == 0 && S0 == 1) ? Bi :
                     (S1 == 1 && S0 == 0) ? ~Bi :
                     1'b1;
    
    wire sum = Ai ^ mux_out ^ Cin;
    wire carry = (Ai & mux_out) | (Ai & Cin) | (mux_out & Cin);
    
    assign Di = sum;
    assign Cout = carry;
endmodule