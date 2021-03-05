
# PlanAhead Launch Script for Post-Synthesis floorplanning, created by Project Navigator

create_project -name tp_cordic -dir "/home/ignatius/Documents/repos/cordic_vhdl/tp_cordic/planAhead_run_3" -part xc3s500epq208-4
set_property design_mode GateLvl [get_property srcset [current_run -impl]]
set_property edif_top_file "/home/ignatius/Documents/repos/cordic_vhdl/tp_cordic/top_level.ngc" [ get_property srcset [ current_run ] ]
add_files -norecurse { {/home/ignatius/Documents/repos/cordic_vhdl/tp_cordic} {ipcore_dir} }
add_files [list {ipcore_dir/RAM.ncf}] -fileset [get_property constrset [current_run]]
set_property target_constrs_file "/home/ignatius/Documents/repos/cordic_vhdl/tp_cordic/src/pines.ucf" [current_fileset -constrset]
add_files [list {/home/ignatius/Documents/repos/cordic_vhdl/tp_cordic/src/pines.ucf}] -fileset [get_property constrset [current_run]]
link_design
