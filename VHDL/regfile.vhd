library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
entity regfile is
port(
din : in std_logic_vector(31 downto 0);
reset : in std_logic;
clk : in std_logic;
write : in std_logic;
read_a : in std_logic_vector(4 downto 0);
read_b : in std_logic_vector(4 downto 0);
write_address : in std_logic_vector(4 downto 0);
out_a : out std_logic_vector(31 downto 0);
out_b : out std_logic_vector(31 downto 0));
end regfile;
architecture regfile_arch of regfile is
type t_reg is array (0 to 31) of std_logic_vector(31 downto 0);
signal r_reg : t_reg;
begin
process(clk, reset, write)
begin
if reset = '1' then
for i in 0 to 31 loop
r_reg(i) <= std_logic_vector(to_unsigned(0,r_reg(i)'length));
end loop;
elsif (clk'event and clk ='1') then
if write = '1' then
r_reg(to_integer(unsigned(write_address))) <= din;
end if;
end if;
end process;
out_a <= r_reg(to_integer(unsigned(read_a)));
out_b <= r_reg(to_integer(unsigned(read_b)));
end regfile_arch;
