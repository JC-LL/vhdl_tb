-- blah
-- entity
library ieee;
use ieee.std_logic_1164.all;

entity test1 is
   port(
     reset_n : in std_logic;
     a : in std_logic_vector(7 downto 0);
     f : out std_logic
   );
end;

architecture rtl of test1 is
begin
end rtl;
