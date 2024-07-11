source [file dirname [info script]]/vars.tcl

write_cfgmem -force -format mcs -interface spix4 -size 128 -loadbit "up 0x01002000 $build_dir/$project_name.runs/impl_1/top_wrapper.bit" -file "$build_dir/top.mcs"
