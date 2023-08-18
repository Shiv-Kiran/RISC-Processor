library ieee;
use ieee.std_logic_1164.all;
 
entity adder_16 is 

port (a1,b1 :in std_logic_vector(15 downto 0) ;
		c1 : out std_logic_vector(15 downto 0);
		cout1: out std_logic);
		
end adder_16;

architecture add_arc of adder_16 is 

component full_adder is

  port (x,y,z :in std_logic ;
		d,e: out std_logic);
		
end component ;

	signal h1 : std_logic_vector(14 downto 0) ;
	
begin 
	
	add0: full_adder port map (x => a1(0), y => b1(0), z => '0', d=> c1(0), e=> h1(0));
	add1: full_adder port map (x => a1(1), y => b1(1), z => h1(0), d=> c1(1), e=> h1(1));
	add2: full_adder port map (x => a1(2), y => b1(2), z => h1(1), d=> c1(2), e=> h1(2));
	add3: full_adder port map (x => a1(3), y => b1(3), z => h1(2), d=> c1(3), e=> h1(3));
	add4: full_adder port map (x => a1(4), y => b1(4), z => h1(3), d=> c1(4), e=> h1(4));	
	add5: full_adder port map (x => a1(5), y => b1(5), z => h1(4), d=> c1(5), e=> h1(5));
	add6: full_adder port map (x => a1(6), y => b1(6), z => h1(5), d=> c1(6), e=> h1(6));
	add7: full_adder port map (x => a1(7), y => b1(7), z => h1(6), d=> c1(7), e=> h1(7));
	add8: full_adder port map (x => a1(8), y => b1(8), z => h1(7), d=> c1(8), e=> h1(8));
	add9: full_adder port map (x => a1(9), y => b1(9), z => h1(8), d=> c1(9), e=> h1(9));
	add10: full_adder port map (x => a1(10), y => b1(10), z => h1(9), d=> c1(10), e=> h1(10));
	add11: full_adder port map (x => a1(11), y => b1(11), z => h1(10), d=> c1(11), e=> h1(11));
	add12: full_adder port map (x => a1(12), y => b1(12), z => h1(11), d=> c1(12), e=> h1(12));	
	add13: full_adder port map (x => a1(13), y => b1(13), z => h1(12), d=> c1(13), e=> h1(13));
	add14: full_adder port map (x => a1(14), y => b1(14), z => h1(13), d=> c1(14), e=> h1(14));
	add15: full_adder port map (x => a1(15), y => b1(15), z => h1(14), d=> c1(15), e=> cout1);

	
	
end add_arc;