module fetch_main;
  
  function logic[31:0] adder(logic[31:0] pc);      // updating pc on each posedge
    return (pc+4);
  endfunction
  
  
  // returns the instruction from the instruction memory according to the pc
  function void instruction_mem(input int index,input logic[31:0] instruction_memory[63:0],output logic[31:0] instruction);
    instruction = instruction_memory[index];
  endfunction
  
endmodule