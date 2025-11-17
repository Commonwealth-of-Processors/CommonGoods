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
  output logic                    o_tlb_miss,
  output logic [VADDR_WIDTH-1:0]  o_tlb_miss_vaddr,
  input  logic                    i_ptw_valid,
  input  logic [PADDR_WIDTH-1:0]  i_ptw_paddr
);

  // Arrays
  logic [ENTRY_NUM-1:0]   r_valid_array;
  logic [TAG_WIDTH-1:0]   r_tag_array   [ENTRY_NUM-1:0];
  logic [ASID_WIDTH-1:0]  r_asid_array  [ENTRY_NUM-1:0];
  logic [PPN_WIDTH-1:0]   r_ppn_array   [ENTRY_NUM-1:0];

  // VA Fields
  logic [TAG_WIDTH-1:0]     w_vaddr_tag;
  logic [OFFSET_WIDTH-1:0]  w_vaddr_offset;

  // Hit Entry and Index
  logic [ENTRY_NUM-1:0]         w_hit;
  logic                         w_hit_index_en;
  logic [$clog2(ENTRY_NUM)-1:0] w_hit_index;

  // Invalid Index
  logic                         w_invalid_index_en;
  logic [$clog2(ENTRY_NUM)-1:0] w_invalid_index;

  // Bit-LRU
  logic [ENTRY_NUM-1:0]         w_mru;
  logic [ENTRY_NUM-1:0]         r_mru;
  logic                         w_lru_index_en;
  logic [$clog2(ENTRY_NUM)-1:0] w_lru_index;

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

  cg_priority_encoder #(
    .BITS_WIDTH (ENTRY_NUM  )
  ) gen_invalid_index (
    .i_bits (~r_valid_array     ),
    .o_index(w_invalid_index    ),
    .o_en   (w_invalid_index_en )
  );

  // Bit-LRU
  always_comb begin
    if(&(r_mru | w_hit)) begin
      w_mru = w_hit;
    end else begin
      w_mru = r_mru | w_hit;
    end
  end

  cg_priority_encoder #(
    .BITS_WIDTH (ENTRY_NUM  )
  ) gen_lru_index (
    .i_bits (~r_mru         ),
    .o_index(w_lru_index    ),
    .o_en   (w_lru_index_en )
  );

  always_ff @(posedge i_clk, negedge i_rstn) begin
    if (!i_rstn) begin
      r_valid_array <= '0;
    end else if (o_tlb_miss) begin
      if (i_ptw_valid) begin
        if (w_invalid_index_en) begin
          r_valid_array[w_invalid_index]  <= 1'b1;
        end else if (w_lru_index_en) begin
          r_valid_array[w_lru_index]  <= 1'b1;
        end
      end
    end
  end

  // Read PPN Array and Construct PADDR
  always_ff @(posedge i_clk) begin
    o_paddr           <= {r_ppn_array[w_hit_index], w_vaddr_offset};
    o_paddr_valid     <= w_hit_index_en;
    o_tlb_miss        <= ~w_hit_index_en & i_vaddr_valid;
    o_tlb_miss_vaddr  <= i_vaddr;
    r_mru             <= w_mru;
    if (o_tlb_miss) begin
      if (i_ptw_valid) begin
        if (w_invalid_index_en) begin
          r_tag_array[w_invalid_index]    <= w_vaddr_tag;
          r_asid_array[w_invalid_index]   <= i_asid;
          r_ppn_array[w_invalid_index]    <= i_ptw_paddr[PADDR_WIDTH-1:PADDR_WIDTH-PPN_WIDTH];
        end else if (w_lru_index_en) begin
          r_tag_array[w_lru_index]        <= w_vaddr_tag;
          r_asid_array[w_lru_index]       <= i_asid;
          r_ppn_array[w_lru_index]        <= i_ptw_paddr[PADDR_WIDTH-1:PADDR_WIDTH-PPN_WIDTH];
        end
      end
    end
  end

  cg_priority_encoder #(
    .BITS_WIDTH (ENTRY_NUM  )
  ) gen_hit_index (
    .i_bits (w_hit          ),
    .o_index(w_hit_index    ),
    .o_en   (w_hit_index_en )
  );


endmodule
`default_nettype wire
