U_Core: entity work.BsaMspMsgTxCore
  port map (
    usrClk => usrClk,
    usrRst => usrRst,
    timingStrobe => timingStrobe,
    timeStamp => timeStamp,
    bsaQuantity0 => bsaQuantity0,
    bsaQuantity1 => bsaQuantity1,
    bsaQuantity2 => bsaQuantity2,
    bsaQuantity3 => bsaQuantity3,
    bsaQuantity4 => bsaQuantity4,
    bsaQuantity5 => bsaQuantity5,
    bsaQuantity6 => bsaQuantity6,
    bsaQuantity7 => bsaQuantity7,
    bsaQuantity8 => bsaQuantity8,
    bsaQuantity9 => bsaQuantity9,
    bsaQuantity10 => bsaQuantity10,
    bsaQuantity11 => bsaQuantity11,
    mpsPermit => mpsPermit,
    cPllRefClk => cPllRefClk,
    stableClk => stableClk,
    stableRst => stableRst,
    cPllLock => cPllLock,
    txPolarity => txPolarity,
    txPreCursor => txPreCursor,
    txPostCursor => txPostCursor,
    txDiffCtrl => txDiffCtrl,
    gtTxP => gtTxP,
    gtTxN => gtTxN,
    gtRxP => gtRxP,
    gtRxN => gtRxN);
