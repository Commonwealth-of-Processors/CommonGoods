`default_nettype none
// MSB is MSB
module cg_priority_encoder #(
  parameter  BITS_WIDTH   = 16,
  localparam INDEX_WIDTH  = $clog2(BITS_WIDTH)
)(
  input  logic [BITS_WIDTH-1:0]   i_bits,
  output logic [INDEX_WIDTH-1:0]  o_index,
  output logic                    o_en
);

  always_comb begin
    o_index = '0;
    o_en    = '0;
    for(int i = 0; BITS_WIDTH > i; i = i + 1) begin
      if (i_bits[i]) begin
        o_index = i[INDEX_WIDTH-1:0];
      end
    end
    o_en = |i_bits;
  end

endmodule
`default_nettype wire
