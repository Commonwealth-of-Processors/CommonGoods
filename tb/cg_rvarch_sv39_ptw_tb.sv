module cg_rvarch_sv39_ptw_tb;
  parameter ADDR_WIDTH  = 64;
  parameter VADDR_WIDTH = 39;
  parameter PADDR_WIDTH = 56;
  parameter DATA_WIDTH  = 64;
  parameter ATTR_WIDTH  = 11;

  logic i_clk   = 0;
  logic i_rstn  = 1;

  // Core Interface
  logic [DATA_WIDTH-1:0] i_satp;
  logic                  o_page_fault;

  // PTW Interface
  logic                    i_tlb_miss;
  logic [VADDR_WIDTH-1:0]  i_tlb_miss_vaddr;
  logic                    o_ptw_valid;
  logic [PADDR_WIDTH-1:0]  o_ptw_paddr;

  cg_memory_interface #(
    .DATA_WIDTH (DATA_WIDTH ),
    .ADDR_WIDTH (ADDR_WIDTH )
  ) if_mem ();

  cg_rvarch_sv39_ptw DUT (
    .i_clk  (i_clk  ),
    .i_rstn (i_rstn ),

    .i_satp       (i_satp       ),
    .o_page_fault (o_page_fault ),

    .if_mem       (if_mem ),

    .i_tlb_miss       (i_tlb_miss     ),
    .i_tlb_miss_vaddr (i_tlb_miss_vaddr),
    .o_ptw_valid      (o_ptw_valid    ),
    .o_ptw_paddr      (o_ptw_paddr    ),
    .o_ptw_pte_attr   ('0)
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
    $finish;
  end

endmodule
