library ieee;
use ieee.std_logic_1164.all;

entity ALU is 

port (a,b :in std_logic_vector(15 downto 0) ;
		op,ls : in std_logic;
		c : out std_logic_vector(15 downto 0);
		z ,cout: out std_logic);
		
end ALU;

architecture alu_architecture of ALU is 

component adder_16 is 

port (a1,b1 :in std_logic_vector(15 downto 0) ;
		c1 : out std_logic_vector(15 downto 0);
		cout1: out std_logic);
		
end component;

component nand_16 is 

port (a1,b1 :in std_logic_vector(15 downto 0) ;
		c1 : out std_logic_vector(15 downto 0) );
		
end component;

component adder_16_shift is 

port (a1,b1 :in std_logic_vector(15 downto 0) ;
		c1 : out std_logic_vector(15 downto 0);
		cout1: out std_logic);
		
end component;

component mux_16_3x1 is 

port (a1,b1,c1 :in std_logic_vector(15 downto 0) ;
		sel :in std_logic_vector(1 downto 0) ;
		d1 : out std_logic_vector(15 downto 0));
		
end component;
	
	signal i1,i2,i3,i4 : std_logic_vector(15 downto 0) ;
	signal i5,i6 :std_logic;
	signal sel1 : std_logic_vector(1 downto 0);
	
begin

	-- if ls = '1' then
	-- 	b(15 downto 0) <= b(14 downto 0) & '0';
	-- end if;	
	sel1(0) <= ls;
	sel1(1) <= op;

	g0: adder_16 port map (a1 => a, b1 => b, c1 => i1, cout1=> i5);
	g1: nand_16 port map (a1 => a, b1 => b, c1 => i2);
	g2: adder_16_shift port map (a1 => a, b1 => b, c1 => i4, cout1=> i6);
	g3: mux_16_3x1 port map (a1 => i1, b1 => i2, c1 => i4, sel => sel1, d1=> i3);

	cout <= i5 and not op and ls;
	c <= i3;
	z <= not ( i3(0) or i3(1) or i3(2) or i3(3) or i3(4) or i3(5) or i3(6) or i3(7) or i3(8) or i3(9) or i3(10) or i3(11) or i3(12) or i3(13) or i3(14) or i3(15) );
	
end alu_architecture;