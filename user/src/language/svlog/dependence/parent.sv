// Description :
// This module always responds with an error response on any request of its APB
// slave port. Use thismodule e.g. as the default port in a APB demultiplexer
// to handle illegal access. Following the reccomendation of the APB 2.0
// specification, the error response will only be asserted on a valid
// transaction.

module apb_err_slv #(
  parameter                       type req_t = logic,     // APB request struct
  parameter                       type resp_t = logic,    // APB response struct
  parameter int unsigned          RespWidth = 32'd32,     // Data width of the response. Gets zero extended or truncated to r.data.
  parameter logic [RespWidth-1:0] RespData = 32'hBADCAB1E // Hexvalue for the data to return on error.
) (
  input req_t slv_req_i,
  output resp_t slv_resp_o
);

  assign slv_resp_o.prdata = RespData;
  assign slv_resp_o.pready = 1'b1;
  // Following the APB recommendations, we only assert the error signal if there is actually a
  // request.

  // CN: 跨文件 package 依赖
  assign slv_resp_o.pslverr = (slv_req_i.psel & slv_req_i.penable)?
                              apb_pkg::RESP_SLVERR : apb_pkg::RESP_OKAY;

endmodule

`include "head1.svh"
`include "head2.svh"

`include "child1.sv"
`include "child2.sv"

module apb_err_slv_intf #(
  parameter int unsigned          APB_ADDR_WIDTH = 0,
  parameter int unsigned          APB_DATA_WIDTH = 0,
  parameter logic [APB_DATA_WIDTH-1:0] RespData  = 32'hBADCAB1E
) (
  // CN: 跨文件 interface 依赖
  APB.Slave slv 
);

  typedef logic [APB_ADDR_WIDTH-1:0] addr_t;
  typedef logic [APB_DATA_WIDTH-1:0] data_t;
  typedef logic [APB_DATA_WIDTH/8-1:0] strb_t;

  // CN: 跨文件宏定义
  `APB_TYPEDEF_REQ_T(apb_req_t, addr_t, data_t, strb_t)
  `APB_TYPEDEF_RESP_T(apb_resp_t, data_t)

  apb_req_t slv_req;
  apb_resp_t slv_resp;

  `APB_ASSIGN_TO_REQ(slv_req, slv)
  `APB_ASSIGN_FROM_RESP(slv, slv_resp)

  // CN: 同文件 Module 依赖
  apb_err_slv #(
    .req_t     ( apb_req_t      ),
    .resp_t    ( apb_resp_t     ),
    .RespWidth ( APB_DATA_WIDTH ),
    .RespData  ( RespData       )
  ) i_apb_err_slv1 (
    .slv_req_i  ( slv_req  ),
    .slv_resp_o ( slv_resp )
  );

  // CN: 跨文件 异名 Module 依赖
  apb_err_slv2 #(
    .req_t     ( apb_req_t      ),
    .resp_t    ( apb_resp_t     ),
    .RespWidth ( APB_DATA_WIDTH ),
    .RespData  ( RespData       )
  ) i_apb_err_slv2 (
    .slv_req_i  ( slv_req  ),
    .slv_resp_o ( slv_resp )
  );

  // CN: 跨文件 同名 Module 依赖
  apb_err_slv #(
    .req_t     ( apb_req_t      ),
    .resp_t    ( apb_resp_t     ),
    .RespWidth ( APB_DATA_WIDTH ),
    .RespData  ( RespData       )
  ) i_apb_err_slv3 (
    .slv_req_ii  ( slv_req  ),
    .slv_resp_oo ( slv_resp )
  );

endmodule


/* @wavedrom this is wavedrom demo
{ 
    signal: [
    { name: "pclk", wave: 'p.......' },
    { name: "Pclk", wave: 'P.......' },
    { name: "nclk", wave: 'n.......' },
    { name: "Nclk", wave: 'N.......' },
    {},
    { name: 'clk0', wave: 'phnlPHNL' },
    { name: 'clk1', wave: 'xhlhLHl.' },
    { name: 'clk2', wave: 'hpHplnLn' },
    { name: 'clk3', wave: 'nhNhplPl' },
    { name: 'clk4', wave: 'xlh.L.Hx' },
]}
*/