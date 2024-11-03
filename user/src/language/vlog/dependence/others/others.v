module child (
    input port_a, port_b, port_c,
    output out_q
);
    // a & b | ((b & c) & (b | c))
    // &=*, |=+               AB + BC(B+C)
    // Distribute             AB + BBC + BCC
    // Simplify AA = A        AB + BC + BC
    // Simplify A + A = A     AB + BC
    // Factor                 B(A+C)
    

    assign out_q = port_b & (port_a | port_c);
    
endmodule

module moreModule (
        input port_a, port_b,
        output Q 
    );

    // CN: 原厂IP模块的依赖
    xfft_v9 dft_inst (
        .aclk(clock),       // input wire aclk
        .aresetn(fft_resetn),                                               
        .s_axis_config_tdata({7'b0, 1'b1}),                          // input wire [7 : 0] s_axis_config_tdata, use LSB to indicate it is forward transform, the rest should be ignored
        .s_axis_config_tvalid(1'b1),                                 // input wire s_axis_config_tvalid
        .s_axis_config_tready(s_axis_config_tready),                // output wire s_axis_config_tready
        .s_axis_data_tdata({fft_in_im, fft_in_re}),                      // input wire [31 : 0] s_axis_data_tdata
        .s_axis_data_tvalid(fft_in_stb),                    // input wire s_axis_data_tvalid
        .s_axis_data_tready(fft_ready),                    // output wire s_axis_data_tready
        .s_axis_data_tlast(fft_din_data_tlast_delayed),                      // input wire s_axis_data_tlast
        .m_axis_data_tdata({idle_line1,fft_out_im, idle_line2, fft_out_re}),                      // output wire [47 : 0] m_axis_data_tdata
        .m_axis_data_tvalid(fft_valid),                    // output wire m_axis_data_tvalid
        .m_axis_data_tready(1'b1),                    // input wire m_axis_data_tready
        .m_axis_data_tlast(m_axis_data_tlast),                      // output wire m_axis_data_tlast
        .event_frame_started(event_frame_started),                  // output wire event_frame_started
        .event_tlast_unexpected(event_tlast_unexpected),            // output wire event_tlast_unexpected
        .event_tlast_missing(event_tlast_missing),                  // output wire event_tlast_missing
        .event_status_channel_halt(event_status_channel_halt),      // output wire event_status_channel_halt
        .event_data_in_channel_halt(event_data_in_channel_halt),    // output wire event_data_in_channel_halt
        .event_data_out_channel_halt(event_data_out_channel_halt)  // output wire event_data_out_channel_halt
    );

    assign Q = port_b & port_a;
    assign Q = 0;

endmodule