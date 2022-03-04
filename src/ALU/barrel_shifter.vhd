-------------------------------------------------------------------------
-- barrel_shifter.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a right
-- barrel shifter of DATA_WIDTH bits wide.
--
-- REQUIRES: MIPS_types.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity barrel_shifter is
    port(
        iA : in std_logic_vector(DATA_WIDTH - 1 downto 0);
        iLeft : in std_logic;
        iShamt : in std_logic_vector(DATA_SELECT - 1 downto 0);
        oResult : out std_logic_vector(DATA_WIDTH));
end barrel_shifter;

architecture structural of barrel_shifter is
    generic(N : integer := 32);
    component mux2t1_N is
        port(
        i_S    : in std_logic;
        i_D0   : in std_logic_vector(N-1 downto 0);
        i_D1   : in std_logic_vector(N-1 downto 0);
        o_O    : out std_logic_vector(N-1 downto 0));
    end component;

signal s_result_16b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_result_8b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_result_4b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_result_2b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_result_1b : std_logic_vector(DATA_WIDTH - 1 downto 0);
signal s_shifted_16b : std_logic_vector(DATA_WIDTH - 1 downto 0);

begin

    s_shifted_16b(31 downto 15)


    MUX2t1_N_16b: mux2t1_N
        generic map(N => DATA_WIDTH);
        port map(
            i_S => iShamt(4),
            i_D0 => iA,
            i_D1 => 
            o_O => s_result_16b);

    MUX2t1_N_8b: mux2t1_N
        generic map(N => DATA_WIDTH);
        port map(
            i_S => iShamt(3),
            i_D0 => s_result_16b,
            i_D1 => 
            o_O => s_result_8b);

    MUX2t1_N_4b: mux2t1_N
        generic map(N => DATA_WIDTH);
        port map(
            i_S => iShamt(2),
            i_D0 => s_result_8b,
            i_D1 => 
            o_O => s_result_4b);

    MUX2t1_N_2b: mux2t1_N
        generic map(N => DATA_WIDTH);
        port map(
            i_S => iShamt(1),
            i_D0 => s_result_4b,
            i_D1 => 
            o_O => s_result_2b);

    MUX2t1_N_1b: mux2t1_N
        generic map(N => DATA_WIDTH);
        port map(
            i_S => iShamt(0),
            i_D0 => s_result_2b,
            i_D1 => 
            o_O => s_result_1b);

    oResult <= s_result_1b;

end structural;