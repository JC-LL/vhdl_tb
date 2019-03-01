-- blah
-- entity
library ieee;
use ieee.std_logic_1164.all;

entity test2 is
   generic (
     N : natural := 8;
     M : natural := 16
   );
   port(
     reset_n : in std_logic;
     a : in std_logic_vector(7 downto 0);
     f : out std_logic
   );
end;

architecture rtl of test2 is
begin
end rtl;
