yosys -import

foreach N [list 9 17 19 21 33 35 37 65 67 69] {
	read_verilog -overwrite -defer ../../SynthesisLibrary/syn_lib/*.v 
	read_verilog -overwrite -defer -sv  maxpool_nbit_kdim_kcc.sv
	hierarchy -check -top maxpool_nbit_kdim_kcc -chparam N $N 
	procs; opt; flatten; opt; 
	techmap; opt;
	dfflibmap -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib
	abc -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys.lib -script ../../SynthesisLibrary/lib_EMP/script.abc; 
	opt; clean; opt;
	opt_clean -purge
	stat -liberty ../../SynthesisLibrary/lib_EMP/asic_cell_yosys_area.lib
	write_verilog -noattr -noexpr -nohex syn/maxpool_${N}bit_kdim_kcc_syn.v
}