`default_nettype none
module CG_memory_beh #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32,
  parameter WORD_NUM   = 1024
)(
  CG_memory_interface.from_memory mem_if
);

  localparam REAL_ADDR_WIDTH = $clog2(WORD_NUM);

  logic [DATA_WIDTH-1:0] mem [WORD_NUM-1:0];

  always_comb begin
    mem_if.wready  = 1'b1;
    mem_if.arready = mem_if.rready;
  end

  always_ff @(posedge mem_if.clk) begin
    if (mem_if.wen && mem_if.wvalid) begin
      mem[mem_if.waddr[REAL_ADDR_WIDTH-1:0]] <= mem_if.wdata;
    end
    mem_if.rvalid <= mem_if.arvalid;
    mem_if.rdata  <= mem[mem_if.araddr];
  end

endmodule
`default_nettype wire
