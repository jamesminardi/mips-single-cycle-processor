-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;



entity tb_ones_compg is
	generic(N : integer := 32);
end tb_ones_compg;

architecture behavior of tb_ones_compg is
	component ones_compg is
  		port(	i_X          : in std_logic_vector(N-1 downto 0);
  				i_OP	: in std_logic;
       			o_F		: out 	std_logic_vector(N-1 downto 0));

	end component;

signal s_iA : std_logic_vector(N-1 downto 0) := x"00000000";
signal s_F : std_logic_vector(N-1 downto 0);
signal s_OP : std_logic := '0';

begin

	DUT: ones_compg
	port map (	i_X => s_iA,
			o_F => s_F,
			i_OP => s_OP);


process
	begin
	-- Expected: s_oF = FFFFFFFF
	s_iA <= x"00000000";
	wait for 100 ns;

	-- Expected: s_oF = 10101010101010101010101010101010
	s_iA <= b"01010101010101010101010101010101";
	wait for 100 ns;

	-- Expected: s_oF = 0000FFFF
	s_iA <= x"FFFF0000";
	wait for 100 ns;
end process;
end behavior;

	
