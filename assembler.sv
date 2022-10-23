module Assembler(output logic[31:0] instruction_mem[63:0]);
  
  function string trim(string s);                // so that blank spaces in the instruction do not create any problem
    int l,startc,endc,lett;
    string t;
    l = s.len();
    startc=0;
    endc = l-1;
    lett = 0;
    foreach(s[i]) begin
      if(s[i]==" ")begin
        if(lett==0)begin
          startc = startc+1;
        end else begin
          endc = endc-1;
        end
      end else begin
        lett = 1;
      end
    end
    t = s.substr(startc,endc);
    return t;
  endfunction
  
  
  function logic[31:0] str_to_logic(string s);     // to convert string into bitset
    logic[31:0] answer;
    foreach (s[i]) begin
      if (s[i] == "1")
        answer[31-i] = 1;
      else
        answer[31-i] = 0;
    end
    return answer;
  endfunction

  
  function string to_binary(string s, int k);        // to convert a string with number into a string with binary representation of that number
    int a;
    int b;
    string ans;
    string temp;
    string q;
    a= s.atoi();
    ans="";
    while(a>0)begin
      b = (a%2);
      temp.itoa(b);
      ans = {temp, ans};
      a = a/2;
      k = k-1;
    end
    q = {k{"0"}};
    ans = {q,ans};
    return ans;
  endfunction
  
  
  function int index(string s1,s2);                
        int l1,l2;
        l1 = s1.len();
        l2 = s2.len();
        if( l2 > l1 )
        return -1;
        for(int i = 0;i < l1 - l2 + 1; i ++) begin
            if( s1.substr(i,i+l2 -1) == s2)
              return (i+l2-1);
        end
      index=-1;
    endfunction
  
  
    function string split(string s, string x);           
        int l;
        l = s.len();
        split="";
        foreach(s[i]) begin
            if(s[i]==x)begin
              s = s.substr(0,i-1);
                return s;
            end
        end
    endfunction
  
  
    function string strsplit(string s, string x);        
        int l;
        l = s.len();
        strsplit=s;
        foreach(s[i]) begin
            if(s[i]==x)begin
                s = s.substr(i+1,l-1);
                return s;
            end
        end
    endfunction
  
  
    function string parser(string s);                    // to convert assembly code into string of machine code
      	string operands, operand1, operand2, operand3;
      string keywords[10] = '{":","addi ","add ","sub ","beq ","lw ","sw ","mul ","j ","*end:"};
        int l;
        int ind = 0;
        foreach(keywords[i]) begin
            ind = index(s,keywords[i]);
            if(ind!=-1) begin
                if(keywords[i]=="addi ") begin
              		l = s.len()-1;
              		operands = s.substr(ind,l);
                  	operand1 = split(operands, ",");	//destination
                    operands = strsplit(operands,",");
                    operand1 = trim(operand1);
                    operand1 = operand1.substr(1,operand1.len()-1);
                    operand1 = to_binary(operand1,5);

                  	operand2 = split(operands, ",");	//source
                    operands = strsplit(operands,",");
                    operand2 = trim(operand2);
                    operand2 = operand2.substr(1,operand2.len()-1);
                    operand2 = to_binary(operand2,5);

                    operand3 = operands;	//immediate
                    operand3 = trim(operand3);
                  	operand3 = to_binary(operand3,16);

                  return {"001000",operand2,operand1,operand3};
                end else if(keywords[i]=="add ") begin
              		l = s.len()-1;
              		operands = s.substr(ind,l);
                  	operand1 = split(operands, ",");	//destination
                    operands = strsplit(operands,",");
                    operand1 = trim(operand1);
                	operand1 = operand1.substr(1,operand1.len()-1);
                    operand1 = to_binary(operand1,5);
                    
                  	operand2 = split(operands, ",");	//source1
                    operands = strsplit(operands,",");
                    operand2 = trim(operand2);
                	operand2 = operand2.substr(1,operand2.len()-1);
                    operand2 = to_binary(operand2,5);

                    operand3 = operands;	//source2
                    operand3 = trim(operand3);
                	operand3 = operand3.substr(1,operand3.len()-1);
                    operand3 = to_binary(operand3,5);

                  return {"000000",operand2,operand3,operand1,"00000","100000"};
                end else if(keywords[i]=="sub ") begin
                    l = s.len()-1;
                    operands = s.substr(ind,l);
                    operand1 = split(operands, ",");
                    operands = strsplit(operands,",");
                    operand1 = trim(operand1);
                    operand1 = operand1.substr(1,operand1.len()-1);
                    operand1 = to_binary(operand1,5);

                    operand2 = split(operands, ",");
                    operands = strsplit(operands,",");
                    operand2 = trim(operand2);
                    operand2 = operand2.substr(1,operand2.len()-1);
                    operand2 = to_binary(operand2,5);

                    operand3 = operands;
                    operand3 = trim(operand3);
                	operand3 = operand3.substr(1,operand3.len()-1);
                    operand3 = to_binary(operand3,5);

                  return {"000000",operand2,operand3,operand1,"00000","100010"};
                end else if(keywords[i]=="mul ") begin
                    l = s.len()-1;
                    operands = s.substr(ind,l);
                    operand1 = split(operands, ",");
                    operands = strsplit(operands,",");
                    operand1 = trim(operand1);
                    operand1 = operand1.substr(1,operand1.len()-1);
                    operand1 = to_binary(operand1,5);
                    
                    operand2 = split(operands, ",");
                    operands = strsplit(operands,",");
                    operand2 = trim(operand2);
                    operand2 = operand2.substr(1,operand2.len()-1);
                    operand2 = to_binary(operand2,5);

                    operand3 = operands;
                    operand3 = trim(operand3);
                    operand3 = operand3.substr(1,operand3.len()-1);
                    operand3 = to_binary(operand3,5);

                  return {"000000",operand2,operand3,operand1,"00000","011000"};
                end else if(keywords[i]=="beq ") begin
                    l = s.len()-1;
                    operands = s.substr(ind,l);
                  	operand1 = split(operands, ",");	//source1
                    operands = strsplit(operands,",");
                    operand1 = trim(operand1);
                    operand1 = operand1.substr(1,operand1.len()-1);
                    operand1 = to_binary(operand1,5);
                    
                  	operand2 = split(operands, ",");	//source2
                    operands = strsplit(operands,",");
                    operand2 = trim(operand2);
                    operand2 = operand2.substr(1,operand2.len()-1);
                    operand2 = to_binary(operand2,5);

                    operand3 = operands;	//relative address
                    operand3 = trim(operand3);
                  	operand3 = to_binary(operand3,16);

                  return {"000100",operand1,operand2,operand3};
                end else if(keywords[i]=="lw ") begin
                    l = s.len()-1;
                    operands = s.substr(ind,l);
                  	operand1 = split(operands, ",");	//source2
                    operands = strsplit(operands,",");
                    operand1 = trim(operand1);
                    operand1 = operand1.substr(1,operand1.len()-1);
                    operand1 = to_binary(operand1,5);
                    
                  	operand2 = split(operands, "(");	//offset
                    operands = strsplit(operands,"(");
                    operand2 = trim(operand2);
                  	operand2 = to_binary(operand2,16);

                  	operand3 = split(operands, ")");	//source1
                    operands = strsplit(operands,")");
                    operand3 = trim(operand3);
                    operand3 = operand3.substr(1,operand3.len()-1);
                    operand3 = to_binary(operand3,5);

                  return {"100011",operand3,operand1,operand2};
                end else if(keywords[i]=="sw ") begin
                    l = s.len()-1;
                    operands = s.substr(ind,l);
                    operand1 = split(operands, ",");
                    operands = strsplit(operands,",");
                    operand1 = trim(operand1);
                    operand1 = operand1.substr(1,operand1.len()-1);
                    operand1 = to_binary(operand1,5);
                    
                    operand2 = split(operands, "(");
                    operands = strsplit(operands,"(");
                    operand2 = trim(operand2);
                  operand2 = to_binary(operand2,16);

                    operand3 = split(operands, ")");
                    operands = strsplit(operands,")");
                    operand3 = trim(operand3);
                    operand3 = operand3.substr(1,operand3.len()-1);
                    operand3 = to_binary(operand3,5);

                  return {"101011",operand3,operand1,operand2};  
                end else if(keywords[i]=="j ") begin
                    l = s.len()-1;
                    operands = s.substr(ind,l);
                    operand1 = operands;	//jump addr
                    operand1 = trim(operand1);
                  operand1 = to_binary(operand1,26);

                  return {"000010",operand1};   //j
                end else if(keywords[i]=="*end:") begin
                  return {"11111111111111111111111111111111"}; //*end:
                end 
            end
        end
      parser=s;
    endfunction

  
    initial begin
        int assembly_code;
        string line, out_line;
        string p;
      	logic[31:0] instr;
      	int ct = 0;
      	
        assembly_code = $fopen("input.txt","r");            // taking assembly code from input.txt

        while(!$feof(assembly_code)) begin
            $fgets(line,assembly_code);
            out_line = parser(line);
          	instr = str_to_logic(out_line);
          	instruction_mem[ct] = instr;                    // storing machine code into instruction_mem
          	ct = ct+1;
        end
        for(int i=0; i<(64-ct); i++) begin
            instruction_mem[ct + i] = 32'b11111111111111111111111111111111;// storing redundant *end: signals in remaining intruction_mem locations
        end

        $fclose(assembly_code);
    end
  
endmodule