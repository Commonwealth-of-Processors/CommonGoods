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
  logic                    o_tlb_miss;
  logic [VADDR_WIDTH-1:0]  o_tlb_miss_vaddr;
  logic                    i_ptw_valid;
  logic [PADDR_WIDTH-1:0]  i_ptw_paddr;

  cg_tlb_fullyassociative DUT (
    .i_clk  (i_clk  ),
    .i_rstn (i_rstn ),

    .i_vaddr_valid    (i_vaddr_valid  ),
    .i_vaddr          (i_vaddr        ),
    .i_asid           ('0),
    .o_paddr_valid    (o_paddr_valid  ),
    .o_paddr          (o_paddr        ),

    .o_tlb_miss       (o_tlb_miss     ),
    .o_tlb_miss_vaddr (o_tlb_miss_vaddr),
    .i_ptw_valid      (i_ptw_valid    ),
    .i_ptw_paddr      (i_ptw_paddr    )
  );

  always #1 begin
    i_clk <= ~i_clk;
  end

  initial begin
    $dumpfile("wave.fst");
    $dumpvars(0, DUT);
  end

  initial begin
    i_rstn  = 1'b1;
    i_vaddr_valid = 1'b0;
    i_ptw_valid   = 1'b0;
    #2
    i_rstn  = 1'b0;
    #2
    i_rstn  = 1'b1;
    #2
    i_vaddr_valid = 1'b1;
    i_vaddr       = 39'h0be_efca_fe14;
    #20
    i_ptw_valid   = 1'b1;
    i_ptw_paddr   = 56'hca_feca_5151_8000;
    #2
    i_ptw_valid   = 1'b0;
    i_ptw_paddr   = '0;
    #2
    i_vaddr_valid = 1'b0;
    i_vaddr       = '0;
    #2
    i_vaddr_valid = 1'b1;
    i_vaddr       = 39'h0be_efca_fe14;
    #2
    i_vaddr_valid = 1'b0;
    #4
    i_vaddr_valid = 1'b1;
    i_vaddr       = 39'h022_3333_4444;
    #4
    i_ptw_valid   = 1'b1;
    i_ptw_paddr   = 56'h11_1111_1111_1000;
    #2
    i_ptw_valid   = 1'b0;
    i_ptw_paddr   = '0;
    #2
    #10
    $finish;
  end

endmodule
