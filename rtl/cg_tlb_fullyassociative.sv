`default_nettype none
module cg_tlb_fullyassociative #(
  parameter VADDR_WIDTH   = 39,
  parameter PADDR_WIDTH   = 56,
  parameter TAG_WIDTH     = 27,
  parameter PPN_WIDTH     = 44,
  parameter OFFSET_WIDTH  = 12,
  parameter ASID_WIDTH    = 16,
  parameter ENTRY_NUM     = 16
)(
  input  logic i_clk,
  input  logic i_rstn,

  // Core Interface
  input  logic                    i_vaddr_valid,
  input  logic [VADDR_WIDTH-1:0]  i_vaddr,
  input  logic [ASID_WIDTH-1:0]   i_asid,
  output logic                    o_paddr_valid,
  output logic [PADDR_WIDTH-1:0]  o_paddr,

  // PTW Interface
  output logic o_tlb_miss
);

  // Arrays
  logic [ENTRY_NUM-1:0]   r_valid_array;
  logic [TAG_WIDTH-1:0]   r_tag_array   [ENTRY_NUM-1:0];
  logic [ASID_WIDTH-1:0]  r_asid_array  [ENTRY_NUM-1:0];
  logic [PPN_WIDTH-1:0]   r_ppn_array   [ENTRY_NUM-1:0];

  // VA Fields
  logic [TAG_WIDTH-1:0]     w_vaddr_tag;
  logic [OFFSET_WIDTH-1:0]  w_vaddr_offset;

  logic [ENTRY_NUM-1:0]         w_hit;
  logic                         w_pe_en;
  logic [$clog2(ENTRY_NUM)-1:0] w_hit_index;

  always_comb begin
    w_vaddr_tag     = i_vaddr[VADDR_WIDTH-1:VADDR_WIDTH-TAG_WIDTH];
    w_vaddr_offset  = i_vaddr[OFFSET_WIDTH-1:0];
  end

  generate 
  for(genvar i = 0; i < ENTRY_NUM; i = i + 1) begin : FULLY_ASSOCIATIVE
    always_comb begin
      w_hit[i] = 1'b0;
      if (i_vaddr_valid) begin
        // Valid Check
        if (r_valid_array[i]) begin
          // ASID Check
          if (r_asid_array[i] == i_asid) begin
            // TAG Check
            if (r_tag_array[i] == w_vaddr_tag) begin
              w_hit[i] = 1'b1;
            end else begin
              w_hit[i] = 1'b0;
            end
          end
        end
      end
    end
  end 
  endgenerate

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      r_valid_array <= '0;
    end
  end

  // Read PPN Array and Construct PADDR
  always_ff @(posedge i_clk) begin
    o_paddr         <= {r_ppn_array[w_hit_index], w_vaddr_offset};
    o_paddr_valid   <= w_pe_en;
    o_tlb_miss      <= ~w_pe_en & i_vaddr_valid;
  end

  cg_priority_encoder #(
    .BITS_WIDTH (ENTRY_NUM  )
  ) priority_encoder (
    .i_bits (w_hit        ),
    .o_index(w_hit_index  ),
    .o_en   (w_pe_en      )
  );

endmodule
`default_nettype wire
