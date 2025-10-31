CG_rvarch_regfile_tb:
	verilator --binary --trace --top-module CG_rvarch_regfile_tb ./tb/CG_rvarch_regfile_tb.sv ./rtl/CG_rvarch_regfile.sv
	cd obj_dir ; ./VCG_rvarch_regfile_tb

CG_memory_beh_tb:
	verilator --binary --trace --top-module CG_memory_beh_tb ./rtl/CG_memory_interface.sv ./tb/CG_memory_beh_tb.sv ./rtl/CG_memory_beh.sv
	cd obj_dir ; ./VCG_memory_beh_tb

CG_counter_tb:
	verilator --binary --trace --top-module CG_counter_tb ./rtl/CG_counter.sv ./tb/CG_counter_tb.sv
	cd obj_dir ; ./VCG_counter_tb

view:
	gtkwave -A --rcvar 'fontname_signals Monospace 16' --rcvar 'fontname_waves Monospace 15' ./obj_dir/wave.vcd

clean:
	rm -r obj_dir

FILE := $(filter-out stat, $(MAKECMDGOALS))
ifeq ($(strip $(FILE)),)
  $(error Usage: make stat <your_source_file.sv>)
endif

YS_SCRIPT  = "read_verilog -sv $(FILE); hierarchy -auto-top; synth; stat"

.PHONY: stat

stat:
	@yosys -p $(YS_SCRIPT)
