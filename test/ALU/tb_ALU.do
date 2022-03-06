vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/MIPS_types.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/Multiplexers/mux2t1.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/Multiplexers/mux2t1_N.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/full_adder.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/full_adder_N.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/add_sub.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/barrel_shifter.vhd

vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/src/ALU/ALU.vhd
vcom -reportprogress 300 -work work ~/cpre381/cpre381-toolflow/proj/test/ALU/tb_ALU.vhd

vsim work.tb_barrel_shifter -voptargs=+acc