`include "package1.sv"
`include "package2.sv"

module apb_err_slv #(
  parameter                       type req_t = logic,     // APB request struct
  parameter                       type resp_t = logic,    // APB response struct
  parameter int unsigned          RespWidth = 32'd32,     // Data width of the response. Gets zero extended or truncated to r.data.
  parameter logic [RespWidth-1:0] RespData = 32'hBADCAB1E // Hexvalue for the data to return on error.
) (
  input req_t slv_req_ii,
  output resp_t slv_resp_oo
);

  assign slv_resp_oo.prdata = RespData;
  assign slv_resp_oo.pready = 1'b1;
  // Following the APB recommendations, we only assert the error signal if there is actually a
  // request.

  // CN: 跨文件 package 依赖
  assign slv_resp_oo.pslverr = (slv_req_ii.psel & slv_req_ii.penable)?
                              apb_pkg::RESP_SLVERR : apb_pkg::RESP_OKAY;

endmodule