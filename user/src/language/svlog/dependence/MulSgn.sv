// Copyright 2024 ETH Zurich and University of Bologna.
// Solderpad Hardware License, Version 0.51, see LICENSE for details.
// SPDX-License-Identifier: SHL-0.51
//
// Based on the work by Reto Zimmermann 1998 - ETH Zürich
// Originally written in VHDL, available under: 
// https://iis-people.ee.ethz.ch/~zimmi/arith_lib.html#library
//
// Authors:
// - Thomas Benz <tbenz@iis.ee.ethz.ch>
// - Philippe Sauter <phsauter@iis.ee.ethz.ch>
// - Paul Scheffler <paulsc@iis.ee.ethz.ch>
//
// Description :
// Multiplier for signed numbers (Baugh-Wooley) using carry-save adder and
// final adder.

module MulSgn #(
	parameter int widthX = 8,  // word width of X (X <= Y)
	parameter int widthY = 8,  // word width of Y
	// parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
	parameter 	  speed  = 2'b10
) (
	input logic [widthX-1:0] X,  // multiplier
	input logic [widthY-1:0] Y,  // multiplicand
	output logic [widthX+widthY-1:0] P  // product
);
// module MulSgn #(
// 	parameter int widthX = 8,  // word width of X (X <= Y)
// 	parameter int widthY = 8,  // word width of Y
// 	// parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
// 	parameter 	  speed  = 2'b10
// ) (
// 	MulSgn_if.MulSgn_in MulSgn_in,
// 	MulSgn_if.MulSgn_out MulSgn_out
// );
	logic [(widthX+2)*(widthX+widthY)-1:0] PP;  // partial products
	logic [widthX+widthY-1:0] ST, CT;  // intermediate sum/carry bits

	// Generation of partial products

	MulPPGenSgn #(
		.widthX(widthX),
		.widthY(widthY)
	) ppGen (
		.X (X),
		.Y (Y),
		// .X (MulSgn_in.X),
		// .Y (MulSgn_in.Y),
		.PP(PP)
	);

	// Carry-save addition of partial products
	AddMopCsv #(
		.width(widthX+widthY),
		.depth(widthX+2),
		.speed (speed)
	) csvAdd (
		.A(PP),
		.S(ST),
		.C(CT)
	);

	// Final carry-propagate addition
	Add #(
		.width(widthX + widthY),
		.speed(speed)
	) cpAdd (
		.A(ST),
		.B(CT),
		// .S(MulSgn_out.P)
		.S(P)
	);
    

    SIM_CONFIG_S3A #(
        .DEVICE_ID(32'h00000000)
    ) SIM_CONFIG_S3A_inst (
        .CSOB(CSOB),   // 1-bit output chip select pin
        .DONE(DONE),   // 1-bit bi-directional Done pin
        .CCLK(CCLK),   // 1-bit input configuration clock
        .D(D),         // 8-bit bi-directional configuration data
        .DCMLOCK(DCMLOCK), // 1-bit input DCM Lock
        .CSIB(CSIB),   // 1-bit input chip select
        .INITB(INITB), // 1-bit bi-directional INIT status pin
        .M(M),         // 3-bit input Mode pins
        .PROGB(PROGB), // 1-bit input Program pin
        .RDWRB(RDWRB)  // 1-bit input Read/write pin
    );

endmodule



// module behavioural_MulSgn #(
// 	parameter int widthX = 8,  // word width of X (X <= Y)
// 	parameter int widthY = 8,  // word width of Y
// 	parameter lau_pkg::speed_e speed = lau_pkg::FAST  // performance parameter
// ) (
// 	input logic [widthX-1:0] X,  // multiplier
// 	input logic [widthY-1:0] Y,  // multiplicand
// 	output logic [widthX+widthY-1:0] P  // product
// );
// 	assign P = signed'(X) * signed'(Y);
// endmodule