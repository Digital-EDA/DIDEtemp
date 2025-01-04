// `include "../src/Registers.v"
`timescale 1ns/1ns

module Registers_tb();
    // inports reg
    reg clk = 0;
    reg rst = 0;
    reg [4:0] Read_Register_1 = 5'd0;
    reg [4:0] Read_Register_2 = 5'd0;
    reg [4:0] Write_Register = 5'd0;
    reg [31:0] Write_Data = 32'd0;
    reg RegWrite = 0;

    // outports wire
    wire [31:0] 	Read_Data_1;
    wire [31:0] 	Read_Data_2;

    Registers u_Registers(
        .clk             	( clk              ),
        .rst             	( rst              ),
        .Read_Register_1 	( Read_Register_1  ),
        .Read_Register_2 	( Read_Register_2  ),
        .Write_Register  	( Write_Register   ),
        .Write_Data      	( Write_Data       ),
        .RegWrite        	( RegWrite         ),
        .Read_Data_1     	( Read_Data_1      ),
        .Read_Data_2     	( Read_Data_2      )
    );

    initial begin
        $display("start a clock pulse");    // 打印开始标记
        $dumpfile("wave.vcd");              // 指定记录模拟波形的文件
        $dumpvars(0, Registers_tb);          // 指定记录的模块层级
        #100 $finish;                      // x个单位时间后结束模拟
    end

    initial begin
        #5
        rst = 1;
    end

    always begin
        #5
        clk <= ~clk;
    end

    initial begin
        // 测试向寄存器x0中写入数据
        #10
        RegWrite <= 1;
        Write_Data <= 32'd10;
        Write_Register <= 5'd0;

        // 测试向寄存器x1中写入数据
        #10
        RegWrite <= 1;
        Write_Data <= 32'd15;
        Write_Register <= 5'd1;

        // 测试同时写入和读取寄存器x1
        #10
        RegWrite <= 1;
        Write_Data <= 32'd10;
        Write_Register <= 5'd1;
        Read_Register_1 <= 5'd1;
    end
    
endmodule //Registers_tb

