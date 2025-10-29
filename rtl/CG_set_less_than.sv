`default_nettype none
module CG_set_less_than #(
  parameter DATA_WIDTH  = 32
)(
  input  logic [DATA_WIDTH-1:0] i_data_rhs,
  input  logic [DATA_WIDTH-1:0] i_data_lhs,
  output logic o_data
);

  always_comb begin
    o_data  = $signed(i_data_lhs) < $signed(i_data_rhs);
  end

endmodule
`default_nettype wire
