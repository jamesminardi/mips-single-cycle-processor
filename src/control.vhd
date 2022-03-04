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
        oRegDst     : out std_logic; -- Selects r-type vs i-type write register
        oALUSrc     : out std_logic; -- Selects source for second ALU input (Rt vs Imm)
        oMemtoReg   : out std_logic; -- Selects ALU result or memory result to reg write
        oRegWrite   : out std_logic; -- Enable register write in datapath->registerfile
        oMemRead    : out std_logic; -- Enable reading of memory in dmem
        oMemWrite   : out std_logic; -- Enable writing to memory in dmem
        oJump       : out std_logic; -- Selects setting PC to jump value or not
        oBranch     : out std_logic; -- Helps select using PC+4 or branch address by being Anded with ALU Zero
        oALUOp      : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0)); -- Selects ALU operation or to select from funct field
end control;

architecture dataflow of control is


    -- Doesn't include JAL & others
begin
    with iOpcode select
        oRegDst <=
            '1' when "000000", -- R-type
            '1' when "001000",
            '1' when "001001",
            '1' when "001100",
            '0' when "001111",
            '0' when "100011",
            '1' when "001110",
            '1' when "001101",
            '1' when "001010",
            '-' when "101011",
            '-' when "000100",
            '-' when "000101",
            '-' when "000010", -- Jump
            '1' when others;
    with iOpcode select
        oALUSrc <=
            '0' when "000000",
            '1' when "001000",
            '1' when "001001",
            '1' when "001100",
            '1' when "001111",
            '1' when "100011",
            '1' when "001110",
            '1' when "001101",
            '1' when "001010",
            '1' when "101011",
            '0' when "000100",
            '0' when "000101",
            '-' when "000010", -- J
            '0' when others;
    with iOpcode select
        oMemtoReg <=
            '0' when "000000",
            '0' when "001000",
            '0' when "001001",
            '0' when "001100",
            '0' when "001111",
            '1' when "100011",
            '0' when "001110",
            '0' when "001101",
            '0' when "001010",
            '-' when "101011",
            '-' when "000100",
            '-' when "000101",
            '-' when "000010", -- J
            '0' when others;
    with iOpcode select
        oRegWrite <=
            '1' when "000000",
            '1' when "001000",
            '1' when "001001",
            '1' when "001100",
            '1' when "001111",
            '1' when "100011",
            '1' when "001110",
            '1' when "001101",
            '1' when "001010",
            '0' when "101011",
            '0' when "000100",
            '0' when "000101",
            '0' when "000010", -- J
            '1' when others;
    with iOpcode select
        oMemRead <=
            '0' when "000000",
            '0' when "001000",
            '0' when "001001",
            '0' when "001100",
            '0' when "001111",
            '1' when "100011",
            '0' when "001110",
            '0' when "001101",
            '0' when "001010",
            '0' when "101011",
            '0' when "000100",
            '0' when "000101",
            '0' when "000010", -- J
            '0' when others;
    with iOpcode select
        oMemWrite <=
            '0' when "000000",
            '0' when "001000",
            '0' when "001001",
            '0' when "001100",
            '0' when "001111",
            '0' when "100011",
            '0' when "001110",
            '0' when "001101",
            '0' when "001010",
            '1' when "101011",
            '0' when "000100",
            '0' when "000101",
            '0' when "000010", -- J
            '0' when others;
    with iOpcode select
        oJump <=
            '0' when "000000",
            '0' when "001000",
            '0' when "001001",
            '0' when "001100",
            '0' when "001111",
            '0' when "100011",
            '0' when "001110",
            '0' when "001101",
            '0' when "001010",
            '0' when "101011",
            '0' when "000100",
            '0' when "000101",
            '1' when "000010", -- J
            '0' when others;
    with iOpcode select
        oBranch <=
            '0' when "000000",
            '0' when "001000",
            '0' when "001001",
            '0' when "001100",
            '0' when "001111",
            '0' when "100011",
            '0' when "001110",
            '0' when "001101",
            '0' when "001010",
            '0' when "101011",
            '1' when "000100",
            '1' when "000101",
            '-' when "000010", -- J
            '0' when others;
    with iOpcode select
        oALUOp <=
            "0000" when "000000",
            "0010" when "001000",
            "0010" when "001001",
            "0100" when "001100",
            "1000" when "001111",
            "0010" when "100011",
            "0111" when "001110",
            "0101" when "001101",
            "1100" when "001010",
            "0010" when "101011",
            "0011" when "000100",
            "0011" when "000101",
            "----" when "000010", -- J
            "0000" when others;
end dataflow;