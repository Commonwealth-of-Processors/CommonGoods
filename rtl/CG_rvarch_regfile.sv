`default_nettype none
module CG_rvarch_regfile #(
  parameter DATA_WIDTH  = 32,
  parameter DATA_NUM    = 32
)(
  input  logic  i_clk,
  
  input  logic  [$clog2(DATA_NUM)-1:0]  i_rs1_addr,
  output logic  [DATA_WIDTH-1:0]        o_rs1_data,

  input  logic  [$clog2(DATA_NUM)-1:0]  i_rs2_addr,
  output logic  [DATA_WIDTH-1:0]        o_rs2_data,

  input  logic  [$clog2(DATA_NUM)-1:0]  i_rd_addr,
  input  logic                          i_rd_we,
  output logic  [DATA_WIDTH-1:0]        i_rd_data
);

  logic [DATA_WIDTH-1:0]  mem [DATA_NUM-1:0];

  always_comb begin
    if(i_rs1_addr == '0) begin
      o_rs1_data  = '0;
    end else begin
      o_rs1_data  = mem[i_rs1_addr];
    end

    if(i_rs2_addr == '0) begin
      o_rs2_data  = '0;
    end else begin
      o_rs2_data  = mem[i_rs2_addr];
    end
  end

  always_ff @(posedge i_clk) begin
    if (i_rd_we) begin
      mem[i_rd_addr]  <= i_rd_data;
    end
  end

endmodule
`default_nettype wire
