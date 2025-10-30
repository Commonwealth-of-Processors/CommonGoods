`default_nettype none
module CG_memory_beh #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32,
  parameter WORD_NUM   = 1024
)(
  CG_memory_interface.from_memory if_mem
);

  localparam REAL_ADDR_WIDTH = $clog2(WORD_NUM);

  logic [DATA_WIDTH-1:0] mem [WORD_NUM-1:0];

  always_comb begin
    if_mem.wready  = 1'b1;
    if_mem.arready = if_mem.rready;
  end

  always_ff @(posedge if_mem.clk) begin
    if (if_mem.wen && if_mem.wvalid) begin
      mem[if_mem.waddr[REAL_ADDR_WIDTH-1:0]] <= if_mem.wdata;
    end
    if_mem.rvalid <= if_mem.arvalid;
    if_mem.rdata  <= mem[if_mem.araddr];
  end

endmodule
`default_nettype wire
