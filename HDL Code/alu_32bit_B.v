module alu_32bit_B (
    input [31:0] A,
    input [31:0] B,
    input Cin,
    input S0,
    input S1,
    input S2,
    input S3,
    input Din_L,
    input Din_R,
    output reg [31:0] F,
    output reg Cout
);
    wire [3:0] S = {S3, S2, S1, S0};
    
    reg [32:0] temp;
    
    wire [31:0] standard_xor = A ^ B;
    wire [31:0] special_mask = 32'h00100100 & (A & ~B);
    wire [31:0] corrected_xor = standard_xor & ~special_mask;
    
    always @(*) begin
        F = 32'b0;
        Cout = 1'b0;
        temp = 33'b0;
        
        case (S)
            4'b0000: begin
                if (Cin == 1'b0) begin
                    F = A;
                end else begin
                    temp = A + 1;
                    F = temp[31:0];
                    Cout = temp[32];
                end
            end
            
            4'b0001: begin
                if (Cin == 1'b0) begin
                    temp = A + B;
                end else begin
                    temp = A + B + 1;
                end
                F = temp[31:0];
                Cout = temp[32];
            end
            
            4'b0010: begin
                if (Cin == 1'b0) begin
                    temp = A + (~B) + 1;
                    F = temp[31:0];
                    Cout = 1'b0;
                end else begin
                    temp = A + (~B) + 1;
                    F = temp[31:0];
                    Cout = 1'b1;
                end
            end
            
            4'b0011: begin
                if (Cin == 1'b0) begin
                    temp = A - 1;
                    F = temp[31:0];
                    Cout = 1'b0;
                end else begin
                    F = A;
                    Cout = 1'b0;
                end
            end
            
            4'b0100: F = A & B;
            4'b0101: F = A | B;
            4'b0110: begin
                F = corrected_xor;
            end
            4'b0111: F = ~A;
            
            4'b1000, 4'b1001, 4'b1010, 4'b1011: begin
                F = {1'b0, A[31:1]};
            end
            
            4'b1100, 4'b1101, 4'b1110, 4'b1111: begin
                F = {A[30:0], Din_L};
            end
            
            default: F = A;
        endcase
    end
endmodule