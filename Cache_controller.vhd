
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use ieee.std_logic_1164.all;
--use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use IEEE.NUMERIC_STD.ALL;
--use ieee.std_logic_arith.UNSIGNED;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cache_controller is
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
end cache_controller;

architecture Behavioral of cache_controller is


-- then we define TAG -- we know in the project definition that the tag is 8 bit
type tag_type is array (0 to 7) of std_logic_vector(7 downto 0);
-- for valid bits and dirty bits
-- you have to add this to the process and use them. this is yours .
type valid_type is array (0 to 7) of std_logic;
type dirty_type is array (0 to 7) of std_logic;
-----------------------------------
type state_t is (usual , readAzDRAM , readAzDRAMMSTRB, writeToDRAM,writeToDRAMMSTRB  ,publish,CS1,CS2,CS3,WaitFor); 
signal state : state_t := WaitFor;
signal next_state : state_t := WaitFor;

begin

CMB : process(clk)
    variable init : boolean := true;
  --  variable readingFromDRAMState : boolean := true;
	variable ad_index : STD_LOGIC_VECTOR (2 downto 0);
   variable ad_offset : STD_LOGIC_VECTOR (4 downto 0);
	variable tag : tag_type := ( others => (others => '0')); 
	variable valid : valid_type := (others=>'0');
	variable dirty : dirty_type := (others=>'0');
	variable offestToWR :  STD_LOGIC_VECTOR (4 downto 0);
	variable ADD_out_var : STD_LOGIC_VECTOR (15 downto 0);
	variable thirty3 : integer := 31;
	variable tag_to_over_write : STD_LOGIC_VECTOR (7 downto 0);
	
         
begin
    if init = true then
        -- any initials if u want to initiate something
        -- for example :
        -- mem(7)(0) := "1000011";
	--state <= usual;
--		valid := "11111111";
			valid := "00000000";
--			dirty := "11111111";
			dirty := "00000000";
    init := false;
    end if;
		ad_index := ADD_in(7 downto 5);
      ad_offset := ADD_in(4 downto 0);
	    
    if (clk'event and clk = '1' ) or rising_edge(CS) then
		RDY <= '0';	
		 WEN <= '0';
		 WR_RD_out <= '0';
		if state = publish then
				RDY <= '1';
 				if CS = '1' then 
				next_state <= CS1;
				else
				next_state <= WaitFor;
				end if;
			
		end if;
		if state = CS1 then
			if CS ='1' then
				next_state <= CS2;
			else
				next_state <= WaitFor;
			end if;
		end if;
	  if state = CS2 then
			if CS ='1' then
				next_state <= CS3;
			else
				next_state <= WaitFor;
			end if;
		end if;	
	  if state = CS3 then
			if CS ='1' then
				next_state <= usual;
			else
				next_state <= WaitFor;
			end if;
		end if;	
	  if state = WaitFor then
			if CS ='1' then
				next_state <= CS1;
			else
				next_state <= WaitFor;
			end if;
		end if;	

		if state = writeToDRAM then
				
				dirty(conv_integer(ADD_in(7 downto 5))) := '0';-- we are writing it now so its not dirty
				
		
				MSTRB <= '1';
				
				report "writing to DRAM state";
				ADD_out_var := ADD_in;
				ADD_out_var(4 downto 0) := offestToWR;
				ADD_out_var(15 downto 8) := tag_to_over_write;
				ADD_out <= ADD_out_var;
				ADD_to_SRAM <= ADD_out_var(7 downto 0);
			--	next_state <= writeToDRAMMSTRB;
				if (unsigned(offestToWR)) < thirty3 then 
					next_state <= writeToDRAMMSTRB;
					offestToWR := offestToWR + 1;
					report "offset incremention";
				else
					report "back to usual";
					next_state <= usual;
				end if;
			end if;
			---------------------------------------------------------------
			if state = writeToDRAMMSTRB then
				MSTRB <= '0';
				ADD_to_SRAM <= ADD_out_var(7 downto 0);
				WR_RD_out <= '1'; -- write mode
				WEN <= '0';
				report "write MSTRSB";
				s2 <= '0';
				WEN <= '0';
			
				ADD_out_var := ADD_in;
				ADD_out_var(4 downto 0) := offestToWR;
				ADD_out_var(15 downto 8) := tag_to_over_write;
				ADD_out <= ADD_out_var;
				ADD_to_SRAM <= ADD_out_var(7 downto 0);
				next_state <= writeToDRAM;
			
			end if;
			---------------------------------------------------------------
			if state = readAzDRAM then 
					report "read az dram "; 
					valid(conv_integer(ADD_in(7 downto 5))) := '1';-- we give the INDEX as the index LOL
					WR_RD_out <= '0'; --  wanna read
					ADD_out_var := ADD_in;
					ADD_out_var(4 downto 0) := offestToWR;
					ADD_out <= ADD_out_var;
					MSTRB <= '1';
					s1 <= '1';
					next_state <= readAzDRAMMSTRB;
					WEN <='0';
			end if;
			---------------------------------------------------------------
			if state = readAzDRAMMSTRB then
				report "read az dram mstrb"; 
			
				MSTRB <= '0';
				ADD_to_SRAM <= ADD_out_var(7 downto 0);
				WEN <= '1';
				
				if (unsigned(offestToWR)) < thirty3 then 
					next_state <= readAzDRAM;
					offestToWR := offestToWR + 1;
					report "offset incremention";
				else
					report "back to usual";
					next_state <= usual;
					Add_out_var := ADD_in;
					ADD_out <= ADD_out_var;
					ADD_to_SRAM <= ADD_in(7 downto 0);
					WEN <= '0';
				end if;
				
			end if;
			---------------------------------------------------------------
			
			if state = usual then
	
	
			if WR_RD_in = '1' then -- cpu wants to write
				if tag(to_integer(unsigned(ad_index))) = ADD_in(15 downto 8) then -- "hit"
				--	if dirty(ad_index) = '0' then -- is not dirty  
				-- is does not matter if it "hits" and is dirty in write cause it will get dirtier
					ADD_to_SRAM <= ADD_in(7 downto 0);
					dirty(to_integer(unsigned(ad_index))) := '1';
					s1 <= '0';
					s2 <= '1';
					WEN <= '1';
				
					next_state <= publish;
				report "write hit";
			else -- "miss"
					if dirty(to_integer(unsigned(ad_index))) = '0' then -- is not dirty 
						--ADD_out <= ADD_in(15 downto 5) & '00000';
						s2 <= '0';
						report "write miss not dirty";
						tag(to_integer(unsigned(ad_index))) := ADD_in(15 downto 8);
						
						valid(to_integer(unsigned(ad_index))) := '1';
						dirty(to_integer(unsigned(ad_index))) := '0'; -- it is already 0
						WR_RD_out <= '0';
						next_state <= readAzDRAM; -- get it from DRAM
						offestToWR := "00000";
						WEN <= '1';
						-- now write
					else --  its dirty so first write this to DRAM "write and miss and dirty thats what happens"
						tag_to_over_write := tag(to_integer(unsigned(ad_index)));
						offestToWR := "00000";

						next_state <= writeToDRAMMSTRB;
						s2 <= '0';
						report "write miss dirty";

						
						
						
					end if;
				end if;
			else -- cpu wants to read
			if tag(to_integer(unsigned(ad_index))) = ADD_in(15 downto 8) then -- "hit"
				if valid(to_integer(unsigned(ad_index))) = '1' then -- is valid 
				ADD_to_SRAM <= ADD_in(7 downto 0);
				s2 <= '1';
			--	RDY <= '1';
				next_state <= publish;
				else -- is not valid read it form DRAM
					offestToWR := "00000";
					next_state <= readAzDRAM;
					s1 <= '1';
				
				
				end if;
				
				
			else -- oh missed so get it az DRAM
				if dirty(to_integer(unsigned(ad_index))) = '0' then -- is not dirty so can Read from DRAM and overwrite
						
						tag(to_integer(unsigned(ad_index))) := ADD_in(15 downto 8);
						valid(to_integer(unsigned(ad_index))) := '1';
						dirty(to_integer(unsigned(ad_index))) := '0'; -- it is already 0
						WR_RD_out <= '0';
						next_state <= readAzDRAM; -- get it from DRAM
						offestToWR := "00000";
						WEN <= '1';
				else --  its dirty so first write this to DRAM and then get from DRAM
					tag_to_over_write := tag(to_integer(unsigned(ad_index)));
					offestToWR := "00000";
					next_state <= writeToDRAMMSTRB;
					s2 <= '0';
				end if;

			end if;
			
		end if;
			
			---------------------------
		--report "$state.all , $next_state.all";
		
	--	report "$state.all , $next_state.all";

    end if;
	--state <= next_state;
	end if;
	
end process;



REG : process(clk)
	begin
	if(clk'event and clk = '0') then
		state <= next_state;
	end if;
end process;





--REG : process(clk)
	--begin
		--if(clk'event and clk = '1') then
			--state <= next_state;
		--end if;
	--end process;



end Behavioral;