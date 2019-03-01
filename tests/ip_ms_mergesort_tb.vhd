-----------------------------------------------------------------
-- This file was generated automatically by vhdl_tb Ruby utility
-- date : (d/m/y) 15/10/2018 12:01
-- Author : Jean-Christophe Le Lann - 2014
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ip_ms_mergesort_tb is
end entity;

architecture bhv of ip_ms_mergesort_tb is

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
  signal clk     : std_logic;
  signal sreset  : std_logic;
  signal ce      : std_logic;
  signal we      : std_logic;
  signal address : unsigned(7 downto 0);
  signal datain  : std_logic_vector(63 downto 0);
  signal dataout : std_logic_vector(63 downto 0);

begin
  -------------------------------------------------------------------
  -- clock and reset
  -------------------------------------------------------------------
  reset_n <= '0','1' after 666 ns;

  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.ip_ms_mergesort(RTL)
        
        port map (
          reset_n => reset_n,
          clk     => clk    ,
          sreset  => sreset ,
          ce      => ce     ,
          we      => we     ,
          address => address,
          datain  => datain ,
          dataout => dataout
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
   begin
     report "running testbench for ip_ms_mergesort(RTL)";
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
