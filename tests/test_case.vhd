library ieee;
use ieee.std_logic_1164.all;

entity my_entity is
port(in1  : in  std_logic_vector(3 downto 0);
     out1 : out std_logic);
end entity my_entity;

architecture rtl of my_entity is
begin
    case in1 is
        when "00" | "01" =>
        out1 <= '0';
    end case;
end architecture rtl;
