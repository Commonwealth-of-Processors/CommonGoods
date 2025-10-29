`default_nettype none
module CG_counter #(
  parameter DATA_WIDTH = 32
)(
  input  logic i_clk,
  input  logic i_rstn,
  input  logic i_prst,
  input  logic i_stop,
  input  logic [DATA_WIDTH-1:0] i_default,
  output logic [DATA_WIDTH-1:0] o_count
);

  logic [DATA_WIDTH-1:0]  w_count;
  logic [DATA_WIDTH-1:0]  r_count;

  always_comb begin
    w_count = r_count + 1;
  end

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      r_count <= '0;
    end else if (i_prst) begin
      r_count <= i_default;
    end else if (i_stop) begin
      r_count <= r_count;
    end else begin
      r_count <= w_count;
    end
  end

endmodule
`default_nettype wire
