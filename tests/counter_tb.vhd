-----------------------------------------------------------------
-- This file was generated automatically by vhdl_tb Ruby utility
-- date : (d/m/y) 25/02/2019 17:07
-- Author : Jean-Christophe Le Lann - 2014
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity counter_tb is
end entity;

architecture bhv of counter_tb is

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

  --signal reset_n : std_logic;
  --signal clk     : std_logic;
  constant N   : natural := 8;
  signal inc   : std_logic;
  signal dec   : std_logic;
  signal value : signed(N - 1 downto 0);

begin
  -------------------------------------------------------------------
  -- clock and reset
  -------------------------------------------------------------------
  reset_n <= '0', '1' after 666 ns;

  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.counter(rtl)
    generic map(
      N => 8)
    port map (
      reset_n => reset_n,
      clk     => clk,
      inc     => inc,
      dec     => dec,
      value   => value
      );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
  begin
    report "running testbench for counter(rtl)";
    report "waiting for asynchronous reset";
    wait until reset_n = '1';
    wait_cycles(100);
    report "applying stimuli...";
    wait_cycles(100);
    report "end of simulation";
    running <= false;
    wait;
  end process;

end bhv;
