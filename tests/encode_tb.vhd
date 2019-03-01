-----------------------------------------------------------------
-- This file was generated automatically by vhdl_tb Ruby utility
-- date : (d/m/y) 15/10/2018 12:01
-- Author : Jean-Christophe Le Lann - 2014
-----------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity encode_tb is
end entity;

architecture bhv of encode_tb is

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

  signal ap_clk    : STD_LOGIC;
  signal ap_rst    : STD_LOGIC;
  signal ap_start  : STD_LOGIC;
  signal ap_done   : STD_LOGIC;
  signal ap_idle   : STD_LOGIC;
  signal ap_ready  : STD_LOGIC;
  signal xin1      : STD_LOGIC_VECTOR(31 downto 0);
  signal xin2      : STD_LOGIC_VECTOR(31 downto 0);
  signal ap_return : STD_LOGIC_VECTOR(31 downto 0);

begin
  -------------------------------------------------------------------
  -- clock and reset
  -------------------------------------------------------------------
  reset_n <= '0','1' after 666 ns;

  clk <= not(clk) after HALF_PERIOD when running else clk;

  --------------------------------------------------------------------
  -- Design Under Test
  --------------------------------------------------------------------
  dut : entity work.encode(behav)
        
        port map (
          ap_clk    => ap_clk   ,
          ap_rst    => ap_rst   ,
          ap_start  => ap_start ,
          ap_done   => ap_done  ,
          ap_idle   => ap_idle  ,
          ap_ready  => ap_ready ,
          xin1      => xin1     ,
          xin2      => xin2     ,
          ap_return => ap_return
        );

  --------------------------------------------------------------------
  -- sequential stimuli
  --------------------------------------------------------------------
  stim : process
   begin
     report "running testbench for encode(behav)";
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
