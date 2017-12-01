module top(input  logic        clk, reset, 
           output logic [31:0] WriteData, Adr, 
           output logic        MemWrite);

  logic [31:0] ReadData;
  
  // instantiate processor and memories
  arm_multi arm(clk, reset, ReadData, MemWrite, Adr, WriteData);
  mem       mem(clk, MemWrite, Adr, WriteData, ReadData);
endmodule