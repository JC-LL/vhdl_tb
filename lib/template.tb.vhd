-----------------------------------------------------------------
-- This file was generated automatically by vhdl_tb Ruby utility
-- date : <%=Time.now.strftime("(d/m/y) %d/%m/%Y %H:%M")%>
-- Author : Jean-Christophe Le Lann - 2014
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity <%=@tb.name%> is
end entity;

architecture bhv of <%=@tb.name%> is

  constant HALF_PERIOD : time := 5 ns;

  signal clk     : std_logic := '0';
  signal reset_n : std_logic := '0';
  signal sreset  : std_logic := '0';
  signal running : boolean   := true;

  procedure wait_cycles(n : natural) is
   begin
     for i in 1 to n loop
       wait until rising_edge(clk);
     end loop;
   end procedure;

<%=@entity.ports.collect do |port|
  "  signal #{port.name.val.ljust(@max_length)} : #{port.type}" if not @symtable.include?(port.name)
  end.compact.join(";\n")%>;

begin
  -------------------------------------------------------------------
  -- clock and reset
  -------------------------------------------------------------------
  reset_n <= '0','1' after 666 ns;

  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.<%=@entity.name%>(<%=@arch.name%>)
        <%=@generics%>
        port map (
<%=@ports%>
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
   begin
     report "running testbench for <%=@entity.name%>(<%=@arch.name%>)";
     report "waiting for asynchronous reset";
     wait until reset_n='1';
     wait_cycles(100);
     report "applying stimuli...";
     wait_cycles(100);
     report "end of simulation";
     running <=false;
     wait;
   end process;

end bhv;
