module decode_main;
  
  // Setting the values of the variables according to the 32 bits of the instruction after posedge
  function void decode(input logic[31:0] instr,output logic[5:0] opcode,output logic[4:0] rs,output logic[4:0] rt,output logic[4:0] rd,output logic[4:0] shamt,output logic[5:0] funct,output logic[15:0] imm_addr,output logic[31:0] jump_address);
    opcode=instr[31:26];
    rs=instr[25:21];
    rt=instr[20:16];
    rd=instr[15:11];
    shamt=instr[10:6];
    funct=instr[5:0];
    imm_addr=instr[15:0];
    jump_address={4'b0,instr[25:0],2'b0};// this is similar to shifting left by 2 
  endfunction
  
  //Setting up the control signals after posedge
  function void control(input logic[5:0] opD, output logic RegDstD,output logic MemtoRegD, BranchD, MemReadD, output logic[1:0] ALUOpD,output logic MemWriteD, ALUSrcD, RegWriteD, jumpD);
    	logic[9:0] controls;
        case(opD)
            6'b000000: controls = 10'b1001000100; //r
            6'b100011: controls = 10'b0111100000; //lw
            6'b101011: controls = 10'b0100010000; //sw
            6'b000100: controls = 10'b0000001010; //beq
            6'b000010: controls = 10'b0000000001; //j
          	6'b001000: controls = 10'b0101000110; //addi
            default:   controls = 10'bxxxxxxxxxx;
        endcase
    	{RegDstD, ALUSrcD, MemtoRegD, RegWriteD, MemReadD, MemWriteD, BranchD, ALUOpD, jumpD} = controls;
    endfunction
  
  // to decide if the destination register is rt or rd after posedge
  function void writeRegMux(input logic [4:0] rt,input logic[4:0] rd,input logic RegDst,output logic [4:0] writeReg);
  	writeReg=RegDst?rd:rt;
  endfunction
  
  // setting up the value of read_data1 and read_data2 on each negedge
  function void RegFile(input logic[4:0] rs,rt,output logic[31:0] rd1,rd2,input logic[31:0] regFile[31:0]);
    rd1 = (rs!=0) ? regFile[rs] : 0;
    rd2 = (rt!=0) ? regFile[rt] : 0;
  endfunction
  
  // for sign-extension (after posedge)
  function void signext(input logic[15:0] a, output logic [31:0] signextended);
    if(a[15]==0) begin
      signextended={16'b0,a};
    end
    else begin
      signextended={16'b1,a};
    end
  endfunction
  
  // because addresses consist of 4 bytes (32 bits), we multiply the sign-extended value by 4 (or left-shift by 2) 
  function void shiftleft2(input logic [31:0] signextended, output logic [31:0] shifted);
	shifted= signextended << 2;
  endfunction
  
endmodule