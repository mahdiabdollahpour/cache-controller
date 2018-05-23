library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MUX is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (7 downto 0);
           B   : in  STD_LOGIC_VECTOR (7 downto 0);
           X   : out STD_LOGIC_VECTOR (7 downto 0));
end MUX;

architecture Behavioral of MUX is
begin
    X(0) <= (A(0) and (not SEL)) or (SEL and B(0));
    X(1) <= (A(1) and (not SEL)) or (SEL and B(1));
    X(2) <= (A(2) and (not SEL)) or (SEL and B(2));
    X(3) <= (A(3) and (not SEL)) or (SEL and B(3));
    X(4) <= (A(4) and (not SEL)) or (SEL and B(4));
    X(5) <= (A(5) and (not SEL)) or (SEL and B(5));
    X(6) <= (A(6) and (not SEL)) or (SEL and B(6));
    X(7) <= (A(7) and (not SEL)) or (SEL and B(7));
end Behavioral;