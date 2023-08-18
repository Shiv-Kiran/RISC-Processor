library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;	 
use ieee.std_logic_unsigned.all;

entity register_16 is
 
	port (	data_in: in std_logic_vector(15 downto 0); 
			clk, wr: in std_logic;
			data_out: out std_logic_vector(15 downto 0));
end entity;

architecture behave of register_16 is 

signal Reg: std_logic_vector(15 downto 0) := (others => '0');

begin
data_out <= Reg;

process (data_in,clk,wr)
	begin
	if(wr = '1') then
		if(rising_edge(clk)) then
			Reg <= data_in;
		end if;
	end if;
	end process;

end behave;
