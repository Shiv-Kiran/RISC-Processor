library ieee;
use ieee.std_logic_1164.all;
 
entity mux_16_2x1 is 

port (a1,b1 :in std_logic_vector(15 downto 0) ;
		sel :in std_logic ;
		c1 : out std_logic_vector(15 downto 0));
		
end mux_16_2x1;

architecture behavioral of mux_16_2x1 is 

begin
process (a1,b1,sel)
begin
	
case sel is
when '0'=>c1<=a1;
when '1'=>c1<=b1;
when others=> null;
end case;
end process;
	
end behavioral;