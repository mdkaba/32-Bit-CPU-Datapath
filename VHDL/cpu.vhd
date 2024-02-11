library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_signed.all;
use IEEE.numeric_std.all;
entity cpu is
port(
reset : in std_logic;
clk : in std_logic;
rs_out, rt_out : out std_logic_vector(3 downto 0) := (others => '0');
-- output ports from register file
pc_out : out std_logic_vector(3 downto 0) := (others => '0');
overflow, zero : out std_logic);
end cpu;
architecture cpu_arch of cpu is
component dcache_comp is
port(
clk : in std_logic;
reset : in std_logic;
data_address : in std_logic_vector(4 downto 0);
data_write : in std_logic;
--read : in std_logic;
d_in : in std_logic_vector(31 downto 0);
d_out: out std_logic_vector(31 downto 0));
end component;
component icache_comp is
port(
address : in std_logic_vector(4 downto 0);
instruction : out std_logic_vector(31 downto 0));
end component;
component pc_comp is
port(
reset : in std_logic;
clk : in std_logic;
D : in std_logic_vector (31 downto 0);
Q : out std_logic_vector (31 downto 0)
);
end component;
component regfile_comp is
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
end component;
component alu_comp is
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
end component;
component sign_extend_comp is
port(
func : in std_logic_vector(1 downto 0);
immediate : in std_logic_vector (15 downto 0);
result : out std_logic_vector( 31 downto 0)
);
end component;
component two_to_one_mult_32_comp is
port (
sel : in std_logic;
a : in std_logic_vector (31 downto 0);
b : in std_logic_vector(31 downto 0);
c : out std_logic_vector(31 downto 0)
);
end component;
component two_to_one_mult_5_comp is
port (
sel : in std_logic;
a : in std_logic_vector (4 downto 0);
b : in std_logic_vector(4 downto 0);
c : out std_logic_vector(4 downto 0)
);
end component;
component next_address_comp is
port(rt, rs : in std_logic_vector(31 downto 0);
-- two register inputs
pc : in std_logic_vector(31 downto 0);
target_address : in std_logic_vector(25 downto 0);
branch_type : in std_logic_vector(1 downto 0);
pc_sel : in std_logic_vector(1 downto 0);
next_pc : out std_logic_vector(31 downto 0)
);
end component;
-- configuration
for icache_instr : icache_comp use entity work.icache(icache_arch);
for dcache_data : dcache_comp use entity work.dcache(dcache_arch);
for pc : pc_comp use entity work.PC(PC_arch);
for regFile : regfile_comp use entity work.regfile(regfile_arch);
for alu_calculation : alu_comp use entity work.alu(alu_arch);
for extension : sign_extend_comp use entity work.sign_extend(sign_extend_arch);
for mult_32_use_One, mult_32_use_Two : two_to_one_mult_32_comp use entity
work.two_to_one_32_mult(two_to_one_32_arch);
for mult_5_use : two_to_one_mult_5_comp use entity
work.two_to_one_5_mult(two_to_one_5_arch);
for next_addr : next_address_comp use entity work.next_address(na_arch);
-- signals
-- in/out for PC
signal next_pc, out_pc : std_logic_vector(31 downto 0);
signal instr_pc : std_logic_vector (4 downto 0);
-- out I-CACHE
signal icache_out : std_logic_vector (31 downto 0);
--regfile OUT/in
signal reg_out_a, reg_out_b : std_logic_vector (31 downto 0);
signal reg_addr : std_logic_vector (4 downto 0);
signal alu_true_final : std_logic_vector (31 downto 0);
--ALU OUT/IN
signal alu_out : std_logic_vector (31 downto 0);
signal alu_y_in : std_logic_vector (31 downto 0);
--DCACHE OUT
signal dcache_out : std_logic_vector (31 downto 0);
-- EXTEND OUT
signal extend_out : std_logic_vector (31 downto 0);
--control signals
signal reg_dst, reg_write, alu_src, add_sub, data_write, reg_in_src : std_logic;
signal pc_sel, branch_type, func, logic_func : std_logic_vector (1 downto 0);
signal op_ctrl, func_ctrl : std_logic_vector (5 downto 0);
signal instr_result : std_logic_vector (13 downto 0);
begin
-- control unit -
process(op_ctrl, func_ctrl, instr_result, clk, reset, icache_out)
begin
op_ctrl <= icache_out (31 downto 26);
func_ctrl <= icache_out (5 downto 0);
--in order they appear on the graph
case op_ctrl is
when "000000" =>
case func_ctrl is
when "100000" => instr_result <= "11100000100000";
when "100010" => instr_result <= "11101000100000";
when "101010" => instr_result <= "11100000010000";
when "100100" => instr_result <= "11101000110000";
when "100101" => instr_result <= "11100001110000";
when "100110" => instr_result <= "11100010110000";
when "100111" => instr_result <= "11100011110000";
when "001000" => instr_result <= "00000000000010";
when others => instr_result <= "00000000000000";
end case;
when "001111" => instr_result <= "10110000000000";
when "001000" => instr_result <= "10110000100000";
when "001010" => instr_result <= "10110000010000";
when "001100" => instr_result <= "10110000110000";
when "001101" => instr_result <= "10110001110000";
when "001110" => instr_result <= "10110010110000";
when "100011" => instr_result <= "10010010100000";
when "101011" => instr_result <= "00010100100000";
when "000010" => instr_result <= "00000000000001";
when "000001" => instr_result <= "00000000001100";
when "000100" => instr_result <= "00000000000100";
when "000101" => instr_result <= "00000000001000";
when others => instr_result <= "00000000000000";
end case;
reg_write <= instr_result(13);
reg_dst <= instr_result(12);
reg_in_src <= instr_result(11);
alu_src <= instr_result(10);
add_sub <= instr_result(9);
data_write <= instr_result(8);
logic_func <= instr_result(7 downto 6);
func <= instr_result(5 downto 4);
branch_type <= instr_result(3 downto 2);
pc_sel <= instr_result(1 downto 0);
end process;
--mapping--------------------------------------------------------------------------------
pc : pc_comp port map (clk => clk, reset => reset, D => next_pc, Q => out_pc);
icache_instr : icache_comp port map (address => out_pc(4 downto 0), instruction =>
icache_out);
regFile : regfile_comp port map (din => alu_true_final, clk => clk, reset => reset, write =>
reg_write, read_a => icache_out(25 downto 21),
read_b => icache_out(20 downto 16), write_address =>
reg_addr, out_a => reg_out_a, out_b => reg_out_b);
alu_calculation : alu_comp port map (x => reg_out_a, y => alu_y_in, add_sub => add_sub,
logic_func => logic_func,
func => func, output => alu_out, overflow => overflow,
zero => zero);
dcache_data : dcache_comp port map (clk => clk, reset => reset, data_address => alu_out(4
downto 0),
data_write => data_write, d_in => reg_out_b, d_out =>
dcache_out);
extension : sign_extend_comp port map (func => func, immediate => icache_out(15 downto 0),
result => extend_out);
next_addr : next_address_comp port map (rt => reg_out_b, rs => reg_out_a, pc => out_pc,
target_address => icache_out (25 downto 0),
branch_type => branch_type, pc_sel => pc_sel, next_pc =>
next_pc);
mult_5_use : two_to_one_mult_5_comp port map (sel => reg_dst, a => icache_out (20 downto
16), b => icache_out (15 downto 11), c => reg_addr);
mult_32_use_Two : two_to_one_mult_32_comp port map (sel => alu_src, a => reg_out_b, b =>
extend_out, c => alu_y_in);
mult_32_use_One : two_to_one_mult_32_comp port map (sel => reg_in_src, a => dcache_out, b
=> alu_out, c => alu_true_final);
rs_out <= reg_out_a(3 downto 0);
rt_out <= reg_out_b(3 downto 0);
pc_out <= out_pc(3 downto 0);
end cpu_arch;
