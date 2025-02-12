`timescale 1ns / 1ps

module axi_hyperbus_tb;
    reg clk, resetn;

    // AXI Signals
    reg [31:0] awaddr, araddr, wdata;
    reg awvalid, wvalid, arvalid, bready, rready;
    wire awready, wready, bvalid, arready, rvalid;
    wire [31:0] rdata;

    // HyperBus Signals
    wire [31:0] hyper_addr;
    wire hyper_cs_n, hyper_we_n, hyper_re_n;
    wire [31:0] hyper_dq;
    
    // Instantiate AXI-HyperBus Bridge
    axi_hyperbus_bridge uut (
        .aclk(clk),
        .aresetn(resetn),
        .awaddr(awaddr),
        .awvalid(awvalid),
        .awready(awready),
        .wdata(wdata),
        .wvalid(wvalid),
        .wready(wready),
        .bvalid(bvalid),
        .bready(bready),
        .araddr(araddr),
        .arvalid(arvalid),
        .arready(arready),
        .rdata(rdata),
        .rvalid(rvalid),
        .rready(rready),
        .hyper_addr(hyper_addr),
        .hyper_cs_n(hyper_cs_n),
        .hyper_we_n(hyper_we_n),
        .hyper_re_n(hyper_re_n),
        .hyper_dq(hyper_dq)
    );
    
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, axi_hyperbus_tb);
    end


    // Clock Generation
    always #5 clk = ~clk;

    initial begin
        // Initialize
        clk = 0;
        resetn = 0;
        awaddr = 32'h0000_1000;
        araddr = 32'h0000_2000;
        wdata = 32'hA5A5A5A5;
        awvalid = 0; wvalid = 0; arvalid = 0; bready = 1; rready = 1;
        #10 resetn = 1;

        // AXI Write Transaction
        #10 awvalid = 1; wvalid = 1;
        #10 awvalid = 0; wvalid = 0;

        // Wait for write response
        wait (bvalid);
        #10 bready = 1;

        // AXI Read Transaction
        #10 arvalid = 1;
        #10 arvalid = 0;

        // Wait for read data
        wait (rvalid);
        #10 rready = 1;

        // Finish
        #50 $finish;
    end
endmodule

