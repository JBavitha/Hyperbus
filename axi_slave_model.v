`timescale 1ns / 1ps

module axi_slave_model #(
    parameter ADDR_WIDTH = 32,
    parameter DATA_WIDTH = 32
)(
    input  wire                  aclk,
    input  wire                  aresetn,

    // AXI Write Address Channel
    input  wire [ADDR_WIDTH-1:0] awaddr,
    input  wire                  awvalid,
    output reg                   awready,

    // AXI Write Data Channel
    input  wire [DATA_WIDTH-1:0] wdata,
    input  wire                  wvalid,
    output reg                   wready,

    // AXI Write Response Channel
    output reg                   bvalid,
    input  wire                  bready,

    // AXI Read Address Channel
    input  wire [ADDR_WIDTH-1:0] araddr,
    input  wire                  arvalid,
    output reg                   arready,

    // AXI Read Data Channel
    output reg [DATA_WIDTH-1:0] rdata,
    output reg                   rvalid,
    input  wire                  rready
);

    reg [DATA_WIDTH-1:0] mem [0:255]; // Simple memory for simulation

    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            awready <= 0;
            wready  <= 0;
            bvalid  <= 0;
            arready <= 0;
            rvalid  <= 0;
            rdata   <= 0;
        end else begin
            // Write transaction
            if (awvalid && !awready) awready <= 1;
            if (wvalid && !wready) begin
                wready <= 1;
                mem[awaddr[7:0]] <= wdata;
                bvalid <= 1;
            end
            if (bvalid && bready) bvalid <= 0;
            
            // Read transaction
            if (arvalid && !arready) begin
                arready <= 1;
                rdata <= mem[araddr[7:0]];
                rvalid <= 1;
            end
            if (rvalid && rready) rvalid <= 0;
        end
    end
endmodule
