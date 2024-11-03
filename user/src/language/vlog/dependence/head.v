`define K_COE 34

module child (
    // this is a test
    input a, b, c,
    // a test
    output Result       // balabalabala for result
);

    // a & b | ((b & c) & (b | c))
    // &=*, |=+               AB + BC(B+C)
    // Distribute             AB + BBC + BCC
    // Simplify AA = A        AB + BC + BC
    // Simplify A + A = A     AB + BC
    // Factor                 B(A+C)

    wire o;
    IBUFDS #(
        .DIFF_TERM("FALSE"),       // Differential Termination
        .IBUF_LOW_PWR("TRUE"),     // Low power="TRUE", Highest performance="FALSE" 
        .IOSTANDARD("DEFAULT"))    // Specify the input I/O standard
    IBUFDS_inst (
        .O(o),   // Buffer output
        .I(a),     // Diff_p buffer input (connect directly to top-level port)
        .IB(b)     // Diff_n buffer input (connect directly to top-level port)
    );

    assign Result = a & (b | c) ^ o;

endmodule