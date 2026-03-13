module logic_unit (
    input Ai,
    input Bi,
    input S0,
    input S1,
    output Ei
);
    wire and_result = Ai & Bi;
    wire or_result = Ai | Bi;
    wire xor_result = Ai ^ Bi;
    wire not_result = ~Ai;
    
    assign Ei = (S1 == 0 && S0 == 0) ? and_result :
                (S1 == 0 && S0 == 1) ? or_result :
                (S1 == 1 && S0 == 0) ? xor_result :
                not_result;
endmodule