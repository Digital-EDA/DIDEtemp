module counter #(
        parameter START_VALUE = 8'b0000_1111
    )(
        input               clk,
        input               rst_n,
        output reg  [7:0]   cnt
    );

    parameter STEP = 1'b1;

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            cnt <= START_VALUE;
        else
            cnt <= cnt + STEP;
    end

endmodule

module fifo();


endmodule //fifo
