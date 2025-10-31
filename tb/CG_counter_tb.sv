module CG_counter_tb;

  logic i_clk   = 0;
  logic i_rstn  = 1;
  logic i_prst  = 0;
  logic i_stop  = 0;
  logic [31:0]  i_default = 32'h0404_0202;
  logic [31:0]  w_count;

  CG_counter  #(
    .DATA_WIDTH (32 )
  ) if_mem (
    .i_clk      (i_clk  ),
    .i_rstn     (i_rstn ),
    .i_prst     (i_prst ),
    .i_stop     (i_stop ),
    .i_default  (i_default),
    .o_count    (w_count)
  );

  always #1 begin
    i_clk <= ~i_clk;
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, DUT);
  end

  logic [31:0]  r_buf;

  always_ff @(posedge i_clk) begin
    r_buf <= w_count + 1;
  end

  initial begin
    i_rstn  = 1'b1;
    #2
    i_rstn  = 1'b0;
    #2
    i_rstn  = 1'b1;
    #20
    i_prst  = 1'b1;
    #2
    i_prst  = 1'b0;
    #20
    $finish;
  end

endmodule
