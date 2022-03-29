-------------------------------------------------------------------------
-- James Minardi
-- control.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a mips Control
-- unit that sets the inputs to the datapath.
--
-- REQUIRES: MIPS_types.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;


entity control is
    port (
        iOpcode     : in std_logic_vector(OPCODE_WIDTH -1 downto 0); -- 6 MSB of 32bit instruction
        -- iALUZero : in std_logic; -- TODO: Zero flag from ALU for PC src?
        -- oPCSrc : in std_logic; -- TODO: Selects using PC+4 or branch addy
        oRegDst     : out std_logic_vector(REGDST_WIDTH  - 1 downto 0); -- Selects r-type vs i-type vs R31 write register
        oALUSrc     : out std_logic; -- Selects source for second ALU input (Rt vs Imm)
        oMemtoReg   : out std_logic_vector(MEMTOREG_WIDTH - 1 downto 0); -- Selects ALU result vs memory result vs PC+4 to reg write
        oRegWrite   : out std_logic; -- Enable register write in datapath->registerfile
        oMemRead    : out std_logic; -- Enable reading of memory in dmem
        oMemWrite   : out std_logic; -- Enable writing to memory in dmem
        oSignExt    : out std_logic; -- Sign extend immediate value
        oJump       : out std_logic; -- Selects setting PC to jump value or not
        oBranch     : out std_logic; -- Helps select using PC+4 or branch address by being Anded with ALU Zero
        oBranchEQ   : out std_logic; -- Determines if BNE or BEQ
        oALUOp      : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0); -- Selects ALU operation or to select from funct field
        oHalt       : out std_logic); -- Halt bit to stop program
end control;

architecture dataflow of control is


    -- Doesn't include JAL & others
begin
    with iOpcode select
        oRegDst <=
            "00" when "001000",  -- Addi
            "00" when "001001",  -- Addiu
            "00" when "001100",  -- Andi
            "00" when "001111",  -- Lui
            "00" when "100011",  -- Lw
            "00" when "001110",  -- Xori
            "00" when "001101",  -- Ori
            "00" when "001010", -- Slti
            "10" when "000011", -- Jal
            "01" when others;
    with iOpcode select
        oALUSrc <=
            '0' when "000000", -- r-type
            '0' when "000100", -- beq
            '0' when "000101", -- bne
            '1' when others;
    with iOpcode select
        oMemtoReg <=
            "01" when "100011", -- lw
            "10" when "000011",  -- jal
            "00" when others;
    with iOpcode select
        oRegWrite <=
            '1' when "000000", -- R-type
            '1' when "001000", -- addi
            '1' when "001001", -- addiu
            '1' when "001100", -- andi
            '1' when "001111", -- lui
            '1' when "100011", -- lw
            '1' when "001110", -- xori
            '1' when "001101", -- ori
            '1' when "001010", -- slti
            '1' when "000011", -- jal
            '0' when others;

    with iOpcode select
        oMemRead <=
            '1' when "100011", -- Lw
            '0' when others;
    with iOpcode select
        oMemWrite <=
            '1' when "101011", -- sw
            '0' when others;
    with iOpcode select
        oSignExt <=
            '1' when "001000",
            '1' when "001001",
            '1' when "100011",
            '1' when "001010",
            '1' when "101011",
            '0' when others;
    with iOpcode select
        oJump <=
            '1' when "000010", -- j
            '1' when "000011", -- jal
            -- Jr sets Jump in top level from alu control
            '0' when others;
    with iOpcode select
        oBranch <=
            '1' when "000100",
            '1' when "000101",
            '0' when others;
    with iOpcode select
        oBranchEQ <=
            '1' when "000100", -- BEQ
            '0' when "000101", -- BNE
            '0' when others;
    with iOpcode select
        oALUOp <=
            "0000" when "000000", -- Funct
            "0010" when "001000",
            "0010" when "001001",
            "0100" when "001100",
            "1001" when "001111", -- Lui
            "0010" when "100011",
            "0111" when "001110",
            "0101" when "001101",
            "1100" when "001010",
            "0010" when "101011",
            "0011" when "000100",
            "0011" when "000101",
            "----" when "000010", -- J
            "0000" when others;
    with iOpcode select
        oHalt <=
            '1' when "010100",
            '0' when others;
        
end dataflow;
