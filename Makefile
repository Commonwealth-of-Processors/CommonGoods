CG_rvarch_regfile_tb:
	verilator --binary --trace --top-module CG_rvarch_regfile_tb ./tb/CG_rvarch_regfile_tb.sv ./rtl/CG_rvarch_regfile.sv
	cd obj_dir ; ./VCG_rvarch_regfile_tb

CG_memory_beh_tb:
	verilator --binary --trace --top-module CG_memory_beh_tb ./rtl/CG_memory_interface.sv ./tb/CG_memory_beh_tb.sv ./rtl/CG_memory_beh.sv
	cd obj_dir ; ./VCG_memory_beh_tb

view:
	gtkwave ./obj_dir/wave.vcd

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
