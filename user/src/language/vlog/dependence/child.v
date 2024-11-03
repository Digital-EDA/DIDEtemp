module child (
    // this is a test
    input a, b, c,
    input child,
    // a test
    output Result       // balabalabala for result
);

    // a & b | ((b & c) & (b | c))
    // &=*, |=+               AB + BC(B+C)
    // Distribute             AB + BBC + BCC
    // Simplify AA = A        AB + BC + BC
    // Simplify A + A = A     AB + BC
    // Factor                 B(A+C)

    assign Result = a & (b | c);

endmodule