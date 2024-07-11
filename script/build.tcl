source [file dirname [info script]]/vars.tcl

open_project $build_dir/$project_name.xpr

update_compile_order -fileset sources_1
reset_run impl_1
launch_runs impl_1 -to_step write_bitstream -jobs $jobs
wait_on_run impl_1
