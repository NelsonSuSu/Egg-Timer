proc start_step { step } {
  set stopFile ".stop.rst"
  if {[file isfile .stop.rst]} {
    puts ""
    puts "*** Halting run - EA reset detected ***"
    puts ""
    puts ""
    return -code error
  }
  set beginFile ".$step.begin.rst"
  set platform "$::tcl_platform(platform)"
  set user "$::tcl_platform(user)"
  set pid [pid]
  set host ""
  if { [string equal $platform unix] } {
    if { [info exist ::env(HOSTNAME)] } {
      set host $::env(HOSTNAME)
    }
  } else {
    if { [info exist ::env(COMPUTERNAME)] } {
      set host $::env(COMPUTERNAME)
    }
  }
  set ch [open $beginFile w]
  puts $ch "<?xml version=\"1.0\"?>"
  puts $ch "<ProcessHandle Version=\"1\" Minor=\"0\">"
  puts $ch "    <Process Command=\".planAhead.\" Owner=\"$user\" Host=\"$host\" Pid=\"$pid\">"
  puts $ch "    </Process>"
  puts $ch "</ProcessHandle>"
  close $ch
}

proc end_step { step } {
  set endFile ".$step.end.rst"
  set ch [open $endFile w]
  close $ch
}

proc step_failed { step } {
  set endFile ".$step.error.rst"
  set ch [open $endFile w]
  close $ch
}

set_msg_config -id {Common 17-41} -limit 10000000
set_msg_config -id {HDL 9-1061} -limit 100000
set_msg_config -id {HDL 9-1654} -limit 100000
set_msg_config -id {Synth 8-256} -limit 10000
set_msg_config -id {Synth 8-638} -limit 10000

start_step init_design
set ACTIVE_STEP init_design
set rc [catch {
  create_msg_db init_design.pb
  create_project -in_memory -part xc7a100tcsg324-1
  set_property board_part digilentinc.com:nexys4_ddr:part0:1.1 [current_project]
  set_property design_mode GateLvl [current_fileset]
  set_param project.singleFileAddWarning.threshold 0
  set_property webtalk.parent_dir C:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.cache/wt [current_project]
  set_property parent.project_path C:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.xpr [current_project]
  set_property ip_output_repo C:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.cache/ip [current_project]
  set_property ip_cache_permissions {read write} [current_project]
  set_property XPM_LIBRARIES XPM_CDC [current_project]
  add_files -quiet C:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.runs/synth_1/EggD.dcp
  add_files -quiet c:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp
  set_property netlist_only true [get_files c:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.dcp]
  read_xdc -mode out_of_context -ref clk_wiz_0 -cells inst c:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc
  set_property processing_order EARLY [get_files c:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_ooc.xdc]
  read_xdc -prop_thru_buffers -ref clk_wiz_0 -cells inst c:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc
  set_property processing_order EARLY [get_files c:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0_board.xdc]
  read_xdc -ref clk_wiz_0 -cells inst c:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc
  set_property processing_order EARLY [get_files c:/Users/nelso/OneDrive/Desktop/ELEC3500/EggD/EggD.srcs/sources_1/ip/clk_wiz_0/clk_wiz_0.xdc]
  link_design -top EggD -part xc7a100tcsg324-1
  write_hwdef -file EggD.hwdef
  close_msg_db -file init_design.pb
} RESULT]
if {$rc} {
  step_failed init_design
  return -code error $RESULT
} else {
  end_step init_design
  unset ACTIVE_STEP 
}

start_step opt_design
set ACTIVE_STEP opt_design
set rc [catch {
  create_msg_db opt_design.pb
  opt_design 
  write_checkpoint -force EggD_opt.dcp
  report_drc -file EggD_drc_opted.rpt
  close_msg_db -file opt_design.pb
} RESULT]
if {$rc} {
  step_failed opt_design
  return -code error $RESULT
} else {
  end_step opt_design
  unset ACTIVE_STEP 
}

start_step place_design
set ACTIVE_STEP place_design
set rc [catch {
  create_msg_db place_design.pb
  implement_debug_core 
  place_design 
  write_checkpoint -force EggD_placed.dcp
  report_io -file EggD_io_placed.rpt
  report_utilization -file EggD_utilization_placed.rpt -pb EggD_utilization_placed.pb
  report_control_sets -verbose -file EggD_control_sets_placed.rpt
  close_msg_db -file place_design.pb
} RESULT]
if {$rc} {
  step_failed place_design
  return -code error $RESULT
} else {
  end_step place_design
  unset ACTIVE_STEP 
}

start_step route_design
set ACTIVE_STEP route_design
set rc [catch {
  create_msg_db route_design.pb
  route_design 
  write_checkpoint -force EggD_routed.dcp
  report_drc -file EggD_drc_routed.rpt -pb EggD_drc_routed.pb -rpx EggD_drc_routed.rpx
  report_methodology -file EggD_methodology_drc_routed.rpt -rpx EggD_methodology_drc_routed.rpx
  report_timing_summary -warn_on_violation -max_paths 10 -file EggD_timing_summary_routed.rpt -rpx EggD_timing_summary_routed.rpx
  report_power -file EggD_power_routed.rpt -pb EggD_power_summary_routed.pb -rpx EggD_power_routed.rpx
  report_route_status -file EggD_route_status.rpt -pb EggD_route_status.pb
  report_clock_utilization -file EggD_clock_utilization_routed.rpt
  close_msg_db -file route_design.pb
} RESULT]
if {$rc} {
  write_checkpoint -force EggD_routed_error.dcp
  step_failed route_design
  return -code error $RESULT
} else {
  end_step route_design
  unset ACTIVE_STEP 
}

