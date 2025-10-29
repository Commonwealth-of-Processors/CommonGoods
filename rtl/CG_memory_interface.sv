interface CG_memory_interface #(
  parameter DATA_WIDTH = 32,
  parameter ADDR_WIDTH = 32
);

  logic clk;
  logic rstn;

  logic                   arvalid;
  logic                   arready;
  logic [ADDR_WIDTH-1:0]  araddr;

  logic                   rvalid;
  logic                   rready;
  logic [DATA_WIDTH-1:0]  rdata;

  logic                   wvalid;
  logic                   wready;
  logic                   wen;
  logic [ADDR_WIDTH-1:0]  waddr;
  logic [DATA_WIDTH-1:0]  wdata;

  modport to_memory(
    input  clk,
    input  rstn,
    output arvalid,
    input  arready,
    output araddr,
    input  rvalid,
    output rready,
    input  rdata,
    output wvalid,
    input  wready,
    output wen,
    output waddr,
    output wdata
  );

  modport from_memory(
    input  clk,
    input  rstn,
    input  arvalid,
    output arready,
    input  araddr,
    output rvalid,
    input  rready,
    output rdata,
    input  wvalid,
    output wready,
    input  wen,
    input  waddr,
    input  wdata
  );

endinterface
