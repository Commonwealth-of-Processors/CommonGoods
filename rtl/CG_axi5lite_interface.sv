interface CG_axi5lite_interface #(
  parameter DATA_WIDTH  = 32,
  parameter ADDR_WIDTH  = 32
);

  logic ACLK;
  logic ARESETn;
  // AW, Write request Channel
  logic AWVALID;
  logic AWREADY;
  logic [ADDR_WIDTH-1:0]  AWADDR;
  logic [2:0]             AWPROT;
  // W, Write data Channel
  logic WVALID;
  logic WREADY;
  logic [DATA_WIDTH-1:0]      WDATA;
  logic [(DATA_WIDTH/8)-1:0]  WSTRB;
  // B, Write response Channel
  logic BVALID;
  logic BREADY;
  // AR, Read request Channel
  logic ARVALID;
  logic ARREADY;
  logic [ADDR_WIDTH-1:0]  ARADDR;
  logic [2:0]             ARPROT;
  // R, Read data Channel
  logic RVALID;
  logic RREADY;
  logic [DATA_WIDTH-1:0]  RDATA;

  modport master (
    input  ACLK,
    input  ARESETn,
    // AW
    output AWVALID,
    input  AWREADY,
    output AWADDR,
    output AWPROT,
    // W
    output WVALID,
    input  WREADY,
    output WDATA,
    output WSTRB,
    // B
    input  BVALID,
    output BREADY,
    // AR
    output ARVALID,
    input  ARREADY,
    output ARADDR,
    output ARPROT,
    // R
    input  RVALID,
    output RREADY,
    input  RDATA
  );

  modport slave (
    input  ACLK,
    input  ARESETn,
    // AW
    input  AWVALID,
    output AWREADY,
    input  AWADDR,
    input  AWPROT,
    // W
    input  WVALID,
    output WREADY,
    input  WDATA,
    input  WSTRB,
    // B
    output BVALID,
    input  BREADY,
    // AR
    input  ARVALID,
    output ARREADY,
    input  ARADDR,
    input  ARPROT,
    // R
    output RVALID,
    input  RREADY,
    output RDATA
  );

endinterface
