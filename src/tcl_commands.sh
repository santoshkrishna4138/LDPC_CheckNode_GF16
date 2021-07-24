vivado -mode tcl
create_project check_node
add_files {directory}/counter_block.v
add_files {directory}/counter_disable_a.v
update_compile_order -fileset sources_1

add_files -fileset sim_1 {directory}/simulation.v 

add_files -fileset constrs_1 -quiet {directory}/cons.xdc

get_board_parts

set_property board_part xilinx.com:au280:part0:1.1 [current_project]


create_ip -name blk_mem_gen -vendor xilinx.com -library ip -version 8.4 -module_name blk_mem_gen_0 -dir {directory}

set_property -dict [list CONFIG.Memory_Type {True_Dual_Port_RAM} CONFIG.Write_Width_A {6} CONFIG.Read_Width_A {6} CONFIG.Write_Width_B {6} CONFIG.Read_Width_B {6} CONFIG.Enable_B {Use_ENB_Pin} CONFIG.Register_PortB_Output_of_Memory_Primitives {true} CONFIG.Port_B_Clock {100} CONFIG.Port_B_Write_Rate {50} CONFIG.Port_B_Enable_Rate {100}] [get_ips blk_mem_gen_0]


generate_target {instantiation_template} [get_files {directory}/blk_mem_gen_0/blk_mem_gen_0.xci  ]


generate_target all [get_files {directory}/blk_mem_gen_0/blk_mem_gen_0.xci ]


catch { config_ip_cache -export [get_ips -all blk_mem_gen_0] }

export_ip_user_files -of_objects [get_files {directory}/blk_mem_gen_0/blk_mem_gen_0.xci  ] -no_script -sync -force -quiet 

create_ip_run [get_files -of_objects [get_fileset sources_1] {directory}/blk_mem_gen_0/blk_mem_gen_0.xci ]


launch_runs -jobs 8 blk_mem_gen_0_synth_1


create_run -flow {Vivado Synthesis 2019} synth_2

launch_runs synth_2 -jobs 32
