// An APB4 (v2.0) interface
interface APB #(
  parameter int unsigned ADDR_WIDTH = 32'd32,
  parameter int unsigned DATA_WIDTH = 32'd32
);
  // CN: 跨文件 package 依赖
  localparam int unsigned STRB_WIDTH = cf_math_pkg::ceil_div(DATA_WIDTH, 8);
  typedef logic [ADDR_WIDTH-1:0] addr_t;
  typedef logic [DATA_WIDTH-1:0] data_t;
  typedef logic [STRB_WIDTH-1:0] strb_t;

  addr_t          paddr;
  apb_pkg::prot_t pprot;
  logic           psel;
  logic           penable;
  logic           pwrite;
  data_t          pwdata;
  strb_t          pstrb;
  logic           pready;
  data_t          prdata;
  logic           pslverr;

  modport Master (
    output paddr, pprot, psel, penable, pwrite, pwdata, pstrb,
    input  pready, prdata, pslverr
  );

  modport Slave (
    input  paddr, pprot, psel, penable, pwrite, pwdata, pstrb,
    output pready, prdata, pslverr
  );

endinterface
