library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity circuit is
   port(
     reset_n : in std_logic;
     clock   : in std_logic;
     a,b     : in unsigned(7 downto 0);
     f       : in unsigned(7 downto 0)
   );
end circuit;

architecture rtl of circuit is
begin
end rtl;
