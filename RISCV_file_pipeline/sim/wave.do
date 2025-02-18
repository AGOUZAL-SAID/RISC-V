onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/dut/riscv/reset_n
add wave -noupdate /tb/dut/riscv/clk
add wave -noupdate /tb/dut/riscv/IF
add wave -noupdate /tb/dut/riscv/ID
add wave -noupdate /tb/dut/riscv/EX
add wave -noupdate /tb/dut/riscv/MEM
add wave -noupdate /tb/dut/riscv/WB
add wave -noupdate /tb/dut/riscv/PC
add wave -noupdate /tb/dut/riscv/Instr
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/adr_rs1
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/adr_rs2
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/ImmExt
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/SImmExt
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/ALUsrc
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/ALUop
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/jump
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/branch
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/adr_rd
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/RFwrite
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/MemWrite
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/rdSrc
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/PCNext
add wave -noupdate -color Gold -itemcolor Gold /tb/dut/riscv/nbDeBits
add wave -noupdate /tb/dut/riscv/rs1
add wave -noupdate /tb/dut/riscv/rs2
add wave -noupdate /tb/dut/riscv/ALUResult
add wave -noupdate /tb/dut/riscv/WD
add wave -noupdate /tb/dut/riscv/RD_dataMem
add wave -noupdate /tb/dut/riscv/RD
add wave -noupdate /tb/dut/riscv/writeMem
add wave -noupdate -color Magenta -itemcolor Magenta /tb/dut/riscv/rd
add wave -noupdate -color Magenta -itemcolor Magenta /tb/dut/riscv/writeRF
add wave -noupdate /tb/dut/riscv/PCNextResult
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {429 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 233
configure wave -valuecolwidth 89
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {379 ns}
