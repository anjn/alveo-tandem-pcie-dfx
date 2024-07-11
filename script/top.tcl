
################################################################
# This is a generated script based on design: top
#
# Though there are limitations about the generated script,
# the main purpose of this utility is to make learning
# IP Integrator Tcl commands easier.
################################################################

namespace eval _tcl {
proc get_script_folder {} {
   set script_path [file normalize [info script]]
   set script_folder [file dirname $script_path]
   return $script_folder
}
}
variable script_folder
set script_folder [_tcl::get_script_folder]

################################################################
# Check if script is running in correct Vivado version.
################################################################
set scripts_vivado_version 2023.2
set current_vivado_version [version -short]

if { [string first $scripts_vivado_version $current_vivado_version] == -1 } {
   puts ""
   if { [string compare $scripts_vivado_version $current_vivado_version] > 0 } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2042 -severity "ERROR" " This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Sourcing the script failed since it was created with a future version of Vivado."}

   } else {
     catch {common::send_gid_msg -ssname BD::TCL -id 2041 -severity "ERROR" "This script was generated using Vivado <$scripts_vivado_version> and is being run in <$current_vivado_version> of Vivado. Please run the script in Vivado <$scripts_vivado_version> then open the design in Vivado <$current_vivado_version>. Upgrade the design by running \"Tools => Report => Report IP Status...\", then run write_bd_tcl to create an updated script."}

   }

   return 1
}

################################################################
# START
################################################################

# To test this script, run the following commands from Vivado Tcl console:
# source top_script.tcl

# If there is no project opened, this script will create a
# project, but make sure you do not have an existing project
# <./myproj/project_1.xpr> in the current working folder.

set list_projs [get_projects -quiet]
if { $list_projs eq "" } {
   create_project project_1 myproj -part xcu55c-fsvh2892-2L-e
   set_property BOARD_PART xilinx.com:au55c:part0:1.0 [current_project]
}


# CHANGE DESIGN NAME HERE
variable design_name
set design_name top

# If you do not already have an existing IP Integrator design open,
# you can create a design using the following command:
#    create_bd_design $design_name

# Creating design if needed
set errMsg ""
set nRet 0

set cur_design [current_bd_design -quiet]
set list_cells [get_bd_cells -quiet]

if { ${design_name} eq "" } {
   # USE CASES:
   #    1) Design_name not set

   set errMsg "Please set the variable <design_name> to a non-empty value."
   set nRet 1

} elseif { ${cur_design} ne "" && ${list_cells} eq "" } {
   # USE CASES:
   #    2): Current design opened AND is empty AND names same.
   #    3): Current design opened AND is empty AND names diff; design_name NOT in project.
   #    4): Current design opened AND is empty AND names diff; design_name exists in project.

   if { $cur_design ne $design_name } {
      common::send_gid_msg -ssname BD::TCL -id 2001 -severity "INFO" "Changing value of <design_name> from <$design_name> to <$cur_design> since current design is empty."
      set design_name [get_property NAME $cur_design]
   }
   common::send_gid_msg -ssname BD::TCL -id 2002 -severity "INFO" "Constructing design in IPI design <$cur_design>..."

} elseif { ${cur_design} ne "" && $list_cells ne "" && $cur_design eq $design_name } {
   # USE CASES:
   #    5) Current design opened AND has components AND same names.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 1
} elseif { [get_files -quiet ${design_name}.bd] ne "" } {
   # USE CASES: 
   #    6) Current opened design, has components, but diff names, design_name exists in project.
   #    7) No opened design, design_name exists in project.

   set errMsg "Design <$design_name> already exists in your project, please set the variable <design_name> to another value."
   set nRet 2

} else {
   # USE CASES:
   #    8) No opened design, design_name not in project.
   #    9) Current opened design, has components, but diff names, design_name not in project.

   common::send_gid_msg -ssname BD::TCL -id 2003 -severity "INFO" "Currently there is no design <$design_name> in project, so creating one..."

   create_bd_design $design_name

   common::send_gid_msg -ssname BD::TCL -id 2004 -severity "INFO" "Making design <$design_name> as current_bd_design."
   current_bd_design $design_name

}

common::send_gid_msg -ssname BD::TCL -id 2005 -severity "INFO" "Currently the variable <design_name> is equal to \"$design_name\"."

if { $nRet != 0 } {
   catch {common::send_gid_msg -ssname BD::TCL -id 2006 -severity "ERROR" $errMsg}
   return $nRet
}

set bCheckIPsPassed 1
##################################################################
# CHECK IPs
##################################################################
set bCheckIPs 1
if { $bCheckIPs == 1 } {
   set list_check_ips "\ 
xilinx.com:ip:axi_intc:4.1\
xilinx.com:ip:xlconcat:2.1\
xilinx.com:ip:xlconstant:1.1\
xilinx.com:ip:axi_quad_spi:3.2\
xilinx.com:ip:util_ds_buf:2.2\
xilinx.com:ip:clk_wiz:6.0\
xilinx.com:ip:proc_sys_reset:5.0\
xilinx.com:ip:cms_subsystem:4.0\
xilinx.com:ip:axi_gpio:2.0\
xilinx.com:ip:mdm:3.2\
xilinx.com:ip:xdma:4.1\
xilinx.com:ip:axi_bram_ctrl:4.1\
xilinx.com:ip:blk_mem_gen:8.4\
xilinx.com:ip:system_ila:1.1\
"

   set list_ips_missing ""
   common::send_gid_msg -ssname BD::TCL -id 2011 -severity "INFO" "Checking if the following IPs exist in the project's IP catalog: $list_check_ips ."

   foreach ip_vlnv $list_check_ips {
      set ip_obj [get_ipdefs -all $ip_vlnv]
      if { $ip_obj eq "" } {
         lappend list_ips_missing $ip_vlnv
      }
   }

   if { $list_ips_missing ne "" } {
      catch {common::send_gid_msg -ssname BD::TCL -id 2012 -severity "ERROR" "The following IPs are not found in the IP Catalog:\n  $list_ips_missing\n\nResolution: Please add the repository containing the IP(s) to the project." }
      set bCheckIPsPassed 0
   }

}

if { $bCheckIPsPassed != 1 } {
  common::send_gid_msg -ssname BD::TCL -id 2023 -severity "WARNING" "Will not continue with creation of design due to the error(s) above."
  return 3
}

##################################################################
# DESIGN PROCs
##################################################################



# Procedure to create entire design; Provide argument to make
# procedure reusable. If parentCell is "", will use root.
proc create_root_design { parentCell } {

  variable script_folder
  variable design_name

  if { $parentCell eq "" } {
     set parentCell [get_bd_cells /]
  }

  # Get object for parentCell
  set parentObj [get_bd_cells $parentCell]
  if { $parentObj == "" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2090 -severity "ERROR" "Unable to find parent cell <$parentCell>!"}
     return
  }

  # Make sure parentObj is hier blk
  set parentType [get_property TYPE $parentObj]
  if { $parentType ne "hier" } {
     catch {common::send_gid_msg -ssname BD::TCL -id 2091 -severity "ERROR" "Parent <$parentObj> has TYPE = <$parentType>. Expected to be <hier>."}
     return
  }

  # Save current instance; Restore later
  set oldCurInst [current_bd_instance .]

  # Set parent object as current
  current_bd_instance $parentObj


  # Create interface ports
  set pcie_7x_mgt [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:pcie_7x_mgt_rtl:1.0 pcie_7x_mgt ]

  set pcie_mgt [ create_bd_intf_port -mode Slave -vlnv xilinx.com:interface:diff_clock_rtl:1.0 pcie_mgt ]

  set satellite_uart [ create_bd_intf_port -mode Master -vlnv xilinx.com:interface:uart_rtl:1.0 satellite_uart ]


  # Create ports
  set satellite_gpio [ create_bd_port -dir I -from 3 -to 0 -type intr satellite_gpio ]
  set_property -dict [ list \
   CONFIG.PortWidth {4} \
   CONFIG.SENSITIVITY {EDGE_RISING} \
 ] $satellite_gpio
  set pcie_perstn_rst [ create_bd_port -dir I -type rst pcie_perstn_rst ]
  set mcap_design_switch [ create_bd_port -dir O mcap_design_switch ]
  set hbm_cattrip [ create_bd_port -dir O -from 0 -to 0 hbm_cattrip ]

  # Create instance: axi_intc, and set properties
  set axi_intc [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_intc:4.1 axi_intc ]
  set_property CONFIG.C_IRQ_CONNECTION {1} $axi_intc


  # Create instance: axi_interconnect, and set properties
  set axi_interconnect [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_interconnect:2.1 axi_interconnect ]
  set_property CONFIG.NUM_MI {5} $axi_interconnect


  # Create instance: irq_concat, and set properties
  set irq_concat [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconcat:2.1 irq_concat ]

  # Create instance: gnd, and set properties
  set gnd [ create_bd_cell -type ip -vlnv xilinx.com:ip:xlconstant:1.1 gnd ]
  set_property CONFIG.CONST_VAL {0} $gnd


  # Create instance: flash_programmer, and set properties
  set flash_programmer [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_quad_spi:3.2 flash_programmer ]
  set_property -dict [list \
    CONFIG.C_FIFO_DEPTH {256} \
    CONFIG.C_SPI_MEMORY {2} \
    CONFIG.C_SPI_MODE {2} \
    CONFIG.C_USE_STARTUP {1} \
    CONFIG.C_USE_STARTUP_INT {1} \
  ] $flash_programmer


  # Create instance: buf_refclk_ibuf, and set properties
  set buf_refclk_ibuf [ create_bd_cell -type ip -vlnv xilinx.com:ip:util_ds_buf:2.2 buf_refclk_ibuf ]
  set_property CONFIG.C_BUF_TYPE {IBUFDSGTE} $buf_refclk_ibuf


  # Create instance: clkwiz_sysclks, and set properties
  set clkwiz_sysclks [ create_bd_cell -type ip -vlnv xilinx.com:ip:clk_wiz:6.0 clkwiz_sysclks ]
  set_property -dict [list \
    CONFIG.CLKIN1_JITTER_PS {40.0} \
    CONFIG.CLKOUT1_JITTER {120.190} \
    CONFIG.CLKOUT1_PHASE_ERROR {92.989} \
    CONFIG.CLKOUT1_REQUESTED_OUT_FREQ {50.000} \
    CONFIG.CLKOUT2_JITTER {165.971} \
    CONFIG.CLKOUT2_PHASE_ERROR {92.989} \
    CONFIG.CLKOUT2_REQUESTED_OUT_FREQ {100.000} \
    CONFIG.CLKOUT2_USED {false} \
    CONFIG.MMCM_CLKFBOUT_MULT_F {3} \
    CONFIG.MMCM_CLKIN1_PERIOD {4.0} \
    CONFIG.MMCM_CLKIN2_PERIOD {10.0} \
    CONFIG.MMCM_CLKOUT0_DIVIDE_F {15} \
    CONFIG.MMCM_CLKOUT1_DIVIDE {1} \
    CONFIG.NUM_OUT_CLKS {1} \
    CONFIG.PLL_CLKIN_PERIOD {4.000} \
    CONFIG.PRIMITIVE {PLL} \
    CONFIG.PRIM_SOURCE {No_buffer} \
    CONFIG.RESET_PORT {resetn} \
    CONFIG.RESET_TYPE {ACTIVE_LOW} \
  ] $clkwiz_sysclks


  # Create instance: psreset_ctrlclk, and set properties
  set psreset_ctrlclk [ create_bd_cell -type ip -vlnv xilinx.com:ip:proc_sys_reset:5.0 psreset_ctrlclk ]
  set_property -dict [list \
    CONFIG.C_AUX_RST_WIDTH {1} \
    CONFIG.C_EXT_RST_WIDTH {1} \
  ] $psreset_ctrlclk


  # Create instance: cms_subsystem, and set properties
  set cms_subsystem [ create_bd_cell -type ip -vlnv xilinx.com:ip:cms_subsystem:4.0 cms_subsystem ]
  set_property CONFIG.HAS_MDM {true} $cms_subsystem


  # Create instance: hbm_test_cattrip, and set properties
  set hbm_test_cattrip [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 hbm_test_cattrip ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_GPIO_WIDTH {1} \
    CONFIG.C_IS_DUAL {0} \
  ] $hbm_test_cattrip


  # Create instance: hbm_test_temp, and set properties
  set hbm_test_temp [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_gpio:2.0 hbm_test_temp ]
  set_property -dict [list \
    CONFIG.C_ALL_OUTPUTS {1} \
    CONFIG.C_ALL_OUTPUTS_2 {1} \
    CONFIG.C_DOUT_DEFAULT {0x0000000A} \
    CONFIG.C_DOUT_DEFAULT_2 {0x00000014} \
    CONFIG.C_GPIO2_WIDTH {7} \
    CONFIG.C_GPIO_WIDTH {7} \
    CONFIG.C_IS_DUAL {1} \
  ] $hbm_test_temp


  # Create instance: mdm, and set properties
  set mdm [ create_bd_cell -type ip -vlnv xilinx.com:ip:mdm:3.2 mdm ]

  # Create instance: xdma, and set properties
  set xdma [ create_bd_cell -type ip -vlnv xilinx.com:ip:xdma:4.1 xdma ]
  set_property -dict [list \
    CONFIG.PF0_DEVICE_ID_mqdma {9048} \
    CONFIG.PF0_SRIOV_VF_DEVICE_ID {A048} \
    CONFIG.PF2_DEVICE_ID_mqdma {9248} \
    CONFIG.PF3_DEVICE_ID_mqdma {9348} \
    CONFIG.axi_data_width {512_bit} \
    CONFIG.axil_master_64bit_en {false} \
    CONFIG.axilite_master_en {true} \
    CONFIG.axilite_master_size {32} \
    CONFIG.axisten_freq {250} \
    CONFIG.cfg_mgmt_if {false} \
    CONFIG.functional_mode {DMA} \
    CONFIG.mcap_enablement {Tandem_PCIe} \
    CONFIG.mode_selection {Advanced} \
    CONFIG.pcie_blk_locn {PCIE4C_X1Y0} \
    CONFIG.pf0_device_id {9048} \
    CONFIG.pf0_msi_enabled {false} \
    CONFIG.pf0_subsystem_id {0007} \
    CONFIG.pl_link_cap_max_link_speed {16.0_GT/s} \
    CONFIG.pl_link_cap_max_link_width {X8} \
    CONFIG.xdma_axilite_slave {false} \
    CONFIG.xdma_pcie_64bit_en {true} \
    CONFIG.xdma_pcie_prefetchable {false} \
  ] $xdma


  # Create instance: axi_bram_ctrl, and set properties
  set axi_bram_ctrl [ create_bd_cell -type ip -vlnv xilinx.com:ip:axi_bram_ctrl:4.1 axi_bram_ctrl ]
  set_property -dict [list \
    CONFIG.DATA_WIDTH {512} \
    CONFIG.SINGLE_PORT_BRAM {1} \
  ] $axi_bram_ctrl


  # Create instance: blk_mem_gen, and set properties
  set blk_mem_gen [ create_bd_cell -type ip -vlnv xilinx.com:ip:blk_mem_gen:8.4 blk_mem_gen ]

  # Create instance: system_ila_1, and set properties
  set system_ila_1 [ create_bd_cell -type ip -vlnv xilinx.com:ip:system_ila:1.1 system_ila_1 ]
  set_property -dict [list \
    CONFIG.C_MON_TYPE {INTERFACE} \
    CONFIG.C_NUM_MONITOR_SLOTS {1} \
    CONFIG.C_SLOT_0_APC_EN {0} \
    CONFIG.C_SLOT_0_AXI_AR_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_AR_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_AW_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_AW_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_B_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_B_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_R_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_R_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_AXI_W_SEL_DATA {1} \
    CONFIG.C_SLOT_0_AXI_W_SEL_TRIG {1} \
    CONFIG.C_SLOT_0_INTF_TYPE {xilinx.com:interface:aximm_rtl:1.0} \
  ] $system_ila_1


  # Create interface connections
  connect_bd_intf_net -intf_net M00_AXI_net [get_bd_intf_pins axi_interconnect/M00_AXI] [get_bd_intf_pins cms_subsystem/s_axi_ctrl]
  connect_bd_intf_net -intf_net M01_AXI_net [get_bd_intf_pins axi_interconnect/M01_AXI] [get_bd_intf_pins axi_intc/s_axi]
  connect_bd_intf_net -intf_net M02_AXI_net [get_bd_intf_pins axi_interconnect/M02_AXI] [get_bd_intf_pins flash_programmer/AXI_LITE]
  connect_bd_intf_net -intf_net M03_AXI_net [get_bd_intf_pins axi_interconnect/M03_AXI] [get_bd_intf_pins hbm_test_cattrip/S_AXI]
  connect_bd_intf_net -intf_net M04_AXI_net [get_bd_intf_pins axi_interconnect/M04_AXI] [get_bd_intf_pins hbm_test_temp/S_AXI]
  connect_bd_intf_net -intf_net S00_AXI_net [get_bd_intf_pins xdma/M_AXI_LITE] [get_bd_intf_pins axi_interconnect/S00_AXI]
connect_bd_intf_net -intf_net [get_bd_intf_nets S00_AXI_net] [get_bd_intf_pins xdma/M_AXI_LITE] [get_bd_intf_pins system_ila_1/SLOT_0_AXI]
  set_property HDL_ATTRIBUTE.DEBUG {true} [get_bd_intf_nets S00_AXI_net]
  connect_bd_intf_net -intf_net axi_bram_ctrl_net [get_bd_intf_pins axi_bram_ctrl/BRAM_PORTA] [get_bd_intf_pins blk_mem_gen/BRAM_PORTA]
  connect_bd_intf_net -intf_net mdm_mbdebug_net [get_bd_intf_pins mdm/MBDEBUG_0] [get_bd_intf_pins cms_subsystem/mdm_mbdebug]
  connect_bd_intf_net -intf_net pcie_mgt_net [get_bd_intf_ports pcie_mgt] [get_bd_intf_pins buf_refclk_ibuf/CLK_IN_D]
  connect_bd_intf_net -intf_net satellite_uart_net [get_bd_intf_pins cms_subsystem/satellite_uart] [get_bd_intf_ports satellite_uart]
  connect_bd_intf_net -intf_net slr1_pcie_7x_mgt_net [get_bd_intf_pins xdma/pcie_mgt] [get_bd_intf_ports pcie_7x_mgt]
  connect_bd_intf_net -intf_net xdma_M_AXI_net [get_bd_intf_pins xdma/M_AXI] [get_bd_intf_pins axi_bram_ctrl/S_AXI]

  # Create port connections
  connect_bd_net -net M00_ACLK_1 [get_bd_pins clkwiz_sysclks/clk_out1] [get_bd_pins axi_intc/s_axi_aclk] [get_bd_pins axi_interconnect/M00_ACLK] [get_bd_pins axi_interconnect/M01_ACLK] [get_bd_pins axi_interconnect/M02_ACLK] [get_bd_pins axi_interconnect/M03_ACLK] [get_bd_pins axi_interconnect/M04_ACLK] [get_bd_pins cms_subsystem/aclk_ctrl] [get_bd_pins flash_programmer/ext_spi_clk] [get_bd_pins flash_programmer/s_axi_aclk] [get_bd_pins hbm_test_cattrip/s_axi_aclk] [get_bd_pins hbm_test_temp/s_axi_aclk] [get_bd_pins psreset_ctrlclk/slowest_sync_clk]
  connect_bd_net -net aclk_pcie_net [get_bd_pins xdma/axi_aclk] [get_bd_pins axi_bram_ctrl/s_axi_aclk] [get_bd_pins axi_interconnect/ACLK] [get_bd_pins axi_interconnect/S00_ACLK] [get_bd_pins clkwiz_sysclks/clk_in1] [get_bd_pins system_ila_1/clk]
  connect_bd_net -net aresetn_ctrl_net [get_bd_pins psreset_ctrlclk/peripheral_aresetn] [get_bd_pins axi_intc/s_axi_aresetn] [get_bd_pins axi_interconnect/M00_ARESETN] [get_bd_pins axi_interconnect/M01_ARESETN] [get_bd_pins axi_interconnect/M02_ARESETN] [get_bd_pins axi_interconnect/M03_ARESETN] [get_bd_pins axi_interconnect/M04_ARESETN] [get_bd_pins cms_subsystem/aresetn_ctrl] [get_bd_pins flash_programmer/s_axi_aresetn] [get_bd_pins hbm_test_cattrip/s_axi_aresetn] [get_bd_pins hbm_test_temp/s_axi_aresetn]
  connect_bd_net -net aresetn_pcie [get_bd_pins xdma/axi_aresetn] [get_bd_pins axi_bram_ctrl/s_axi_aresetn] [get_bd_pins axi_interconnect/ARESETN] [get_bd_pins axi_interconnect/S00_ARESETN] [get_bd_pins psreset_ctrlclk/ext_reset_in] [get_bd_pins system_ila_1/resetn]
  connect_bd_net -net axi_intc_irq_net [get_bd_pins axi_intc/irq] [get_bd_pins xdma/usr_irq_req]
  connect_bd_net -net cms_subsystem_interrupt_host_net [get_bd_pins cms_subsystem/interrupt_host] [get_bd_pins irq_concat/In0]
  connect_bd_net -net flash_programmer_interrupt_net [get_bd_pins flash_programmer/ip2intc_irpt] [get_bd_pins irq_concat/In1]
  connect_bd_net -net gnd_net [get_bd_pins gnd/dout] [get_bd_pins flash_programmer/usrcclkts]
  connect_bd_net -net hbm_cattrip_net [get_bd_pins hbm_test_cattrip/gpio_io_o] [get_bd_pins cms_subsystem/interrupt_hbm_cattrip] [get_bd_ports hbm_cattrip]
  connect_bd_net -net hbm_test_temp_gpio2_net [get_bd_pins hbm_test_temp/gpio2_io_o] [get_bd_pins cms_subsystem/hbm_temp_2]
  connect_bd_net -net hbm_test_temp_gpio_net [get_bd_pins hbm_test_temp/gpio_io_o] [get_bd_pins cms_subsystem/hbm_temp_1]
  connect_bd_net -net intr_net [get_bd_pins irq_concat/dout] [get_bd_pins axi_intc/intr]
  connect_bd_net -net locked_net [get_bd_pins clkwiz_sysclks/locked] [get_bd_pins psreset_ctrlclk/dcm_locked]
  connect_bd_net -net mdm_debug_sys_rst_net [get_bd_pins mdm/Debug_SYS_Rst] [get_bd_pins cms_subsystem/mdm_debug_sys_rst]
  connect_bd_net -net pcie_perstn_rst_net [get_bd_ports pcie_perstn_rst] [get_bd_pins clkwiz_sysclks/resetn] [get_bd_pins xdma/sys_rst_n]
  connect_bd_net -net satellite_gpio_net [get_bd_ports satellite_gpio] [get_bd_pins cms_subsystem/satellite_gpio]
  connect_bd_net -net sys_clk_gt_net [get_bd_pins buf_refclk_ibuf/IBUF_OUT] [get_bd_pins xdma/sys_clk_gt]
  connect_bd_net -net sys_clk_net [get_bd_pins buf_refclk_ibuf/IBUF_DS_ODIV2] [get_bd_pins xdma/sys_clk]
  connect_bd_net -net xdma_mcap_design_switch [get_bd_pins xdma/mcap_design_switch] [get_bd_ports mcap_design_switch]

  # Create address segments
  assign_bd_address -offset 0xC0000000 -range 0x00008000 -target_address_space [get_bd_addr_spaces xdma/M_AXI] [get_bd_addr_segs axi_bram_ctrl/S_AXI/Mem0] -force
  assign_bd_address -offset 0x00040000 -range 0x00010000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs axi_intc/S_AXI/Reg] -force
  assign_bd_address -offset 0x00000000 -range 0x00040000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs cms_subsystem/s_axi_ctrl/Mem] -force
  assign_bd_address -offset 0x00050000 -range 0x00010000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs flash_programmer/AXI_LITE/Reg] -force
  assign_bd_address -offset 0x00100000 -range 0x00001000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs hbm_test_cattrip/S_AXI/Reg] -force
  assign_bd_address -offset 0x00110000 -range 0x00001000 -target_address_space [get_bd_addr_spaces xdma/M_AXI_LITE] [get_bd_addr_segs hbm_test_temp/S_AXI/Reg] -force


  # Restore current instance
  current_bd_instance $oldCurInst

  validate_bd_design
  save_bd_design
}
# End of create_root_design()


##################################################################
# MAIN FLOW
##################################################################

create_root_design ""


