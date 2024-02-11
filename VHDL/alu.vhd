library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
entity alu is
port(x, y : in std_logic_vector(31 downto 0);
-- two input operands
add_sub : in std_logic ; -- 0 = add , 1 = sub
logic_func : in std_logic_vector(1 downto 0 ) ;
-- 00 = AND, 01 = OR , 10 = XOR , 11 = NOR
func : in std_logic_vector(1 downto 0 ) ;
-- 00 = lui, 01 = setless , 10 = arith , 11 = logic
output : out std_logic_vector(31 downto 0) ;
overflow : out std_logic ;
zero : out std_logic);
end alu;
architecture alu_arch of alu is
signal x_temp, y_temp : std_logic_vector (31 downto 0);
signal add_sub_res : std_logic_vector (31 downto 0);
signal lui_command : std_logic_vector (31 downto 0);
signal MSB_res : std_logic_vector (31 downto 0);
signal logic_unit_res : std_logic_vector (31 downto 0);
signal add_sub_res_zero_detection : std_logic_vector (31 downto 0);
signal zero_value : std_logic;
signal x_over, y_over, over_res : std_logic_vector (31 downto 0);
--signal over_res : signed(31 downto 0);
signal add_sub_over : std_logic;
begin
process (x, y, add_sub, logic_func, func, x_temp, y_temp, add_sub_res, logic_unit_res,
add_sub_res_zero_detection, zero_value, MSB_res, add_sub_over, over_res, x_over, y_over,
lui_command)
begin
x_temp <= x;
y_temp <= y;
if (add_sub = '0') then
add_sub_res <= std_logic_vector(unsigned(x) + unsigned(y));
else
add_sub_res <= std_logic_vector(unsigned(x) - unsigned(y));
end if;
if (logic_func = "00") then
logic_unit_res <= x_temp and y_temp;
elsif (logic_func = "01") then
logic_unit_res <= x_temp or y_temp;
elsif (logic_func = "10") then
logic_unit_res <= x_temp xor y_temp;
else
logic_unit_res <= x_temp nor y_temp;
end if;
lui_command <= y; --more will be done later on according to the lab outline
if (unsigned(x) < unsigned(y)) then
MSB_res <= (0 => '1',
others => '0');
elsif (unsigned(x) > unsigned(y)) then
MSB_res <= (others => '0');
else
MSB_res <= MSB_res;
end if;
case func is
when "00" =>
output <= lui_command;
when "01" =>
output <= MSB_res;
when "10" =>
output <= add_sub_res;
when "11" =>
output <= logic_unit_res;
when others =>
output <= (others => 'X');
end case;
add_sub_res_zero_detection <= add_sub_res;
if (unsigned(add_sub_res_zero_detection) = 0) then
zero_value <= '1';
else
zero_value <= '0';
end if;
zero <= zero_value;
x_over <= x;
y_over <= y;
add_sub_over <= add_sub;
--if (add_sub_over = '0') then
-- over_res <= std_logic_vector(signed(x_over) + signed(y_over));
-- overflow <= (x_over(31) and y_over(31) and (not add_sub_over) and (not over_res(31)))
-- or ((not x_over(31)) and (not y_over(31)) and (not add_sub_over) and (over_res(31)));
--else
-- over_res <= std_logic_vector(signed(x_over) - signed(y_over));
-- overflow <= (x_over(31) and (not y_over(31)) and (not over_res(31)) and add_sub_over)
-- or ((not x_over(31)) and (y_over(31)) and (over_res(31)) and add_sub_over);
if (add_sub = '0') then
over_res <= std_logic_vector(signed(x_over) + signed(y_over));
if (x_over(31) = '1' and y_over(31) = '1') then
if (over_res(31) = '1') then
overflow <= '1';
else
overflow <= '1';
end if;
elsif (x_over(31) = '1' and y_over(31) = '0') then
if (over_res(31) = '1') then
overflow <= '1';
else
overflow <= '0';
end if;
else
overflow <= '0';
end if;
else
over_res <= std_logic_vector(signed(x_over) - signed(y_over));
if (x_over(31) = '1' and y_over(31) = '0') then
if (over_res(31) = '1') then
overflow <= '0';
else
overflow <= '1';
end if;
elsif (x_over(31) = '0' and y_over(31) = '1') then
if (over_res(31) = '1') then
overflow <= '1';
else
overflow <= '0';
end if;
else
overflow <= '0';
end if;
end if;
end process;
end alu_arch;
