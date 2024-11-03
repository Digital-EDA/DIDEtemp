/* 
   CN: 

*/

// CN: 代码转文档测试功能
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

`define main_out out

module Main #(
    parameter xou, xin
) (
    // Main input : shared comment
    input clk, reset, a, b, c,
    // Main output
    output Qus, Qs, Qa, `main_out
);

/*
## CN ![gif](https://img1.imgtp.com/2023/08/18/bA4ybk5Z.gif)
1. 本地文件依赖，include和非include区别
2. 自动跳转至依赖部分
3. 依赖注释的悬停提示
    - first point
    - second point
4. 依赖内容的自动补全

{
    signal : [
        { name: "clk",  wave: "p......" },
        { name: "bus",  wave: "x.34.5x", data: "head body tail" },
        { name: "wire", wave: "0.1..0." }
    ]
}
*/
// 
// ## EN
// 1. should be included from head.v
// 2. no include from child.v or head.v
child u0_child(
    .a(a),
    .b(b),
    .c(c),
    .Result(Qus)
);

//
child u1_child(a,b,c,Qus);

// ## CN: 
// 同名不同端口的模块定位
child u2_child(
    .port_a(a),
    .port_b(b),
    .port_c(c),
    .out_q(Qs)
);

moreModule u_moreModule(
    .port_a(a),
    .port_b(b), 
    .Q(Qa)
);

// CN: 库 module（外部文件）的依赖

wire [11:0] 	x_o; // cordic x 输出

// cordic y 输出
wire [11:0] 	y_o; 

// 隔离

// cordic x 输出
wire [11:0] 	phase_out; // `相位`输出

/*block*/
// valid out
wire            valid_out; // line

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



// CN: 跨文件宏定义
assign `main_out = `K_COE;

endmodule

/* @wavedrom this is wavedrom demo2
{ 
    signal: [
    { name: "pclk", wave: 'p.......' },
    { name: "Pclk", wave: 'P.......' },
    { name: "nclk", wave: 'n.......' },
    { name: "Nclk", wave: 'N.......' },
    {},
    { name: 'clk0', wave: 'phnlPHNL' },
    { name: 'clk1', wave: 'xhlhLHl.' },
    { name: 'clk2', wave: 'hpHplnLn' },
    { name: 'clk3', wave: 'nhNhplPl' },
    { name: 'clk4', wave: 'xlh.L.Hx' },
]}
*/