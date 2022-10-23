`include "IFcomp.sv"
`include "IDcomp.sv"
`include "EXcomp.sv"
`include "DMcomp.sv"
`include "WBcomp.sv"
`include "assembler.sv"

module maindriver;
  
  logic clk;
  
  // Number of cycles and Number of cycles with stalling respectively (For CPI calc)
  real cycle_count, stalled_count;
  
  // Bools which represent whether stalling is being done at a particular time
  int stall_bit1, stall_bit2, stall_bit3,stall_bit4;
  
  logic[31:0] instruction_memory[63:0],pc;
  logic[31:0] data_memory[63:0], regFile[31:0];
  
  
  // Calling assembler module
  Assembler asmb(instruction_memory);
  
  
  // Initializing essential variables
  initial begin
    clk = 1;
    pc = 0;
    cycle_count = 0;
    stalled_count = 0;
    stall_bit1 = 0;
    stall_bit2 = 0;
    stall_bit3 = 0;
    stall_bit4 = 0;
    for(int i=0;i<64;i++) begin
      data_memory[i] <= 32'b00000000000000000000000000000000;
      regFile[i] <= 32'b00000000000000000000000000000000;
    end
    forever begin      
      #20 clk = ~clk;           
    end    
  end
  
  
  // Stopping the program if *end: is encountered in writeback stage
  always @(negedge clk) begin
    if(opcodeDMWB==6'b111111) #9 $stop;
  end
  
  
  
  
  
  
  
  // Declaring variables in IF-ID registers
  logic[31:0] pcplus4IFID, instIFID;
  
  
  // Declaring variables in ID-EX registers
  logic[31:0] pcplus4IDEX, read_data1IDEX, read_data2IDEX, signextendedIDEX, shiftedIDEX, jump_addrIDEX;
  logic[5:0] opcodeIDEX, functIDEX, shamtIDEX;
  logic[4:0] rsIDEX, rtIDEX, rdIDEX, rD_IDEX;
  logic[15:0] imm_addrIDEX;
  logic RegDstIDEX, MemtoRegIDEX, BranchIDEX, MemReadIDEX, MemWriteIDEX, ALUSrcIDEX, RegWriteIDEX, jumpIDEX;
  logic[1:0] ALUOpIDEX;
  
  
  // Declaring variables in EX-DM registers
  logic MemtoRegEXDM, BranchEXDM, MemReadEXDM, MemWriteEXDM, RegWriteEXDM, jumpEXDM, PCSrcEXDM, zeroEXDM, RegDstEXDM, ALUSrcEXDM;
  logic[31:0] eff_addrEXDM, jump_addrEXDM, alu_outputEXDM, pcplus4EXDM, read_data2EXDM;
  logic[4:0] rd_EXDM, rs_EXDM, rt_EXDM, rD_EXDM;
  logic[5:0] opcodeEXDM;
  
  
  // Declaring variables in DM-WB registers
  logic MemtoRegDMWB, RegWriteDMWB;
  logic[31:0] RDdataDMWB, ALUresultDMWB, pcplus4DMWB;
  logic[5:0] opcodeDMWB;
  logic[4:0] rd_DMWB;
  
  
  
  
  
  
  
  
  
  
  // Calling functions from fetch unit to fetch the respective instruction and saving the fetched instruction in IF-ID registers
  always @(posedge clk) begin
  	#8 fetch_main.instruction_mem(pc/4,instruction_memory, instIFID);
  	pc = fetch_main.adder(pc);
    pcplus4IFID = pc;
    cycle_count = cycle_count + 1;
  end
  
  
  // Calling functions from decode unit to decode the respective instruction, and saving the decoded parts in ID-EX registers
  always @(posedge clk) begin
      #5 decode_main.decode(instIFID,opcodeIDEX,rsIDEX,rtIDEX,rdIDEX,shamtIDEX,functIDEX,imm_addrIDEX,jump_addrIDEX);
      decode_main.control(opcodeIDEX,RegDstIDEX,MemtoRegIDEX, BranchIDEX, MemReadIDEX,ALUOpIDEX,MemWriteIDEX, ALUSrcIDEX, RegWriteIDEX, jumpIDEX);
      decode_main.writeRegMux(rtIDEX,rdIDEX,RegDstIDEX,rD_IDEX);
      decode_main.RegFile(rsIDEX,rtIDEX,read_data1IDEX, read_data2IDEX,regFile);
      decode_main.signext(imm_addrIDEX,signextendedIDEX);
      decode_main.shiftleft2(signextendedIDEX,shiftedIDEX);
      pcplus4IDEX=pcplus4IFID;
  end
  
  
  // Executing the respective instruction according to the control signals and the data read from registers in the decode stage
  // Also storing ALU output and Effective address in the EX-DM registers
  always @(posedge clk) begin
    #3 exec_main.exec(RegDstIDEX, MemtoRegIDEX, BranchIDEX, MemReadIDEX, MemWriteIDEX, ALUSrcIDEX, RegWriteIDEX, jumpIDEX, ALUOpIDEX, rsIDEX, rtIDEX,  rdIDEX, rD_IDEX, read_data1IDEX, read_data2IDEX, shiftedIDEX, signextendedIDEX, pcplus4IDEX, jump_addrIDEX, functIDEX, opcodeIDEX, RegDstEXDM, MemtoRegEXDM, BranchEXDM, MemReadEXDM, MemWriteEXDM, ALUSrcEXDM, RegWriteEXDM, jumpEXDM, jump_addrEXDM, eff_addrEXDM, alu_outputEXDM, pcplus4EXDM, read_data2EXDM, PCSrcEXDM, zeroEXDM, rs_EXDM, rt_EXDM, rd_EXDM, rD_EXDM, opcodeEXDM);
  end
  
  
  // Interacting with memory in form of read-write commands according to the control signals and ALU output
  // Also storing the data read from memory in DM-WB registers
  always @(posedge clk) begin
         #2  data_memory = DataMemoryMain.Data_Memory(MemWriteEXDM, MemReadEXDM, PCSrcEXDM, jumpEXDM, MemtoRegEXDM, RegWriteEXDM, opcodeEXDM, rD_EXDM, alu_outputEXDM, read_data2EXDM, pcplus4EXDM, eff_addrEXDM, jump_addrEXDM, data_memory, ALUresultDMWB, RDdataDMWB, pcplus4DMWB, opcodeDMWB, rd_DMWB, MemtoRegDMWB, RegWriteDMWB);
  end
  
  
  // Writing the data read from memory or ALU output in respective registers according to destination register and control signals
  always @(posedge clk) begin
    #1  regFile = wrtbck_main.wrtbck(MemtoRegDMWB, RegWriteDMWB, RDdataDMWB, ALUresultDMWB, rd_DMWB, regFile);
  end
  
  
  
  
  
  
  
  
  
  
  // Printing the data stored in first ten registers along with cycle number and current CPI
  always @(negedge clk) begin
    #8 $display("Cycle number = %0d",cycle_count);
    $display("Number of instructions executed = %0d",cycle_count - stalled_count);
    $display("Current CPI = %f",cycle_count/(cycle_count - stalled_count));
    $display("Program Counter = %0d",pc);
    $display("Register[0] = %0d",regFile[0]);
    $display("Register[1] = %0d",regFile[1]);
    $display("Register[2] = %0d",regFile[2]);
    $display("Register[3] = %0d",regFile[3]);
    $display("Register[4] = %0d",regFile[4]);
    $display("Register[5] = %0d",regFile[5]);
    $display("Register[6] = %0d",regFile[6]);
    $display("Register[7] = %0d",regFile[7]);
    $display("Register[8] = %0d",regFile[8]);
    $display("Register[9] = %0d",regFile[9]);
  end
  
  
  
  
  
  
  
  
  
  
  //stalling implementation

  //case 1: read after write in the very next instruction
  
  always @(negedge clk) begin
    #7 if((rD_EXDM == rsIDEX || rD_EXDM == rtIDEX) && ((opcodeEXDM == 6'b000000) || (opcodeEXDM == 6'b100011) || (opcodeEXDM == 6'b001000)) && (stall_bit2 == 0) && (stall_bit3 == 0) && (stall_bit4 == 0)) begin //for r and lw type instruction

          RegDstIDEX = 0;
          MemtoRegIDEX = 0;
          BranchIDEX = 0;
          MemReadIDEX = 0;
          MemWriteIDEX = 0;
          ALUSrcIDEX = 0;
          RegWriteIDEX = 0;
          jumpIDEX = 0;
          opcodeIDEX = 6'b000101;
          stall_bit1 = 1;                          // Setting stall bool = 1
      	  stalled_count = stalled_count + 1;       // Updating the number of stalled instructions
          pc = pc - 8;                             // pc is assigned value such that the same instruction is fetched again
    end
  end
  
   always @(negedge clk) begin
     #6 if(stall_bit1 == 1) begin
         RegDstIDEX = 0;
         MemtoRegIDEX = 0;
         BranchIDEX = 0;
         MemReadIDEX = 0;
         MemWriteIDEX = 0;
         ALUSrcIDEX = 0;
         RegWriteIDEX = 0;
         jumpIDEX = 0;
         stall_bit1 = 0;                           // Since stalling is now complete, we reset the stall bool to ensure normal flow
         stalled_count = stalled_count + 1;        // Updating the number of stalled instructions
      	 opcodeIDEX = 6'b000101;
    	end
    end
  
  
  //case 2: read after write in the second next instruction
  
    always @(negedge clk) begin
      #5 if((rd_DMWB == rsIDEX || rd_DMWB == rtIDEX) && ((opcodeDMWB == 6'b000000) || (opcodeDMWB == 6'b100011) || (opcodeDMWB == 6'b001000)) && (stall_bit1 == 0) && (stall_bit3 == 0) && (stall_bit4 == 0)) begin //for r and lw type instruction

          RegDstIDEX = 0;
          MemtoRegIDEX = 0;
          BranchIDEX = 0;
          MemReadIDEX = 0;
          MemWriteIDEX = 0;
          ALUSrcIDEX = 0;
          RegWriteIDEX = 0;
          jumpIDEX = 0;
          opcodeIDEX = 6'b000001;                 // Setting a random opcode to ensure that this dummy instruction does not stall other instructions
          stall_bit2  = 1;
          stalled_count = stalled_count + 1;
          pc = pc - 8;                            //pc is assigned value such that the same instruction is fetched again
        end
    end
  
  always @(negedge clk) begin
    #4 if((stall_bit2==1)) begin
         RegDstIDEX = 0;
         MemtoRegIDEX = 0;
         BranchIDEX = 0;
         MemReadIDEX = 0;
         MemWriteIDEX = 0;
         ALUSrcIDEX = 0;
         RegWriteIDEX = 0;
      	 jumpIDEX = 0;
         stall_bit2 = 0;
      	 stalled_count = stalled_count + 1;
      	 opcodeIDEX = 6'b000001;
    	end
    end
  
   
  // case 3: branch instruction
  
    always @(negedge clk) begin
      #3 if(PCSrcEXDM) begin                      // if branch is taken
          RegDstIDEX = 0;
          MemtoRegIDEX = 0;
          BranchIDEX = 0;
          MemReadIDEX = 0;
          MemWriteIDEX = 0;
          ALUSrcIDEX = 0;
          RegWriteIDEX = 0;
          jumpIDEX = 0;
          stall_bit3 = 1;
          stalled_count = stalled_count + 1;
          pc = eff_addrEXDM;                      // Setting the effective address as new pc
          opcodeIDEX = 6'b000001;
        end
    end
  
  
  
  always @(negedge clk) begin
    #2 if(stall_bit3==1) begin
         RegDstIDEX = 0;
         MemtoRegIDEX = 0;
         BranchIDEX = 0;
         MemReadIDEX = 0;
         MemWriteIDEX = 0;
         ALUSrcIDEX = 0;
         RegWriteIDEX = 0;
         jumpIDEX = 0;
         stall_bit3 = 0;
         stalled_count = stalled_count + 1;
      	 opcodeIDEX = 6'b000001;
    	end
    end
  
  //case 4: jump instruction
  
    always @(negedge clk) begin
      #1 if(jumpEXDM) begin                        // if jump control signal is 1
             RegDstIDEX = 0;
             MemtoRegIDEX = 0;
             BranchIDEX = 0;
             MemReadIDEX = 0;
             MemWriteIDEX = 0;
             ALUSrcIDEX = 0;
             RegWriteIDEX = 0;
             jumpIDEX = 0;
             stall_bit4 = 1;
             stalled_count = stalled_count + 1;
             pc = jump_addrEXDM;                     // Setting the jump address as the new pc
          	 opcodeIDEX = 6'b000001;
        end
    end
  
  
  
  always @(negedge clk) begin
    if(stall_bit4==1) begin
         RegDstIDEX = 0;
         MemtoRegIDEX = 0;
         BranchIDEX = 0;
         MemReadIDEX = 0;
         MemWriteIDEX = 0;
         ALUSrcIDEX = 0;
         RegWriteIDEX = 0;
         jumpIDEX = 0;
         stall_bit4=0;
         stalled_count = stalled_count + 1;
      	 opcodeIDEX = 6'b000001;
    	end
    end

endmodule