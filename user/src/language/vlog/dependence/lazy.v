module lazy (
    input      clock,
    input      reset
);

// output declaration of module cordic
wire ovalid;
wire [XY_BITS-1:0] x_o;
wire [XY_BITS-1:0] y_o;
wire [PH_BITS-1:0] z_o;

cordic #(
    .STYLE      	("ROTATE"  ),
    .CALMODE    	("FAST"    ),
    .XY_BITS    	(12        ),
    .PH_BITS    	(32        ),
    .ITERATIONS 	(32        ))
u_cordic(
    .clock  	(clock   ),
    .reset  	(reset   ),
    .ivalid 	(ivalid  ),
    .x_i    	(x_i     ),
    .y_i    	(y_i     ),
    .z_i    	(z_i     ),
    .ovalid 	(ovalid  ),
    .x_o    	(x_o     ),
    .y_o    	(y_o     ),
    .z_o    	(z_o     )
);


endmodule
