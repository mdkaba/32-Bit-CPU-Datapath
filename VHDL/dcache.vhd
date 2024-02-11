library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
entity dcache is
port(
clk : in std_logic;
reset : in std_logic;
data_address : in std_logic_vector(4 downto 0);
data_write : in std_logic;
--read : in std_logic;
d_in : in std_logic_vector(31 downto 0);
d_out: out std_logic_vector(31 downto 0));
end dcache;
architecture dcache_arch of dcache is
type d_cac_arr is array (0 to 31) of std_logic_vector(31 downto 0);
signal d_cac_signal : d_cac_arr;
begin
process(clk, reset, data_write)
begin
if reset = '1' then
for i in 0 to 31 loop
d_cac_signal(i) <=
std_logic_vector(to_unsigned(0,d_cac_signal(i)'length));
end loop;
elsif (clk'event and clk = '1') then
if data_write = '1' then
d_cac_signal(to_integer(unsigned(data_address(4 downto 0)))) <= d_in;
end if;
end if;
--if (read = '1') then
-- d_out <= data_address;
--else
-- d_out <= d_cac_signal(to_integer(unsigned(data_address(4 downto 0))));
--end if;
end process;
d_out <= d_cac_signal(to_integer(unsigned(data_address(4 downto 0))));
end dcache_arch;
