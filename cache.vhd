----------------------------------------------------------------------------------
-- Company: 
-- Engineer: mahab
-- 
-- Create Date:    15:59:06 03/30/2018 
-- Design Name: 
-- Module Name:    cache - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cache is
    Port (
				C_CLK : STD_LOGIC;
				ADD_in : in  STD_LOGIC_VECTOR (15 downto 0);
           WR_or_RD_in : in  STD_LOGIC;
           CS : in  STD_LOGIC;
           DRAM_DIN : out  STD_LOGIC_VECTOR (7 downto 0);
           DRAM_DOUT : in  STD_LOGIC_VECTOR (7 downto 0);
           CPU_DIN : out  STD_LOGIC_VECTOR (7 downto 0);
           CPU_DOUT : in  STD_LOGIC_VECTOR (7 downto 0);
           ADD_out : out  STD_LOGIC_VECTOR (15 downto 0);
           WR_or_RD_out : out  STD_LOGIC;
           RDY : out  STD_LOGIC;
           MSTRB : out  STD_LOGIC);
end cache;

architecture Behavioral of cache is
component cache_controller is
    Port ( CLK : in STD_LOGIC;
           ADD_in : in STD_LOGIC_VECTOR (15 downto 0);
           ADD_out : out STD_LOGIC_VECTOR (15 downto 0);
           ADD_to_SRAM : out STD_LOGIC_VECTOR (7 downto 0);
           WR_RD_in : in STD_LOGIC;
           WR_RD_out : out STD_LOGIC;
           WEN : out STD_LOGIC;
           CS : in STD_LOGIC;
           MSTRB : out STD_LOGIC;
           s1 : out STD_LOGIC;--choosing DIN
           s2 : out STD_LOGIC;--choosing DOUT
           RDY : out STD_LOGIC);
end component;
component cache_SRAM is
    Port ( CLK : in STD_LOGIC;
           ADD : in STD_LOGIC_VECTOR (7 downto 0);
           WEN : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (7 downto 0);
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
end component;

component MUX is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (7 downto 0);
           B   : in  STD_LOGIC_VECTOR (7 downto 0);
           X   : out STD_LOGIC_VECTOR (7 downto 0));
end component;
component DEMUX is
		Port ( d : in  STD_LOGIC_VECTOR (7 downto 0);
           s : in  STD_LOGIC;
			  a : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0)
           );

end component;
	signal rdy_var : STD_LOGIC;
	signal s1 : STD_LOGIC;
	signal s2 : STD_LOGIC;
	signal wen_var : STD_LOGIC;
	signal mstrb_out : STD_LOGIC;
	signal SRAM_DIN : std_logic_vector(7 downto 0);
	signal DRAM_DIN_VAR : std_logic_vector(7 downto 0);
	signal DRAM_DOUT_VAR : std_logic_vector(7 downto 0);
	signal SRAM_DOUT : std_logic_vector(7 downto 0);
	signal CPU_DOUT_VAR : std_logic_vector(7 downto 0);
	signal CPU_DIN_VAR : std_logic_vector(7 downto 0);
	signal ADD_to_SRAM : std_logic_vector(7 downto 0);
	
begin
	DRAM_DOUT_VAR <= DRAM_DOUT;
	CPU_DOUT_VAR <= CPU_DOUT;
	--	mux1 : Mux PORT MAP(s1,CPU_DOUT_VAR,DRAM_DOUT_VAR,SRAM_DIN);
	SRAM_DIN <= DRAM_DOUT_VAR when (s1 = '1') else CPU_DOUT_VAR;
	--mux2 : Mux PORT MAP(s2,DRAM_DIN_VAR,CPU_DIN_VAR,SRAM_DOUT);
	--CPU_DIN_VAR <= SRAM_DOUT when (s2 = '1');
	--DRAM_DIN_VAR <= SRAM_DOUT when (s2 = '0');
	demuxins : DEMUX PORT MAP(SRAM_DOUT,s2,DRAM_DIN_VAR,CPU_DIN_VAR);
	controller : cache_controller PORT MAP(
			C_CLK,
           ADD_in ,
           ADD_out ,
           ADD_to_SRAM ,
           WR_or_RD_in ,
           WR_or_RD_out ,
           wen_var ,
           CS ,
           mstrb_out ,
           s1,
           s2 ,
           rdy_var );
			  
			  
			  
	sram : cache_SRAM PORT MAP(C_CLK ,ADD_to_SRAM ,wen_var ,SRAM_DIN ,SRAM_DOUT);
	
	
	RDY <= rdy_var;
	DRAM_DIN <= DRAM_DIN_VAR;
	CPU_DIN <= CPU_DIN_VAR;
	
	MSTRB <= mstrb_out;
	
	

end Behavioral;

