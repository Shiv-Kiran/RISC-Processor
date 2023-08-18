library ieee, std;
use ieee.std_logic_1164.all;

entity testbench is
end entity;

architecture str of testbench is

component IITB_RISC is
port ( clk, rst : in std_logic);
end component;

signal clk : std_logic := '0';
signal rst : std_logic := '0';

begin

dut_instance: IITB_RISC
	port map (clk => clk, rst => rst);
	process
	
	begin
	wait for 5 ns;
		for I in 1 to 120 loop
			clk <= '1';
			wait for 2.5 ns;
			clk <= '0';
			wait for 2.5 ns;
		end loop;
	wait;
	end process;
end str;
