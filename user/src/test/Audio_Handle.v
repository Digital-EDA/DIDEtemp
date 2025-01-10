`timescale 1ns / 1ps
module Audio_Handle (
    input         clk_in,
    input         RST,

    input  [11:0] Audio_CH1,
    input  [11:0] Audio_CH2,
    input  [11:0] Move_Fre_SIG,

    output [11:0] Module_SIG,
    output [31:0] Fre_word
);

/***************************************************************************/
wire        [11:0] AM_wave;
AnalogMod #(
    .MODULE_TYPE  	("AMP"  ),
    .ISDSBSC_SET  	(0      ),
    .INPUT_WIDTH  	(12     ),
    .PHASE_WIDTH  	(32     ),
    .MODUL_WIDTH  	(16     ),
    .OUTPUT_WIDTH 	(12     ))
u_AnalogMod(
    .clk_cw   	(clk_in     ),
    .clk_sw   	(clk_in     ),
    .reset    	(1'b0       ),
    .wave_in  	(Audio_CH2  ),
    .fre_word 	(32'd858993 ),  //(fre*4294967296)/clk_in/1000000  //10K
    .pha_word 	(32'd0      ),
    .mod_word 	(16'd32768  ),  //(2^16-1)*percent
    .amp_word 	(16'd65535  ),
    .mod_wave 	(AM_wave    )
);

/***************************************************************************/

reg signed [11:0] Audio_SIG_r = 0;
always @(posedge clk_in) begin
	if (RST) begin
		Audio_SIG_r <= 12'd0;
	end
	else begin
		Audio_SIG_r <= $signed(Audio_CH1) + $signed(AM_wave);
	end
end
assign Module_SIG = Audio_SIG_r;

reg signed [31:0] Carry_fre = 0;
always @(posedge clk_in) begin
	if (RST) begin
		Carry_fre <= 32'd0;
	end
	else begin
		Carry_fre <= $signed(Move_Fre_SIG) * $signed(20'd10486);   //5M
	end
end

reg  [31:0] Fre_word_r = 0;
always @(posedge clk_in) begin
	if (RST) begin
		Fre_word_r <= 32'd0;
	end
	else begin
		Fre_word_r <= 32'd416611827 + $signed(Carry_fre);
	end
end
assign Fre_word = Fre_word_r;

endmodule
