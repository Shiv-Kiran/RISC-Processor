library ieee;
use ieee.std_logic_1164.all;

entity sign_ex_9 is
	port (a: in std_logic_vector(8 downto 0);
		c: out std_logic_vector(15 downto 0));
end entity ;

architecture sign9_arc of sign_ex_9 is

begin

process(a)

begin
		c(15 downto 7) <= a(8 downto 0);
		c(6) <= '0';
		c(5) <= '0'; 
		c(4) <= '0';
		c(3) <= '0'; 
		c(2) <= '0';
		c(1) <= '0';
		c(0) <= '0';

end process;
end sign9_arc;