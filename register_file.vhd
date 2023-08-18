library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;


entity register_file is 

	port (	address1, address2,	address3: in std_logic_vector(2 downto 0);
			data_in: in std_logic_vector(15 downto 0); 
			clk, wr: in std_logic;
			data_out1, data_out2: out std_logic_vector(15  downto 0));
			
end entity;

architecture str of register_file is
 
type reg_data is array(7 downto 0) of std_logic_vector(15 downto 0);   
signal reg_file: reg_data:= ( 0 => x"0014",
							1 => x"0046",
							others => x"0001");

begin

data_out1 <= reg_file(to_integer(unsigned(address1)));
data_out2 <= reg_file(to_integer(unsigned(address2)));

	process (data_in,address3,clk,wr)

	begin
	if(wr = '1') then
		if(rising_edge(clk)) then
			reg_file(to_integer(unsigned(address3))) <= data_in;
		end if;
	end if;
	
	end process;

end str;
