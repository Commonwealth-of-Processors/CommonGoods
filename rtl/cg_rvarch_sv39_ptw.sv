`default_nettype none
module cg_rvarch_sv39_ptw #(
  parameter ADDR_WIDTH  = 64,
  parameter VADDR_WIDTH = 39,
  parameter PADDR_WIDTH = 56,
  parameter DATA_WIDTH  = 64,
  parameter ATTR_WIDTH  = 11
)(
  input  logic i_clk,
  input  logic i_rstn,

  // Core Interface
  input  logic [DATA_WIDTH-1:0] i_satp,
  output logic                  o_page_fault,

  // Memory Interface
  cg_memory_interface.to_memory_ro  if_mem,

  // TLB Interface
  input  logic                    i_tlb_miss,
  input  logic [VADDR_WIDTH-1:0]  i_tlb_miss_vaddr,
  output logic                    o_ptw_valid,
  output logic [PADDR_WIDTH-1:0]  o_ptw_paddr,
  output logic [ATTR_WIDTH-1:0]   o_ptw_pte_attr
);

  logic w_ptw_valid;

  typedef enum {IDLE, PROC, MEM, ERR} state_t;
  state_t r_state;
  state_t w_state;

  logic [1:0] r_pt_lvl;
  logic [1:0] w_pt_lvl;

  logic [VADDR_WIDTH-1:0] w_target_va;
  logic [VADDR_WIDTH-1:0] r_target_va;

  logic [PADDR_WIDTH-1:0] r_concat_addr;
  logic [PADDR_WIDTH-1:0] w_concat_addr;

  logic [DATA_WIDTH-1:0]  w_pte;
  logic [DATA_WIDTH-1:0]  r_pte;

  logic [ATTR_WIDTH-1:0]  w_ptw_pte_attr;

  // PP
  // 00 : U
  // 01 : S
  // 11 : M

  always_comb begin
    case(r_state)
      IDLE: begin
        // TLB miss then walk start
        if (i_tlb_miss) begin
          w_state       = MEM;
          w_ptw_valid   = 1'b0;
          w_pt_lvl      = 2'b11;
          w_target_va   = i_tlb_miss_vaddr;
          // L3 PTE Address
          w_concat_addr = {i_satp[43:0], r_target_va[38:30], 3'b000};
        end else begin
          w_state       = IDLE;
          w_ptw_valid   = o_ptw_valid;
        end
        if_mem.raddr_valid  = 1'b0;
      end
      PROC: begin
        // PTE.V Check
        if (r_pte[0] == 1'b1) begin
          // Leaf PTE Check
          if (|r_pte[3:1]) begin
            // Calculate PA
            w_ptw_valid = 1'b1;
            w_state     = IDLE;
            case(r_pt_lvl)
              // Gigapage
              2'b10:  begin
                w_concat_addr = {r_pte[53:28], r_target_va[29:0]};
              end
              // Megapage
              2'b01:  begin
                w_concat_addr = {r_pte[53:19], r_target_va[20:0]};
              end
              // page
              2'b00:  begin
                w_concat_addr = {r_pte[53:10], r_target_va[11:0]};
              end
              // must not be reach here
              default: begin
                w_state       = ERR;
                w_ptw_valid   = 1'b0;
              end
            endcase
          end else begin
            // Calcualte PTE Address
            w_state     = MEM;
            w_ptw_valid = 1'b0;
            case(r_pt_lvl)
              // L2 PTE Address
              2'b10: begin
                w_concat_addr = {r_pte[53:10], r_target_va[29:21], 3'b000};
              end
              // L1 PTE Address
              2'b01: begin
                w_concat_addr = {r_pte[53:10], r_target_va[20:12], 3'b000};
              end
              // L1 PTE is not Leaf
              default: begin
                w_state = ERR;
              end
            endcase
          end
        end else begin
          // Page Fault
          // Invalid PTE
          w_state     = ERR;
          w_ptw_valid = 1'b0;
        end
        if_mem.raddr_valid  = 1'b0;
        w_ptw_pte_attr      = {r_pte[63:61], r_pte[7:0]};
      end
      MEM:  begin
        if_mem.raddr        = (ADDR_WIDTH)'(r_concat_addr);
        if_mem.raddr_valid  = 1'b1;
        if (if_mem.rdata_valid) begin
          w_state   = PROC;
          w_pte     = if_mem.rdata;
          w_pt_lvl  = r_pt_lvl - 1;
        end else begin
          w_state   = r_state;
          w_pte     = r_pte;
          w_pt_lvl  = r_pt_lvl;
        end
      end
      ERR:  begin
      end
      default:  begin
      end
    endcase
  end

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      r_state     <= IDLE;
      o_ptw_valid <= 1'b0;
    end else begin
      r_state     <= w_state;
      o_ptw_valid <= w_ptw_valid;
    end
  end

  always_ff @(posedge i_clk) begin
    r_concat_addr <= w_concat_addr;
    r_pt_lvl      <= w_pt_lvl;
    r_pte         <= w_pte;
    o_ptw_paddr   <= w_concat_addr;
    r_target_va   <= w_target_va;
    o_ptw_pte_attr  <= w_ptw_pte_attr;
  end

endmodule
`default_nettype wire
