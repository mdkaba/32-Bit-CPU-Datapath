library IEEE;
use IEEE.std_logic_1164.all;
entity two_to_one_32_mult is
port (
sel : in std_logic;
a : in std_logic_vector (31 downto 0);
b : in std_logic_vector(31 downto 0);
c : out std_logic_vector(31 downto 0)
);
end two_to_one_32_mult;
architecture two_to_one_32_arch of two_to_one_32_mult is
begin
process(sel, a, b)
begin
case sel is
when '0' => c <= a;
when '1' => c <= b;
when others => c <= "00000000000000000000000000000000";
end case;
end process;
end two_to_one_32_arch;
