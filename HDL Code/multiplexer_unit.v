module multiplexer_unit (
    input [1:0] S,
    input [1:0] S_low,
    input Di,
    input arithmetic_cout,
    input Ei,
    input Shift_R,
    input Shift_L,
    input Cin,
    output Fi,
    output Cout
);
    assign Fi = (S == 2'b00) ? Di :
                (S == 2'b01) ? Ei :
                (S == 2'b10) ? Shift_R :
                Shift_L;
    
    wire is_transfer_A_variant = (S_low == 2'b11 && Cin == 1'b1);
    wire is_decrement = (S_low == 2'b11 && Cin == 1'b0);
    
    assign Cout = (S == 2'b00) ? 
                  (is_transfer_A_variant ? 1'b0 : arithmetic_cout) : 
                  1'b0;
endmodule