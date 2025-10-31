package CG_rvarch_instr_field_pkg;
  parameter INSTR_WIDTH = 32;

  function automatic [6:0] opcode (input [INSTR_WIDTH-1:0] i_instr);
    opcode = i_instr[6:0];
  endfunction

  function automatic [4:0] rd (input [INSTR_WIDTH-1:0] i_instr);
    rd = i_instr[11:7];
  endfunction

  function automatic [2:0] funct3 (input [INSTR_WIDTH-1:0] i_instr);
    funct3 = i_instr[14:12];
  endfunction

  function automatic [4:0] rs1 (input [INSTR_WIDTH-1:0] i_instr);
    rs1 = i_instr[19:15];
  endfunction

  function automatic [4:0] rs2 (input [INSTR_WIDTH-1:0] i_instr);
    rs2 = i_instr[24:20];
  endfunction

  function automatic [6:0] funct7 (input [INSTR_WIDTH-1:0] i_instr);
    funct7 = i_instr[31:25];
  endfunction

  function automatic [31:0] i_imm32 (input [INSTR_WIDTH-1:0] i_instr);
    i_imm32 = 32'(signed'({i_instr[31], i_instr[30:25], i_instr[24:21], i_instr[20]}));
  endfunction
  
  function automatic [31:0] s_imm32 (input [INSTR_WIDTH-1:0] i_instr);
    s_imm32 = 32'(signed'({i_instr[31], i_instr[30:25], i_instr[11:8], i_instr[7]}));
  endfunction

  function automatic [31:0] b_imm32 (input [INSTR_WIDTH-1:0] i_instr);
    b_imm32 = 32'(signed'({i_instr[31], i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0}));
  endfunction

  function automatic [31:0] u_imm32 (input [INSTR_WIDTH-1:0] i_instr);
    u_imm32 = 32'(signed'({i_instr[31], i_instr[30:20], i_instr[19:12], 11'b000_0000_0000}));
  endfunction

  function automatic [31:0] j_imm32 (input [INSTR_WIDTH-1:0] i_instr);
    j_imm32 = 32'(signed'({i_instr[31], i_instr[19:12], i_instr[20], i_instr[30:25], i_instr[24:21], 1'b0}));
  endfunction

  function automatic [63:0] i_imm64 (input [INSTR_WIDTH-1:0] i_instr);
    i_imm64 = 64'(signed'({i_instr[31], i_instr[30:25], i_instr[24:21], i_instr[20]}));
  endfunction

  function automatic [63:0] s_imm64 (input [INSTR_WIDTH-1:0] i_instr);
    s_imm64 = 64'(signed'({i_instr[31], i_instr[30:25], i_instr[11:8], i_instr[7]}));
  endfunction

  function automatic [63:0] b_imm64 (input [INSTR_WIDTH-1:0] i_instr);
    b_imm64 = 64'(signed'({i_instr[31], i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0}));
  endfunction

  function automatic [63:0] u_imm64 (input [INSTR_WIDTH-1:0] i_instr);
    u_imm64 = 64'(signed'({i_instr[31], i_instr[30:20], i_instr[19:12], 11'b000_0000_0000}));
  endfunction

  function automatic [63:0] j_imm64 (input [INSTR_WIDTH-1:0] i_instr);
    j_imm64 = 64'(signed'({i_instr[31], i_instr[19:12], i_instr[20], i_instr[30:25], i_instr[24:21], 1'b0}));
  endfunction
endpackage
