library ieee;
use ieee.std_logic_1164.all;
 
entity mux_16_3x1 is 

port (a1,b1,c1 :in std_logic_vector(15 downto 0) ;
		sel :in std_logic_vector(1 downto 0) ;
		d1 : out std_logic_vector(15 downto 0));
		
end mux_16_3x1;

architecture behavioral of mux_16_3x1 is 

begin
process (a1,b1,sel)
begin
	
case sel is
when "00"=> d1 <=a1;
when "10"=> d1 <=b1;
when "01"=> d1 <=c1;
when "11"=> d1 <=c1;
when others=> null;
end case;
end process;
	
end behavioral;