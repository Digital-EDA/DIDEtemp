// Macros to define APB4 Request/Response Structs
`ifndef APB_TYPEDEF_SVH_
`define APB_TYPEDEF_SVH_


// APB4 (v2.0) Request/Response Structs
//
// Usage Example:
// `APB_TYPEDEF_REQ_T  ( apb_req_t,  addr_t, data_t, strb_t )
// `APB_TYPEDEF_RESP_T ( apb_resp_t, data_t )
`define APB_TYPEDEF_REQ_T(apb_req_t, addr_t, data_t, strb_t)  \
  typedef struct packed {                                     \
    addr_t          paddr;                                    \
    apb_pkg::prot_t pprot;                                    \
    logic           psel;                                     \
    logic           penable;                                  \
    logic           pwrite;                                   \
    data_t          pwdata;                                   \
    strb_t          pstrb;                                    \
  } apb_req_t;
`define APB_TYPEDEF_RESP_T(apb_resp_t, data_t) \
  typedef struct packed {                      \
    logic  pready;                             \
    data_t prdata;                             \
    logic  pslverr;                            \
    } apb_resp_t;


// All APB request/response structs in one macro.
//
// Usage Example:
// `APB_TYPEDEF_ALL(my_apb, addr_t, data_t, strb_t)
//
// This defines the `my_apb_req_t` and `my_apb_resp_t` request/response structs.
`define APB_TYPEDEF_ALL(__name, __addr_t, __data_t, __strb_t)      \
  `APB_TYPEDEF_REQ_T(__name``_req_t, __addr_t, __data_t, __strb_t) \
  `APB_TYPEDEF_RESP_T(__name``_resp_t, __data_t)

`endif
