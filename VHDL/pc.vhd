library IEEE;
use IEEE.std_logic_1164.all;
entity PC is
port(
reset : in std_logic;
clk : in std_logic;
D : in std_logic_vector (31 downto 0);
Q : out std_logic_vector (31 downto 0)
);
end PC;
architecture PC_arch of PC is
begin
process(clk, reset)
begin
if (reset = '1') then
Q <= "00000000000000000000000000000000";
elsif (clk'event and clk = '1') then
Q <= D;
end if;
end process;
end PC_arch;
