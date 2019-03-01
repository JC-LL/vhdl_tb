--------------------------------------------------------------------------------
-- Generated automatically by Reggae compiler
-- (c) Jean-Christophe Le Lann - 2011
-- date : Thu May 24 17:34:22 2018
--------------------------------------------------------------------------------
library ieee,std;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ip_ms_mergesort_pkg.all;

entity ip_ms_mergesort is
  port(
    reset_n : in  std_logic;
    clk     : in  std_logic;
    sreset  : in  std_logic;
    ce      : in  std_logic;
    we      : in  std_logic;
    address : in  unsigned(7 downto 0);
    datain  : in  std_logic_vector(63 downto 0);
    dataout : out std_logic_vector(63 downto 0));
end ip_ms_mergesort;

architecture RTL of ip_ms_mergesort is

  --interface
  signal regs      : registers_type;
  signal sampling  : sampling_type;

begin

  regif_inst : entity work.ip_ms_mergesort_reg
    port map(
      reset_n   => reset_n,
      clk       => clk,
      sreset    => sreset,
      ce        => ce,
      we        => we,
      address   => address,
      datain    => datain,
      dataout   => dataout,
      registers => regs,
      sampling  => sampling
    );

  inst_ms_mergesort : entity work.ms_mergesort
    port map(
      ap_clk => clk,
      ap_rst => regs.reg_ap_rst.lsb,
      ap_start => regs.reg_ap_start.lsb,
      ap_done => sampling.reg_ap_done_lsb,
      ap_idle => sampling.reg_ap_idle_lsb,
      ap_ready => sampling.reg_ap_ready_lsb,
      a_address0 => sampling.reg_a_address0_value,
      a_ce0 => sampling.reg_a_ce0_lsb,
      a_we0 => sampling.reg_a_we0_lsb,
      a_d0 => sampling.reg_a_d0_value,
      a_q0 => regs.reg_a_q0.value);


end RTL;
