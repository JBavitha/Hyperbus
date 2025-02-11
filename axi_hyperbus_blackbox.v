`timescale 1ns / 1ps

module axi_hyperbus_blackbox #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                  aclk,
    input  wire                  aresetn,

    // AXI4 Slave Interface
    input  wire [ADDR_WIDTH-1:0] awaddr,
    input  wire                  awvalid,
    output wire                  awready,
    input  wire [DATA_WIDTH-1:0] wdata,
    input  wire                  wvalid,
    output wire                  wready,
    output wire                  bvalid,
    input  wire                  bready,
    input  wire [ADDR_WIDTH-1:0] araddr,
    input  wire                  arvalid,
    output wire                  arready,
    output wire [DATA_WIDTH-1:0] rdata,
    output wire                  rvalid,
    input  wire                  rready,

    // HyperBus Master Interface
    output wire [ADDR_WIDTH-1:0] hyper_addr,
    output wire                  hyper_cs_n,
    output wire                  hyper_clk,
    inout  wire [DATA_WIDTH-1:0] hyper_dq,
    output wire                  hyper_rwds,
    output wire                  hyper_we_n,
    output wire                  hyper_re_n
);

    // Black-box implementation: No internal logic
    assign awready = 1'b0;
    assign wready  = 1'b0;
    assign bvalid  = 1'b0;
    assign arready = 1'b0;
    assign rdata   = {DATA_WIDTH{1'b0}};
    assign rvalid  = 1'b0;
    assign hyper_addr = {ADDR_WIDTH{1'b0}};
    assign hyper_cs_n = 1'b1;
    assign hyper_clk  = 1'b0;
    assign hyper_rwds = 1'b0;
    assign hyper_we_n = 1'b1;
    assign hyper_re_n = 1'b1;

endmodule
