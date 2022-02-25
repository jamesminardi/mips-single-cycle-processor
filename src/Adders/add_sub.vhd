library IEEE;
use IEEE.std_logic_1164.all;

entity add_sub is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(i_A		: in 	std_logic_vector(N-1 downto 0);
       i_B		: in 	std_logic_vector(N-1 downto 0);
       i_I		: in	std_logic_vector(N-1 downto 0);
       i_nAdd_Sub:in 	std_logic;
       i_ALUSrc	: in	std_logic;
       o_S		: out 	std_logic_vector(N-1 downto 0);
       o_C 		: out 	std_logic);

end add_sub;

architecture behavior of add_sub is

	component full_adder_N is
	port(x1		: in 	std_logic_vector(N-1 downto 0);
       	x2		: in 	std_logic_vector(N-1 downto 0);
       	cin		: in 	std_logic;
       	sum		: out 	std_logic_vector(N-1 downto 0);
       	cout 	: out 	std_logic);
	end component;
  
	component ones_compg is
		port(	i_X	: in std_logic_vector(N-1 downto 0);
  				i_OP		: in std_logic;	-- 1 takes one's complement of number (Inverts all bits)
       			o_F	: out std_logic_vector(N-1 downto 0));
	end component;
	
	component mux2t1_N is
		port(
			i_S          : in std_logic;
			i_D0         : in std_logic_vector(N-1 downto 0);
       		i_D1         : in std_logic_vector(N-1 downto 0);
       		o_O          : out std_logic_vector(N-1 downto 0));
	end component;
	

signal s_inner_carry : std_logic_vector(N-2 downto 0); -- Carry N-1 is just cout
signal s_B : std_logic_vector(N-1 downto 0);
signal complement_to_adder : std_logic_vector(N-1 downto 0);

begin

	operation_g: ones_compg port map(
		i_X => s_B,
		i_OP => i_nAdd_Sub,
		o_F => complement_to_adder);
		
	adder_g: full_adder_N port map(
		x1 => i_A,
		x2 => complement_to_adder,
		cin => i_nAdd_Sub,
		sum => o_S,
		cout => o_C);
	mux_g: mux2t1_N
		port map(
			i_S => i_ALUSrc,
			i_D0 => i_B,
			i_D1 => i_I,
			o_O => s_B);
		
end behavior;
