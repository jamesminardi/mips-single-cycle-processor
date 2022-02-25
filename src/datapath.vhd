-------------------------------------------------------------------------
-- James Minardi
-- datapath.vhd
-------------------------------------------------------------------------
-- DESCRIPTION: This file contains an implementation of a simplified MIPS
-- processor datapath consisting of a register file and ALU.
-------------------------------------------------------------------------

-- library declaration
library IEEE;
use IEEE.std_logic_1164.all;

entity datapath is
	generic(N : integer := 32;
			REG_W : integer := 5;
			DATA_WIDTH : natural := 32;
			ADDR_WIDTH : natural := 10);
	port(
		i_CLK : in std_logic;		-- Clock input
		i_We : in std_logic := '0';		-- Write enable
		i_Rs : in std_logic_vector(REG_W - 1 downto 0) := (others=>'0'); -- Register to read 1
		i_Rt : in std_logic_vector(REG_W - 1 downto 0) := (others=>'0'); -- Register to read 2
		i_Rd : in std_logic_vector(REG_W - 1 downto 0) := (others=>'0'); -- Reg being written to
		i_MemtoReg 	: in std_logic := '0';		-- Mem to reg (send data to register write data)
		i_MemWrite	: in std_logic;	-- Memory Write enable
		i_Imm		: in std_logic_vector((N/2)-1 downto 0) := (others=>'0');
		i_Ex		: in std_logic := '0'; 	-- If 1, Sign extend i_Imm. 0, zero extend.
		i_nAdd_Sub	: in 	std_logic := '0';
       	i_ALUSrc	: in	std_logic := '0');
end datapath;

architecture structural of datapath is

	component add_sub is
  		port(i_A		: in 	std_logic_vector(N-1 downto 0);
       		i_B			: in 	std_logic_vector(N-1 downto 0);
       		i_I			: in	std_logic_vector(N-1 downto 0);
       		i_nAdd_Sub	: in 	std_logic;
       		i_ALUSrc	: in	std_logic;
       		o_S			: out 	std_logic_vector(N-1 downto 0);
       		o_C 		: out 	std_logic);
	end component;

    component extender is
        port(
            i_D : in std_logic_vector((N/2)-1 downto 0);
            i_Extend : in std_logic;
            o_F : out std_logic_vector(N-1 downto 0));
    end component;
		
	
	component regfile is
		port (
			i_CLK : in std_logic;		-- Clock input
			i_We : in std_logic;		-- Write enable
			i_Rs : in std_logic_vector(REG_W - 1 downto 0); -- Register to read 1
			i_Rt : in std_logic_vector(REG_W - 1 downto 0); -- Register to read 2
			i_Rd : in std_logic_vector(REG_W - 1 downto 0); -- Reg being written to
			i_Wd : in std_logic_vector(N-1 downto 0);		-- Data to write to i_Rd
			o_Rs : out std_logic_vector(N-1 downto 0);		-- i_rs data output
			o_Rt : out std_logic_vector(N-1 downto 0));		-- i_rt data output
	end component;

	component dmem is
        port (
            clk : in std_logic;
            addr : in std_logic_vector(ADDR_WIDTH -1 downto 0);
            data : in std_logic_vector(DATA_WIDTH -1 downto 0);
            we : in std_logic := '1';
            q : out std_logic_vector(DATA_WIDTH -1 downto 0));
    end component;

	component mux2t1_N is
		port(
			i_S          : in std_logic;
			i_D0         : in std_logic_vector(N-1 downto 0);
			i_D1         : in std_logic_vector(N-1 downto 0);
			o_O          : out std_logic_vector(N-1 downto 0));
	end component;


signal s_Wd: std_logic_vector(N-1 downto 0);
signal s_Rs, s_Rt : std_logic_vector(N-1 downto 0);
signal s_Imm : std_logic_vector(N-1 downto 0);
signal s_C : std_logic;
signal s_ALUResult : std_logic_vector(N-1 downto 0);
signal s_MemOut : std_logic_vector(N-1 downto 0);
signal s_MemWrite : std_logic;


begin
	s_MemWrite <= i_MemWrite;
	REGFILE_C: regfile
		port map(
			i_CLK => i_CLK,
			i_We => i_We,
			i_Rs => i_Rs,
			i_Rt => i_Rt,
			i_Rd => i_Rd,
			i_Wd => s_Wd,
			o_Rs => s_Rs,
			o_Rt => s_Rt);
	EXTENDER_C: extender
		port map(
			i_D => i_Imm,
			i_Extend => i_Ex,
			o_F => s_Imm);
	DMEM_C: dmem
		port map(
			clk => i_CLK,
			--addr => s_ALUResult(ADDR_WIDTH+1 downto 2), -- ?
			addr => s_ALUResult(ADDR_WIDTH-1 downto 0),
			data => s_Rt,
			we => s_MemWrite,
			q => s_MemOut);
	ADD_SUB_C: add_sub
		port map(
			i_A => s_Rs,
			i_B => s_Rt,
			i_I => s_Imm,
			i_nAdd_Sub => i_nAdd_Sub,
			i_ALUSrc => i_ALUSrc,
			o_S => s_ALUResult,
			o_C => s_C);
	MUX2t1_N_C: mux2t1_N
		port map(
			i_S => i_MemtoReg,
			i_D0 => s_ALUResult,
			i_D1 => s_MemOut,
			o_O => s_Wd);
end structural;









