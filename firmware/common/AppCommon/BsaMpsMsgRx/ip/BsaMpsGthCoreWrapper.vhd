-------------------------------------------------------------------------------
-- File       : BsaMpsMsgRxCore.vhd
-- Company    : SLAC National Accelerator Laboratory
-- Created    : 2017-03-13
-- Last update: 2017-04-04
-------------------------------------------------------------------------------
-- Description: Wrapper for BsaMpsGthCore
-------------------------------------------------------------------------------
-- This file is part of 'LCLS2 LLRF Firmware'.
-- It is subject to the license terms in the LICENSE.txt file found in the 
-- top-level directory of this distribution and at: 
--    https://confluence.slac.stanford.edu/display/ppareg/LICENSE.html. 
-- No part of 'LCLS2 LLRF Firmware', including this file, 
-- may be copied, modified, propagated, or distributed except according to 
-- the terms contained in the LICENSE.txt file.
-------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

use work.StdRtlPkg.all;

entity BsaMpsGthCoreWrapper is
   generic (
      TPD_G        : time    := 1 ns;
      SIMULATION_G : boolean := false);
   port (
      -- RX Data Interface (clk domain)
      rxClk       : out sl;
      rxRst       : out sl;
      rxValid     : out sl;
      rxData      : out slv(15 downto 0);
      rxdataK     : out slv(1 downto 0);
      rxDecErr    : out slv(1 downto 0);
      rxDispErr   : out slv(1 downto 0);
      rxBufStatus : out slv(2 downto 0);
      rxPolarity  : in  sl;
      cPllLock    : out sl;
      gtRst       : in  sl;
      -- Simulation TX Data Interface (txClk domain)
      txClk       : in  sl               := '0';
      txRst       : in  sl               := '0';
      txData      : in  slv(15 downto 0) := (others => '0');
      txDataK     : in  slv(1 downto 0)  := (others => '0');
      -- Remote LLRF BSA/MPS Ports
      gtRefClk    : in  sl;
      stableClk   : in  sl;
      gtRxP       : in  sl;
      gtRxN       : in  sl;
      gtTxP       : out sl;
      gtTxN       : out sl);
end BsaMpsGthCoreWrapper;

architecture mapping of BsaMpsGthCoreWrapper is

   component BsaMpsGthCore
      port (
         gtwiz_userclk_tx_active_in         : in  std_logic_vector(0 downto 0);
         gtwiz_userclk_rx_active_in         : in  std_logic_vector(0 downto 0);
         gtwiz_reset_clk_freerun_in         : in  std_logic_vector(0 downto 0);
         gtwiz_reset_all_in                 : in  std_logic_vector(0 downto 0);
         gtwiz_reset_tx_pll_and_datapath_in : in  std_logic_vector(0 downto 0);
         gtwiz_reset_tx_datapath_in         : in  std_logic_vector(0 downto 0);
         gtwiz_reset_rx_pll_and_datapath_in : in  std_logic_vector(0 downto 0);
         gtwiz_reset_rx_datapath_in         : in  std_logic_vector(0 downto 0);
         gtwiz_reset_rx_cdr_stable_out      : out std_logic_vector(0 downto 0);
         gtwiz_reset_tx_done_out            : out std_logic_vector(0 downto 0);
         gtwiz_reset_rx_done_out            : out std_logic_vector(0 downto 0);
         gtwiz_userdata_tx_in               : in  std_logic_vector(15 downto 0);
         gtwiz_userdata_rx_out              : out std_logic_vector(15 downto 0);
         drpclk_in                          : in  std_logic_vector(0 downto 0);
         gthrxn_in                          : in  std_logic_vector(0 downto 0);
         gthrxp_in                          : in  std_logic_vector(0 downto 0);
         gtrefclk0_in                       : in  std_logic_vector(0 downto 0);
         loopback_in                        : in  std_logic_vector(2 downto 0);
         rx8b10ben_in                       : in  std_logic_vector(0 downto 0);
         rxbufreset_in                      : in  std_logic_vector(0 downto 0);
         rxcommadeten_in                    : in  std_logic_vector(0 downto 0);
         rxmcommaalignen_in                 : in  std_logic_vector(0 downto 0);
         rxpcommaalignen_in                 : in  std_logic_vector(0 downto 0);
         rxpolarity_in                      : in  std_logic_vector(0 downto 0);
         rxusrclk_in                        : in  std_logic_vector(0 downto 0);
         rxusrclk2_in                       : in  std_logic_vector(0 downto 0);
         tx8b10ben_in                       : in  std_logic_vector(0 downto 0);
         txctrl0_in                         : in  std_logic_vector(15 downto 0);
         txctrl1_in                         : in  std_logic_vector(15 downto 0);
         txctrl2_in                         : in  std_logic_vector(7 downto 0);
         txusrclk_in                        : in  std_logic_vector(0 downto 0);
         txusrclk2_in                       : in  std_logic_vector(0 downto 0);
         gthtxn_out                         : out std_logic_vector(0 downto 0);
         gthtxp_out                         : out std_logic_vector(0 downto 0);
         rxbufstatus_out                    : out std_logic_vector(2 downto 0);
         rxbyteisaligned_out                : out std_logic_vector(0 downto 0);
         rxbyterealign_out                  : out std_logic_vector(0 downto 0);
         rxclkcorcnt_out                    : out std_logic_vector(1 downto 0);
         rxcommadet_out                     : out std_logic_vector(0 downto 0);
         rxctrl0_out                        : out std_logic_vector(15 downto 0);
         rxctrl1_out                        : out std_logic_vector(15 downto 0);
         rxctrl2_out                        : out std_logic_vector(7 downto 0);
         rxctrl3_out                        : out std_logic_vector(7 downto 0);
         rxoutclk_out                       : out std_logic_vector(0 downto 0);
         rxpmaresetdone_out                 : out std_logic_vector(0 downto 0);
         txoutclk_out                       : out std_logic_vector(0 downto 0);
         txpmaresetdone_out                 : out std_logic_vector(0 downto 0));
   end component;

   signal data          : slv(15 downto 0) := (others => '0');
   signal dataK         : slv(1 downto 0)  := (others => '0');
   signal decErr        : slv(1 downto 0)  := (others => '0');
   signal dispErr       : slv(1 downto 0)  := (others => '0');
   signal cnt           : slv(31 downto 0) := (others => '0');
   signal clk           : sl               := '0';
   signal txOutClkOut   : sl               := '0';
   signal rxReset       : sl               := '0';
   signal txReset       : sl               := '0';
   signal linkUp        : sl               := '0';
   signal dataValid     : sl               := '0';
   signal wdtRst        : sl               := '0';
   signal wdtReset      : sl               := '0';
   signal wdtRstOneShot : sl               := '0';

begin

   GEN_SIM : if (SIMULATION_G = true) generate
      rxClk       <= txClk;
      rxRst       <= txRst;
      rxValid     <= not(txRst);
      rxData      <= txData;
      rxDataK     <= txDataK;
      rxDecErr    <= (others => '0');
      rxDispErr   <= (others => '0');
      rxBufStatus <= (others => '0');
      cPllLock    <= not(txRst);
      gtTxP       <= '0';
      gtTxN       <= '1';
   end generate;


   GEN_REAL : if (SIMULATION_G = false) generate

      rxClk <= clk;
      rxRst <= rxReset;

      U_BUFG : BUFG
         port map (
            I => txOutClkOut,
            O => clk);

      txReset <= gtRst or txRst;

      rxValid   <= linkUp;
      rxData    <= data    when(linkUp = '1') else (others => '0');
      rxDataK   <= dataK   when(linkUp = '1') else (others => '0');
      rxDecErr  <= decErr  when(linkUp = '1') else (others => '0');
      rxDispErr <= dispErr when(linkUp = '1') else (others => '0');
      dataValid <= not (uOr(decErr) or uOr(dispErr));

      process(clk)
      begin
         if rising_edge(clk) then
            rxReset <= gtRst or wdtRst after TPD_G;
            if (gtRst = '1') or (rxRstDone = '0') or (dataValid = '0') or (rxBuff(2) = '1') then
               cnt    <= (others => '0') after TPD_G;
               linkUp <= '0'             after TPD_G;
            else
               if (cnt = DURATION_100MS_C) then
                  linkUp <= '1' after TPD_G;
               else
                  cnt <= cnt + 1 after TPD_G;
               end if;
            end if;
         end if;
      end process;

      wdtReset <= (not(dataValid) and linkUp) or wdtRstOneShot;
      U_PwrUpRst : entity work.PwrUpRst
         generic map(
            TPD_G      => TPD_G,
            DURATION_G => DURATION_100MS_C)
         port map (
            arst   => wdtReset,
            clk    => clk,
            rstOut => wdtRst);

      U_WatchDogRst : entity work.WatchDogRst
         generic map(
            TPD_G      => TPD_G,
            DURATION_G => DURATION_1S_C)
         port map (
            clk    => clk,
            monIn  => linkUp,
            rstOut => wdtRstOneShot);

      U_BsaMpsGthCore : BsaMpsGthCore
         port map (
            gtwiz_userclk_tx_active_in(0)         => '1',
            gtwiz_userclk_rx_active_in(0)         => '1',
            gtwiz_reset_clk_freerun_in (0)        => stableClk,
            gtwiz_reset_all_in(0)                 => '0',
            gtwiz_reset_tx_pll_and_datapath_in(0) => '0',
            gtwiz_reset_tx_datapath_in(0)         => txReset,
            gtwiz_reset_rx_pll_and_datapath_in(0) => '0',
            gtwiz_reset_rx_datapath_in(0)         => rxReset,
            gtwiz_reset_rx_cdr_stable_out(0)      => open,
            gtwiz_reset_tx_done_out(0)            => txRstDone,
            gtwiz_reset_rx_done_out(0)            => rxRstDone,
            gtwiz_userdata_tx_in                  => txData,
            gtwiz_userdata_rx_out                 => data,
            drpclk_in(0)                          => stableClk,
            gthrxn_in(0)                          => gtRxN,
            gthrxp_in(0)                          => gtRxP,
            gtrefclk0_in(0)                       => gtRefClk,
            loopback_in                           => (others => '0'),
            rx8b10ben_in(0)                       => '1',
            rxbufreset_in(0)                      => '0',
            rxcommadeten_in(0)                    => '1',
            rxmcommaalignen_in(0)                 => '1',
            rxpcommaalignen_in(0)                 => '1',
            rxpolarity_in(0)                      => rxPolarity,
            rxusrclk_in(0)                        => clk,
            rxusrclk2_in(0)                       => clk,
            tx8b10ben_in(0)                       => '1',
            txctrl0_in                            => X"0000",
            txctrl1_in                            => X"0000",
            txctrl2_in(1 downto 0)                => txDataK,
            txctrl2_in(7 downto 2)                => (others => '0'),
            txusrclk_in(0)                        => txClk,
            txusrclk2_in(0)                       => txClk,
            gthtxn_out(0)                         => gtTxN,
            gthtxp_out(0)                         => gtTxP,
            rxbufstatus_out                       => rxBufStatus,
            rxbyteisaligned_out                   => open,
            rxbyterealign_out                     => open,
            rxclkcorcnt_out                       => open,
            rxcommadet_out                        => open,
            rxctrl0_out(1 downto 0)               => dataK,
            rxctrl0_out(15 downto 2)              => open,
            rxctrl1_out(1 downto 0)               => dispErr,
            rxctrl1_out(15 downto 2)              => open,
            rxctrl2_out                           => open,
            rxctrl3_out(1 downto 0)               => decErr,
            rxctrl3_out(7 downto 2)               => open,
            rxoutclk_out(0)                       => open,
            rxpmaresetdone_out(0)                 => open,
            txoutclk_out(0)                       => txOutClkOut,
            txpmaresetdone_out(0)                 => open);
   end generate;

end mapping;