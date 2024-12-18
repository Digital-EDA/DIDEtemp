/* 
   CN: 

*/

// CN: 代码转文档测试功�?
/* @wavedrom this is wavedrom demo1
{
    signal : [
        { name: "clk",  wave: "p......" },
        { name: "bus",  wave: "x.34.5x", data: "head body tail" },
        { name: "wire", wave: "0.1..0." }
    ]
}
*/

`include "head.v"

`define main_out led

module main #(
    parameter xou = 10, xin = 9
) (
    // Main input : shared comment
    input clock, reset,

    // Main output
    output [(xou-1):0] `main_out
);

wire out;

reg value;

always @(posedge clock or posedge reset) begin : ACCUM
    if (reset) begin
        value <= 1'b0;
    end
    else begin
        value <= value + out;
    end
end

//mixed u_mixed (
//    .a(1'b1),
//    .b(value),
//    .sum(out),
//    .y1(`main_out[0]),
//    .y2(`main_out[1])
//);

 cfg_structural u_mixed (
     .a(1'b1),
     .b(value),
     .sum(out),
     .y1(),
     .y2()
 );

// outports wire
wire [(`W_COE-1):0] 	count;

counter #(
	.START_VALUE 	( 8'b0000_1111  ),
	.STEP        	( 1'b1          ))
u_counter(
	.clock 	( clock  ),
	.rstn  	( ~reset ),
	.count 	( count  )
);

assign `main_out[3:2] = count[`W_COE:`W_COE-1];

endmodule
