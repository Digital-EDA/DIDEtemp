module apb_err_slv2 #(
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