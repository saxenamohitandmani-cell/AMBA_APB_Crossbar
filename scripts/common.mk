# Common simulation rules, included by every lesson's Makefile.
#
# Usage (from a lesson folder):
#   make                      # run with the default simulator
#   make SIM=verilator        # pick a simulator
#   make DEFINES=BUG          # compile with +define+BUG (comma-separated list)
#   make clean
#
# Supported SIM values: verilator, icarus, questa, xcelium, vcs, riviera

SIM     ?= verilator
TOP     ?= tb
SRCS    ?= design.sv testbench.sv
DEFINES ?=
# Extra Verilator options, e.g. VERILATOR_FLAGS="-CFLAGS -fcoroutines" for some prebuilt installs
VERILATOR_FLAGS ?=

comma := ,
DEF_LIST := $(subst $(comma), ,$(DEFINES))

.PHONY: run clean

run: $(SIM)

verilator:
	verilator --binary --timing -j 0 -Wno-fatal -Wno-lint -Wno-style $(VERILATOR_FLAGS) \
	  --top-module $(TOP) $(addprefix +define+,$(DEF_LIST)) $(SRCS)
	./obj_dir/V$(TOP)

icarus:
	iverilog -g2012 -s $(TOP) $(addprefix -D,$(DEF_LIST)) -o sim.out $(SRCS)
	vvp sim.out

questa:
	vlib work
	vlog -sv $(addprefix +define+,$(DEF_LIST)) $(SRCS)
	vsim -c $(TOP) -do "run -all; quit -f"

xcelium:
	xrun -sv -top $(TOP) $(addprefix -define ,$(DEF_LIST)) $(SRCS)

vcs:
	vcs -sverilog -full64 -top $(TOP) $(addprefix +define+,$(DEF_LIST)) $(SRCS) -R

riviera:
	vlib work
	vlog $(addprefix +define+,$(DEF_LIST)) $(SRCS)
	vsim -c $(TOP) -do "run -all; quit"

clean:
	rm -rf obj_dir sim.out work transcript vsim.wlf xcelium.d xrun.* simv* csrc ucli.key *.vcd *.log
