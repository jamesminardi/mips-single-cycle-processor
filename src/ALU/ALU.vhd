-------------------------------------------------------------------------
-- ALU.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a mips ALU
--
-- REQUIRES: MIPS_types.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;


entity ALU is
    port (
        iA : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        iB : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        iALUOp : in std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
        oResult : out std_logic_vector(DATA_WIDTH - 1 downto 0);
        oCout : out std_logic;
        oOverflow : out std_logic;
        oZero : out std_logic);
end ALU;

architecture structural of control is

    component add_sub is
        port(
            iSubtract : in std_logic;
            iA	    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            iB	    : in  std_logic_vector(DATA_WIDTH-1 downto 0);
            oSum	: out std_logic_vector(DATA_WIDTH-1 downto 0);
            oCout 	: out std_logic;
            oCout2  : out std_logic);
    end component;

signal s_subtract : std_logic;
signal s_add_sub_result : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_cout, s_cout2 : std_logic;

begin

    s_subtract <= iALUOp(0);
    
    adder_g: add_sub port map(
        iSubtract => s_subtract;
        iA	    => iA;
        iB	    => iB;
        oSum	=> s_add_sub_result;
        oCout 	=> s_cout;
        oCout2  => s_cout2);

    with iALUOP select
        oResult <=
            s_add_sub_result when "001-"
            iA AND iB when "0100",
            iA OR iB when "0101",
            iA XOR iB when "0111",
            iA NOR iB when "0110",
            -- slt when "1100"
            -- sll when 1000
            -- srl when 1010
            -- sra when 1011
    
    with oResult select
        oZero <=
            '0' when x"00000000",
            '1' when others;
    
    oOverflow <= s_cout XOR s_cout2;
        
        
        
end structural;