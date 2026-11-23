# =============================================================================
# Questa run script for this lesson
#
# GUI:    In the Questa Transcript window:
#           cd <path>/phase0_foundations/day01_intro_to_dv
#           do run.do            (normal run)
#           do run.do BUG        (compile with +define+BUG)
#
# Batch:  vsim -c -do "do run.do; quit -f"
#         vsim -c -do "do run.do BUG; quit -f"
# =============================================================================

set TOP  tb
set SRCS {design.sv testbench.sv}

# Optional define passed as the first argument, for example: do run.do BUG
set DEFS ""
if {$argc > 0} { set DEFS "+define+$1" }

# Fresh work library
if {[file exists work]} { vdel -lib work -all }
vlib work

# Compile
eval vlog -sv $DEFS $SRCS

# Elaborate and load (+acc keeps signals visible for waveforms)
vsim -voptargs=+acc work.$TOP

# Add all signals to the wave window when running in the GUI
if {![batch_mode]} { add wave -r /* }

run -all
