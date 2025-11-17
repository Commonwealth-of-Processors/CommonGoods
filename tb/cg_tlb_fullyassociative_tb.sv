module cg_tlb_fullyassociative_tb;
  parameter VADDR_WIDTH   = 39;
  parameter PADDR_WIDTH   = 56;
  parameter ASID_WIDTH    = 16;

  logic i_clk   = 0;
  logic i_rstn  = 1;

  // Core Interface
  logic                    i_vaddr_valid;
  logic [VADDR_WIDTH-1:0]  i_vaddr;
  logic [ASID_WIDTH-1:0]   i_asid;
  logic                    o_paddr_valid;
  logic [PADDR_WIDTH-1:0]  o_paddr;

  // PTW Interface
  logic o_tlb_miss;

  cg_tlb_fullyassociative DUT (
    .i_clk  (i_clk  ),
    .i_rstn (i_rstn ),
    .i_vaddr_valid  (i_vaddr_valid  ),
    .i_vaddr        (i_vaddr        ),
    .i_asid         ('0),
    .o_paddr_valid  (),
    .o_paddr        (),
    .o_tlb_miss     ()
  );

  always #1 begin
    i_clk <= ~i_clk;
  end

  initial begin
    $dumpfile("wave.vcd");
    $dumpvars(0, DUT);
  end

  initial begin
    i_rstn  = 1'b1;
    i_vaddr_valid = 1'b0;
    #2
    i_rstn  = 1'b0;
    #2
    i_rstn  = 1'b1;
    #2
    i_vaddr_valid = 1'b1;
    i_vaddr       = '1;
    #20
    $finish;
  end

endmodule
