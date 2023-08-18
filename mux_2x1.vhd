library ieee;
use ieee.std_logic_1164.all;
 
entity mux_2x1 is 

port (x,y,sel1 :in std_logic ;
		d: out std_logic);
		
end mux_2x1;


architecture arc_2x1 of mux_2x1 is

begin

	d <= ( x and not sel1 ) or ( y and sel1 ) ;
	 
end arc_2x1;