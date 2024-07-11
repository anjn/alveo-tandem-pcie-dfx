`timescale 1 ps / 1 ps

module top_wrapper_iobuf (
    hbm_cattrip,
    pcie_7x_mgt_rxn,
    pcie_7x_mgt_rxp,
    pcie_7x_mgt_txn,
    pcie_7x_mgt_txp,
    pcie_mgt_clk_n,
    pcie_mgt_clk_p,
    pcie_perstn_rst,
    satellite_gpio,
    satellite_uart_rxd,
    satellite_uart_txd
);
    input [7:0]pcie_7x_mgt_rxn;
    input [7:0]pcie_7x_mgt_rxp;
    output [7:0]pcie_7x_mgt_txn;
    output [7:0]pcie_7x_mgt_txp;
    input [0:0]pcie_mgt_clk_n;
    input [0:0]pcie_mgt_clk_p;
  
    input pcie_perstn_rst;
  
    inout [0:0]hbm_cattrip;
    inout satellite_uart_txd;
  
    inout [3:0]satellite_gpio;
    inout satellite_uart_rxd;
  
    wire mcap_design_switch;
    wire mcap_design_switch_inv;
  
    wire [7:0]pcie_7x_mgt_rxn;
    wire [7:0]pcie_7x_mgt_rxp;
    wire [7:0]pcie_7x_mgt_txn;
    wire [7:0]pcie_7x_mgt_txp;
    wire [0:0]pcie_mgt_clk_n;
    wire [0:0]pcie_mgt_clk_p;
  
    wire [0:0]hbm_cattrip;
    wire pcie_perstn_rst;
    wire [3:0]satellite_gpio;
    wire satellite_uart_rxd;
    wire satellite_uart_txd;
  
    wire [0:0]hbm_cattrip_buf;
    wire pcie_perstn_rst_buf;
    wire [3:0]satellite_gpio_buf;
    wire satellite_uart_rxd_buf;
    wire satellite_uart_txd_buf;

    // Logic placed in stage 1
    LUT1 #(
        .INIT(2'b01) // Invert logic
    ) mcap_design_switch_lut1 (
        .O(mcap_design_switch_inv),
        .I0(mcap_design_switch)
    );
  
    // Reset
    IBUF pcie_perstn_rst_ibuf (
        .O(pcie_perstn_rst_buf),
        .I(pcie_perstn_rst)
    );
  
    // Outputs
    IOBUF hbm_cattrip_iobuf (
        .O(),
        .I(hbm_cattrip_buf[0]),
        .IO(hbm_cattrip[0]),
        .T(mcap_design_switch_inv)
    );
  
    IOBUF satellite_uart_txd_iobuf (
        .O(),
        .I(satellite_uart_txd_buf),
        .IO(satellite_uart_txd),
        .T(mcap_design_switch_inv)
    );
  
    // Inputs
    IOBUF satellite_uart_rxd_iobuf (
        .O(satellite_uart_rxd_buf),
        .I(),
        .IO(satellite_uart_rxd),
        .T(1'b1)
    );
  
    IOBUF satellite_gpio_0_iobuf (
        .O(satellite_gpio_buf[0]),
        .I(),
        .IO(satellite_gpio[0]),
        .T(1'b1)
    );
  
    IOBUF satellite_gpio_1_iobuf (
        .O(satellite_gpio_buf[1]),
        .I(),
        .IO(satellite_gpio[1]),
        .T(1'b1)
    );
  
    IOBUF satellite_gpio_2_iobuf (
        .O(satellite_gpio_buf[2]),
        .I(),
        .IO(satellite_gpio[2]),
        .T(1'b1)
    );
  
    IOBUF satellite_gpio_3_iobuf (
        .O(satellite_gpio_buf[3]),
        .I(),
        .IO(satellite_gpio[3]),
        .T(1'b1)
    );
  
  
    top_wrapper top_wrapper_i (
        .hbm_cattrip(hbm_cattrip_buf),
        .mcap_design_switch(mcap_design_switch),
        .pcie_7x_mgt_rxn(pcie_7x_mgt_rxn),
        .pcie_7x_mgt_rxp(pcie_7x_mgt_rxp),
        .pcie_7x_mgt_txn(pcie_7x_mgt_txn),
        .pcie_7x_mgt_txp(pcie_7x_mgt_txp),
        .pcie_mgt_clk_n(pcie_mgt_clk_n),
        .pcie_mgt_clk_p(pcie_mgt_clk_p),
        .pcie_perstn_rst(pcie_perstn_rst_buf),
        .satellite_gpio(satellite_gpio_buf),
        .satellite_uart_rxd(satellite_uart_rxd_buf),
        .satellite_uart_txd(satellite_uart_txd_buf)
    );
endmodule

