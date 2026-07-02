#========================================================

# RV32I Core SDC Constraints

#========================================================

#---------------- Clock ----------------#
set T_CLK      10.0
set CLK_UNCERT 0.15

create_clock -name clk -period $T_CLK [get_ports clk]
set_clock_uncertainty $CLK_UNCERT [get_clocks clk]

#---------------- I/O Delays ----------------#
set IN_DELAY   1.0
set OUT_DELAY  1.0

set_input_delay  $IN_DELAY  -clock clk 
[remove_from_collection [all_inputs] {clk reset}]

set_output_delay $OUT_DELAY -clock clk [all_outputs]

#---------------- Reset ----------------#
set_false_path   -from [get_ports reset]
set_ideal_network      [get_ports reset]

#---------------- Design Rules ----------------#
set_max_transition  0.4 [current_design]
set_max_fanout      16  [current_design]
set_max_capacitance 0.2 [current_design]

