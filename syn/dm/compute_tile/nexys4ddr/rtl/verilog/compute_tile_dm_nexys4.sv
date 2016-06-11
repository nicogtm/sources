module compute_tile_dm_nexys4
  (
   input                 clk,
   input                 cpu_reset_n,

   output                uart_rxd_out,
   input                 uart_txd_in,

   output [12:0]         ddr2_addr,
   output [2:0]          ddr2_ba,
   output                ddr2_cas_n,
   output                ddr2_ck_n,
   output                ddr2_ck_p,
   output                ddr2_cke,
   output                ddr2_cs_n,
   output [1:0]          ddr2_dm,
   inout [15:0]          ddr2_dq,
   inout [1:0]           ddr2_dqs_n,
   inout [1:0]           ddr2_dqs_p,
   output                ddr2_odt,
   output                ddr2_ras_n,
   output                ddr2_we_n
   );

   localparam NASTI_ID_WIDTH = 4;
   localparam DDR_ADDR_WIDTH = 28;
   localparam DDR_DATA_WIDTH = 32;

   nasti_channel
     #(.ID_WIDTH   (NASTI_ID_WIDTH),
       .ADDR_WIDTH (DDR_ADDR_WIDTH),
       .DATA_WIDTH (DDR_DATA_WIDTH))
   c_nasti_ddr();

   wb_channel
     #(.ADDR_WIDTH (DDR_ADDR_WIDTH),
       .DATA_WIDTH (DDR_DATA_WIDTH))
   c_wb_ddr();

   logic                 sys_clk, sys_rst;
   logic                 uart_rx, uart_tx;

   compute_tile_dm
     u_compute_tile(.wb_mem_adr_i  (c_wb_ddr.adr_o),
                    .wb_mem_cyc_i  (c_wb_ddr.cyc_o),
                    .wb_mem_dat_i  (c_wb_ddr.dat_o),
                    .wb_mem_sel_i  (c_wb_ddr.sel_o),
                    .wb_mem_stb_i  (c_wb_ddr.stb_o),
                    .wb_mem_we_i   (c_wb_ddr.we_o),
                    .wb_mem_cab_i  (c_wb_ddr.cab_o),
                    .wb_mem_cti_i  (c_wb_ddr.cti_o),
                    .wb_mem_bte_i  (c_wb_ddr.bte_o),
                    .wb_mem_ack_o  (c_wb_ddr.ack_i),
                    .wb_mem_rty_o  (c_wb_ddr.rty_i),
                    .wb_mem_err_o  (c_wb_ddr.err_i),
                    .wb_mem_dat_o  (c_wb_ddr.dat_i),
                    .*
                    );

   nexys4ddr
     u_board(.ddr_awid    (c_nasti_ddr.aw_id),
             .ddr_awaddr  (c_nasti_ddr.aw_addr),
             .ddr_awlen   (c_nasti_ddr.aw_len),
             .ddr_awsize  (c_nasti_ddr.aw_size),
             .ddr_awburst (c_nasti_ddr.aw_burst),
             .ddr_awcache (c_nasti_ddr.aw_cache),
             .ddr_awprot  (c_nasti_ddr.aw_prot),
             .ddr_awqos   (c_nasti_ddr.aw_qos),
             .ddr_awvalid (c_nasti_ddr.aw_valid),
             .ddr_awready (c_nasti_ddr.aw_ready),
             .ddr_wdata   (c_nasti_ddr.w_data),
             .ddr_wstrb   (c_nasti_ddr.w_strb),
             .ddr_wlast   (c_nasti_ddr.w_last),
             .ddr_wvalid  (c_nasti_ddr.w_valid),
             .ddr_wready  (c_nasti_ddr.w_ready),
             .ddr_bid     (c_nasti_ddr.b_id),
             .ddr_bresp   (c_nasti_ddr.b_resp),
             .ddr_bvalid  (c_nasti_ddr.b_valid),
             .ddr_bready  (c_nasti_ddr.b_ready),
             .ddr_arid    (c_nasti_ddr.ar_id),
             .ddr_araddr  (c_nasti_ddr.ar_addr),
             .ddr_arlen   (c_nasti_ddr.ar_len),
             .ddr_arsize  (c_nasti_ddr.ar_size),
             .ddr_arburst (c_nasti_ddr.ar_burst),
             .ddr_arcache (c_nasti_ddr.ar_cache),
             .ddr_arprot  (c_nasti_ddr.ar_prot),
             .ddr_arqos   (c_nasti_ddr.ar_qos),
             .ddr_arvalid (c_nasti_ddr.ar_valid),
             .ddr_arready (c_nasti_ddr.ar_ready),
             .ddr_rid     (c_nasti_ddr.r_id),
             .ddr_rresp   (c_nasti_ddr.r_resp),
             .ddr_rdata   (c_nasti_ddr.r_data),
             .ddr_rlast   (c_nasti_ddr.r_last),
             .ddr_rvalid  (c_nasti_ddr.r_valid),
             .ddr_rready  (c_nasti_ddr.r_ready),
             .*
             );

   wb2nasti
     #(.ADDR_WIDTH (DDR_ADDR_WIDTH),
       .DATA_WIDTH (DDR_DATA_WIDTH),
       .NASTI_ID_WIDTH (NASTI_ID_WIDTH))
   u_wb2nasti_ddr
     (.clk             (sys_clk),
      .rst             (sys_rst),
      .wb_ddr_cyc_i    (c_wb_ddr.cyc_o),
      .wb_ddr_stb_i    (c_wb_ddr.stb_o),
      .wb_ddr_we_i     (c_wb_ddr.we_o),
      .wb_ddr_adr_i    (c_wb_ddr.adr_o),
      .wb_ddr_dat_i    (c_wb_ddr.dat_o),
      .wb_ddr_sel_i    (c_wb_ddr.sel_o),
      .wb_ddr_cti_i    (c_wb_ddr.cti_o),
      .wb_ddr_bte_i    (c_wb_ddr.bte_o),
      .wb_ddr_ack_o    (c_wb_ddr.ack_i),
      .wb_ddr_err_o    (c_wb_ddr.err_i),
      .wb_ddr_rty_o    (c_wb_ddr.rty_i),
      .wb_ddr_dat_o    (c_wb_ddr.dat_i),
      .m_nasti_awid    (c_nasti_ddr.aw_id),
      .m_nasti_awaddr  (c_nasti_ddr.aw_addr),
      .m_nasti_awlen   (c_nasti_ddr.aw_len),
      .m_nasti_awsize  (c_nasti_ddr.aw_size),
      .m_nasti_awburst (c_nasti_ddr.aw_burst),
      .m_nasti_awcache (c_nasti_ddr.aw_cache),
      .m_nasti_awprot  (c_nasti_ddr.aw_prot),
      .m_nasti_awqos   (c_nasti_ddr.aw_qos),
      .m_nasti_awvalid (c_nasti_ddr.aw_valid),
      .m_nasti_awready (c_nasti_ddr.aw_ready),
      .m_nasti_wdata   (c_nasti_ddr.w_data),
      .m_nasti_wstrb   (c_nasti_ddr.w_strb),
      .m_nasti_wlast   (c_nasti_ddr.w_last),
      .m_nasti_wvalid  (c_nasti_ddr.w_valid),
      .m_nasti_wready  (c_nasti_ddr.w_ready),
      .m_nasti_bid     (c_nasti_ddr.b_id),
      .m_nasti_bresp   (c_nasti_ddr.b_resp),
      .m_nasti_bvalid  (c_nasti_ddr.b_valid),
      .m_nasti_bready  (c_nasti_ddr.b_ready),
      .m_nasti_arid    (c_nasti_ddr.ar_id),
      .m_nasti_araddr  (c_nasti_ddr.ar_addr),
      .m_nasti_arlen   (c_nasti_ddr.ar_len),
      .m_nasti_arsize  (c_nasti_ddr.ar_size),
      .m_nasti_arburst (c_nasti_ddr.ar_burst),
      .m_nasti_arcache (c_nasti_ddr.ar_cache),
      .m_nasti_arprot  (c_nasti_ddr.ar_prot),
      .m_nasti_arqos   (c_nasti_ddr.ar_qos),
      .m_nasti_arvalid (c_nasti_ddr.ar_valid),
      .m_nasti_arready (c_nasti_ddr.ar_ready),
      .m_nasti_rid     (c_nasti_ddr.r_id),
      .m_nasti_rdata   (c_nasti_ddr.r_data),
      .m_nasti_rresp   (c_nasti_ddr.r_resp),
      .m_nasti_rlast   (c_nasti_ddr.r_last),
      .m_nasti_rvalid  (c_nasti_ddr.r_valid),
      .m_nasti_rready  (c_nasti_ddr.r_ready)
      );

endmodule // compute_tile_dm_nexys4
