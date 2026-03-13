# ####################################################################

#  Created by Genus(TM) Synthesis Solution 21.17-s066_1 on Thu Apr 10 20:32:44 EDT 2025

# ####################################################################

set sdc_version 2.0

set_units -capacitance 1000fF
set_units -time 1000ps

# Set the current design
current_design alu_1bit

create_clock -name "clk" -period 1000.0 -waveform {0.0 500.0} 
set_load -pin_load 4.0 [get_ports Fi]
set_load -pin_load 4.0 [get_ports Cout]
set_clock_gating_check -setup 0.0 
set_input_delay -clock [get_clocks clk] -add_delay 0.01 [get_ports S3]
set_input_delay -clock [get_clocks clk] -add_delay 0.01 [get_ports S2]
set_input_delay -clock [get_clocks clk] -add_delay 0.01 [get_ports S1]
set_input_delay -clock [get_clocks clk] -add_delay 0.01 [get_ports S0]
set_input_delay -clock [get_clocks clk] -add_delay 0.01 [get_ports Cin]
set_input_delay -clock [get_clocks clk] -add_delay 0.01 [get_ports Ai_plus_1]
set_input_delay -clock [get_clocks clk] -add_delay 0.01 [get_ports Ai_minus_1]
set_input_delay -clock [get_clocks clk] -add_delay 0.01 [get_ports Bi]
set_input_delay -clock [get_clocks clk] -add_delay 0.01 [get_ports Ai]
set_output_delay -clock [get_clocks clk] -add_delay 0.03 [get_ports Cout]
set_output_delay -clock [get_clocks clk] -add_delay 0.03 [get_ports Fi]
set_max_fanout 5.000 [get_ports Ai]
set_max_fanout 5.000 [get_ports Bi]
set_max_fanout 5.000 [get_ports Ai_minus_1]
set_max_fanout 5.000 [get_ports Ai_plus_1]
set_max_fanout 5.000 [get_ports Cin]
set_max_fanout 5.000 [get_ports S0]
set_max_fanout 5.000 [get_ports S1]
set_max_fanout 5.000 [get_ports S2]
set_max_fanout 5.000 [get_ports S3]
set_drive 2.0 [get_ports Ai]
set_drive 2.0 [get_ports Bi]
set_drive 2.0 [get_ports Ai_minus_1]
set_drive 2.0 [get_ports Ai_plus_1]
set_drive 2.0 [get_ports Cin]
set_drive 2.0 [get_ports S0]
set_drive 2.0 [get_ports S1]
set_drive 2.0 [get_ports S2]
set_drive 2.0 [get_ports S3]
set_wire_load_mode "enclosed"
