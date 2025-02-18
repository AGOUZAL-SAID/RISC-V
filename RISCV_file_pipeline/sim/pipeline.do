onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb/dut/riscv/RF/clk
add wave -noupdate /tb/dut/gene_reset/reset_n
add wave -noupdate -radix decimal /tb/dut/riscv/PC_before_1
add wave -noupdate -radix decimal /tb/dut/riscv/PC_1
add wave -noupdate /tb/dut/riscv/Instr_2
add wave -noupdate -radix decimal /tb/dut/riscv/jump_3
add wave -noupdate -radix decimal /tb/dut/riscv/PC_2
add wave -noupdate -radix decimal /tb/dut/riscv/ImmExt_2
add wave -noupdate -radix decimal /tb/dut/riscv/SImmExt_2
add wave -noupdate -radix decimal /tb/dut/riscv/PC_plus_imm_3
add wave -noupdate -radix decimal /tb/dut/riscv/TargetAddrResult_3
add wave -noupdate -radix decimal /tb/dut/riscv/PCNextResult_3
add wave -noupdate /tb/dut/riscv/RF/rs1
add wave -noupdate /tb/dut/riscv/RF/rs2
add wave -noupdate /tb/dut/riscv/RF/rd
add wave -noupdate -radix decimal /tb/dut/riscv/WD_3
add wave -noupdate /tb/dut/riscv/RF/val_rd
add wave -noupdate /tb/dut/riscv/RF/write_enable
add wave -noupdate /tb/dut/riscv/decoder/store
add wave -noupdate /tb/dut/riscv/MemWrite_2
add wave -noupdate /tb/dut/riscv/MemWrite_3
add wave -noupdate /tb/dut/riscv/d_write_enable
add wave -noupdate /tb/dut/riscv/RF/val_rs1
add wave -noupdate -radix unsigned /tb/dut/riscv/RF/val_rs2
add wave -noupdate -radix unsigned /tb/dut/riscv/d_data_write
add wave -noupdate {/tb/dut/ram_data/ram[0]}
add wave -noupdate -childformat {{{/tb/dut/riscv/RF/regs[4]} -radix decimal} {{/tb/dut/riscv/RF/regs[18]} -radix unsigned}} -expand -subitemconfig {{/tb/dut/riscv/RF/regs[4]} {-radix decimal} {/tb/dut/riscv/RF/regs[18]} {-height 16 -radix unsigned}} /tb/dut/riscv/RF/regs
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {235 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 238
configure wave -valuecolwidth 40
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
WaveRestoreZoom {175 ns} {320 ns}
