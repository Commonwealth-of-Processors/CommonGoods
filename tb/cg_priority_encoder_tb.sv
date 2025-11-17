module cg_priority_encoder_tb;

  logic [15:0] bits;

  cg_priority_encoder #(
    .BITS_WIDTH (16 )
  ) DUT (
    .i_bits (bits),
    .o_index(),
    .o_en   ()
  );

  initial begin
    $dumpfile("wave.fst");
    $dumpvars(0, DUT);
  end

  initial begin
    bits = 16'b0000_0000_0000_0000;
    #1
    bits = 16'b0000_0000_0000_0001;
    #1
    bits = 16'b0000_0000_0000_0011;
    #1
    bits = 16'b0000_0000_0000_0100;
    #1
    bits = 16'b0000_0000_0000_1000;
    #1
    bits = 16'b0000_0000_0001_1000;
    #1
    bits = 16'b0000_0000_0010_0000;
    #1
    bits = 16'b0000_0000_0100_0000;
    #1
    $finish;
  end

endmodule
