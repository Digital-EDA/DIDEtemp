module counter #(
        parameter START_VALUE = 8'b0000_1111
    )(
        input               clock,
        input               rstn,
        output reg  [7:0]   count
    );

    parameter STEP = 1'b1;

    always @(posedge clock or negedge rstn) begin
        if (!rstn) begin
            count <= START_VALUE;
        end
        else begin
            count <= count + STEP;
        end
    end

endmodule

// 1-bit Full Adder module
module full_adder_1bit (
        input A,           // First input bit
        input B,           // Second input bit
        input Cin,         // Carry-in bit
        output Sum,        // Sum output
        output Cout        // Carry-out output
    );

    assign Sum = A ^ B ^ Cin;      // Sum calculation

    // Carry-out calculation
    assign Cout = (A & B) | (B & Cin) | (A & Cin); 

endmodule
