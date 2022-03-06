-- tb_barrel_shifter.vhd
-------------------------------------------------------------------------
-- TETS: 4 (400ns)
-- REQUIRES: MIPS_types.vhd, barrel_shifter.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity tb_barrel_shifter is
end tb_barrel_shifter;
    
architecture behavior of tb_barrel_shifter is
    component barrel_shifter is
        port(
            iA : in std_logic_vector(DATA_WIDTH - 1 downto 0);
            iLeft : in std_logic;
            iArithmetic : in std_logic;
            iShamt : in std_logic_vector(DATA_SELECT - 1 downto 0);
            oResult : out std_logic_vector(DATA_WIDTH - 1 downto 0));
    end component;

signal s_iA : std_logic_vector(DATA_WIDTH-1 downto 0);
signal s_iLeft : std_logic;
signal s_iArithmetic : std_logic;
signal s_iShamt : std_logic_vector(DATA_SELECT-1 downto 0);
signal s_oResult : std_logic_vector(DATA_WIDTH-1 downto 0);


begin
    DUT: barrel_shifter
    port map(
        iA => s_iA,
        iLeft => s_iLeft,
        iArithmetic => s_iArithmetic,
        iShamt => s_iShamt,
        oResult => s_oResult);
    
    P_TB: process
    begin

-- Test shift right logical
        s_iA <= x"F1E2D3C4";
        s_iLeft <= '0';
        s_iArithmetic <= '0';
        s_iShamt <= "00100" -- Shift 4
        -- Expected:
        --  oResult = x"0F1E2D3C4"
        wait for 100 ns;

-- Test shift right logical 2
        s_iA <= x"F1E2D3C4"; -- 1111_0001_1110_0010_1101_0011_1100_0100
        s_iLeft <= '0';
        s_iArithmetic <= '0';
        s_iShamt <= "00011" -- Shift 3
        -- Expected:
        --  oResult = x"1E3C5A78", 0001_1110_0011_1100_0101_1010_0111_1000
        wait for 100 ns;

-- Test shift right arithmetic
        s_iA <= x"F1E2D3C4";
        s_iLeft <= '0';
        s_iArithmetic <= '1';
        s_iShamt <= "00100" -- Shift 4
        -- Expected:
        --  oResult = x"FF1E2D3C4"
        wait for 100 ns;

-- Test shift left logical
        s_iA <= x"F1E2D3C4";
        s_iLeft <= '0';
        s_iArithmetic <= '0';
        s_iShamt <= "00100" -- Shift 4
        -- Expected:
        --  oResult = x"1E2D3C40"
        wait for 100 ns;

    end process;

end behavior;