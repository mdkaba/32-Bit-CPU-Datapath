add wave *

force clk 0
force reset 0
force data_write 1
force data_address 11111
force d_in x"1aaabc11"
run 2

force clk 1
run 5




