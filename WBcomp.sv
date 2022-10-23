typedef logic[31:0] reg_array_type[];

module wrtbck_main;
 
 function reg_array_type wrtbck
    (
        input logic MemToReg,RegWrite,
        input logic [31:0]RDdata,ALUresult,
        input logic[4:0] writeReg,
        input logic[31:0] regFile[31:0]
    );

   logic[31:0] Result;                      //Implementing MemToReg multiplexer
   if(MemToReg)Result = RDdata;
   else Result = ALUresult;
          
   if(RegWrite) begin                      // Writing back into the destination register
     regFile[writeReg] = Result;
   end
   return regFile;
  
 endfunction
endmodule