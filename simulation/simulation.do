vlog -novopt mult_rom_time_impl.v -y D:/Xilinx/Vivado/2016.4/data/verilog/src/unisims +libext+.v
vlog -novopt sbox.v
vlog -novopt gamma.v
vlog -novopt tau.v
vlog -novopt pi.v
vlog -novopt omega.v
vlog -novopt theta.v
vlog -novopt sigma.v
vlog -novopt round.v
vlog -novopt key_selection.v
vlog -novopt key_evolution.v
vlog -novopt anubis.v
vlog -novopt tb_anubis.v
vsim -novopt -t ps +masdelays tb_anubis glbl