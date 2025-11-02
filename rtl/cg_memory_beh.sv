`default_nettype none
module cg_memory_beh #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32,
  parameter WORD_NUM   = 1024
)(
  cg_memory_interface.from_memory if_mem
);

  localparam REAL_ADDR_WIDTH = $clog2(WORD_NUM);

  logic [DATA_WIDTH-1:0] mem [WORD_NUM-1:0];

  always_comb begin
    if_mem.wdata_ready  = 1'b1;
    if_mem.raddr_ready  = if_mem.rdata_ready;
  end

  always_ff @(posedge if_mem.i_clk) begin
    if (if_mem.wen && if_mem.wdata_valid) begin
      mem[if_mem.waddr[REAL_ADDR_WIDTH-1:0]] <= if_mem.wdata;
    end
    if_mem.rdata_valid  <= if_mem.raddr_valid;
    if_mem.rdata        <= mem[if_mem.raddr];
  end

endmodule
`default_nettype wire
