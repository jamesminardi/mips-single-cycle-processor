-- tb_control.vhd
-------------------------------------------------------------------------
-- TETS: 2 (200ns)
-- REQUIRES: MIPS_types.vhd, control.vhd
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

-- constants & types declaration
library work;
use work.MIPS_types.all;

entity tb_control is
end tb_control;

architecture behavior of tb_control is
    component control is
        port(
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
    end component;

signal s_iOpcode    : std_logic_vector(OPCODE_WIDTH - 1 downto 0);
signal s_oRegDst    : std_logic;
signal s_oALUSrc    : std_logic;
signal s_oMemtoReg  : std_logic;
signal s_oRegWrite  : std_logic;
signal s_oMemRead   : std_logic;
signal s_oMemWrite  : std_logic;
signal s_oJump      : std_logic;
signal s_oBranch    : std_logic;
signal s_oALUOp     : std_logic_vector(ALU_OP_WIDTH - 1 downto 0);


begin
DUT: control
port map(
    iOpcode     => s_iOpcode,
    oRegDst     => s_oRegDst,
    oALUSrc     => s_oALUSrc,
    oMemtoReg   => s_oMemtoReg,
    oRegWrite   => s_oRegWrite,
    oMemRead    => s_oMemRead,
    oMemWrite   => s_oMemWrite,
    oJump       => s_oJump,
    oBranch     => s_oBranch,
    oALUOp      => s_oALUOp);

P_TB: process
begin
    -- Test add
    s_iOpcode <= "000000";
    -- Excepted:
    --  oRegDst     = 1
    --  oALUSrc     = 0
    --  oMemtoReg   = 0
    --  oRegWrite   = 1
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oBranch     = 0
    --  oALUOp      = 0000
    wait for 100 ns;

    -- Test addi
    s_iOpcode <= "001000";
    -- Excepted:
    --  oRegDst     = 1
    --  oALUSrc     = 1
    --  oMemtoReg   = 0
    --  oRegWrite   = 1
    --  oMemRead    = 0
    --  oMemWrite   = 0
    --  oJump       = 0
    --  oBranch     = 0
    --  oALUOp      = 0010
    wait for 100 ns;
end process;
end behavior;