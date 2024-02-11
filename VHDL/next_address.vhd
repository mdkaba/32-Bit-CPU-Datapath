library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
entity next_address is
port(rt, rs : in std_logic_vector(31 downto 0);
-- two register inputs
pc : in std_logic_vector(31 downto 0);
target_address : in std_logic_vector(25 downto 0);
branch_type : in std_logic_vector(1 downto 0);
pc_sel : in std_logic_vector(1 downto 0);
next_pc : out std_logic_vector(31 downto 0)
);
end next_address ;
architecture na_arch of next_address is
--signal temp : signed (31 downto 0);
begin
process(rt, rs, pc, target_address, pc_sel, branch_type)
begin
case pc_sel is
when "00" =>
case branch_type is
when "00" =>
next_pc <= std_logic_vector(unsigned(pc) + 1);
when "01" =>
if (rs = rt) then
next_pc <= std_logic_vector(unsigned(pc) + 1) +
std_logic_vector(resize(signed(target_address(15 downto 0)), next_pc'length));
else
next_pc <= std_logic_vector(unsigned(pc) + 1);
end if;
when "10" =>
if (rs /= rt) then
--temp <= (resize(signed(target_address(15 downto 0)), next_pc'length));
next_pc <= std_logic_vector((signed(pc) + 1) +
(resize(signed(target_address(15 downto 0)), next_pc'length)));
else
next_pc <= std_logic_vector(unsigned(pc) + 1);
end if;
when "11" =>
if (rs < 0) then
next_pc <= std_logic_vector(unsigned(pc) + 1) +
std_logic_vector(resize(signed(target_address(15 downto 0)), next_pc'length));
else
next_pc <= std_logic_vector(unsigned(pc) + 1);
end if;
when others =>
next_pc <= std_logic_vector(unsigned(pc) + 1);
end case;
when "01" =>
next_pc <= std_logic_vector(resize(signed(target_address(15 downto 0)),
next_pc'length));
when "10" =>
next_pc <= rs;
when others =>
next_pc <= std_logic_vector(unsigned(pc) + 1);
end case;
end process;
end na_arch;
