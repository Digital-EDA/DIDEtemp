interface MulSgn_if #(
	parameter int widthX = 8,  // word width of X (X <= Y)
	parameter int widthY = 8,  // word width of Y
	// parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
	parameter 	  speed  = 2'b10
) ();
	logic [widthX-1:0]          X;  // multiplier
	logic [widthY-1:0]          Y;  // multiplicand
	logic [widthX+widthY-1:0]   P;  // product
    
modport MulSgn_in (
    input X, Y
);

modport MulSgn_out (
    output P
);

endinterface 