interface CG_memory_interface #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32
)(
  input logic i_clk,
  input logic i_rstn
);

  logic                   raddr_valid;
  logic                   raddr_ready;
  logic [ADDR_WIDTH-1:0]  raddr;

  logic                   rdata_valid;
  logic                   rdata_ready;
  logic [DATA_WIDTH-1:0]  rdata;

  logic                   wdata_valid;
  logic                   wdata_ready;
  logic                   wen;
  logic [ADDR_WIDTH-1:0]  waddr;
  logic [DATA_WIDTH-1:0]  wdata;

  modport to_memory(
    output raddr_valid,
    input  raddr_ready,
    output raddr,

    input  rdata_valid,
    output rdata_ready,
    input  rdata,

    output wdata_valid,
    input  wdata_ready,
    output wen,
    output waddr,
    output wdata
  );

  modport from_memory(
    input  i_clk,
    input  i_rstn,

    input  raddr_valid,
    output raddr_ready,
    input  raddr,

    output rdata_valid,
    input  rdata_ready,
    output rdata,

    input  wdata_valid,
    output wdata_ready,
    input  wen,
    input  waddr,
    input  wdata
  );

endinterface
