module arm_multi(input logic clk, reset,
                 input logic [31:0] ReadData,
                 output logic MemWrite,
                 output logic [31:0] Adr,
                 output logic [31:0] WriteData
                 );

    logic PCWrite, AdrSrc, IRWrite, ALUSrcA, RegWrite;
    logic [1:0] RegSrc, ALUSrcB, ResultSrc, ImmSrc, ALUControl;
    logic [3:0] ALUFlags;
    logic [31:0] Instr;

    controller c(clk, reset, Instr[31:12], ALUFlags, PCWrite, MemWrite, RegWrite, IRWrite, AdrSrc, RegSrc, ALUSrcA, ALUSrcB, ResultSrc, ImmSrc, ALUControl);
    datapath   d(clk, reset, PCWrite, AdrSrc, IRWrite, ALUSrcA, RegWrite, RegSrc, ALUSrcB, ResultSrc, ImmSrc, ALUControl, ReadData, ALUFlags, Adr, WriteData, Instr);

endmodule
