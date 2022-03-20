library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity fetch is
      port(
		i_CLK : in std_logic; --clock
                i_Addr   : in std_logic_vector(DATA_WIDTH - 1 downto 0); --input address
                i_Jump   : in std_logic; --input 0 or 1 for jump or not jump
                i_Branch   : in std_logic; --input 0 or 1 for branch or not branch
				i_Imm  : in std_logic_vector(DATA_WIDTH - 1 downto 0);
                o_Addr   : out std_logic_vector(DATA_WIDTH - 1 downto 0)); --output address

end fetch;

architecture behavior of fetch is

	
	component mux2t1_N is --mux's
  	  	generic(N : integer := 32);
  		port(
		        i_S          : in std_logic;
   	            i_D0         : in std_logic_vector(N-1 downto 0);
             	i_D1         : in std_logic_vector(N-1 downto 0);
	     	    o_O          : out std_logic_vector(N-1 downto 0));
	end component;

	
	component full_adder_N is --add feature
		port(
			iA		: in 	std_logic_vector(DATA_WIDTH - 1 downto 0);
			iB		: in 	std_logic_vector(DATA_WIDTH-1 downto 0);
			iCin	: in 	std_logic; -- Not needed
			oSum	: out 	std_logic_vector(DATA_WIDTH-1 downto 0);
			oCout2	: out	std_logic; -- Not needed: Cout before the last adder
		 	oCout 	: out 	std_logic);
	end component;

	component barrel_shifter is	
		port(
			iA           : in std_logic_vector(DATA_WIDTH -1 downto 0);
			iLeft        : in std_logic;
			iArithmetic  : in std_logic;
			iShamt       : in std_logic_vector(DATA_SELECT-1 downto 0);
			oResult      : out std_logic_vector(DATA_WIDTH-1 downto 0));
	end component;

	component and2 is
		port(
			i_A  : in std_logic;
			i_B  : in std_logic;
			o_F  : out std_logic);
	end component;
	
    --add this section for the sigals and begin stuff
signal s_PCPlus4 : std_logic_vector(DATA_SELECT-1 downto 0);
	        
	begin 
	generic(int : integer := 4);
	G_NBit_MUX: for i in 0 to 31 generate -- there are 32 registers that will be tried in the mux
	
	ADD_4: full_adder_N --does the pc+4
	port map (
			iA			 => s_IMemAddr, -- PC data 
			iB			 => int, -- 4
			iCin	     => s_inner_carry, --carry in
			oSum		 => oSum, -- sum = PC + 4 
			oCout 		 => oCout); --carry out

	SHIFT_1: barrel_shifter --shift to jump MUX
		port map (
			iA               => iA,
			iLeft            => 1,
			iArithmetic      => 0,
			iShamt           => iShamt,
			oResult          => oResult);

	SHIFT_2: barrel_shifter --shift to ALU
		port map (
				iA           => iA, --input signal from barrel shift file
				iLeft        => 1,
				iArithmetic  => 0,
				iShamt       => iShamt,
				oResult      => oResult); --output	

	ADD_ALU: full_adder_N --(pc+4) + shift2 to branch mux
		port map (
				iA			 => oSum, --PC+4
				iB			 => iB, -- shift2 sign ext
				iCin		 => s_inner_carry, --carry in
				oSum		 => oSum, -- PC+4 + shift2 sign ext
				oCout 		 => oCout); -- carry out

	AND_1: andg2 -- and for the branch mux
		port map (
				i_A          => i_A, --control branch
				i_B          => i_B, --alu zero
				o_F          => o_F);

	B_MUX: mux2t1_N
		port map (
				i_S          => s_andres, -- select = alu branch AND ALU zero
			    i_D0         => i_D0(i), -- 0 = result of add4
	    		i_D1         => i_D1(i), -- 1 = result of add alu (add4 + shifted sign ext)
				o_O          => o_O);	-- goes to jump mux D1

	J_MUX: mux2t1_N
		port map (
				i_S          => i_S, --jump select = alu control jump
   	            i_D0         => i_D0(i), --0 = result of the branch mux
             	i_D1         => i_D1(i), --1 = jump addr (31-0)
	     	    o_O          => s_NextInstAddr); --output goes to PC (next inst addr in processor)


	




end behavior;
