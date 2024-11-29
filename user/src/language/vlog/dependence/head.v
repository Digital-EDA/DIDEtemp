`define W_COE 8

// 2-bit Full Adder module
module full_adder #(
        parameter WIDTH = `W_COE
    ) (
        input  [WIDTH-1:0] A,     // 2-bit first input
        input  [WIDTH-1:0] B,     // 2-bit second input
        input  Cin,         // Carry-in
        output [WIDTH-1:0] Sum,  // 2-bit sum output
        output Cout        // Carry-out
    );
    
    wire [WIDTH:0] Ca;           // Intermediate carry
    assign Ca[0] = Cin;

    genvar i;
    generate for(i = 0 ; i < (WIDTH-1); i = i + 1) begin : U    
        // First 1-bit Full Adder for least significant bit
        full_adder FA (
            .A(A[i]),
            .B(B[i]),
            .Cin(Ca[i]),
            .Sum(Sum[i]),
            .Cout(Ca[i+1])
        );
    end
    endgenerate
    
endmodule

