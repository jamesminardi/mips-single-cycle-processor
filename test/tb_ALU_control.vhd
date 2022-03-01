-------------------------------------------------------------------------
-- TETS: 2 (200ns)
-- REQUIRES: MIPS_types.vhd, ALU_control.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity tb_ALU_control is
end tb_ALU_control;

architecture behavior of tb_ALU_control is
    component ALU_control is
        port (
            -- ALU Op given by Control Unit
            iOP : in std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
    
            -- Instruction: "Funct" field
            iFunct : in std_logic_vector(FUNCT_WIDTH - 1 downto 0);
    
            -- Action for ALU to do
            oAction : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0));
    end component;

signal s_iOP : std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
signal s_iFunct : std_logic_vector(FUNCT_WIDTH - 1 downto 0);
signal s_oAction : std_logic_vector(ALU_OP_WIDTH - 1 downto 0);

begin 
DUT: ALU_control
port map(
    iOP => s_iOP,
    iFunct => s_iFunct,
    oAction => s_oAction);
P_TB: process
begin
    -- Test add
    s_iOP <= "0000"; -- Use Funct
    s_iFunct <= "100000";
    -- Excepted: oAction = 0010 (add)
    wait for 100 ns;

    -- Test addi
    s_iOP <= "0010"; -- Ignore funct & Add
    s_iFunct <= "100101"; -- or funct (to be ignored)
    -- Excepted: oAction = 0010 (add) (Not 0101)
    wait for 100 ns;
end process;
end behavior;