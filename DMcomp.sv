typedef logic[31:0] array_type[];

module DataMemoryMain();
  
  function array_type Data_Memory
    (
      input logic write_mem, read_mem, PCsrc, jump,Mem_to_reg,RegWrite, input logic[5:0] opcode,input logic[4:0] WriteReg,
      input logic [31:0] address, write_data, pc_if_branch_false, pc_if_branch_true, pc_if_jump,
      input logic[31:0] Memory[63:0],
      output logic [31:0] aluresult, read_data, pc_next,output logic[5:0] opcodeMo, output logic[4:0] writeReg,
      output logic memToReg,regWrite
    );
   
    

    logic [31:0] mem_index;

    // calculating next PC
    logic [31:0] pc_if_not_jump;
    
    pc_if_not_jump = PCsrc ? pc_if_branch_true : pc_if_branch_false;

    pc_next = jump ? pc_if_jump : pc_if_not_jump;                     // Final pc
    
    opcodeMo=opcode;
    mem_index=address;
    memToReg = Mem_to_reg;
    regWrite = RegWrite;
    writeReg = WriteReg;
    aluresult = address;                            // to pass aluresult because aluresult is required in writeback unit

    // Writing data in memory 
    if (write_mem) begin
      Memory[mem_index] = write_data;
    end

    // Reading data from memory
      if (read_mem) begin
      read_data = Memory[mem_index];
      end
    
    return Memory;

  endfunction

endmodule