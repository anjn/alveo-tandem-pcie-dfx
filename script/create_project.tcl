set board au55c

source [file dirname [info script]]/vars.tcl
source ${script_dir}/board_settings/${board}.tcl

file delete -force ${build_dir}
file mkdir ${build_dir}

create_project $project_name $build_dir -part $part
set_property BOARD_PART $board_part [current_project]

add_files -fileset [get_filesets sources_1] [glob -nocomplain -directory $src_dir "*.{v,vh}"]
add_files -fileset [get_filesets constrs_1] $constr_dir/au55c/general.xdc

source $script_dir/top.tcl

set wrapper_path [make_wrapper -fileset sources_1 -files [get_files -norecurse top.bd] -top]
add_files -norecurse -fileset sources_1 $wrapper_path

set_property top top_wrapper_iobuf [current_fileset]

add_files -fileset utils_1 $constr_dir/pre_place.tcl
set_property STEPS.PLACE_DESIGN.TCL.PRE [ get_files $constr_dir/pre_place.tcl -of [get_fileset utils_1] ] [get_runs impl_1]

