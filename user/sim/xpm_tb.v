`timescale 1 ns / 1 ns

module tb_xpm();

    parameter    INPUT_WIDTH  = 64;
    parameter    OUTPUT_WIDTH = 8;
    /*
        The depth parameter of writing mem
        if INPUT_WIDTH < OUTPUT_WIDTH, WR_DEPTH = (OUTPUT_WIDTH/INPUT_WIDTH) * RD_DEPTH
    */
    parameter    WR_DEPTH     = 16;
    /*
        The depth parameter of reading mem
        if INPUT_WIDTH > OUTPUT_WIDTH, RD_DEPTH = (INPUT_WIDTH/OUTPUT_WIDTH) * WR_DEPTH
    */
    parameter    RD_DEPTH     = 128;
    //The parameter of reading method
    parameter    MODE         = "Standard";
    //Is data stored from high bits or from low bits
    parameter    DIRECTION    = "LSB";

    parameter MAIN_FRE   = 100; //unit MHz
    reg                   sys_clk = 0;
    reg                   sys_rst = 1;

    always begin
        #(500/MAIN_FRE) sys_clk = ~sys_clk;
    end

    always begin
        #50 sys_rst = 0;
    end

    //Instance 
    // outports wire
    wire                      	valid;
    wire [OUTPUT_WIDTH-1:0]   	dout;
    wire                      	full;
    wire                      	empty;
    wire [$clog2(WR_DEPTH) : 0] wr_data_count;
    wire [$clog2(RD_DEPTH) : 0] rd_data_count;
    wire [$clog2(WR_DEPTH) : 0] wr_data_space;
    wire [$clog2(RD_DEPTH) : 0] rd_data_space;

    reg							wr_en;
    reg							rd_en;
    reg	 [INPUT_WIDTH-1:0]		din;

    initial begin
        wr_en = 1'b0;
        rd_en = 1'b0;

        #100

        @(posedge sys_clk);
        wr_en = 1'b1;
        rd_en = 1'b0;

        #(WR_DEPTH * 12)

        @(posedge sys_clk);
        wr_en = 1'b0;
        rd_en = 1'b0;

        #200

        @(posedge sys_clk);
        wr_en = 1'b0;
        rd_en = 1'b1;

        #30

        @(posedge sys_clk);
        wr_en = 1'b0;
        rd_en = 1'b0;

        #215

        @(posedge sys_clk);
        wr_en = 1'b0;
        rd_en = 1'b1;

        #(RD_DEPTH * 22)

        @(posedge sys_clk);
        wr_en = 1'b0;
        rd_en = 1'b0;
    end

    always @(posedge sys_clk or negedge sys_rst) begin
        if(sys_rst == 1'b1)begin
            din <= 64'h0123_4567_89ab_cdef;
        end
        else if(wr_en)begin
            din[7:0]   <= din[7:0]   + 1'b1;
            din[15:8]  <= din[15:8]  + 1'b1;
            din[23:16] <= din[23:16] + 1'b1;
            din[31:24] <= din[31:24] + 1'b1;
            din[39:32] <= din[39:32] + 1'b1;
            din[47:40] <= din[47:40] + 1'b1;
            din[55:48] <= din[55:48] + 1'b1;
            din[63:56] <= din[63:56] + 1'b1;
        end
    end

    always @(posedge sys_clk) begin
        if(wr_en & (~full))
            $display("the write data is %h\t the write_count is %d",din,wr_data_count);
    end

    always @(posedge sys_clk) begin
        if(valid)
            $display("the read data is %h\t the read_count is %d",dout,rd_data_count);
    end

    xpm_fifo_sync #(
        .DOUT_RESET_VALUE("0"),    // String
        .ECC_MODE("no_ecc"),       // String
        .FIFO_MEMORY_TYPE("auto"), // String
        .FIFO_READ_LATENCY(0),     // DECIMAL
        .FIFO_WRITE_DEPTH(WR_DEPTH),   // DECIMAL
        .FULL_RESET_VALUE(0),      // DECIMAL
        .PROG_EMPTY_THRESH(10),    // DECIMAL
        .PROG_FULL_THRESH(10),     // DECIMAL
        .RD_DATA_COUNT_WIDTH($clog2(RD_DEPTH)+1),   // DECIMAL
        .READ_DATA_WIDTH(OUTPUT_WIDTH),      // DECIMAL
        .READ_MODE("fwft"),         // String
        .USE_ADV_FEATURES("0404"), // only enable rd_data_count and wr_data_count
        .WAKEUP_TIME(0),           // DECIMAL
        .WRITE_DATA_WIDTH(INPUT_WIDTH),     // DECIMAL
        .WR_DATA_COUNT_WIDTH($clog2(WR_DEPTH)+1))    // DECIMAL
    fifo_1clk_for_running_sum_dual_ch_i (
        .almost_empty(),
        .almost_full(),
        .data_valid(),
        .dbiterr(),
        .dout(dout),
        .empty(empty),
        .full(full),
        .overflow(),
        .prog_empty(),
        .prog_full(),
        .rd_data_count(),
        .rd_rst_busy(),
        .sbiterr(),
        .underflow(),
        .wr_ack(),
        .wr_data_count(wr_data_count),
        .wr_rst_busy(),
        .din(din),
        .injectdbiterr(),
        .injectsbiterr(),
        .rd_en(rd_en),
        .rst(~rstn),
        .sleep(),
        .wr_clk(sys_clk),
        .wr_en(data_in_valid)
    );

    initial begin            
        $dumpfile("wave.vcd");        
        $dumpvars(0, tb_xpm);    
        #50000 $finish;
    end

endmodule  //TOP
