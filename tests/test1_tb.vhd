-----------------------------------------------------------------
-- This file was generated automatically by tb_gen Ruby utility
-- date : (d/m/y) 06/04/2018 23:25
-- Author : Jean-Christophe Le Lann - 2014
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity test1_tb is
end entity;

architecture bhv of test1_tb is

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

  signal reset_n : std_logic;
  signal a       : std_logic_vector(7 downto 0);
  signal f       : std_logic;

begin
  -------------------------------------------------------------------
  -- clock and reset
  -------------------------------------------------------------------
  reset_n <= '0','1' after 666 ns;

  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.test1(rtl)
        generic map(
)
        port map (
          reset_n => reset_n,
          a       => a      ,
          f       => f      
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
   begin
     report "running testbench for test1(rtl)";
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
