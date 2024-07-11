# https://support.xilinx.com/s/article/65940?language=ja
set bscan_cells [get_cells -hierarchical -filter { PRIMITIVE_TYPE =~ CONFIGURATION.BSCAN.*} ]
set_property HD.TANDEM_IP_PBLOCK Stage1_Main $bscan_cells

