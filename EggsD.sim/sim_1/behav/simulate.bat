@echo off
set xv_path=C:\\Xilinx\\Vivado\\2016.3\\bin
call %xv_path%/xsim Egg_TimerTB_behav -key {Behavioral:sim_1:Functional:Egg_TimerTB} -tclbatch Egg_TimerTB.tcl -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0