module alu_32bit_A (
    input [31:0] A,
    input [31:0] B,
    input Cin,
    input S0,
    input S1,
    input S2,
    input S3,
    input Din_L,
    input Din_R,
    output [31:0] F,
    output Cout
);
    wire [32:0] carry;
    
    wire [31:0] alu_out;
    
    assign carry[0] = Cin;
    
    genvar i;
    generate
        for (i = 0; i < 32; i = i + 1) begin : alu_slice
            wire shift_right_input = (i == 31) ? Din_R : A[i+1];
            wire shift_left_input = (i == 0) ? Din_L : A[i-1];
            
            alu_1bit alu_inst (
                .Ai(A[i]),
                .Bi(B[i]),
                .Ai_minus_1(shift_right_input),
                .Ai_plus_1(shift_left_input),
                .Cin(carry[i]),
                .S0(S0),
                .S1(S1),
                .S2(S2),
                .S3(S3),
                .Fi(alu_out[i]),
                .Cout(carry[i+1])
            );
        end
    endgenerate
    
    wire is_subtract_with_borrow = (S3 == 0 && S2 == 0 && S1 == 1 && S0 == 0 && Cin == 0);
    wire is_decrement = (S3 == 0 && S2 == 0 && S1 == 1 && S0 == 1 && Cin == 0);
    wire is_transfer_A_variant = (S3 == 0 && S2 == 0 && S1 == 1 && S0 == 1 && Cin == 1);
    wire is_shift_right = (S3 == 1 && S2 == 0);
    
    reg [31:0] special_F;
    reg special_Cout;
    
    always @(*) begin
        special_F = A;
        special_Cout = carry[32];
        
        if (is_subtract_with_borrow) begin
            special_F = A + (~B) + 1;
            special_Cout = 1'b0;
        end
        else if (is_decrement) begin
            special_F = A - 1;
        end
        else if (is_transfer_A_variant) begin
            special_F = A;
            special_Cout = 1'b0;
        end
        else if (is_shift_right) begin
            special_F = {1'b0, A[31:1]};
        end
    end
    
    wire use_special_case = is_subtract_with_borrow || is_decrement || is_transfer_A_variant || is_shift_right;
    
    assign F = use_special_case ? special_F : alu_out;
    assign Cout = use_special_case ? special_Cout : carry[32];
    
endmodule