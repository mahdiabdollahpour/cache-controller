----------------------------------------------------------------------------------
-- Company: 
-- Engineer: mahab
-- 
-- Create Date:    09:34:19 04/06/2018 
-- Design Name: 
-- Module Name:    DEMUX - Behavioral 
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

entity DEMUX is
    Port ( d : in  STD_LOGIC_VECTOR (7 downto 0);
           s : in  STD_LOGIC;
			  a : out  STD_LOGIC_VECTOR (7 downto 0);
           b : out  STD_LOGIC_VECTOR (7 downto 0)
           );
end DEMUX;

architecture Behavioral of DEMUX is
component DEMUX1to2 is
	port(
			d,s:in std_logic;
			z0,z1:out std_logic
		);
	
end component;
	

begin
	demux0 : DEMUX1to2 PORT MAP(d(0),s,a(0),b(0));
	demux1 : DEMUX1to2 PORT MAP(d(1),s,a(1),b(1));
	demux2 : DEMUX1to2 PORT MAP(d(2),s,a(2),b(2));
	demux3 : DEMUX1to2 PORT MAP(d(3),s,a(3),b(3));
	demux4 : DEMUX1to2 PORT MAP(d(4),s,a(4),b(4));
	demux5 : DEMUX1to2 PORT MAP(d(5),s,a(5),b(5));
	demux6 : DEMUX1to2 PORT MAP(d(6),s,a(6),b(6));
	demux7 : DEMUX1to2 PORT MAP(d(7),s,a(7),b(7));


end Behavioral;

