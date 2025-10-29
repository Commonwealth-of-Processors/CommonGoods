`default_nettype none
module CG_shifter_arithmetic_right #(
  parameter DATA_WIDTH  = 32
)(
  input  logic [DATA_WIDTH-1:0] i_data_lhs,
  input  logic [DATA_WIDTH-1:0] i_data_rhs,
  output logic [DATA_WIDTH-1:0] o_data
);

  always_comb begin
    o_data = i_data_lhs >>> i_data_rhs;
  end

endmodule
`default_nettype wire
