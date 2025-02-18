# Clock constraints
create_clock -name "clock_50" -period 20.000ns [get_ports {clock_50}]

# Automatically constrain PLL and other generated clocks
derive_pll_clocks -create_base_clocks

# tsu
#set_max_delay -from [all_inputs] -to [get_registers *] 5.000ns

# tco
#set_max_delay -from [get_registers *] -to [all_outputs] 15.000ns

#tpd
#set_max_delay -from [all_inputs] -to [all_outputs] 15.000ns

# th
#set_input_delay -clock virt_clk50 -min -1.5ns [all_inputs]

# tco constraints
#set_output_delay -clock "clock_50" -max 18ns [get_ports {*}] 
#set_output_delay -clock "clock_50" -min -1.000ns [get_ports {*}] 

# tpd constraints
#set_max_delay 20.000ns -from [get_ports {*}] -to [get_ports {*}]
#set_min_delay 1.000ns -from [get_ports {*}] -to [get_ports {*}]

# Remove async reset checking
set_false_path -from [get_registers {gene_reset:gene_reset|R[1]]}] -to [get_registers *]

