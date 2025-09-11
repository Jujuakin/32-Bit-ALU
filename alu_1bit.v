module alu_1bit (
    input Ai,
    input Bi,
    input Ai_minus_1,
    input Ai_plus_1,
    input Cin,
    input S0,
    input S1,
    input S2,
    input S3,
    output Fi,
    output Cout
);
    wire Di;
    wire arithmetic_cout;
    wire Ei;
    
    arithmetic_unit arithmetic_unit_inst (
        .Ai(Ai),
        .Bi(Bi),
        .Cin(Cin),
        .S0(S0),
        .S1(S1),
        .Di(Di),
        .Cout(arithmetic_cout)
    );
    
    logic_unit logic_unit_inst (
        .Ai(Ai),
        .Bi(Bi),
        .S0(S0),
        .S1(S1),
        .Ei(Ei)
    );
    
    multiplexer_unit multiplexer_unit_inst (
        .S({S3, S2}),
        .S_low({S1, S0}),
        .Di(Di),
        .arithmetic_cout(arithmetic_cout),
        .Ei(Ei),
        .Shift_R(Ai_minus_1),
        .Shift_L(Ai_plus_1),
        .Cin(Cin),
        .Fi(Fi),
        .Cout(Cout)
    );
endmodule