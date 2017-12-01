module datapath(input logic clk, reset,
                input logic PCWrite, AdrSrc, IRWrite, ALUSrcA, RegWrite,
                input logic [1:0] RegSrc,
                input logic [1:0] ALUSrcB,
                input logic [1:0] ResultSrc,
                input logic [1:0] ImmSrc,
                input logic [1:0] ALUControl,
                input logic [31:0] ReadData,
                output logic [3:0] ALUFlags,
                output logic [31:0] Adr,
                output logic [31:0] WriteData,
                output logic [31:0] Instr
                );


    //memory:
    //  enable = MemWrite
    //  A = Adr
    //  WD = WriteData
    //  RD = ReadData

    //dataflow signals
    logic [31:0] pc, Data, SrcA, SrcB, ALUResult, ALUOut, Result, ExtImm, rd1, rd2, a;
    logic [3:0] ra1, ra2;

    //memory interface
    mux2 #(32)    memaddrmux(pc, Result, AdrSrc, Adr);
    flopenr #(32) memoutreg(clk, reset, IRWrite, ReadData, Instr);

    //instruction / register logic
    mux2 #(4)  ra1mux(Instr[19:16], 4'b1111, RegSrc[0], ra1);
    mux2 #(4)  ra2mux(Instr[3:0], Instr[15:12], RegSrc[1], ra2);
    regfile     rf(clk, RegWrite, ra1, ra2, Instr[15:12], Result, Result, rd1, rd2);
    flopr #(32) rfreg1(clk, reset, rd1, a);
    flopr #(32) rfreg2(clk, reset, rd2, WriteData);

    //ALU logic
    extend      aluExt(Instr[23:0], ImmSrc, ExtImm);
    mux2 #(32)  alu1mux(a, pc, ALUSrcA, SrcA);
    mux3 #(32)  alu2mux(WriteData, ExtImm, 32'b100, ALUSrcB, SrcB);
    alu         alu(SrcA, SrcB, ALUControl, ALUResult, ALUFlags);
    flopr #(32) alureg(clk, reset, ALUResult, ALUOut);

    //Writeback Logic
    flopr #(32)   datareg(clk, reset, ReadData, Data);
    mux3 #(32)    wbmux(ALUOut, Data, ALUResult, ResultSrc, Result);
    flopenr #(32) wbreg(clk, reset, PCWrite, Result, pc);
endmodule




    