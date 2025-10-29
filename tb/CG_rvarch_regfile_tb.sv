module CG_rvarch_regfile_tb;

  logic         i_clk = 0;
  logic [4:0]   i_rs1_addr;
  logic [31:0]  o_rs1_data;
  logic [4:0]   i_rs2_addr;
  logic [31:0]  o_rs2_data;
  logic [4:0]   i_rd_addr;
  logic [31:0]  i_rd_data;
  logic         i_rd_we;

  always #1 begin
    i_clk <= ~i_clk;
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, DUT);
  end

  CG_rvarch_regfile #(
    .DATA_WIDTH (32),
    .DATA_NUM   (32)
  ) DUT (
    .i_clk      (i_clk      ),
    .i_rs1_addr (i_rs1_addr ),
    .o_rs1_data (o_rs1_data ),
    .i_rs2_addr (i_rs2_addr ),
    .o_rs2_data (o_rs2_data ),
    .i_rd_addr  (i_rd_addr  ),
    .i_rd_we    (i_rd_we    ),
    .i_rd_data  (i_rd_data  )
  );

  initial begin
    #2
    i_rd_we   = 1'b1;
    i_rd_addr = 5'b00001;
    i_rd_data = 32'h0000_0810;
    #2
    i_rd_we   = '0;
    i_rd_addr = '0;
    i_rd_data = '0;
    #2
    i_rs1_addr = 5'b00001;
    #2
    i_rs1_addr = 5'b00000;
    #2
    i_rs1_addr = 5'b00010;
    i_rd_we   = 1'b1;
    i_rd_addr = 5'b00010;
    i_rd_data = 32'h0000_0514;
    #2
    i_rd_we   = '0;
    i_rd_addr = '0;
    i_rd_data = '0;
    #10
    $finish;
  end

endmodule
