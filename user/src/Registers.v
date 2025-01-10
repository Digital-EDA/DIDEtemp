module Registers(
    input       clk,
    input       rst,
    input [4:0] Read_Register_1,
    input [4:0] Read_Register_2,
    input [4:0] Write_Register,
    input [31:0] Write_Data,
    input RegWrite,

    output reg [31:0] Read_Data_1,
    output reg [31:0] Read_Data_2
);

    reg [31:0] register [31:0];

    integer i;

    always @(posedge clk or negedge rst) begin
        if(!rst) begin
            for(i = 0; i < 32; i = i + 1)
                register[i] <= 32'd0;
        end
        else begin
            Read_Data_1 <= register[Read_Register_1];
            Read_Data_2 <= register[Read_Register_2];
            if(RegWrite) begin
                register[Write_Register] <= Write_Data;
            end
            else
                register[Write_Register] <= register[Write_Register];
        end
    end
    
    
endmodule //Registers

