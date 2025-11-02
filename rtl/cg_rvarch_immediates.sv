`default_nettype none
module cg_rvarch_immediates #(
  parameter INSTR_WIDTH = 32,
  parameter DATA_WIDTH  = 32
)(
  input  logic [INSTR_WIDTH-1:0]  i_instr,
  output logic [DATA_WIDTH-1:0]   o_i_immediate,
  output logic [DATA_WIDTH-1:0]   o_s_immediate,
  output logic [DATA_WIDTH-1:0]   o_b_immediate,
  output logic [DATA_WIDTH-1:0]   o_u_immediate,
  output logic [DATA_WIDTH-1:0]   o_j_immediate
);

  always_comb begin
    o_i_immediate = DATA_WIDTH'(signed'({i_instr[31], i_instr[30:25], i_instr[24:21], i_instr[20]}));
    o_s_immediate = DATA_WIDTH'(signed'({i_instr[31], i_instr[30:25], i_instr[11:8], i_instr[7]}));
    o_b_immediate = DATA_WIDTH'(signed'({i_instr[31], i_instr[7], i_instr[30:25], i_instr[11:8], 1'b0}));
    o_u_immediate = DATA_WIDTH'(signed'({i_instr[31], i_instr[30:20], i_instr[19:12], 11'b000_0000_0000}));
    o_j_immediate = DATA_WIDTH'(signed'({i_instr[31], i_instr[19:12], i_instr[20], i_instr[30:25], i_instr[24:21], 1'b0}));
  end

endmodule
`default_nettype wire
