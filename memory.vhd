library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity memory is 

	port (address1,address2,data_in: in std_logic_vector(15 downto 0); clk,wr: in std_logic;
				data_out: out std_logic_vector(15 downto 0));
				
end memory;

architecture behave of memory is 

type storage is array(65535 downto 0) of std_logic_vector(15 downto 0);

signal mem_array: storage:=(
	0 => x"3001",
	1 => x"1010",
	2 => x"2042",
	3 => x"0038",
	4 => x"54c3",
	5 => x"03fa",
	6 => x"73fb", 
	7 => x"0000",
	8 => x"933a", 
	9 => x"c079", 
	10 => x"1f86",
	11 => x"4f9f",
	12 => x"c9c2",
	13 => x"abcd",
	14 => x"91c0",
	15 => x"1234", 
	16 => x"7caa", 
	17 => x"91c0",
	18 => x"1234",
	19 => x"1254",
	20 => x"1235",
	128 => x"ffff",
	129 => x"0002", 
	130 => x"0000", 
	131 => x"0000", 
	132 => x"0001", 
	133 => x"0000",
	others => x"ffff");

begin

	data_out <= mem_array(to_integer(unsigned(address1)));
	
	process (data_in,address2,clk,wr)
	
		begin
		
		if(wr = '1') then
			if(rising_edge(clk)) then
				mem_array(to_integer(unsigned(address2))) <= data_in;
			end if;
		end if;
		
	end process;

end behave;