-------------------------------------------------------------------------
-- Henry Duwe
-- Department of Electrical and Computer Engineering
-- Iowa State University
-------------------------------------------------------------------------


-- MIPS_Processor.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains a skeleton of a MIPS_Processor  
-- implementation.

-- 01/29/2019 by H3::Design created.
-------------------------------------------------------------------------


library IEEE;
use IEEE.std_logic_1164.all;

library work;
use work.MIPS_types.all;

entity MIPS_Processor is
	generic(N : integer := DATA_WIDTH);
	port(
		iCLK            : in std_logic;
		iRST            : in std_logic;
		iInstLd         : in std_logic;
		iInstAddr       : in std_logic_vector(N-1 downto 0);
		iInstExt        : in std_logic_vector(N-1 downto 0);
		-- TODO: Hook this up to the output of the ALU.
		-- It is important for synthesis that you have this
		-- output that can effectively be impacted by all
		-- other components so they are not optimized away.
		oALUOut         : out std_logic_vector(N-1 downto 0));
end MIPS_Processor;

architecture structure of MIPS_Processor is
-- Required data memory signals
signal s_DMemWr			: std_logic; -- TODO: use this signal as the final active high data memory write enable signal
signal s_DMemAddr		: std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory address input
signal s_DMemData		: std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input
signal s_DMemOut		: std_logic_vector(N-1 downto 0); -- TODO: use this signal as the data memory output
 
-- Required register file signals 
signal s_RegWr    		: std_logic; -- TODO: use this signal as the final active high write enable input to the register file
signal s_RegWrAddr		: std_logic_vector(4 downto 0); -- TODO: use this signal as the final destination register address input
signal s_RegWrData		: std_logic_vector(N-1 downto 0); -- TODO: use this signal as the final data memory data input

-- Required instruction memory signals
signal s_IMemAddr    	: std_logic_vector(N-1 downto 0); -- Do not assign this signal, assign to s_NextInstAddr instead
signal s_NextInstAddr	: std_logic_vector(N-1 downto 0); -- TODO: use this signal as your intended final instruction memory address input.
signal s_Inst        	: std_logic_vector(N-1 downto 0); -- TODO: use this signal as the instruction signal 

-- Required halt signal -- for simulation
-- TODO: this signal indicates to the simulation that intended
-- program execution has completed. (Opcode: 01 0100)
signal s_Halt			: std_logic;


-- Required overflow signal -- for overflow exception detection
-- TODO: this signal indicates an overflow exception would have
-- been initiated
signal s_Ovfl			: std_logic;

	component mem is
		generic(ADRR_WIDTH : integer;
				DATA_WIDTH : integer);
		port(
			clk		: in std_logic;
			addr	: in std_logic_vector((ADDR_WIDTH-1) downto 0);
			data	: in std_logic_vector((DATA_WIDTH-1) downto 0);
			we		: in std_logic := '1';
			q		: out std_logic_vector((DATA_WIDTH -1) downto 0));
	end component;

-- TODO: You may add any additional signals or components your implementation 
--       requires below this comment

-- ### Control signals
signal s_Opcode 	: std_logic_vector(OPCODE_WIDTH - 1 downto 0);
signal s_RegDst 	: std_logic_vector(DATA_SELECT - 1 downto 0);
signal s_ALUSrc 	: std_logic;
signal s_MemtoReg 	: std_logic;
signal s_RegWrite 	: std_logic;
signal s_MemRead 	: std_logic;
signal s_MemWrite 	: std_logic;
signal s_Jump 		: std_logic;
signal s_Branch 	: std_logic;
signal s_ALUOp 		: std_logic_vector(ALU_OP_WIDTH - 1 downto 0);


signal s_WriteRegister : std_logic_vector(DATA_SELECT - 1 downto 0); -- Input into regfile i_Rd

	component regfile is
		generic(N 	  : integer;
				REG_W : integer);
		port(
			i_CLK : in std_logic;		-- Clock input
			i_RST : in std_logic;		-- Reset
			i_We : in std_logic;		-- Write enable
			i_Rs : in std_logic_vector(REG_W - 1 downto 0); -- Register to read 1
			i_Rt : in std_logic_vector(REG_W - 1 downto 0); -- Register to read 2
			i_Rd : in std_logic_vector(REG_W - 1 downto 0); -- Reg being written to
			i_Wd : in std_logic_vector(N -1 downto 0);		-- Data to write to i_Rd
			o_Rs : out std_logic_vector(N -1 downto 0);		-- i_rs data output
			o_Rt : out std_logic_vector(N -1 downto 0));		-- i_rt data output
	end component;

	component extender is
		port(
			i_D : in std_logic_vector((DATA_WIDTH/2)-1 downto 0);
			i_Extend : in std_logic;
			o_F : out std_logic_vector(DATA_WIDTH-1 downto 0));
	end component;

	component control is
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
	end component;

	component ALU_control is
		port (
			-- ALU Op given by Control Unit
			iALUOp : in std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
	
			-- Instruction: "Funct" field
			iFunct : in std_logic_vector(FUNCT_WIDTH - 1 downto 0);
	
			-- Action for ALU to do
			oAction : out std_logic_vector(ALU_OP_WIDTH - 1 downto 0));
	end component;
	
	component ALU is
		port(
			iA 		: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			iB 		: in std_logic_vector(DATA_WIDTH - 1 downto 0);
			iALUOp 	: in std_logic_vector(ALU_OP_WIDTH - 1 downto 0);
			oResult : out std_logic_vector(DATA_WIDTH - 1 downto 0);
			oCout 	: out std_logic;
			oOverflow : out std_logic;
			oZero 	: out std_logic);
	end component;

	component mux2t1_N is
		generic(N : integer := 32); -- Generic of type integer for input/output data width. Default value is 32.
		port(
			i_S 	: in std_logic;
			i_D0	: in std_logic_vector(N-1 downto 0);
			i_D1	: in std_logic_vector(N-1 downto 0);
			o_O 	: out std_logic_vector(N-1 downto 0));
	end component;



begin

	-- TODO: This is required to be your final input to your instruction memory.
	-- This provides a feasible method to externally load the memory module which
	-- means that the synthesis tool must assume it knows nothing about the values
	-- stored in the instruction memory. If this is not included, much, if not all
	-- of the design is optimized out because the synthesis tool will believe the
	-- memory to be all zeros.
	with iInstLd select
    s_IMemAddr <=
		s_NextInstAddr when '0',
    	iInstAddr 	   when others;

	IMem: mem
	generic map(
		ADDR_WIDTH => ADDR_WIDTH,
		DATA_WIDTH => N)
	port map(
		clk  => iCLK,
		addr => s_IMemAddr(11 downto 2),
		data => iInstExt,
		we   => iInstLd,
		q    => s_Inst);
		  
	DMem: mem
	generic map(
		ADDR_WIDTH => ADDR_WIDTH,
		DATA_WIDTH => N)
	port map(
		clk  => iCLK,
		addr => s_DMemAddr(11 downto 2),
		data => s_DMemData,
		we   => s_DMemWr,
		q    => s_DMemOut);

	Write_Reg_Mux: mux2t1_N
	generic map(
		N => DATA_WIDTH)
	port map(
		i_S  =>
		i_D0 =>
		i_D1 =>
		o_O  => );
	

-- TODO: Ensure that s_Halt is connected to an output control signal produced
--       from decoding the Halt instruction (Opcode: 01 0100)
-- TODO: Ensure that s_Ovfl is connected to the overflow output of your ALU

-- TODO: Implement the rest of your processor below this comment!




end structure;