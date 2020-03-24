# 
# Synthesis run script generated by Vivado
# 

set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
create_project -in_memory -part xc7a100tcsg324-1

set_param project.singleFileAddWarning.threshold 0
set_param project.compositeFile.enableAutoGeneration 0
set_param synth.vivado.isSynthRun true
set_property webtalk.parent_dir C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.cache/wt [current_project]
set_property parent.project_path C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.xpr [current_project]
set_property XPM_LIBRARIES XPM_CDC [current_project]
set_property default_lib xil_defaultlib [current_project]
set_property target_language Verilog [current_project]
set_property board_part digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
set_property ip_output_repo c:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.cache/ip [current_project]
set_property ip_cache_permissions {read write} [current_project]
add_files -quiet c:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp
set_property used_in_implementation false [get_files c:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp]
read_verilog -library xil_defaultlib {
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/slow_clk.v
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/debouncer.v
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/div59.v
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/bcdto7segment.v
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/show_count_time.v
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/set_cook_time.v
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/run_count_time.v
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/MHZtoHZ.v
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/increment_count_time.v
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/HalfCLK.v
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/seg_mgmt.v
  C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/sources_1/new/EggD.v
}
foreach dcp [get_files -quiet -all *.dcp] {
  set_property used_in_implementation false $dcp
}
read_xdc C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/constrs_1/imports/ELEC3500_1/Nexys4DDR_Master.xdc
set_property used_in_implementation false [get_files C:/Users/nelso/OneDrive/Documents/GitHub/Egg-Timer/EggD.srcs/constrs_1/imports/ELEC3500_1/Nexys4DDR_Master.xdc]


synth_design -top EggD -part xc7a100tcsg324-1


write_checkpoint -force -noxdef EggD.dcp

catch { report_utilization -file EggD_utilization_synth.rpt -pb EggD_utilization_synth.pb }
