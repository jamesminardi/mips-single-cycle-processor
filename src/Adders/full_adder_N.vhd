library IEEE;
use IEEE.std_logic_1164.all;

entity full_adder_N is
  generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
  port(x1		: in 	std_logic_vector(N-1 downto 0);
       x2		: in 	std_logic_vector(N-1 downto 0);
       cin		: in 	std_logic;
       sum		: out 	std_logic_vector(N-1 downto 0);
       cout 	: out 	std_logic);

end full_adder_N;

architecture behavior of full_adder_N is

  component full_adder is
	Port (	A, B, cin 	:  in std_logic;
			sum 		: out std_logic;
			cout 		: out std_logic);
  end component;

signal s_inner_carry : std_logic_vector(N-2 downto 0); -- Carry N-1 is just cout

begin
	-- First adder
	full_adder_0: full_adder port map(
		A => x1(0),
		B => x2(0),
		cin => cin,
		sum => sum(0),
		cout => s_inner_carry(0));
	
	-- Middle adders
	nbit_full_adder: for i in 1 to N-2 generate
	full_adder_I: full_adder port map (
		A => x1(i),
		B => x2(i),
		cin => s_inner_carry(i-1),
		sum => sum(i),
		cout => s_inner_carry(i));
	end generate nbit_full_adder;
 

  	-- Final adder
	full_adder_Nm1: full_adder port map(
		A => x1(N-1),
		B => x2(N-1),
		cin => s_inner_carry(N-2),
		sum => sum(N-1),
		cout => cout);
  
end behavior;
