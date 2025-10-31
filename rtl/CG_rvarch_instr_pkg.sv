package CG_rvarch_instr_field_pkg;
  parameter INSTR_WIDTH = 32;

  parameter OPCODE_LOAD     = 7'b00_000_11;
  parameter OPCODE_LOAD_FP  = 7'b00_001_11;
  parameter OPCODE_CUSTOM_0 = 7'b00_010_11;
  parameter OPCODE_MISC_MEM = 7'b00_011_11;
  parameter OPCODE_OP_IMM   = 7'b00_100_11;
  parameter OPCODE_AUIPC    = 7'b00_101_11;
  parameter OPCODE_OP_IMM_32= 7'b00_110_11;

  parameter OPCODE_STORE    = 7'b01_000_11;
  parameter OPCODE_STORE_FP = 7'b01_001_11;
  parameter OPCODE_CUSTOM_1 = 7'b01_010_11;
  parameter OPCODE_AMO_FP   = 7'b01_011_11;
  parameter OPCODE_OP       = 7'b01_100_11;
  parameter OPCODE_LUI      = 7'b01_101_11;
  parameter OPCODE_OP_32    = 7'b01_110_11;

  parameter OPCODE_MADD     = 7'b10_000_11;
  parameter OPCODE_MSUB     = 7'b10_001_11;
  parameter OPCODE_NMSUB    = 7'b10_010_11;
  parameter OPCODE_NMADD    = 7'b10_011_11;
  parameter OPCODE_OP_FP    = 7'b10_100_11;
  parameter OPCODE_OP_V     = 7'b10_101_11;
  parameter OPCODE_CUSTOM_2 = 7'b10_110_11;

  parameter OPCODE_BRANCH   = 7'b11_000_11;
  parameter OPCODE_JALR     = 7'b11_001_11;
  parameter OPCODE_RESERVED = 7'b11_010_11;
  parameter OPCODE_JAL      = 7'b11_011_11;
  parameter OPCODE_SYSTEM   = 7'b11_100_11;
  parameter OPCODE_OP_VE    = 7'b11_101_11;
  parameter OPCODE_CUSTOM_3 = 7'b11_110_11;

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

  function automatic is_rd_opcode (input [INSTR_WIDTH-1:0] i_instr);
    case(opcode(i_instr))
      OPCODE_LOAD   : is_rd_opcode  = 1'b1;
      OPCODE_OP_IMM : is_rd_opcode  = 1'b1;
      OPCODE_AUIPC  : is_rd_opcode  = 1'b1;
      OPCODE_OP     : is_rd_opcode  = 1'b1;
      OPCODE_LUI    : is_rd_opcode  = 1'b1;
      OPCODE_JAL    : is_rd_opcode  = 1'b1;
      OPCODE_JALR   : is_rd_opcode  = 1'b1;
      default       : is_rd_opcode  = 1'b0;
    endcase
  endfunction
endpackage
