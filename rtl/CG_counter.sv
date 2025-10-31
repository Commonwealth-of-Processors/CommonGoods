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

  logic r_rstn;
  logic [DATA_WIDTH-1:0]  w_count;

  always_comb begin
    if(!r_rstn) begin
      w_count = '0;
    end else begin
      w_count = o_count + 1;
    end
  end

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      o_count <= '0;
    end else if (i_prst) begin
      o_count <= i_default;
    end else if (i_stop) begin
      o_count <= o_count;
    end else begin
      o_count <= w_count;
    end
    r_rstn  <= i_rstn;
  end

endmodule
`default_nettype wire
