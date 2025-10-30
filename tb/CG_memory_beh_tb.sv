module CG_memory_beh_tb;

  CG_memory_interface #(
    .DATA_WIDTH (32 ),
    .ADDR_WIDTH (32 )
  ) if_mem ();

  always #1 begin
    if_mem.clk <= ~if_mem.clk;
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
    if_mem.wen    = 1'b1;
    if_mem.wvalid = 1'b1;
    if_mem.waddr  = 32'h0000_0514;
    if_mem.wdata  = 32'h0000_0114;
    #2
    if_mem.wen    = '0;
    if_mem.wvalid = '0;
    if_mem.waddr  = '0;
    if_mem.wdata  = '0;
    #2
    if_mem.wen    = 1'b1;
    if_mem.wvalid = 1'b1;
    if_mem.waddr  = 32'h0000_0515;
    if_mem.wdata  = 32'h0000_0214;
    #2
    if_mem.wen    = '0;
    if_mem.wvalid = '0;
    if_mem.waddr  = '0;
    if_mem.wdata  = '0;
    #2
    if_mem.wen    = 1'b1;
    if_mem.wvalid = 1'b1;
    if_mem.waddr  = 32'h0000_0516;
    if_mem.wdata  = 32'hAAAA_AAAA;
    #2
    if_mem.wen    = '0;
    if_mem.wvalid = '0;
    if_mem.waddr  = '0;
    if_mem.wdata  = '0;
    #2
    if_mem.arvalid  = 1'b1;
    if_mem.araddr   = 32'h0000_0514;
    if_mem.rready   = 1'b1;
    #2
    if_mem.arvalid  = '0;
    if_mem.araddr   = '0;
    if_mem.rready   = '0;
    #2
    if_mem.arvalid  = 1'b1;
    if_mem.araddr   = 32'h0000_0516;
    if_mem.rready   = 1'b1;
    if_mem.wen    = 1'b1;
    if_mem.wvalid = 1'b1;
    if_mem.waddr  = 32'h0000_0516;
    if_mem.wdata  = 32'h0000_0314;
    #2
    if_mem.arvalid  = '0;
    if_mem.araddr   = '0;
    if_mem.rready   = '0;
    if_mem.wen    = '0;
    if_mem.wvalid = '0;
    if_mem.waddr  = '0;
    if_mem.wdata  = '0;
    #2
    if_mem.arvalid  = 1'b1;
    if_mem.araddr   = 32'h0000_0516;
    if_mem.rready   = 1'b1;
    #2
    if_mem.arvalid  = '0;
    if_mem.araddr   = '0;
    if_mem.rready   = '0;
    #10
    $finish;
  end

endmodule
