add wave *
force din X"000100E0"
force clk 0
force reset 1
force write 0
force write_address 00001
force read_a 00001
force read_b 00000
run 2
force din X"90C22AD0"
force clk 1
force reset 0
force write 1
force write_address 00001
force read_a 00000
force read_b 00001
run 2
force clk 0
run 2
force din X"7242AAD2"
force clk 1
force reset 0
force write 1
force write_address 00011
force read_a 00010
force read_b 00011
run 2
force clk 0
run 2
force din X"C65AEAD2"
force clk 1
force reset 0
force write 1
force write_address 00101
force read_a 00100
force read_b 00101
run 2
force clk 0
run 2
force din X"805A02DF"
force clk 1
force reset 0
force write 1
force write_address 00111
force read_a 00110
force read_b 00111
run 2
force clk 0
run 2
force din X"80400401"
force clk 1
force reset 0
force write 1
force write_address 01001
force read_a 01000
force read_b 01001
run 2
force clk 0
run 2
force din X"FC400401"
force clk 1
force reset 0
force write 1
force write_address 01011
force read_a 01010
force read_b 01011
run 2
force clk 0
run 2
force din X"FC430020"
force clk 1
force reset 0
force write 1
force write_address 01101
force read_a 01100
force read_b 01101
run 2
force clk 0
run 2
force din X"10431FE0"
force clk 1
force reset 0
force write 1
force write_address 01111
force read_a 01110
force read_b 01111
run 2
force clk 0
run 2
force din X"000100E0"
force clk 1
force reset 0
force write 1
force write_address 10001
force read_a 10000
force read_b 10001
run 2
force clk 0
run 2
force din X"000100E0"
force clk 1
force reset 0
force write 0
force write_address 10011
force read_a 10010
force read_b 10011
run 2
force clk 0
run 2
force din X"7242AAD2"
force clk 1
force reset 0
force write 1
force write_address 10101
force read_a 10100
force read_b 10101
run 2
force clk 0
run 2
force din X"80400401"
force clk 1
force reset 0
force write 1
force write_address 10111
force read_a 10110
force read_b 10111
run 2
force clk 0
run 2
force din X"FC430020"
force clk 1
force reset 0
force write 1
force write_address 11000
force read_a 11000
force read_b 11001
run 2
force clk 0
run 2
force din X"90C22AD0"
force clk 1
force reset 0
force write 1
force write_address 11010
force read_a 11010
force read_b 11011
run 2
force clk 0
run 2
force din X"FC400401"
force clk 1
force reset 0
force write 1
force write_address 11100
force read_a 11100
force read_b 11101
run 2
force clk 0
run 2
force din X"000100E0"
force clk 1
force reset 0
force write 0
force write_address 11110
force read_a 11110
force read_b 11111
run 2
