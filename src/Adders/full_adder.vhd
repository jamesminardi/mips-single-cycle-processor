-- libraru declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- entity
entity full_adder is
	Port (	A, B, cin 	: in std_logic;
			sum 		: out std_logic;
			cout 		: out std_logic);
end full_adder;

-- architecture
architecture behavior of full_adder is

	-- AND gate
	component andg2 is
		port (	i_A,
				i_B : in std_logic;
				o_F : out std_logic);
	end component;

	-- OR gate
	component org2 is
  		port (	i_A          : in std_logic;
       			i_B          : in std_logic;
       			o_F          : out std_logic);
	end component;
	
	-- XOR gate
	component xorg2 is
  		port(	i_A          : in std_logic;
       			i_B          : in std_logic;
       			o_F          : out std_logic);
	end component;
	
	signal s_half_adder_sum : std_logic;
	signal s_half_adder_carry : std_logic;
	signal s_half_adder2_carry : std_logic;
	
	begin
	-- Structural
	HA1_xor: xorg2 port map (
		i_A => A,
		i_B => B,
		o_F => s_half_adder_sum);
	
	HA1_and: andg2 port map (
		i_A => A,
		i_B => B,
		o_F => s_half_adder_carry);
	
	HA2_xor: xorg2 port map (
		i_A => s_half_adder_sum,
		i_B => cin,
		o_F => sum);
	
	HA2_and: andg2 port map (
		i_A => s_half_adder_sum,
		i_B => cin,
		o_F => s_half_adder2_carry);
		
	FA_or: org2 port map (
		i_A => s_half_adder_carry,
		i_B => s_half_adder2_carry,
		o_F => cout);

end behavior;
	
	
	
	
	
	
	
	
	
	
	
	

