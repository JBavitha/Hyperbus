module axi_hyperbus_bridge #(
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

    // State Machine Definitions
    localparam IDLE     = 2'b00;
    localparam WRITE    = 2'b01;
    localparam READ     = 2'b10;
    localparam RESPONSE = 2'b11;

    reg [1:0] state;
    reg [ADDR_WIDTH-1:0] addr_reg;
    reg [DATA_WIDTH-1:0] data_reg;
    reg [DATA_WIDTH-1:0] rdata_reg;
    reg write_en, read_en;

    // AXI Write Transaction -> HyperBus Write
    always @(posedge aclk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            write_en <= 0;
            read_en <= 0;
            rdata_reg <= 0;
        end else begin
            case (state)
                IDLE: begin
                    if (awvalid && wvalid) begin
                        addr_reg <= awaddr;
                        data_reg <= wdata;
                        write_en <= 1;
                        state <= WRITE;
                    end else if (arvalid) begin
                        addr_reg <= araddr;
                        read_en <= 1;
                        state <= READ;
                    end
                end
                WRITE: begin
                    write_en <= 0;
                    state <= RESPONSE;
                end
                READ: begin
                    rdata_reg <= hyper_dq;  // Capture data from HyperBus
                    read_en <= 0;
                    state <= RESPONSE;
                end
                RESPONSE: begin
                    state <= IDLE;
                end
            endcase
        end
    end

    // Connecting to HyperBus
    assign hyper_addr = addr_reg;
    assign hyper_we_n = ~write_en;
    assign hyper_re_n = ~read_en;
    assign hyper_cs_n = ~(write_en | read_en);
    assign hyper_dq   = (write_en) ? data_reg : {DATA_WIDTH{1'bz}};

    // AXI Response Handling
    assign awready = (state == IDLE);
    assign wready  = (state == IDLE);
    assign bvalid  = (state == RESPONSE);
    assign arready = (state == IDLE);
    assign rdata   = rdata_reg;
    assign rvalid  = (state == RESPONSE);

endmodule

