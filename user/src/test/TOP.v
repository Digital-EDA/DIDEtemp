module TOP (
        input         sys_clk,
        
        input  [11:0] AD9926_data_1,
        input  [11:0] AD9926_data_2,
        input  [11:0] AD9926_data_3,
        output        AD9926_clk_1,
        output        AD9926_clk_2,
        output        AD9926_clk_3,

        output        FM_OUT
    );

    wire    clk_500m;
    wire    clk_250m;
    wire    clk_10m;
    wire    clk_50m;

    wire    locked;
    CLK_Global # (
        .CLKIN_PERIOD(20),
        .Mult(20),
        .DIVCLK_DIV(1),

        .CLKOUT0_DIV(2),
        .CLK0_PHASE(0.0),

        .CLKOUT1_DIV(4),
        .CLK1_PHASE(0.0),

        .CLKOUT2_DIV(100),
        .CLK2_PHASE(0.0),

        .CLKOUT3_DIV(20),
        .CLK3_PHASE(0.0)) 
    CLK_Global_u (
        .clk_in(sys_clk),
        .rst_n(1'b1),

        .clk_out1(clk_500m),
        .clk_out2(clk_250m),
        .clk_out3(clk_10m),
        .clk_out4(clk_50m),

        .locked(locked)
    ); 

    wire        [11:0] Audio_wave_a;
    AD9226 AD9226_1(
        .clk_in(clk_10m),
        .rst_n(1),
        .AD_data(AD9926_data_1),
        .AD_clk(AD9926_clk_1),
        .wave_CH(Audio_wave_a)
    );

    wire        [11:0] Audio_wave_b;
    AD9226 AD9226_2(
        .clk_in(clk_10m),
        .rst_n(1),
        .AD_data(AD9926_data_2),
        .AD_clk(AD9926_clk_2),
        .wave_CH(Audio_wave_b)
    );

    wire        [11:0] Move_wave;
    AD9226 AD9226_3(
        .clk_in(clk_10m),
        .rst_n(1),
        .AD_data(AD9926_data_3),
        .AD_clk(AD9926_clk_3),
        .wave_CH(Move_wave)
    );

    wire        [11:0] Module_SIG;
    wire        [31:0] Fre_word;
    Audio_Handle Audio_Handle_u(
        .clk_in(clk_50m),
        .RST(0),

        .Audio_CH1(Audio_wave_a),
        .Audio_CH2(Audio_wave_b),
        .Move_Fre_SIG(Move_wave),

        .Module_SIG(Module_SIG),
        .Fre_word(Fre_word)
    );

    wire        [11:0] FM_wave;

    AnalogMod #(
        .MODULE_TYPE  	("AMP"  ),
        .ISDSBSC_SET  	(0      ),
        .INPUT_WIDTH  	(12     ),
        .PHASE_WIDTH  	(32     ),
        .MODUL_WIDTH  	(16     ),
        .OUTPUT_WIDTH 	(12     ))
    u_AnalogMod(
        .clk_cw   	(clk_500m    ),
        .clk_sw   	(clk_500m    ),
        .reset    	(1'd0     ),
        .wave_in  	(Module_SIG   ),
        .fre_word 	(Fre_word  ),  //(fre*1048576)/clk_in/1000000  //50k
        .pha_word 	(32'd0  ),
        .mod_word 	(32'd105  ),
        .amp_word 	(16'd65535  ),
        .mod_wave 	(FM_wave  )
    );

    assign FM_OUT = FM_wave[11];

endmodule