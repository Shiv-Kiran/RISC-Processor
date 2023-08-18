library ieee;
use ieee.std_logic_1164.all;
 
entity full_adder is 

port (x,y,z :in std_logic ;
		d,e: out std_logic);
		
end full_adder;


architecture full_arc of full_adder is

begin

	d <= x xor ( y xor z ) ;
	e <= ( x and y ) or ( x and z ) or ( z and y );
	
end full_arc;