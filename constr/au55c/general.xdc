
# (c) Copyright 2020 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
############################################################

# ------------------------------------------------------------------------------
# Clock constraints
# ------------------------------------------------------------------------------

create_clock -period 10.0 -name ref_clk [get_ports pcie_mgt_clk_p[0]]

# ------------------------------------------------------------------------------
# AXI QSPI constraints
# ------------------------------------------------------------------------------

set tdata_trace_delay_max 0.47
set tdata_trace_delay_min 0.35
set tclk_trace_delay_max 0.37
set tclk_trace_delay_min 0.31
set tco_max 7.7
set tco_min 0.25
set tsu 1.75
set th 2.5
create_generated_clock -name clk_sck -source [get_pins -hierarchical *flash_programmer/ext_spi_clk] [get_pins -hierarchical *inst/CCLK] -edges {1 3 5}
set_input_delay -clock clk_sck -max [expr $tco_max + $tdata_trace_delay_max + $tclk_trace_delay_max] [get_pins -hierarchical *STARTUP*/DATA_IN[*]] -clock_fall;
set_input_delay -clock clk_sck -min [expr $tco_min + $tdata_trace_delay_min + $tclk_trace_delay_min] [get_pins -hierarchical *STARTUP*/DATA_IN[*]] -clock_fall;
set_multicycle_path 2 -setup -from clk_sck -to [get_clocks -of_objects [get_pins -hierarchical *flash_programmer/ext_spi_clk]]
set_multicycle_path 1 -hold -end -from clk_sck -to [get_clocks -of_objects [get_pins -hierarchical *flash_programmer/ext_spi_clk]]
set_output_delay -clock clk_sck -max [expr $tsu + $tdata_trace_delay_max - $tclk_trace_delay_min] [get_pins -hierarchical *STARTUP*/DATA_OUT[*]];
set_output_delay -clock clk_sck -min [expr $tdata_trace_delay_min -$th - $tclk_trace_delay_max] [get_pins -hierarchical *STARTUP*/DATA_OUT[*]];
set_multicycle_path 1 -hold -from [get_clocks -of_objects [get_pins -hierarchical *flash_programmer/ext_spi_clk]] -to clk_sck

# ------------------------------------------------------------------------------
# Configuration
# ------------------------------------------------------------------------------

set_property CONFIG_VOLTAGE 1.8                         [current_design]
set_property BITSTREAM.CONFIG.CONFIGFALLBACK Enable     [current_design]
set_property BITSTREAM.GENERAL.COMPRESS TRUE            [current_design]
set_property CONFIG_MODE SPIx4                          [current_design]
set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4            [current_design]
set_property BITSTREAM.CONFIG.EXTMASTERCCLK_EN disable  [current_design]
set_property BITSTREAM.CONFIG.CONFIGRATE 63.8           [current_design]
set_property BITSTREAM.CONFIG.SPI_FALL_EDGE YES         [current_design]
set_property BITSTREAM.CONFIG.UNUSEDPIN Pullup          [current_design]
set_property BITSTREAM.CONFIG.SPI_32BIT_ADDR Yes        [current_design]

# ------------------------------------------------------------------------------
# IO constraints
# ------------------------------------------------------------------------------

# ref_clk
set_property PACKAGE_PIN AR15                           [get_ports {pcie_mgt_clk_p[0]}]

# perst_n
set_property PACKAGE_PIN BF41                           [get_ports pcie_perstn_rst]
set_property -dict {IOSTANDARD LVCMOS18 DRIVE 4}        [get_ports pcie_perstn_rst]

# Satellite Controller UART
set_property PACKAGE_PIN BJ42                           [get_ports satellite_uart_rxd]
set_property -dict {IOSTANDARD LVCMOS18}                [get_ports satellite_uart_rxd]
set_property PACKAGE_PIN BH42                           [get_ports satellite_uart_txd]
set_property -dict {IOSTANDARD LVCMOS18 DRIVE 4}        [get_ports satellite_uart_txd]

# Satellite Controller GPIO
set_property PACKAGE_PIN BE46                           [get_ports satellite_gpio[0]]
set_property -dict {IOSTANDARD LVCMOS18}                [get_ports satellite_gpio[0]]
set_property PACKAGE_PIN BH46                           [get_ports satellite_gpio[1]]
set_property -dict {IOSTANDARD LVCMOS18}                [get_ports satellite_gpio[1]]
set_property PACKAGE_PIN BF45                           [get_ports satellite_gpio[2]]
set_property -dict {IOSTANDARD LVCMOS18}                [get_ports satellite_gpio[2]]
set_property PACKAGE_PIN BF46                           [get_ports satellite_gpio[3]]
set_property -dict {IOSTANDARD LVCMOS18}                [get_ports satellite_gpio[3]]

# Fix the CATTRIP issue for custom flow
# Read AR72926 for details.
set_property -dict {PACKAGE_PIN BE45 IOSTANDARD LVCMOS18 PULLDOWN TRUE} [get_ports hbm_cattrip[0]]

# I2C
#set_property PACKAGE_PIN BM14     [get_ports si5394_scl_io]
#set_property IOSTANDARD  LVCMOS18 [get_ports si5394_scl_io]
#set_property PACKAGE_PIN BN14     [get_ports si5394_sda_io]
#set_property IOSTANDARD  LVCMOS18 [get_ports si5394_sda_io]

# QSFP reference clock from Si5394
#set_property PACKAGE_PIN AD43 [get_ports SYNCE_CLK0_clk_n]
#set_property PACKAGE_PIN AD42 [get_ports SYNCE_CLK0_clk_p]
#set_property PACKAGE_PIN AB43 [get_ports SYNCE_CLK1_clk_n]
#set_property PACKAGE_PIN AB42 [get_ports SYNCE_CLK1_clk_p]

# PCIe reference clock from Si5394
#set_property PACKAGE_PIN AK12 [get_ports PCIE_SYSCLK0_clk_n]
#set_property PACKAGE_PIN AK13 [get_ports PCIE_SYSCLK0_clk_p]
#set_property PACKAGE_PIN AP12 [get_ports PCIE_SYSCLK1_clk_n]
#set_property PACKAGE_PIN AP13 [get_ports PCIE_SYSCLK1_clk_p]

# GT 124~127 reference clock from Si5394
#set_property PACKAGE_PIN AK43 [get_ports NS1_SYSCLK5_clk_n]
#set_property PACKAGE_PIN AK42 [get_ports NS1_SYSCLK5_clk_p]
#set_property PACKAGE_PIN AP43 [get_ports NS2_SYSCLK6_clk_n]
#set_property PACKAGE_PIN AP42 [get_ports NS2_SYSCLK6_clk_p]

# SYSCLK4
#set_property PACKAGE_PIN F23  [get_ports SYSCLK4_clk_n]
#set_property IOSTANDARD  LVDS [get_ports SYSCLK4_clk_n]
#set_property PACKAGE_PIN F24  [get_ports SYSCLK4_clk_p]
#set_property IOSTANDARD  LVDS [get_ports SYSCLK4_clk_p]

# ------------------------------------------------------------------------------
# Timings
# ------------------------------------------------------------------------------

#create_clock -period 5.000 -name SYNCE_CLK0 -waveform {0.000 2.500} [get_ports SYNCE_CLK0_clk_p]
#create_clock -period 5.000 -name SYNCE_CLK1 -waveform {0.000 2.500} [get_ports SYNCE_CLK1_clk_p]
#
#create_clock -period 5.000 -name PCIE_SYSCLK0 -waveform {0.000 2.500} [get_ports PCIE_SYSCLK0_clk_p]
#create_clock -period 5.000 -name PCIE_SYSCLK1 -waveform {0.000 2.500} [get_ports PCIE_SYSCLK1_clk_p]
#
#create_clock -period 5.000 -name NS1_SYSCLK5 -waveform {0.000 2.500} [get_ports NS1_SYSCLK5_clk_p]
#create_clock -period 5.000 -name NS2_SYSCLK6 -waveform {0.000 2.500} [get_ports NS2_SYSCLK6_clk_p]
#
#create_clock -period 5.000 -name SYSCLK4 -waveform {0.000 2.500} [get_ports SYSCLK4_clk_p]

# ------------------------------------------------------------------------------
# False paths
# ------------------------------------------------------------------------------

#set_false_path -from [get_pins -hier * -filter {name=~*/freq_counter*/in_freq_reg*/C}] -to [get_pins -hier * -filter {name=~*/freq_counter*/freq_reg*/D}]

# ------------------------------------------------------------------------------
# Tandem PCIe
# ------------------------------------------------------------------------------

set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_cells pcie_perstn_rst_ibuf]
set_property HD.TANDEM 1 [get_cells pcie_perstn_rst_ibuf]

set_property HD.TANDEM_IP_PBLOCK Stage1_Main [get_cells top_wrapper_i/top_i/buf_refclk_ibuf]
set_property HD.TANDEM 1 [get_cells top_wrapper_i/top_i/buf_refclk_ibuf]

set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_cells hbm_cattrip_iobuf]
set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_cells satellite_uart_txd_iobuf]
set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_cells satellite_uart_rxd_iobuf]
set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_cells satellite_gpio_0_iobuf]
set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_cells satellite_gpio_1_iobuf]
set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_cells satellite_gpio_2_iobuf]
set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_cells satellite_gpio_3_iobuf]
set_property HD.TANDEM_IP_PBLOCK Stage1_Config_IO [get_cells VCC]

set_property HD.TANDEM_IP_PBLOCK Stage1_Main [get_cells mcap_design_switch_lut1]

set_property HD.TANDEM_IP_PBLOCK Stage1_Main [get_cells top_wrapper_i/top_i/flash_programmer/U0/NO_DUAL_QUAD_MODE.QSPI_NORMAL/QSPI_LEGACY_MD_GEN.QSPI_CORE_INTERFACE_I/LOGIC_FOR_MD_12_GEN.SCK_MISO_STARTUP_USED.QSPI_STARTUP_BLOCK_I/STARTUP_8SERIES_GEN.STARTUP3_8SERIES_inst]


