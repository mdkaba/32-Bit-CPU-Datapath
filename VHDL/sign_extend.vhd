library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
entity sign_extend is
port(
func : in std_logic_vector(1 downto 0);
immediate : in std_logic_vector (15 downto 0);
result : out std_logic_vector( 31 downto 0)
);
end sign_extend;
architecture sign_extend_arch of sign_extend is
begin
process(func, immediate)
begin
case func is
when "00" => result <= immediate & "0000000000000000";
when "11" => result <= "0000000000000000" & immediate;
when others => result <= std_logic_vector(resize(signed(immediate),
result'length));
end case;
end process;
end sign_extend_arch;
