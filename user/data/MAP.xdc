set_property -dict {PACKAGE_PIN K17 IOSTANDARD LVCMOS33} [get_ports clock]

create_clock -period 20.000 [get_ports clock]
set_input_jitter [get_clocks -of_objects [get_ports clock]] 0.200
set_property PHASESHIFT_MODE WAVEFORM [get_cells -hierarchical *adv*]

# set_property -dict {PACKAGE_PIN M19 IOSTANDARD LVCMOS33} [get_ports key[0]]
# set_property -dict {PACKAGE_PIN M20 IOSTANDARD LVCMOS33} [get_ports key[1]]
# set_property -dict {PACKAGE_PIN L16 IOSTANDARD LVCMOS33} [get_ports key[2]]
# set_property -dict {PACKAGE_PIN F16 IOSTANDARD LVCMOS33} [get_ports key[3]]

# set_property -dict {PACKAGE_PIN M15 IOSTANDARD LVCMOS33} [get_ports led[0]]
# set_property -dict {PACKAGE_PIN G14 IOSTANDARD LVCMOS33} [get_ports led[1]]
# set_property -dict {PACKAGE_PIN M17 IOSTANDARD LVCMOS33} [get_ports led[2]]
# set_property -dict {PACKAGE_PIN G15 IOSTANDARD LVCMOS33} [get_ports led[3]]
