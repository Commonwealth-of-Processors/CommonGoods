module CG_memory_beh_tb;

  logic i_clk = 0;

  CG_memory_interface #(
    .DATA_WIDTH (32 ),
    .ADDR_WIDTH (32 )
  ) if_mem (
    .i_clk  (i_clk  ),
    .i_rstn (1'b1   )
  );

  always #1 begin
    i_clk <= ~i_clk;
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, DUT);
  end

  CG_memory_beh #(
    .DATA_WIDTH (32   ),
    .ADDR_WIDTH (32   ),
    .WORD_NUM   (1024 )
  ) DUT (
    .if_mem (if_mem )
  );

  initial begin
    if_mem.wen          = 1'b1;
    if_mem.wdata_valid  = 1'b1;
    if_mem.waddr        = 32'h0000_0514;
    if_mem.wdata        = 32'h0000_0114;
    #2
    if_mem.wen          = '0;
    if_mem.wdata_valid  = '0;
    if_mem.waddr        = '0;
    if_mem.wdata        = '0;
    #2
    if_mem.wen          = 1'b1;
    if_mem.wdata_valid  = 1'b1;
    if_mem.waddr        = 32'h0000_0515;
    if_mem.wdata        = 32'h0000_0214;
    #2
    if_mem.wen          = '0;
    if_mem.wdata_valid  = '0;
    if_mem.waddr        = '0;
    if_mem.wdata        = '0;
    #2
    if_mem.wen          = 1'b1;
    if_mem.wdata_valid  = 1'b1;
    if_mem.waddr        = 32'h0000_0516;
    if_mem.wdata        = 32'hAAAA_AAAA;
    #2
    if_mem.wen          = '0;
    if_mem.wdata_valid  = '0;
    if_mem.waddr        = '0;
    if_mem.wdata        = '0;
    #2
    if_mem.raddr_valid  = 1'b1;
    if_mem.raddr        = 32'h0000_0514;
    if_mem.rdata_ready  = 1'b1;
    #2
    if_mem.raddr_valid  = '0;
    if_mem.raddr        = '0;
    if_mem.rdata_ready  = '0;
    #2
    if_mem.raddr_valid  = 1'b1;
    if_mem.raddr        = 32'h0000_0516;
    if_mem.rdata_ready  = 1'b1;
    if_mem.wen          = 1'b1;
    if_mem.wdata_valid  = 1'b1;
    if_mem.waddr        = 32'h0000_0516;
    if_mem.wdata        = 32'h0000_0314;
    #2
    if_mem.raddr_valid  = '0;
    if_mem.raddr        = '0;
    if_mem.rdata_ready  = '0;
    if_mem.wen          = '0;
    if_mem.wdata_valid  = '0;
    if_mem.waddr        = '0;
    if_mem.wdata        = '0;
    #2
    if_mem.raddr_valid  = 1'b1;
    if_mem.raddr        = 32'h0000_0516;
    if_mem.rdata_ready  = 1'b1;
    #2
    if_mem.raddr_valid  = '0;
    if_mem.raddr        = '0;
    if_mem.rdata_ready  = '0;
    #10
    $finish;
  end

endmodule
