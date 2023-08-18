library std;
use std.standard.all;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity IITB_RISC is

	port (clk,rst : in  std_logic);
	 
end entity;

architecture risc_architecture of IITB_RISC is


-- requestes for ra rb rc writes the value of rc depending upon wr
component register_file is 

	port (address1, address2, address3: in std_logic_vector(2 downto 0);
			data_in: in std_logic_vector(15 downto 0); 
			clk, wr: in std_logic;
			data_out1, data_out2: out std_logic_vector(15  downto 0));
			
end component;

-- address1,2 are position in the array data_in is written depending upon value of wr
component memory is 

	port (address1,address2,data_in: in std_logic_vector(15 downto 0); 
			clk,wr: in std_logic;
			data_out: out std_logic_vector(15 downto 0)); -- value at position address1
				
end component;

-- depending upon op calculates sum or nand outputs required flags 
component ALU is 

	port (a,b :in std_logic_vector(15 downto 0) ;
			op,ls : in std_logic;
			c : out std_logic_vector(15 downto 0);
			z ,cout: out std_logic);
		
end component;

-- first 10 are don't care last 6 are from a 
component sign_ex_6 is
	port (a: in std_logic_vector(5 downto 0);
		c: out std_logic_vector(15 downto 0));
end component; 

-- first or last 9 of c are a depending upon value of a
component sign_ex_9 is
	port (a: in std_logic_vector(8 downto 0);
		c: out std_logic_vector(15 downto 0));
end component;

-- states for various operations 
type state_machine is (start, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17, s18, s19, s20, s21, s22, s23, s24, s_end);
signal state: state_machine :=start;
signal ra1, ra2, ra3 : std_logic_vector(2 downto 0);  --  3 registers
signal r1_data, r2_data, din_reg, alu_a, alu_b, alu_c, addr1, addr2, din_mem, dout_mem, sg_ex6, sg_ex9 : std_logic_vector(15 downto 0);
signal w_reg, c_flag, z_flag, op_alu, shif_alu, w_mem : std_logic;
signal zero, carry : std_logic := '0';		-- zero and carry flag
signal addr, ir, t1, t2, t3, t4 : std_logic_vector(15 downto 0) := "0000000000000000";
signal op_code : std_logic_vector(3 downto 0) :="1111";
signal im_9 : std_logic_vector(8 downto 0);		-- imm9
signal im_6 : std_logic_vector(5 downto 0);		-- imm6

begin

-- input data from din_reg depending upon w_reg get value at ra1, ra2 at r1_data,r2_data
reg_main : register_file port map (address1 => ra1, address2 => ra2, address3 => ra3, data_in => din_reg, clk => clk, wr => w_reg, data_out1 => r1_data, data_out2 => r2_data);
-- inputs alu_a, alu_b , op_alu and output to alu_c with z_flag, c_flag flag
alu_main : ALU port map (a => alu_a, b => alu_b,op => op_alu,ls => shif_alu, c => alu_c, z => z_flag, cout => c_flag);
mem_main : memory port map ( address1 => addr1, address2 => addr2, data_in => din_mem, data_out => dout_mem, wr => w_mem, clk => clk);
sign6_ex : sign_ex_6 port map ( a => im_6, c => sg_ex6 );
sign9_ex : sign_ex_9 port map ( a => im_9, c => sg_ex9 );

process(clk, state, addr, ir, t1, t2, t3, t4, zero ,carry ,op_code )	

	-- state variables
	variable next_state : state_machine;
	variable temp1_next, temp2_next, temp3_next, temp4_next, ir_next, addr_next : std_logic_vector(15 downto 0);
	variable op_code_next : std_logic_vector(3 downto 0);
	variable zero_next,carry_next : std_logic;
	
	begin
	
	next_state :=state;
	temp1_next := t1;
	temp2_next := t2;
	temp3_next := t3;
	temp4_next := t4;
	ir_next := ir;
	addr_next := addr;
	op_code_next := op_code;
	zero_next := zero;
	carry_next := carry;
	
	case state is
		when start =>
			w_reg <= '0';
			w_mem <= '0';
			addr1 <= addr;
			ir_next := dout_mem; -- instruction pulled from memory
			op_code_next := ir_next(15 downto 12);
			temp1_next := "0000000000000000";
			temp2_next := "0000000000000000";
			temp3_next := "0000000000000000";
			temp4_next := "0000000000000000";
			case op_code_next is
				when "0001" =>			-- ADD/ADC/ADZ/ADL
					next_state :=s1;
				when "0000" =>			-- ADI		
					next_state :=s4;
				when "0010" =>			-- NDU/NDC/NDZ
					next_state :=s1;
				when "0011" =>			-- LHI  -- changed the op_code 
					next_state :=s15;
				when "0101" =>			-- LW
					next_state :=s4;
				when "0111" =>			-- SW
					next_state :=s4;
				when "0110" =>			-- LM
					next_state :=s18;
				when "1100" =>			-- SM
					next_state :=s18;
				when "1000" =>			-- BEQ		
					next_state :=s1;
				when "1001" =>			-- JAL
					next_state :=s17;	
				when "1010" =>			-- JLR
					next_state :=s1;
				when "1011" =>			-- JRI 
					next_state :=s1;
				when others => null;
					next_state :=s_end;
			end case;
			
		when s1 =>  -- compute and store task
			ra1 <= ir_next(11 downto 9);
			ra2 <= ir_next(8 downto 6);
			temp1_next := r1_data;
			temp2_next := r2_data;				--  ( ir_next(1 downto 0) = "11" ) or
			if ( op_code_next = "0001" and ( ( ir_next(1 downto 0) = "00" ) or ( ir_next(1 downto 0) = "10" and carry_next = '1' ) or ( ir_next(1 downto 0) = "01" and zero_next = '1' ) ) ) then
				next_state := s2 ;  -- ALU
			elsif ( op_code_next = "0010" and ( ( ir_next(1 downto 0) = "00" ) or ( ir_next(1 downto 0) = "10" and carry_next = '1' ) or ( ir_next(1 downto 0) = "01" and zero_next = '1' ) ) ) then 
				next_state := s23; -- NAND
			elsif ( op_code_next = "1000" ) then
				next_state := s6;  -- BEQ
			elsif ( op_code_next = "1010" ) then
				next_state := s13; -- JLR
			else
				next_state := s_end;
			end if;
		
		when s23 => -- NAND
			w_reg <= '0';
			w_mem <= '0';
			op_alu <= '1'; -- FOR ALU FUNCTION
			shif_alu <= '0';
			alu_a <= temp1_next;
			alu_b <= temp2_next;
			temp3_next := alu_c;
			zero_next := z_flag;
			next_state := s3;
			
		when s2 =>  -- ALU
			w_reg <= '0';
			w_mem <= '0';
			op_alu <= '0'; -- FOR ALU FUNCTION
			if (ir_next(1 downto 0) = "11" ) then  -- for ADL
				shif_alu <= '1';
			else
				shif_alu <= '0';
			end if;
			alu_a <= temp1_next;		-- ALU INPUTS
			alu_b <= temp2_next;		--
			temp3_next := alu_c;		-- ALU OUTPUTS
			zero_next := z_flag;
			carry_next := c_flag;
			next_state := s3;
			
		when s3 => -- for writing register rc register_file function
			w_reg <= '1';
			w_mem <= '0';
			ra3 <= ir_next(5 downto 3);
			din_reg <= temp3_next; -- writing rc value which is alu_c(= temp3_next)
			next_state := s_end; 
		
			-- LW lw ra, rb, Imm - load value of memory from (rb + imm6) and write to ra
		when s4 =>	-- imm6 loading and storing 
			w_reg <= '0';
			w_mem <= '0';
			im_6 <= ir_next(5 downto 0);
			temp4_next := sg_ex6; -- sign extended imm6
			if( ( op_code_next = "0101" ) or ( op_code_next = "0111" ) ) then -- LW/SW 
				next_state := s5;
			elsif ( op_code_next = "1000" ) then -- BEQ
				next_state := s8;  -- branching 
			else -- ADI
				next_state := s7;
			end if;

		when s6 => -- BEQ RA RB IMM6 - ra = rb := branch to PC+imm6
			w_reg <= '0';
			w_mem <= '0';
			if ( temp1_next=temp2_next ) then
				next_state := s4;
			else 
				next_state := s_end;
			end if;
			
		when s8 => -- Branching
			w_reg <= '0';
			w_mem <= '0';
			op_alu <= '0';
			shif_alu <= '0';
			alu_a <= temp4_next; -- ALU Operation
			alu_b <= addr;
			addr_next := alu_c; -- branch to result
			if ( op_code_next = "1001" ) then
				next_state := s14; -- JAL
			else
				next_state := start; -- BEQ
			end if;
			
		when s7 => -- ADI rb ra imm6 : dat(regb) = dat(rega) + exImm6
			w_reg <= '0';
			w_mem <= '0';
			op_alu <= '0';
			shif_alu <= '0';
			ra1 <= ir_next(11 downto 9);
			temp1_next := r1_data;
			alu_a <= temp1_next; -- dat(reg1)
			alu_b <= temp4_next; -- sign extended imm6
			temp3_next := alu_c; -- output
			zero_next := z_flag;
			carry_next := c_flag;
			next_state := s9; -- writing at rb
			
		when s9 => -- writing at rb
			w_reg <= '1';
			w_mem <= '0';
			ra3 <= ir_next(8 downto 6);
			din_reg <= temp3_next;
			next_state := s_end;
			
		when s5 =>  -- LW/SW ra rb imm6 need rb + imm6
			w_reg <= '0';
			w_mem <= '0';
			op_alu <= '0';
			shif_alu <= '0';			
			ra1 <= ir_next(8 downto 6); -- rb 
			temp1_next := r1_data;
			alu_a <= temp1_next; 
			alu_b <= temp4_next; -- sign extended imm6
			temp3_next := alu_c;
			if ( op_code_next = "0101" ) then  -- LW
				next_state := s10; 
			elsif ( op_code_next = "0111" ) then -- SW
				next_state := s11;
			end if;
			
		when s10 => -- Load from dat(rb) + imm6 to rega
			w_reg <= '0';
			w_mem <= '0';
			addr1 <= temp3_next; -- mem postion of dat(rb) + imm6
			temp2_next := dout_mem;  -- dat at that position
			next_state := s12;

		when s12 => -- LW Writing to ra
			w_reg <= '1';  
			w_mem <= '0';
			ra3 <= ir_next(11 downto 9);
			din_reg <= temp2_next;
			zero_next := not ( temp2_next(0) or temp2_next(1) or temp2_next(2) or temp2_next(3) or temp2_next(4) or temp2_next(5) or temp2_next(6) or temp2_next(7) or temp2_next(8) or temp2_next(9) or temp2_next(10) or temp2_next(11) or temp2_next(12) or temp2_next(13) or temp2_next(14) or temp2_next(15) );
			next_state := s_end;

		when s11 => -- SW - Write dat(rega) at mem pos dat(rb) + imm6
			w_reg <= '0';
			w_mem <= '1'; -- memory writing
			ra2 <= ir_next(11 downto 9); -- need ra value
			temp2_next := r2_data;
			addr2 <= temp3_next; -- dat(rb) + imm6
			din_mem <= temp2_next;
			next_state := s_end;

		when s13 =>  -- JLR ra rb - updata pc to dat(rb) and dat(ra) = pc
			w_reg <= '0';
			w_mem <= '0';
			addr_next := temp2_next; -- updating pc to dat(rb)
			next_state := s14;
			
		when s14 => -- JLR, JAL(writing in ra) need to write ra
			w_reg <= '1';
			w_mem <= '0';
			ra3 <= ir_next(11 downto 9);
			din_reg <= std_logic_vector(to_unsigned(to_integer(unsigned(addr)) + 1,16));
			next_state := start;
			
		when s15 => -- LHI ra imm9 -- ra / JRI
			w_reg <= '0';
			w_mem <= '0';
			im_9 <= ir_next(8 downto 0);
			temp1_next := sg_ex9; -- sign extended imm9
			if ( op_code_next = "0011") then -- LHI
				next_state := s16;
			elsif (op_code_next = "1011") then
				next_state := s24;
			end if;
		
		when s24 => -- branching 
			w_reg <= '0';
			w_mem <= '0';
			ra1 <= ir_next(11 downto 9);
			temp4_next := r1_data;
			alu_a <= temp1_next; 
			alu_b <= temp4_next; -- sign extended imm6
			addr_next := alu_c;
			next_state := s_end;

		when s16 => -- LHI write to ra
			w_reg <= '1';
			w_mem <= '0';
			ra3 <= ir_next(11 downto 9);
			din_reg <= temp1_next;
			next_state := s_end;

		when s17 => -- JAL ra imm9 store pc in ra, branch to pc + imm9 
			w_reg <= '0';
			w_mem <= '0';
			im_9 <= ir_next(8 downto 0);
			temp4_next := sg_ex9; -- sign extended imm9
			next_state := s8; -- for branching
			
		when s18 => -- LM/SM ra imm9 
		-- imm9 each bit is indicating if imm9(7) = 0 unset if =1 then set
			w_reg <= '0';
			w_mem <= '0';
			ra1 <= ir_next(11 downto 9);
			temp1_next := r1_data;
			temp2_next := "0000000000000000";
			temp3_next := "0000000000000001";
			if ( op_code_next = "1101" ) then  -- LM
				next_state := s19;
			elsif ( op_code_next = "1100" ) then -- SM
				next_state := s20;
			end if;
			
		when s19 => -- LM consecutive memory is loaded to registers 
			w_reg <= '1'; -- write to registers
			w_mem <= '0';
			addr1 <= temp1_next;
			temp4_next := dout_mem;
			ra3 <= temp2_next(2 downto 0);
			din_reg <= temp4_next;
			next_state := s21;
			
		when s20 =>	 -- SM registers are stored to memory
			w_reg <= '0';
			w_mem <= '1'; -- write to memory
			ra1 <= temp2_next(2 downto 0);
			temp4_next := r1_data;
			addr2 <= temp1_next;
			din_mem <= temp4_next;
			next_state := s21;
			
		when s21 =>
			w_reg <= '0';
			w_mem <= '0';
			op_alu <= '0';
			shif_alu <= '0';
			alu_a <= temp2_next;
			alu_b <= temp3_next;
			temp2_next := alu_c;
			next_state := s22;
		
		when s22 =>
			w_reg <= '0';
			w_mem <= '0';
			op_alu <= '0';
			shif_alu <= '0';
			alu_a <= temp1_next;
			alu_b <= temp3_next;
			temp1_next := alu_c;
			if ( unsigned(temp2_next)<8 ) then -- works like a loop
				if ( op_code_next = "1101" ) then -- LM
					next_state := s19;
				else
					next_state := s20;  -- SM
				end if;
			else
				next_state := s_end;
			end if;
			
		when s_end =>
			w_reg <= '0';
			w_mem <= '0';
			op_alu <= '0';
			shif_alu <= '0';
			alu_a <= "0000000000000001";
			alu_b <= addr_next;
			addr_next := alu_c;
			next_state :=start;
			
		when others => null;
	end case;

	if(rising_edge(clk)) then 
		if( rst='1' ) then -- reset
			t1 <= "0000000000000000";
			t2 <= "0000000000000000";
			t3 <= "0000000000000000";
			t4 <= "0000000000000000";
			zero <= '0';
			carry <= '0';
			op_code <= "1111";
			addr <= "0000000000000000";
			ir <= "0000000000000000";
			state <= start;
		else
			t1 <= temp1_next;
			t2 <= temp2_next;
			t3 <= temp3_next;
			t4 <= temp4_next;
			zero <= zero_next;
			carry <= carry_next;
			op_code <= op_code_next;
			addr <= addr_next;
			ir <= ir_next;
			state <= next_state;
		end if;
	end if;

end process;
end risc_architecture;