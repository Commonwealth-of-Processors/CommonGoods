cg_rvarch_regfile_tb:
	verilator --binary --trace --top-module cg_rvarch_regfile_tb ./tb/cg_rvarch_regfile_tb.sv ./rtl/cg_rvarch_regfile.sv
	cd obj_dir ; ./Vcg_rvarch_regfile_tb

cg_memory_beh_tb:
	verilator --binary --trace --top-module cg_memory_beh_tb ./rtl/cg_memory_interface.sv ./tb/cg_memory_beh_tb.sv ./rtl/cg_memory_beh.sv
	cd obj_dir ; ./Vcg_memory_beh_tb

cg_counter_tb:
	verilator --binary --trace --top-module cg_counter_tb ./rtl/cg_counter.sv ./tb/cg_counter_tb.sv
	cd obj_dir ; ./Vcg_counter_tb

cg_priority_encoder_tb:
	verilator --binary --trace --top-module cg_priority_encoder_tb ./rtl/cg_priority_encoder.sv ./tb/cg_priority_encoder_tb.sv
	cd obj_dir ; ./Vcg_priority_encoder_tb

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
