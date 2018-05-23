--------------------------------------------------------------------------------
-- Company: 
-- Engineer: mahab
--
-- Create Date:   17:02:14 03/30/2018
-- Design Name:   
-- Module Name:   C:/Users/ASUS/Documents/LC_proj/cahce/myTestBench.vhd
-- Project Name:  cahce
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: cache
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY myTestBench IS
END myTestBench;
 
ARCHITECTURE behavior OF myTestBench IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT cache
    PORT(
         C_CLK : IN  std_logic;
         ADD_in : IN  std_logic_vector(15 downto 0);
         WR_or_RD_in : IN  std_logic;
         CS : IN  std_logic;
         DRAM_DIN : OUT  std_logic_vector(7 downto 0);
         DRAM_DOUT : IN  std_logic_vector(7 downto 0);
         CPU_DIN : OUT  std_logic_vector(7 downto 0);
         CPU_DOUT : IN  std_logic_vector(7 downto 0);
         ADD_out : OUT  std_logic_vector(15 downto 0);
         WR_or_RD_out : OUT  std_logic;
         RDY : OUT  std_logic;
         MSTRB : OUT  std_logic
        );
    END COMPONENT;
    component SDRAM_Controller is
		Port ( CLK : in STD_LOGIC;
           ADD : in STD_LOGIC_VECTOR (15 downto 0);
           WRorRD : in STD_LOGIC;
           MEMSTRB : in STD_LOGIC;
           DIN : in STD_LOGIC_VECTOR (7 downto 0);
           DOUT : out STD_LOGIC_VECTOR (7 downto 0));
		end component;

   --Inputs
   signal C_CLK : std_logic := '0';
   signal ADD_in : std_logic_vector(15 downto 0) := (others => '0');
   signal WR_or_RD_in : std_logic := '0';
   signal CS : std_logic := '0';
   signal DRAM_DOUT : std_logic_vector(7 downto 0) := (others => '0');
   signal CPU_DOUT : std_logic_vector(7 downto 0) := (others => '0');

 	--Outputs
   signal DRAM_DIN : std_logic_vector(7 downto 0);
   signal CPU_DIN : std_logic_vector(7 downto 0);
   signal ADD_out : std_logic_vector(15 downto 0);
   signal WR_or_RD_out : std_logic;
   signal RDY : std_logic;
   signal MSTRB : std_logic;

   -- Clock period definitions
   constant C_CLK_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: cache PORT MAP (
          C_CLK => C_CLK,
          ADD_in => ADD_in,
          WR_or_RD_in => WR_or_RD_in,
          CS => CS,
          DRAM_DIN => DRAM_DIN,
          DRAM_DOUT => DRAM_DOUT,
          CPU_DIN => CPU_DIN,
          CPU_DOUT => CPU_DOUT,
          ADD_out => ADD_out,
          WR_or_RD_out => WR_or_RD_out,
          RDY => RDY,
          MSTRB => MSTRB
        );
	dram : SDRAM_controller PORT MAP (
		C_CLK,
		ADD_out,
		WR_or_RD_out,
		MSTRB,
		DRAM_DIN,
		DRAM_DOUT);

   -- Clock process definitions
   C_CLK_process :process
   begin
		C_CLK <= '0';
		wait for C_CLK_period/2;
		C_CLK <= '1';
		wait for C_CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
  --    wait for 100 ns;	

	--  wait for C_CLK_period*10;
		
	--	ADD_in <= "0000000000000001";
	--	WR_or_RD_in <= '0';
	--	CS <= '1';
	--	wait for C_CLK_period*4;
	--	CS <= '0';
	--	wait for C_CLK_period*40;
	
		ADD_in <= "0111000000000001";
		WR_or_RD_in <= '1';
		CPU_DOUT <= "11111101";
		CS <= '1';
		wait for C_CLK_period*4;
		CS <= '0';
		if RDY ='1' then
			WR_or_RD_in <= '0';
			CS <= '1';
			WR_or_RD_in <= '0';
			wait for C_CLK_period*4;
			CS <= '0';
		end if;
		-- CPU_DOUT <= "00000001";
		wait for C_CLK_period*40;

      -- insert stimulus here 

      wait;
   end process;

END;
