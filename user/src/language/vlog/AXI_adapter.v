module AXI_adapter (
    // Clock and Reset
    input wire ACLK,
    input wire ARESETn,

    // Original Memory Interface
    input wire [31:0] mem_addr,
    input wire mem_rreq,
    input wire mem_wreq,
    input wire [31:0] mem_wdata,
    input wire [3:0] mem_wstrb,
    output reg [31:0] mem_rdata,
    input wire mem_done,

    // AXI Lite Write Address Channel
    output reg [31:0] AWADDR,
    output reg AWVALID,
    input wire AWREADY,

    // AXI Lite Write Data Channel
    output reg [31:0] WDATA,
    output reg [3:0] WSTRB,
    output reg WVALID,
    input wire WREADY,

    // AXI Lite Write Response Channel
    input wire BVALID,
    input wire [1:0] BRESP,
    output reg BREADY,

    // AXI Lite Read Address Channel
    output reg [31:0] ARADDR,
    output reg ARVALID,
    input wire ARREADY,

    // AXI Lite Read Data Channel
    input wire [31:0] RDATA,
    input wire [1:0] RRESP,
    input wire RVALID,
    output reg RREADY
);

    // Synchronized reset
    reg rst_sync1, rst_sync2;
    wire front_rst_n;

    // Synchronization logic
    always @(posedge ACLK or negedge ARESETn) begin
        if (!ARESETn) begin
            rst_sync1 <= 1'b0;
            rst_sync2 <= 1'b0;
        end else begin
            rst_sync1 <= 1'b1;
            rst_sync2 <= rst_sync1;
        end
    end
    
    assign front_rst_n = rst_sync2;

// Write FSM
typedef enum logic [1:0] {WRITE_IDLE, WRITE_ADDR, WRITE_DATA, WRITE_RESP} write_state_t;
write_state_t write_state;

// Read FSM
typedef enum logic [1:0] {READ_IDLE, READ_ADDR, READ_DATA} read_state_t;
read_state_t read_state;


// Write FSM Logic
always @(posedge ACLK or negedge ARESETn) begin
    if (!front_rst_n) begin
        write_state <= WRITE_IDLE;
        AWVALID <= 1'b0;
        WVALID <= 1'b0;
        BREADY <= 1'b0;
    end else begin
        case (write_state)
            WRITE_IDLE: begin
                if (mem_wreq) begin
                    AWADDR <= mem_addr;
                    AWVALID <= 1'b1;
                    write_state <= WRITE_ADDR;
                end
            end
            
            WRITE_ADDR: begin
                if (AWREADY) begin
                    AWVALID <= 1'b0;
                    WDATA <= mem_wdata;
                    WSTRB <= mem_wstrb; // Use external wstrb
                    WVALID <= 1'b1;
                    write_state <= WRITE_DATA;
                end
            end
            
            WRITE_DATA: begin
                if (WREADY) begin
                    WVALID <= 1'b0;
                    BREADY <= 1'b1;
                    write_state <= WRITE_RESP;
                end
            end
            
            WRITE_RESP: begin
                if (BVALID) begin
                    BREADY <= 1'b0;
                    write_state <= WRITE_IDLE;
                end
            end
        endcase
    end
end

// Read FSM Logic
always @(posedge ACLK or negedge ARESETn) begin
    if (!front_rst_n) begin
        read_state <= READ_IDLE;
        ARVALID <= 1'b0;
        RREADY <= 1'b0;
    end else begin
        case (read_state)
            READ_IDLE: begin
                if (mem_rreq) begin
                    ARADDR <= mem_addr;
                    ARVALID <= 1'b1;
                    read_state <= READ_ADDR;
                end
            end
            
            READ_ADDR: begin
                if (ARREADY) begin
                    ARVALID <= 1'b0;
                    RREADY <= 1'b1;
                    read_state <= READ_DATA;
                end
            end
            
            READ_DATA: begin
                if (RVALID) begin
                    mem_rdata <= RDATA;
                    RREADY <= 1'b0;
                    read_state <= READ_IDLE;
                end
            end
        endcase
    end
end

endmodule