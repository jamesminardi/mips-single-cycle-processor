-------------------------------------------------------------------------
-- James Minardi
-- ALU_control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of an ALU Control
-- module that selects the operation to be used by the ALU. Abstracts the
-- funct field of the instruction from the Control Unit.
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;


entity ALU_control is
    port (
        -- ALU Op given by Control Unit
        iOP : in std_logic_vector(ALU_OP_WIDTH - 1 downto 0);

        -- Instruction: "Funct" field
        iFunct : in std_logic_vector(FUNCT_WIDTH downto 0);

        -- Action for ALU to do
        oAction : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
    );
end ALU_control;

architecture dataflow of ALU_control




