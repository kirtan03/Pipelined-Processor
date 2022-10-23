
module exec_main;
  
  function void exec(input logic RegDstE_in,MemtoRegE_in,BranchE_in,MemReadE_in,MemWriteE_in,ALUSrcE_in,RegWriteE_in,jumpE_in,
                     input logic[1:0] ALUOpE,
                     input logic[31:0] rsE_in, rtE_in, rdE_in, rDE_in, read_data1E, read_data2E_in, rel_branch_addressE, signextended_dataE, pcplus4E_in,jump_addrE_in, 
                     input logic[5:0] functE,opcode_in,
                     output logic RegDstE_out,MemtoRegE_out,BranchE_out, MemReadE_out, MemWriteE_out, ALUSrcE_out, RegWriteE_out, jumpE_out,
                     output logic[31:0] jump_addrE_out,effective_addressE,alu_outputE,pcplus4E_out, read_data2E_out,
                     output logic PCSrc, zeroFlag,
                     output logic[31:0] rsE_out,rtE_out,rdE_out, rDE_out,
                     output logic[5:0] opcode_out);
    
    logic[31:0] aluinput2;
    logic [3:0] alucontrolE;

    RegDstE_out = RegDstE_in;           // to pass the control signals from previous unit to next unit
    MemtoRegE_out = MemtoRegE_in;
    BranchE_out = BranchE_in;
    MemReadE_out = MemReadE_in;
    MemWriteE_out = MemWriteE_in;
    ALUSrcE_out = ALUSrcE_in;
    RegWriteE_out = RegWriteE_in;
    jumpE_out = jumpE_in;
    jump_addrE_out=jump_addrE_in;
    
    rsE_out = rsE_in;
    rtE_out = rtE_in;
    rdE_out = rdE_in;
  
  	pcplus4E_out = pcplus4E_in;
    
    read_data2E_out = read_data2E_in;
    rDE_out = rDE_in;
    
    opcode_out = opcode_in;
    
    
    // Setting ALU control using ALU OP
    case(ALUOpE)
      2'b00: alucontrolE = 4'b0010;//lw or sw
      2'b01: alucontrolE =4'b0110;//beq
      2'b11: alucontrolE =4'b0010;//addi
      default:
        case(functE)
          6'b100000: alucontrolE=4'b0010;//add
          6'b100010: alucontrolE=4'b0110;//sub
          6'b100100: alucontrolE=4'b0000;//and
          6'b100101: alucontrolE=4'b0001;//or
          6'b011000: alucontrolE=4'b0011;//mult
        endcase
    endcase
    
    aluinput2=ALUSrcE_in?signextended_dataE:read_data2E_in;
    
    case(alucontrolE)
      0: alu_outputE = read_data1E&aluinput2;
      1: alu_outputE = read_data1E|aluinput2;
      2: alu_outputE = read_data1E+aluinput2;
      3: alu_outputE = read_data1E*aluinput2;
      6: alu_outputE = read_data1E-aluinput2;    
    endcase
    
    // Zero flag to decide whether branch will be taken or not
    if (alu_outputE==0) begin
      zeroFlag=1;
    end
    else begin
      zeroFlag=0;
    end
    
    effective_addressE = rel_branch_addressE;
    PCSrc=zeroFlag & BranchE_in;
  endfunction
  
endmodule