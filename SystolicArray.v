module MulAddRecFNToRaw_preMul(
  input  [32:0] io_a,
  input  [32:0] io_b,
  input  [32:0] io_c,
  output [23:0] io_mulAddA,
  output [23:0] io_mulAddB,
  output [47:0] io_mulAddC,
  output        io_toPostMul_isSigNaNAny,
  output        io_toPostMul_isNaNAOrB,
  output        io_toPostMul_isInfA,
  output        io_toPostMul_isZeroA,
  output        io_toPostMul_isInfB,
  output        io_toPostMul_isZeroB,
  output        io_toPostMul_signProd,
  output        io_toPostMul_isNaNC,
  output        io_toPostMul_isInfC,
  output        io_toPostMul_isZeroC,
  output [9:0]  io_toPostMul_sExpSum,
  output        io_toPostMul_doSubMags,
  output        io_toPostMul_CIsDominant,
  output [4:0]  io_toPostMul_CDom_CAlignDist,
  output [25:0] io_toPostMul_highAlignedSigC,
  output        io_toPostMul_bit0AlignedSigC
);
  wire [8:0] rawA_exp = io_a[31:23]; // @[rawFloatFromRecFN.scala 51:21]
  wire  rawA_isZero = rawA_exp[8:6] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  rawA_isSpecial = rawA_exp[8:7] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  rawA__isNaN = rawA_isSpecial & rawA_exp[6]; // @[rawFloatFromRecFN.scala 56:33]
  wire  rawA__sign = io_a[32]; // @[rawFloatFromRecFN.scala 59:25]
  wire [9:0] rawA__sExp = {1'b0,$signed(rawA_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _rawA_out_sig_T = ~rawA_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [24:0] rawA__sig = {1'h0,_rawA_out_sig_T,io_a[22:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire [8:0] rawB_exp = io_b[31:23]; // @[rawFloatFromRecFN.scala 51:21]
  wire  rawB_isZero = rawB_exp[8:6] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  rawB_isSpecial = rawB_exp[8:7] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  rawB__isNaN = rawB_isSpecial & rawB_exp[6]; // @[rawFloatFromRecFN.scala 56:33]
  wire  rawB__sign = io_b[32]; // @[rawFloatFromRecFN.scala 59:25]
  wire [9:0] rawB__sExp = {1'b0,$signed(rawB_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _rawB_out_sig_T = ~rawB_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [24:0] rawB__sig = {1'h0,_rawB_out_sig_T,io_b[22:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire [8:0] rawC_exp = io_c[31:23]; // @[rawFloatFromRecFN.scala 51:21]
  wire  rawC_isZero = rawC_exp[8:6] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  wire  rawC_isSpecial = rawC_exp[8:7] == 2'h3; // @[rawFloatFromRecFN.scala 53:53]
  wire  rawC__isNaN = rawC_isSpecial & rawC_exp[6]; // @[rawFloatFromRecFN.scala 56:33]
  wire  rawC__sign = io_c[32]; // @[rawFloatFromRecFN.scala 59:25]
  wire [9:0] rawC__sExp = {1'b0,$signed(rawC_exp)}; // @[rawFloatFromRecFN.scala 60:27]
  wire  _rawC_out_sig_T = ~rawC_isZero; // @[rawFloatFromRecFN.scala 61:35]
  wire [24:0] rawC__sig = {1'h0,_rawC_out_sig_T,io_c[22:0]}; // @[rawFloatFromRecFN.scala 61:44]
  wire  signProd = rawA__sign ^ rawB__sign; // @[MulAddRecFN.scala 96:30]
  wire [10:0] _sExpAlignedProd_T = $signed(rawA__sExp) + $signed(rawB__sExp); // @[MulAddRecFN.scala 99:19]
  wire [10:0] sExpAlignedProd = $signed(_sExpAlignedProd_T) - 11'she5; // @[MulAddRecFN.scala 99:32]
  wire  doSubMags = signProd ^ rawC__sign; // @[MulAddRecFN.scala 101:30]
  wire [10:0] _GEN_0 = {{1{rawC__sExp[9]}},rawC__sExp}; // @[MulAddRecFN.scala 105:42]
  wire [10:0] sNatCAlignDist = $signed(sExpAlignedProd) - $signed(_GEN_0); // @[MulAddRecFN.scala 105:42]
  wire [9:0] posNatCAlignDist = sNatCAlignDist[9:0]; // @[MulAddRecFN.scala 106:42]
  wire  isMinCAlign = rawA_isZero | rawB_isZero | $signed(sNatCAlignDist) < 11'sh0; // @[MulAddRecFN.scala 107:50]
  wire  CIsDominant = _rawC_out_sig_T & (isMinCAlign | posNatCAlignDist <= 10'h18); // @[MulAddRecFN.scala 109:23]
  wire [6:0] _CAlignDist_T_2 = posNatCAlignDist < 10'h4a ? posNatCAlignDist[6:0] : 7'h4a; // @[MulAddRecFN.scala 113:16]
  wire [6:0] CAlignDist = isMinCAlign ? 7'h0 : _CAlignDist_T_2; // @[MulAddRecFN.scala 111:12]
  wire [24:0] _mainAlignedSigC_T = ~rawC__sig; // @[MulAddRecFN.scala 119:25]
  wire [24:0] _mainAlignedSigC_T_1 = doSubMags ? _mainAlignedSigC_T : rawC__sig; // @[MulAddRecFN.scala 119:13]
  wire [52:0] _mainAlignedSigC_T_3 = doSubMags ? 53'h1fffffffffffff : 53'h0; // @[Bitwise.scala 77:12]
  wire [77:0] _mainAlignedSigC_T_5 = {_mainAlignedSigC_T_1,_mainAlignedSigC_T_3}; // @[MulAddRecFN.scala 119:94]
  wire [77:0] mainAlignedSigC = $signed(_mainAlignedSigC_T_5) >>> CAlignDist; // @[MulAddRecFN.scala 119:100]
  wire [26:0] _reduced4CExtra_T = {rawC__sig, 2'h0}; // @[MulAddRecFN.scala 121:30]
  wire  reduced4CExtra_reducedVec_0 = |_reduced4CExtra_T[3:0]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_1 = |_reduced4CExtra_T[7:4]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_2 = |_reduced4CExtra_T[11:8]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_3 = |_reduced4CExtra_T[15:12]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_4 = |_reduced4CExtra_T[19:16]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_5 = |_reduced4CExtra_T[23:20]; // @[primitives.scala 120:54]
  wire  reduced4CExtra_reducedVec_6 = |_reduced4CExtra_T[26:24]; // @[primitives.scala 123:57]
  wire [6:0] _reduced4CExtra_T_1 = {reduced4CExtra_reducedVec_6,reduced4CExtra_reducedVec_5,reduced4CExtra_reducedVec_4,
    reduced4CExtra_reducedVec_3,reduced4CExtra_reducedVec_2,reduced4CExtra_reducedVec_1,reduced4CExtra_reducedVec_0}; // @[primitives.scala 124:20]
  wire [32:0] reduced4CExtra_shift = 33'sh100000000 >>> CAlignDist[6:2]; // @[primitives.scala 76:56]
  wire [5:0] _reduced4CExtra_T_18 = {reduced4CExtra_shift[14],reduced4CExtra_shift[15],reduced4CExtra_shift[16],
    reduced4CExtra_shift[17],reduced4CExtra_shift[18],reduced4CExtra_shift[19]}; // @[Cat.scala 33:92]
  wire [6:0] _GEN_1 = {{1'd0}, _reduced4CExtra_T_18}; // @[MulAddRecFN.scala 121:68]
  wire [6:0] _reduced4CExtra_T_19 = _reduced4CExtra_T_1 & _GEN_1; // @[MulAddRecFN.scala 121:68]
  wire  reduced4CExtra = |_reduced4CExtra_T_19; // @[MulAddRecFN.scala 129:11]
  wire  _alignedSigC_T_4 = &mainAlignedSigC[2:0] & ~reduced4CExtra; // @[MulAddRecFN.scala 133:44]
  wire  _alignedSigC_T_7 = |mainAlignedSigC[2:0] | reduced4CExtra; // @[MulAddRecFN.scala 134:44]
  wire  _alignedSigC_T_8 = doSubMags ? _alignedSigC_T_4 : _alignedSigC_T_7; // @[MulAddRecFN.scala 132:16]
  wire [74:0] alignedSigC_hi = mainAlignedSigC[77:3]; // @[Cat.scala 33:92]
  wire [75:0] alignedSigC = {alignedSigC_hi,_alignedSigC_T_8}; // @[Cat.scala 33:92]
  wire  _io_toPostMul_isSigNaNAny_T_2 = rawA__isNaN & ~rawA__sig[22]; // @[common.scala 82:46]
  wire  _io_toPostMul_isSigNaNAny_T_5 = rawB__isNaN & ~rawB__sig[22]; // @[common.scala 82:46]
  wire  _io_toPostMul_isSigNaNAny_T_9 = rawC__isNaN & ~rawC__sig[22]; // @[common.scala 82:46]
  wire [10:0] _io_toPostMul_sExpSum_T_2 = $signed(sExpAlignedProd) - 11'sh18; // @[MulAddRecFN.scala 157:53]
  wire [10:0] _io_toPostMul_sExpSum_T_3 = CIsDominant ? $signed({{1{rawC__sExp[9]}},rawC__sExp}) : $signed(
    _io_toPostMul_sExpSum_T_2); // @[MulAddRecFN.scala 157:12]
  assign io_mulAddA = rawA__sig[23:0]; // @[MulAddRecFN.scala 140:16]
  assign io_mulAddB = rawB__sig[23:0]; // @[MulAddRecFN.scala 141:16]
  assign io_mulAddC = alignedSigC[48:1]; // @[MulAddRecFN.scala 142:30]
  assign io_toPostMul_isSigNaNAny = _io_toPostMul_isSigNaNAny_T_2 | _io_toPostMul_isSigNaNAny_T_5 |
    _io_toPostMul_isSigNaNAny_T_9; // @[MulAddRecFN.scala 145:58]
  assign io_toPostMul_isNaNAOrB = rawA__isNaN | rawB__isNaN; // @[MulAddRecFN.scala 147:42]
  assign io_toPostMul_isInfA = rawA_isSpecial & ~rawA_exp[6]; // @[rawFloatFromRecFN.scala 57:33]
  assign io_toPostMul_isZeroA = rawA_exp[8:6] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign io_toPostMul_isInfB = rawB_isSpecial & ~rawB_exp[6]; // @[rawFloatFromRecFN.scala 57:33]
  assign io_toPostMul_isZeroB = rawB_exp[8:6] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign io_toPostMul_signProd = rawA__sign ^ rawB__sign; // @[MulAddRecFN.scala 96:30]
  assign io_toPostMul_isNaNC = rawC_isSpecial & rawC_exp[6]; // @[rawFloatFromRecFN.scala 56:33]
  assign io_toPostMul_isInfC = rawC_isSpecial & ~rawC_exp[6]; // @[rawFloatFromRecFN.scala 57:33]
  assign io_toPostMul_isZeroC = rawC_exp[8:6] == 3'h0; // @[rawFloatFromRecFN.scala 52:53]
  assign io_toPostMul_sExpSum = _io_toPostMul_sExpSum_T_3[9:0]; // @[MulAddRecFN.scala 156:28]
  assign io_toPostMul_doSubMags = signProd ^ rawC__sign; // @[MulAddRecFN.scala 101:30]
  assign io_toPostMul_CIsDominant = _rawC_out_sig_T & (isMinCAlign | posNatCAlignDist <= 10'h18); // @[MulAddRecFN.scala 109:23]
  assign io_toPostMul_CDom_CAlignDist = CAlignDist[4:0]; // @[MulAddRecFN.scala 160:47]
  assign io_toPostMul_highAlignedSigC = alignedSigC[74:49]; // @[MulAddRecFN.scala 162:20]
  assign io_toPostMul_bit0AlignedSigC = alignedSigC[0]; // @[MulAddRecFN.scala 163:48]
endmodule
module MulAddRecFNToRaw_postMul(
  input         io_fromPreMul_isSigNaNAny,
  input         io_fromPreMul_isNaNAOrB,
  input         io_fromPreMul_isInfA,
  input         io_fromPreMul_isZeroA,
  input         io_fromPreMul_isInfB,
  input         io_fromPreMul_isZeroB,
  input         io_fromPreMul_signProd,
  input         io_fromPreMul_isNaNC,
  input         io_fromPreMul_isInfC,
  input         io_fromPreMul_isZeroC,
  input  [9:0]  io_fromPreMul_sExpSum,
  input         io_fromPreMul_doSubMags,
  input         io_fromPreMul_CIsDominant,
  input  [4:0]  io_fromPreMul_CDom_CAlignDist,
  input  [25:0] io_fromPreMul_highAlignedSigC,
  input         io_fromPreMul_bit0AlignedSigC,
  input  [48:0] io_mulAddResult,
  output        io_invalidExc,
  output        io_rawOut_isNaN,
  output        io_rawOut_isInf,
  output        io_rawOut_isZero,
  output        io_rawOut_sign,
  output [9:0]  io_rawOut_sExp,
  output [26:0] io_rawOut_sig
);
  wire  CDom_sign = io_fromPreMul_signProd ^ io_fromPreMul_doSubMags; // @[MulAddRecFN.scala 188:42]
  wire [25:0] _sigSum_T_2 = io_fromPreMul_highAlignedSigC + 26'h1; // @[MulAddRecFN.scala 191:47]
  wire [25:0] _sigSum_T_3 = io_mulAddResult[48] ? _sigSum_T_2 : io_fromPreMul_highAlignedSigC; // @[MulAddRecFN.scala 190:16]
  wire [74:0] sigSum = {_sigSum_T_3,io_mulAddResult[47:0],io_fromPreMul_bit0AlignedSigC}; // @[Cat.scala 33:92]
  wire [1:0] _CDom_sExp_T = {1'b0,$signed(io_fromPreMul_doSubMags)}; // @[MulAddRecFN.scala 201:69]
  wire [9:0] _GEN_0 = {{8{_CDom_sExp_T[1]}},_CDom_sExp_T}; // @[MulAddRecFN.scala 201:43]
  wire [9:0] CDom_sExp = $signed(io_fromPreMul_sExpSum) - $signed(_GEN_0); // @[MulAddRecFN.scala 201:43]
  wire [49:0] _CDom_absSigSum_T_1 = ~sigSum[74:25]; // @[MulAddRecFN.scala 204:13]
  wire [49:0] _CDom_absSigSum_T_5 = {1'h0,io_fromPreMul_highAlignedSigC[25:24],sigSum[72:26]}; // @[MulAddRecFN.scala 207:71]
  wire [49:0] CDom_absSigSum = io_fromPreMul_doSubMags ? _CDom_absSigSum_T_1 : _CDom_absSigSum_T_5; // @[MulAddRecFN.scala 203:12]
  wire [23:0] _CDom_absSigSumExtra_T_1 = ~sigSum[24:1]; // @[MulAddRecFN.scala 213:14]
  wire  _CDom_absSigSumExtra_T_2 = |_CDom_absSigSumExtra_T_1; // @[MulAddRecFN.scala 213:36]
  wire  _CDom_absSigSumExtra_T_4 = |sigSum[25:1]; // @[MulAddRecFN.scala 214:37]
  wire  CDom_absSigSumExtra = io_fromPreMul_doSubMags ? _CDom_absSigSumExtra_T_2 : _CDom_absSigSumExtra_T_4; // @[MulAddRecFN.scala 212:12]
  wire [80:0] _GEN_5 = {{31'd0}, CDom_absSigSum}; // @[MulAddRecFN.scala 217:24]
  wire [80:0] _CDom_mainSig_T = _GEN_5 << io_fromPreMul_CDom_CAlignDist; // @[MulAddRecFN.scala 217:24]
  wire [28:0] CDom_mainSig = _CDom_mainSig_T[49:21]; // @[MulAddRecFN.scala 217:56]
  wire [26:0] _CDom_reduced4SigExtra_T_1 = {CDom_absSigSum[23:0], 3'h0}; // @[MulAddRecFN.scala 220:53]
  wire  CDom_reduced4SigExtra_reducedVec_0 = |_CDom_reduced4SigExtra_T_1[3:0]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_1 = |_CDom_reduced4SigExtra_T_1[7:4]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_2 = |_CDom_reduced4SigExtra_T_1[11:8]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_3 = |_CDom_reduced4SigExtra_T_1[15:12]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_4 = |_CDom_reduced4SigExtra_T_1[19:16]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_5 = |_CDom_reduced4SigExtra_T_1[23:20]; // @[primitives.scala 120:54]
  wire  CDom_reduced4SigExtra_reducedVec_6 = |_CDom_reduced4SigExtra_T_1[26:24]; // @[primitives.scala 123:57]
  wire [6:0] _CDom_reduced4SigExtra_T_2 = {CDom_reduced4SigExtra_reducedVec_6,CDom_reduced4SigExtra_reducedVec_5,
    CDom_reduced4SigExtra_reducedVec_4,CDom_reduced4SigExtra_reducedVec_3,CDom_reduced4SigExtra_reducedVec_2,
    CDom_reduced4SigExtra_reducedVec_1,CDom_reduced4SigExtra_reducedVec_0}; // @[primitives.scala 124:20]
  wire [2:0] _CDom_reduced4SigExtra_T_4 = ~io_fromPreMul_CDom_CAlignDist[4:2]; // @[primitives.scala 52:21]
  wire [8:0] CDom_reduced4SigExtra_shift = 9'sh100 >>> _CDom_reduced4SigExtra_T_4; // @[primitives.scala 76:56]
  wire [5:0] _CDom_reduced4SigExtra_T_20 = {CDom_reduced4SigExtra_shift[1],CDom_reduced4SigExtra_shift[2],
    CDom_reduced4SigExtra_shift[3],CDom_reduced4SigExtra_shift[4],CDom_reduced4SigExtra_shift[5],
    CDom_reduced4SigExtra_shift[6]}; // @[Cat.scala 33:92]
  wire [6:0] _GEN_1 = {{1'd0}, _CDom_reduced4SigExtra_T_20}; // @[MulAddRecFN.scala 220:72]
  wire [6:0] _CDom_reduced4SigExtra_T_21 = _CDom_reduced4SigExtra_T_2 & _GEN_1; // @[MulAddRecFN.scala 220:72]
  wire  CDom_reduced4SigExtra = |_CDom_reduced4SigExtra_T_21; // @[MulAddRecFN.scala 221:73]
  wire  _CDom_sig_T_4 = |CDom_mainSig[2:0] | CDom_reduced4SigExtra | CDom_absSigSumExtra; // @[MulAddRecFN.scala 224:61]
  wire [26:0] CDom_sig = {CDom_mainSig[28:3],_CDom_sig_T_4}; // @[Cat.scala 33:92]
  wire  notCDom_signSigSum = sigSum[51]; // @[MulAddRecFN.scala 230:36]
  wire [50:0] _notCDom_absSigSum_T_1 = ~sigSum[50:0]; // @[MulAddRecFN.scala 233:13]
  wire [50:0] _GEN_2 = {{50'd0}, io_fromPreMul_doSubMags}; // @[MulAddRecFN.scala 234:41]
  wire [50:0] _notCDom_absSigSum_T_4 = sigSum[50:0] + _GEN_2; // @[MulAddRecFN.scala 234:41]
  wire [50:0] notCDom_absSigSum = notCDom_signSigSum ? _notCDom_absSigSum_T_1 : _notCDom_absSigSum_T_4; // @[MulAddRecFN.scala 232:12]
  wire  notCDom_reduced2AbsSigSum_reducedVec_0 = |notCDom_absSigSum[1:0]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_1 = |notCDom_absSigSum[3:2]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_2 = |notCDom_absSigSum[5:4]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_3 = |notCDom_absSigSum[7:6]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_4 = |notCDom_absSigSum[9:8]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_5 = |notCDom_absSigSum[11:10]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_6 = |notCDom_absSigSum[13:12]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_7 = |notCDom_absSigSum[15:14]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_8 = |notCDom_absSigSum[17:16]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_9 = |notCDom_absSigSum[19:18]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_10 = |notCDom_absSigSum[21:20]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_11 = |notCDom_absSigSum[23:22]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_12 = |notCDom_absSigSum[25:24]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_13 = |notCDom_absSigSum[27:26]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_14 = |notCDom_absSigSum[29:28]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_15 = |notCDom_absSigSum[31:30]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_16 = |notCDom_absSigSum[33:32]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_17 = |notCDom_absSigSum[35:34]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_18 = |notCDom_absSigSum[37:36]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_19 = |notCDom_absSigSum[39:38]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_20 = |notCDom_absSigSum[41:40]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_21 = |notCDom_absSigSum[43:42]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_22 = |notCDom_absSigSum[45:44]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_23 = |notCDom_absSigSum[47:46]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_24 = |notCDom_absSigSum[49:48]; // @[primitives.scala 103:54]
  wire  notCDom_reduced2AbsSigSum_reducedVec_25 = |notCDom_absSigSum[50]; // @[primitives.scala 106:57]
  wire [5:0] notCDom_reduced2AbsSigSum_lo_lo = {notCDom_reduced2AbsSigSum_reducedVec_5,
    notCDom_reduced2AbsSigSum_reducedVec_4,notCDom_reduced2AbsSigSum_reducedVec_3,notCDom_reduced2AbsSigSum_reducedVec_2
    ,notCDom_reduced2AbsSigSum_reducedVec_1,notCDom_reduced2AbsSigSum_reducedVec_0}; // @[primitives.scala 107:20]
  wire [12:0] notCDom_reduced2AbsSigSum_lo = {notCDom_reduced2AbsSigSum_reducedVec_12,
    notCDom_reduced2AbsSigSum_reducedVec_11,notCDom_reduced2AbsSigSum_reducedVec_10,
    notCDom_reduced2AbsSigSum_reducedVec_9,notCDom_reduced2AbsSigSum_reducedVec_8,notCDom_reduced2AbsSigSum_reducedVec_7
    ,notCDom_reduced2AbsSigSum_reducedVec_6,notCDom_reduced2AbsSigSum_lo_lo}; // @[primitives.scala 107:20]
  wire [5:0] notCDom_reduced2AbsSigSum_hi_lo = {notCDom_reduced2AbsSigSum_reducedVec_18,
    notCDom_reduced2AbsSigSum_reducedVec_17,notCDom_reduced2AbsSigSum_reducedVec_16,
    notCDom_reduced2AbsSigSum_reducedVec_15,notCDom_reduced2AbsSigSum_reducedVec_14,
    notCDom_reduced2AbsSigSum_reducedVec_13}; // @[primitives.scala 107:20]
  wire [25:0] notCDom_reduced2AbsSigSum = {notCDom_reduced2AbsSigSum_reducedVec_25,
    notCDom_reduced2AbsSigSum_reducedVec_24,notCDom_reduced2AbsSigSum_reducedVec_23,
    notCDom_reduced2AbsSigSum_reducedVec_22,notCDom_reduced2AbsSigSum_reducedVec_21,
    notCDom_reduced2AbsSigSum_reducedVec_20,notCDom_reduced2AbsSigSum_reducedVec_19,notCDom_reduced2AbsSigSum_hi_lo,
    notCDom_reduced2AbsSigSum_lo}; // @[primitives.scala 107:20]
  wire [4:0] _notCDom_normDistReduced2_T_26 = notCDom_reduced2AbsSigSum[1] ? 5'h18 : 5'h19; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_27 = notCDom_reduced2AbsSigSum[2] ? 5'h17 : _notCDom_normDistReduced2_T_26; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_28 = notCDom_reduced2AbsSigSum[3] ? 5'h16 : _notCDom_normDistReduced2_T_27; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_29 = notCDom_reduced2AbsSigSum[4] ? 5'h15 : _notCDom_normDistReduced2_T_28; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_30 = notCDom_reduced2AbsSigSum[5] ? 5'h14 : _notCDom_normDistReduced2_T_29; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_31 = notCDom_reduced2AbsSigSum[6] ? 5'h13 : _notCDom_normDistReduced2_T_30; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_32 = notCDom_reduced2AbsSigSum[7] ? 5'h12 : _notCDom_normDistReduced2_T_31; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_33 = notCDom_reduced2AbsSigSum[8] ? 5'h11 : _notCDom_normDistReduced2_T_32; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_34 = notCDom_reduced2AbsSigSum[9] ? 5'h10 : _notCDom_normDistReduced2_T_33; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_35 = notCDom_reduced2AbsSigSum[10] ? 5'hf : _notCDom_normDistReduced2_T_34; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_36 = notCDom_reduced2AbsSigSum[11] ? 5'he : _notCDom_normDistReduced2_T_35; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_37 = notCDom_reduced2AbsSigSum[12] ? 5'hd : _notCDom_normDistReduced2_T_36; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_38 = notCDom_reduced2AbsSigSum[13] ? 5'hc : _notCDom_normDistReduced2_T_37; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_39 = notCDom_reduced2AbsSigSum[14] ? 5'hb : _notCDom_normDistReduced2_T_38; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_40 = notCDom_reduced2AbsSigSum[15] ? 5'ha : _notCDom_normDistReduced2_T_39; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_41 = notCDom_reduced2AbsSigSum[16] ? 5'h9 : _notCDom_normDistReduced2_T_40; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_42 = notCDom_reduced2AbsSigSum[17] ? 5'h8 : _notCDom_normDistReduced2_T_41; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_43 = notCDom_reduced2AbsSigSum[18] ? 5'h7 : _notCDom_normDistReduced2_T_42; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_44 = notCDom_reduced2AbsSigSum[19] ? 5'h6 : _notCDom_normDistReduced2_T_43; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_45 = notCDom_reduced2AbsSigSum[20] ? 5'h5 : _notCDom_normDistReduced2_T_44; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_46 = notCDom_reduced2AbsSigSum[21] ? 5'h4 : _notCDom_normDistReduced2_T_45; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_47 = notCDom_reduced2AbsSigSum[22] ? 5'h3 : _notCDom_normDistReduced2_T_46; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_48 = notCDom_reduced2AbsSigSum[23] ? 5'h2 : _notCDom_normDistReduced2_T_47; // @[Mux.scala 47:70]
  wire [4:0] _notCDom_normDistReduced2_T_49 = notCDom_reduced2AbsSigSum[24] ? 5'h1 : _notCDom_normDistReduced2_T_48; // @[Mux.scala 47:70]
  wire [4:0] notCDom_normDistReduced2 = notCDom_reduced2AbsSigSum[25] ? 5'h0 : _notCDom_normDistReduced2_T_49; // @[Mux.scala 47:70]
  wire [5:0] notCDom_nearNormDist = {notCDom_normDistReduced2, 1'h0}; // @[MulAddRecFN.scala 238:56]
  wire [6:0] _notCDom_sExp_T = {1'b0,$signed(notCDom_nearNormDist)}; // @[MulAddRecFN.scala 239:78]
  wire [9:0] _GEN_3 = {{3{_notCDom_sExp_T[6]}},_notCDom_sExp_T}; // @[MulAddRecFN.scala 239:46]
  wire [9:0] notCDom_sExp = $signed(io_fromPreMul_sExpSum) - $signed(_GEN_3); // @[MulAddRecFN.scala 239:46]
  wire [113:0] _GEN_6 = {{63'd0}, notCDom_absSigSum}; // @[MulAddRecFN.scala 241:27]
  wire [113:0] _notCDom_mainSig_T = _GEN_6 << notCDom_nearNormDist; // @[MulAddRecFN.scala 241:27]
  wire [28:0] notCDom_mainSig = _notCDom_mainSig_T[51:23]; // @[MulAddRecFN.scala 241:50]
  wire  notCDom_reduced4SigExtra_reducedVec_0 = |notCDom_reduced2AbsSigSum[1:0]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_1 = |notCDom_reduced2AbsSigSum[3:2]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_2 = |notCDom_reduced2AbsSigSum[5:4]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_3 = |notCDom_reduced2AbsSigSum[7:6]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_4 = |notCDom_reduced2AbsSigSum[9:8]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_5 = |notCDom_reduced2AbsSigSum[11:10]; // @[primitives.scala 103:54]
  wire  notCDom_reduced4SigExtra_reducedVec_6 = |notCDom_reduced2AbsSigSum[12]; // @[primitives.scala 106:57]
  wire [6:0] _notCDom_reduced4SigExtra_T_2 = {notCDom_reduced4SigExtra_reducedVec_6,
    notCDom_reduced4SigExtra_reducedVec_5,notCDom_reduced4SigExtra_reducedVec_4,notCDom_reduced4SigExtra_reducedVec_3,
    notCDom_reduced4SigExtra_reducedVec_2,notCDom_reduced4SigExtra_reducedVec_1,notCDom_reduced4SigExtra_reducedVec_0}; // @[primitives.scala 107:20]
  wire [3:0] _notCDom_reduced4SigExtra_T_4 = ~notCDom_normDistReduced2[4:1]; // @[primitives.scala 52:21]
  wire [16:0] notCDom_reduced4SigExtra_shift = 17'sh10000 >>> _notCDom_reduced4SigExtra_T_4; // @[primitives.scala 76:56]
  wire [5:0] _notCDom_reduced4SigExtra_T_20 = {notCDom_reduced4SigExtra_shift[1],notCDom_reduced4SigExtra_shift[2],
    notCDom_reduced4SigExtra_shift[3],notCDom_reduced4SigExtra_shift[4],notCDom_reduced4SigExtra_shift[5],
    notCDom_reduced4SigExtra_shift[6]}; // @[Cat.scala 33:92]
  wire [6:0] _GEN_4 = {{1'd0}, _notCDom_reduced4SigExtra_T_20}; // @[MulAddRecFN.scala 245:78]
  wire [6:0] _notCDom_reduced4SigExtra_T_21 = _notCDom_reduced4SigExtra_T_2 & _GEN_4; // @[MulAddRecFN.scala 245:78]
  wire  notCDom_reduced4SigExtra = |_notCDom_reduced4SigExtra_T_21; // @[MulAddRecFN.scala 247:11]
  wire  _notCDom_sig_T_3 = |notCDom_mainSig[2:0] | notCDom_reduced4SigExtra; // @[MulAddRecFN.scala 250:39]
  wire [26:0] notCDom_sig = {notCDom_mainSig[28:3],_notCDom_sig_T_3}; // @[Cat.scala 33:92]
  wire  notCDom_completeCancellation = notCDom_sig[26:25] == 2'h0; // @[MulAddRecFN.scala 253:50]
  wire  _notCDom_sign_T = io_fromPreMul_signProd ^ notCDom_signSigSum; // @[MulAddRecFN.scala 257:36]
  wire  notCDom_sign = notCDom_completeCancellation ? 1'h0 : _notCDom_sign_T; // @[MulAddRecFN.scala 255:12]
  wire  notNaN_isInfProd = io_fromPreMul_isInfA | io_fromPreMul_isInfB; // @[MulAddRecFN.scala 262:49]
  wire  notNaN_isInfOut = notNaN_isInfProd | io_fromPreMul_isInfC; // @[MulAddRecFN.scala 263:44]
  wire  notNaN_addZeros = (io_fromPreMul_isZeroA | io_fromPreMul_isZeroB) & io_fromPreMul_isZeroC; // @[MulAddRecFN.scala 265:58]
  wire  _io_invalidExc_T = io_fromPreMul_isInfA & io_fromPreMul_isZeroB; // @[MulAddRecFN.scala 270:31]
  wire  _io_invalidExc_T_1 = io_fromPreMul_isSigNaNAny | _io_invalidExc_T; // @[MulAddRecFN.scala 269:35]
  wire  _io_invalidExc_T_2 = io_fromPreMul_isZeroA & io_fromPreMul_isInfB; // @[MulAddRecFN.scala 271:32]
  wire  _io_invalidExc_T_3 = _io_invalidExc_T_1 | _io_invalidExc_T_2; // @[MulAddRecFN.scala 270:57]
  wire  _io_invalidExc_T_6 = ~io_fromPreMul_isNaNAOrB & notNaN_isInfProd; // @[MulAddRecFN.scala 272:36]
  wire  _io_invalidExc_T_7 = _io_invalidExc_T_6 & io_fromPreMul_isInfC; // @[MulAddRecFN.scala 273:61]
  wire  _io_invalidExc_T_8 = _io_invalidExc_T_7 & io_fromPreMul_doSubMags; // @[MulAddRecFN.scala 274:35]
  wire  _io_rawOut_isZero_T_1 = ~io_fromPreMul_CIsDominant & notCDom_completeCancellation; // @[MulAddRecFN.scala 281:42]
  wire  _io_rawOut_sign_T_1 = io_fromPreMul_isInfC & CDom_sign; // @[MulAddRecFN.scala 284:31]
  wire  _io_rawOut_sign_T_2 = notNaN_isInfProd & io_fromPreMul_signProd | _io_rawOut_sign_T_1; // @[MulAddRecFN.scala 283:54]
  wire  _io_rawOut_sign_T_5 = notNaN_addZeros & io_fromPreMul_signProd; // @[MulAddRecFN.scala 285:48]
  wire  _io_rawOut_sign_T_6 = _io_rawOut_sign_T_5 & CDom_sign; // @[MulAddRecFN.scala 286:36]
  wire  _io_rawOut_sign_T_7 = _io_rawOut_sign_T_2 | _io_rawOut_sign_T_6; // @[MulAddRecFN.scala 284:43]
  wire  _io_rawOut_sign_T_15 = io_fromPreMul_CIsDominant ? CDom_sign : notCDom_sign; // @[MulAddRecFN.scala 290:17]
  wire  _io_rawOut_sign_T_16 = ~notNaN_isInfOut & ~notNaN_addZeros & _io_rawOut_sign_T_15; // @[MulAddRecFN.scala 289:49]
  assign io_invalidExc = _io_invalidExc_T_3 | _io_invalidExc_T_8; // @[MulAddRecFN.scala 271:57]
  assign io_rawOut_isNaN = io_fromPreMul_isNaNAOrB | io_fromPreMul_isNaNC; // @[MulAddRecFN.scala 276:48]
  assign io_rawOut_isInf = notNaN_isInfProd | io_fromPreMul_isInfC; // @[MulAddRecFN.scala 263:44]
  assign io_rawOut_isZero = notNaN_addZeros | _io_rawOut_isZero_T_1; // @[MulAddRecFN.scala 280:25]
  assign io_rawOut_sign = _io_rawOut_sign_T_7 | _io_rawOut_sign_T_16; // @[MulAddRecFN.scala 288:50]
  assign io_rawOut_sExp = io_fromPreMul_CIsDominant ? $signed(CDom_sExp) : $signed(notCDom_sExp); // @[MulAddRecFN.scala 291:26]
  assign io_rawOut_sig = io_fromPreMul_CIsDominant ? CDom_sig : notCDom_sig; // @[MulAddRecFN.scala 292:25]
endmodule
module RoundAnyRawFNToRecFN(
  input         io_invalidExc,
  input         io_in_isNaN,
  input         io_in_isInf,
  input         io_in_isZero,
  input         io_in_sign,
  input  [9:0]  io_in_sExp,
  input  [26:0] io_in_sig,
  output [32:0] io_out
);
  wire  doShiftSigDown1 = io_in_sig[26]; // @[RoundAnyRawFNToRecFN.scala 119:57]
  wire [8:0] _roundMask_T_1 = ~io_in_sExp[8:0]; // @[primitives.scala 52:21]
  wire  roundMask_msb = _roundMask_T_1[8]; // @[primitives.scala 58:25]
  wire [7:0] roundMask_lsbs = _roundMask_T_1[7:0]; // @[primitives.scala 59:26]
  wire  roundMask_msb_1 = roundMask_lsbs[7]; // @[primitives.scala 58:25]
  wire [6:0] roundMask_lsbs_1 = roundMask_lsbs[6:0]; // @[primitives.scala 59:26]
  wire  roundMask_msb_2 = roundMask_lsbs_1[6]; // @[primitives.scala 58:25]
  wire [5:0] roundMask_lsbs_2 = roundMask_lsbs_1[5:0]; // @[primitives.scala 59:26]
  wire [64:0] roundMask_shift = 65'sh10000000000000000 >>> roundMask_lsbs_2; // @[primitives.scala 76:56]
  wire [15:0] _GEN_0 = {{8'd0}, roundMask_shift[57:50]}; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_7 = _GEN_0 & 16'hff; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_9 = {roundMask_shift[49:42], 8'h0}; // @[Bitwise.scala 108:70]
  wire [15:0] _roundMask_T_11 = _roundMask_T_9 & 16'hff00; // @[Bitwise.scala 108:80]
  wire [15:0] _roundMask_T_12 = _roundMask_T_7 | _roundMask_T_11; // @[Bitwise.scala 108:39]
  wire [15:0] _GEN_1 = {{4'd0}, _roundMask_T_12[15:4]}; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_17 = _GEN_1 & 16'hf0f; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_19 = {_roundMask_T_12[11:0], 4'h0}; // @[Bitwise.scala 108:70]
  wire [15:0] _roundMask_T_21 = _roundMask_T_19 & 16'hf0f0; // @[Bitwise.scala 108:80]
  wire [15:0] _roundMask_T_22 = _roundMask_T_17 | _roundMask_T_21; // @[Bitwise.scala 108:39]
  wire [15:0] _GEN_2 = {{2'd0}, _roundMask_T_22[15:2]}; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_27 = _GEN_2 & 16'h3333; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_29 = {_roundMask_T_22[13:0], 2'h0}; // @[Bitwise.scala 108:70]
  wire [15:0] _roundMask_T_31 = _roundMask_T_29 & 16'hcccc; // @[Bitwise.scala 108:80]
  wire [15:0] _roundMask_T_32 = _roundMask_T_27 | _roundMask_T_31; // @[Bitwise.scala 108:39]
  wire [15:0] _GEN_3 = {{1'd0}, _roundMask_T_32[15:1]}; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_37 = _GEN_3 & 16'h5555; // @[Bitwise.scala 108:31]
  wire [15:0] _roundMask_T_39 = {_roundMask_T_32[14:0], 1'h0}; // @[Bitwise.scala 108:70]
  wire [15:0] _roundMask_T_41 = _roundMask_T_39 & 16'haaaa; // @[Bitwise.scala 108:80]
  wire [15:0] _roundMask_T_42 = _roundMask_T_37 | _roundMask_T_41; // @[Bitwise.scala 108:39]
  wire [21:0] _roundMask_T_59 = {_roundMask_T_42,roundMask_shift[58],roundMask_shift[59],roundMask_shift[60],
    roundMask_shift[61],roundMask_shift[62],roundMask_shift[63]}; // @[Cat.scala 33:92]
  wire [21:0] _roundMask_T_60 = ~_roundMask_T_59; // @[primitives.scala 73:32]
  wire [21:0] _roundMask_T_61 = roundMask_msb_2 ? 22'h0 : _roundMask_T_60; // @[primitives.scala 73:21]
  wire [21:0] _roundMask_T_62 = ~_roundMask_T_61; // @[primitives.scala 73:17]
  wire [24:0] _roundMask_T_63 = {_roundMask_T_62,3'h7}; // @[primitives.scala 68:58]
  wire [2:0] _roundMask_T_70 = {roundMask_shift[0],roundMask_shift[1],roundMask_shift[2]}; // @[Cat.scala 33:92]
  wire [2:0] _roundMask_T_71 = roundMask_msb_2 ? _roundMask_T_70 : 3'h0; // @[primitives.scala 62:24]
  wire [24:0] _roundMask_T_72 = roundMask_msb_1 ? _roundMask_T_63 : {{22'd0}, _roundMask_T_71}; // @[primitives.scala 67:24]
  wire [24:0] _roundMask_T_73 = roundMask_msb ? _roundMask_T_72 : 25'h0; // @[primitives.scala 62:24]
  wire [24:0] _GEN_4 = {{24'd0}, doShiftSigDown1}; // @[RoundAnyRawFNToRecFN.scala 158:23]
  wire [24:0] _roundMask_T_74 = _roundMask_T_73 | _GEN_4; // @[RoundAnyRawFNToRecFN.scala 158:23]
  wire [26:0] roundMask = {_roundMask_T_74,2'h3}; // @[RoundAnyRawFNToRecFN.scala 158:42]
  wire [27:0] _shiftedRoundMask_T = {1'h0,_roundMask_T_74,2'h3}; // @[RoundAnyRawFNToRecFN.scala 161:41]
  wire [26:0] shiftedRoundMask = _shiftedRoundMask_T[27:1]; // @[RoundAnyRawFNToRecFN.scala 161:53]
  wire [26:0] _roundPosMask_T = ~shiftedRoundMask; // @[RoundAnyRawFNToRecFN.scala 162:28]
  wire [26:0] roundPosMask = _roundPosMask_T & roundMask; // @[RoundAnyRawFNToRecFN.scala 162:46]
  wire [26:0] _roundPosBit_T = io_in_sig & roundPosMask; // @[RoundAnyRawFNToRecFN.scala 163:40]
  wire  roundPosBit = |_roundPosBit_T; // @[RoundAnyRawFNToRecFN.scala 163:56]
  wire [26:0] _anyRoundExtra_T = io_in_sig & shiftedRoundMask; // @[RoundAnyRawFNToRecFN.scala 164:42]
  wire  anyRoundExtra = |_anyRoundExtra_T; // @[RoundAnyRawFNToRecFN.scala 164:62]
  wire [26:0] _roundedSig_T = io_in_sig | roundMask; // @[RoundAnyRawFNToRecFN.scala 173:32]
  wire [25:0] _roundedSig_T_2 = _roundedSig_T[26:2] + 25'h1; // @[RoundAnyRawFNToRecFN.scala 173:49]
  wire  _roundedSig_T_4 = ~anyRoundExtra; // @[RoundAnyRawFNToRecFN.scala 175:30]
  wire [25:0] _roundedSig_T_7 = roundPosBit & _roundedSig_T_4 ? roundMask[26:1] : 26'h0; // @[RoundAnyRawFNToRecFN.scala 174:25]
  wire [25:0] _roundedSig_T_8 = ~_roundedSig_T_7; // @[RoundAnyRawFNToRecFN.scala 174:21]
  wire [25:0] _roundedSig_T_9 = _roundedSig_T_2 & _roundedSig_T_8; // @[RoundAnyRawFNToRecFN.scala 173:57]
  wire [26:0] _roundedSig_T_10 = ~roundMask; // @[RoundAnyRawFNToRecFN.scala 179:32]
  wire [26:0] _roundedSig_T_11 = io_in_sig & _roundedSig_T_10; // @[RoundAnyRawFNToRecFN.scala 179:30]
  wire [25:0] _roundedSig_T_16 = {{1'd0}, _roundedSig_T_11[26:2]}; // @[RoundAnyRawFNToRecFN.scala 179:47]
  wire [25:0] roundedSig = roundPosBit ? _roundedSig_T_9 : _roundedSig_T_16; // @[RoundAnyRawFNToRecFN.scala 172:16]
  wire [2:0] _sRoundedExp_T_1 = {1'b0,$signed(roundedSig[25:24])}; // @[RoundAnyRawFNToRecFN.scala 184:78]
  wire [9:0] _GEN_5 = {{7{_sRoundedExp_T_1[2]}},_sRoundedExp_T_1}; // @[RoundAnyRawFNToRecFN.scala 184:40]
  wire [10:0] sRoundedExp = $signed(io_in_sExp) + $signed(_GEN_5); // @[RoundAnyRawFNToRecFN.scala 184:40]
  wire [8:0] common_expOut = sRoundedExp[8:0]; // @[RoundAnyRawFNToRecFN.scala 186:37]
  wire [22:0] common_fractOut = doShiftSigDown1 ? roundedSig[23:1] : roundedSig[22:0]; // @[RoundAnyRawFNToRecFN.scala 188:16]
  wire [3:0] _common_overflow_T = sRoundedExp[10:7]; // @[RoundAnyRawFNToRecFN.scala 195:30]
  wire  common_overflow = $signed(_common_overflow_T) >= 4'sh3; // @[RoundAnyRawFNToRecFN.scala 195:50]
  wire  common_totalUnderflow = $signed(sRoundedExp) < 11'sh6b; // @[RoundAnyRawFNToRecFN.scala 199:31]
  wire  isNaNOut = io_invalidExc | io_in_isNaN; // @[RoundAnyRawFNToRecFN.scala 234:34]
  wire  commonCase = ~isNaNOut & ~io_in_isInf & ~io_in_isZero; // @[RoundAnyRawFNToRecFN.scala 236:61]
  wire  overflow = commonCase & common_overflow; // @[RoundAnyRawFNToRecFN.scala 237:32]
  wire  notNaN_isInfOut = io_in_isInf | overflow; // @[RoundAnyRawFNToRecFN.scala 247:32]
  wire  signOut = isNaNOut ? 1'h0 : io_in_sign; // @[RoundAnyRawFNToRecFN.scala 249:22]
  wire [8:0] _expOut_T_1 = io_in_isZero | common_totalUnderflow ? 9'h1c0 : 9'h0; // @[RoundAnyRawFNToRecFN.scala 252:18]
  wire [8:0] _expOut_T_2 = ~_expOut_T_1; // @[RoundAnyRawFNToRecFN.scala 252:14]
  wire [8:0] _expOut_T_3 = common_expOut & _expOut_T_2; // @[RoundAnyRawFNToRecFN.scala 251:24]
  wire [8:0] _expOut_T_11 = notNaN_isInfOut ? 9'h40 : 9'h0; // @[RoundAnyRawFNToRecFN.scala 264:18]
  wire [8:0] _expOut_T_12 = ~_expOut_T_11; // @[RoundAnyRawFNToRecFN.scala 264:14]
  wire [8:0] _expOut_T_13 = _expOut_T_3 & _expOut_T_12; // @[RoundAnyRawFNToRecFN.scala 263:17]
  wire [8:0] _expOut_T_18 = notNaN_isInfOut ? 9'h180 : 9'h0; // @[RoundAnyRawFNToRecFN.scala 276:16]
  wire [8:0] _expOut_T_19 = _expOut_T_13 | _expOut_T_18; // @[RoundAnyRawFNToRecFN.scala 275:15]
  wire [8:0] _expOut_T_20 = isNaNOut ? 9'h1c0 : 9'h0; // @[RoundAnyRawFNToRecFN.scala 277:16]
  wire [8:0] expOut = _expOut_T_19 | _expOut_T_20; // @[RoundAnyRawFNToRecFN.scala 276:73]
  wire [22:0] _fractOut_T_2 = isNaNOut ? 23'h400000 : 23'h0; // @[RoundAnyRawFNToRecFN.scala 280:16]
  wire [22:0] fractOut = isNaNOut | io_in_isZero | common_totalUnderflow ? _fractOut_T_2 : common_fractOut; // @[RoundAnyRawFNToRecFN.scala 279:12]
  wire [9:0] _io_out_T = {signOut,expOut}; // @[RoundAnyRawFNToRecFN.scala 285:23]
  assign io_out = {_io_out_T,fractOut}; // @[RoundAnyRawFNToRecFN.scala 285:33]
endmodule
module RoundRawFNToRecFN(
  input         io_invalidExc,
  input         io_in_isNaN,
  input         io_in_isInf,
  input         io_in_isZero,
  input         io_in_sign,
  input  [9:0]  io_in_sExp,
  input  [26:0] io_in_sig,
  output [32:0] io_out
);
  wire  roundAnyRawFNToRecFN_io_invalidExc; // @[RoundAnyRawFNToRecFN.scala 308:15]
  wire  roundAnyRawFNToRecFN_io_in_isNaN; // @[RoundAnyRawFNToRecFN.scala 308:15]
  wire  roundAnyRawFNToRecFN_io_in_isInf; // @[RoundAnyRawFNToRecFN.scala 308:15]
  wire  roundAnyRawFNToRecFN_io_in_isZero; // @[RoundAnyRawFNToRecFN.scala 308:15]
  wire  roundAnyRawFNToRecFN_io_in_sign; // @[RoundAnyRawFNToRecFN.scala 308:15]
  wire [9:0] roundAnyRawFNToRecFN_io_in_sExp; // @[RoundAnyRawFNToRecFN.scala 308:15]
  wire [26:0] roundAnyRawFNToRecFN_io_in_sig; // @[RoundAnyRawFNToRecFN.scala 308:15]
  wire [32:0] roundAnyRawFNToRecFN_io_out; // @[RoundAnyRawFNToRecFN.scala 308:15]
  RoundAnyRawFNToRecFN roundAnyRawFNToRecFN ( // @[RoundAnyRawFNToRecFN.scala 308:15]
    .io_invalidExc(roundAnyRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(roundAnyRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(roundAnyRawFNToRecFN_io_in_isInf),
    .io_in_isZero(roundAnyRawFNToRecFN_io_in_isZero),
    .io_in_sign(roundAnyRawFNToRecFN_io_in_sign),
    .io_in_sExp(roundAnyRawFNToRecFN_io_in_sExp),
    .io_in_sig(roundAnyRawFNToRecFN_io_in_sig),
    .io_out(roundAnyRawFNToRecFN_io_out)
  );
  assign io_out = roundAnyRawFNToRecFN_io_out; // @[RoundAnyRawFNToRecFN.scala 316:23]
  assign roundAnyRawFNToRecFN_io_invalidExc = io_invalidExc; // @[RoundAnyRawFNToRecFN.scala 311:44]
  assign roundAnyRawFNToRecFN_io_in_isNaN = io_in_isNaN; // @[RoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_isInf = io_in_isInf; // @[RoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_isZero = io_in_isZero; // @[RoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_sign = io_in_sign; // @[RoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_sExp = io_in_sExp; // @[RoundAnyRawFNToRecFN.scala 313:44]
  assign roundAnyRawFNToRecFN_io_in_sig = io_in_sig; // @[RoundAnyRawFNToRecFN.scala 313:44]
endmodule
module MulAddRecFN(
  input  [32:0] io_a,
  input  [32:0] io_b,
  input  [32:0] io_c,
  output [32:0] io_out
);
  wire [32:0] mulAddRecFNToRaw_preMul_io_a; // @[MulAddRecFN.scala 314:15]
  wire [32:0] mulAddRecFNToRaw_preMul_io_b; // @[MulAddRecFN.scala 314:15]
  wire [32:0] mulAddRecFNToRaw_preMul_io_c; // @[MulAddRecFN.scala 314:15]
  wire [23:0] mulAddRecFNToRaw_preMul_io_mulAddA; // @[MulAddRecFN.scala 314:15]
  wire [23:0] mulAddRecFNToRaw_preMul_io_mulAddB; // @[MulAddRecFN.scala 314:15]
  wire [47:0] mulAddRecFNToRaw_preMul_io_mulAddC; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isSigNaNAny; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isNaNAOrB; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isInfA; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isZeroA; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isInfB; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isZeroB; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_signProd; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isNaNC; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isInfC; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_isZeroC; // @[MulAddRecFN.scala 314:15]
  wire [9:0] mulAddRecFNToRaw_preMul_io_toPostMul_sExpSum; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_doSubMags; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_CIsDominant; // @[MulAddRecFN.scala 314:15]
  wire [4:0] mulAddRecFNToRaw_preMul_io_toPostMul_CDom_CAlignDist; // @[MulAddRecFN.scala 314:15]
  wire [25:0] mulAddRecFNToRaw_preMul_io_toPostMul_highAlignedSigC; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_preMul_io_toPostMul_bit0AlignedSigC; // @[MulAddRecFN.scala 314:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isSigNaNAny; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNAOrB; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isInfA; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroA; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isInfB; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroB; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_signProd; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNC; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isInfC; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroC; // @[MulAddRecFN.scala 316:15]
  wire [9:0] mulAddRecFNToRaw_postMul_io_fromPreMul_sExpSum; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_doSubMags; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_CIsDominant; // @[MulAddRecFN.scala 316:15]
  wire [4:0] mulAddRecFNToRaw_postMul_io_fromPreMul_CDom_CAlignDist; // @[MulAddRecFN.scala 316:15]
  wire [25:0] mulAddRecFNToRaw_postMul_io_fromPreMul_highAlignedSigC; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_fromPreMul_bit0AlignedSigC; // @[MulAddRecFN.scala 316:15]
  wire [48:0] mulAddRecFNToRaw_postMul_io_mulAddResult; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_invalidExc; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_isNaN; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_isInf; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_isZero; // @[MulAddRecFN.scala 316:15]
  wire  mulAddRecFNToRaw_postMul_io_rawOut_sign; // @[MulAddRecFN.scala 316:15]
  wire [9:0] mulAddRecFNToRaw_postMul_io_rawOut_sExp; // @[MulAddRecFN.scala 316:15]
  wire [26:0] mulAddRecFNToRaw_postMul_io_rawOut_sig; // @[MulAddRecFN.scala 316:15]
  wire  roundRawFNToRecFN_io_invalidExc; // @[MulAddRecFN.scala 336:15]
  wire  roundRawFNToRecFN_io_in_isNaN; // @[MulAddRecFN.scala 336:15]
  wire  roundRawFNToRecFN_io_in_isInf; // @[MulAddRecFN.scala 336:15]
  wire  roundRawFNToRecFN_io_in_isZero; // @[MulAddRecFN.scala 336:15]
  wire  roundRawFNToRecFN_io_in_sign; // @[MulAddRecFN.scala 336:15]
  wire [9:0] roundRawFNToRecFN_io_in_sExp; // @[MulAddRecFN.scala 336:15]
  wire [26:0] roundRawFNToRecFN_io_in_sig; // @[MulAddRecFN.scala 336:15]
  wire [32:0] roundRawFNToRecFN_io_out; // @[MulAddRecFN.scala 336:15]
  wire [47:0] _mulAddResult_T = mulAddRecFNToRaw_preMul_io_mulAddA * mulAddRecFNToRaw_preMul_io_mulAddB; // @[MulAddRecFN.scala 324:45]
  MulAddRecFNToRaw_preMul mulAddRecFNToRaw_preMul ( // @[MulAddRecFN.scala 314:15]
    .io_a(mulAddRecFNToRaw_preMul_io_a),
    .io_b(mulAddRecFNToRaw_preMul_io_b),
    .io_c(mulAddRecFNToRaw_preMul_io_c),
    .io_mulAddA(mulAddRecFNToRaw_preMul_io_mulAddA),
    .io_mulAddB(mulAddRecFNToRaw_preMul_io_mulAddB),
    .io_mulAddC(mulAddRecFNToRaw_preMul_io_mulAddC),
    .io_toPostMul_isSigNaNAny(mulAddRecFNToRaw_preMul_io_toPostMul_isSigNaNAny),
    .io_toPostMul_isNaNAOrB(mulAddRecFNToRaw_preMul_io_toPostMul_isNaNAOrB),
    .io_toPostMul_isInfA(mulAddRecFNToRaw_preMul_io_toPostMul_isInfA),
    .io_toPostMul_isZeroA(mulAddRecFNToRaw_preMul_io_toPostMul_isZeroA),
    .io_toPostMul_isInfB(mulAddRecFNToRaw_preMul_io_toPostMul_isInfB),
    .io_toPostMul_isZeroB(mulAddRecFNToRaw_preMul_io_toPostMul_isZeroB),
    .io_toPostMul_signProd(mulAddRecFNToRaw_preMul_io_toPostMul_signProd),
    .io_toPostMul_isNaNC(mulAddRecFNToRaw_preMul_io_toPostMul_isNaNC),
    .io_toPostMul_isInfC(mulAddRecFNToRaw_preMul_io_toPostMul_isInfC),
    .io_toPostMul_isZeroC(mulAddRecFNToRaw_preMul_io_toPostMul_isZeroC),
    .io_toPostMul_sExpSum(mulAddRecFNToRaw_preMul_io_toPostMul_sExpSum),
    .io_toPostMul_doSubMags(mulAddRecFNToRaw_preMul_io_toPostMul_doSubMags),
    .io_toPostMul_CIsDominant(mulAddRecFNToRaw_preMul_io_toPostMul_CIsDominant),
    .io_toPostMul_CDom_CAlignDist(mulAddRecFNToRaw_preMul_io_toPostMul_CDom_CAlignDist),
    .io_toPostMul_highAlignedSigC(mulAddRecFNToRaw_preMul_io_toPostMul_highAlignedSigC),
    .io_toPostMul_bit0AlignedSigC(mulAddRecFNToRaw_preMul_io_toPostMul_bit0AlignedSigC)
  );
  MulAddRecFNToRaw_postMul mulAddRecFNToRaw_postMul ( // @[MulAddRecFN.scala 316:15]
    .io_fromPreMul_isSigNaNAny(mulAddRecFNToRaw_postMul_io_fromPreMul_isSigNaNAny),
    .io_fromPreMul_isNaNAOrB(mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNAOrB),
    .io_fromPreMul_isInfA(mulAddRecFNToRaw_postMul_io_fromPreMul_isInfA),
    .io_fromPreMul_isZeroA(mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroA),
    .io_fromPreMul_isInfB(mulAddRecFNToRaw_postMul_io_fromPreMul_isInfB),
    .io_fromPreMul_isZeroB(mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroB),
    .io_fromPreMul_signProd(mulAddRecFNToRaw_postMul_io_fromPreMul_signProd),
    .io_fromPreMul_isNaNC(mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNC),
    .io_fromPreMul_isInfC(mulAddRecFNToRaw_postMul_io_fromPreMul_isInfC),
    .io_fromPreMul_isZeroC(mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroC),
    .io_fromPreMul_sExpSum(mulAddRecFNToRaw_postMul_io_fromPreMul_sExpSum),
    .io_fromPreMul_doSubMags(mulAddRecFNToRaw_postMul_io_fromPreMul_doSubMags),
    .io_fromPreMul_CIsDominant(mulAddRecFNToRaw_postMul_io_fromPreMul_CIsDominant),
    .io_fromPreMul_CDom_CAlignDist(mulAddRecFNToRaw_postMul_io_fromPreMul_CDom_CAlignDist),
    .io_fromPreMul_highAlignedSigC(mulAddRecFNToRaw_postMul_io_fromPreMul_highAlignedSigC),
    .io_fromPreMul_bit0AlignedSigC(mulAddRecFNToRaw_postMul_io_fromPreMul_bit0AlignedSigC),
    .io_mulAddResult(mulAddRecFNToRaw_postMul_io_mulAddResult),
    .io_invalidExc(mulAddRecFNToRaw_postMul_io_invalidExc),
    .io_rawOut_isNaN(mulAddRecFNToRaw_postMul_io_rawOut_isNaN),
    .io_rawOut_isInf(mulAddRecFNToRaw_postMul_io_rawOut_isInf),
    .io_rawOut_isZero(mulAddRecFNToRaw_postMul_io_rawOut_isZero),
    .io_rawOut_sign(mulAddRecFNToRaw_postMul_io_rawOut_sign),
    .io_rawOut_sExp(mulAddRecFNToRaw_postMul_io_rawOut_sExp),
    .io_rawOut_sig(mulAddRecFNToRaw_postMul_io_rawOut_sig)
  );
  RoundRawFNToRecFN roundRawFNToRecFN ( // @[MulAddRecFN.scala 336:15]
    .io_invalidExc(roundRawFNToRecFN_io_invalidExc),
    .io_in_isNaN(roundRawFNToRecFN_io_in_isNaN),
    .io_in_isInf(roundRawFNToRecFN_io_in_isInf),
    .io_in_isZero(roundRawFNToRecFN_io_in_isZero),
    .io_in_sign(roundRawFNToRecFN_io_in_sign),
    .io_in_sExp(roundRawFNToRecFN_io_in_sExp),
    .io_in_sig(roundRawFNToRecFN_io_in_sig),
    .io_out(roundRawFNToRecFN_io_out)
  );
  assign io_out = roundRawFNToRecFN_io_out; // @[MulAddRecFN.scala 342:23]
  assign mulAddRecFNToRaw_preMul_io_a = io_a; // @[MulAddRecFN.scala 319:35]
  assign mulAddRecFNToRaw_preMul_io_b = io_b; // @[MulAddRecFN.scala 320:35]
  assign mulAddRecFNToRaw_preMul_io_c = io_c; // @[MulAddRecFN.scala 321:35]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isSigNaNAny = mulAddRecFNToRaw_preMul_io_toPostMul_isSigNaNAny; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNAOrB = mulAddRecFNToRaw_preMul_io_toPostMul_isNaNAOrB; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isInfA = mulAddRecFNToRaw_preMul_io_toPostMul_isInfA; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroA = mulAddRecFNToRaw_preMul_io_toPostMul_isZeroA; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isInfB = mulAddRecFNToRaw_preMul_io_toPostMul_isInfB; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroB = mulAddRecFNToRaw_preMul_io_toPostMul_isZeroB; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_signProd = mulAddRecFNToRaw_preMul_io_toPostMul_signProd; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isNaNC = mulAddRecFNToRaw_preMul_io_toPostMul_isNaNC; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isInfC = mulAddRecFNToRaw_preMul_io_toPostMul_isInfC; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_isZeroC = mulAddRecFNToRaw_preMul_io_toPostMul_isZeroC; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_sExpSum = mulAddRecFNToRaw_preMul_io_toPostMul_sExpSum; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_doSubMags = mulAddRecFNToRaw_preMul_io_toPostMul_doSubMags; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_CIsDominant = mulAddRecFNToRaw_preMul_io_toPostMul_CIsDominant; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_CDom_CAlignDist = mulAddRecFNToRaw_preMul_io_toPostMul_CDom_CAlignDist; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_highAlignedSigC = mulAddRecFNToRaw_preMul_io_toPostMul_highAlignedSigC; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_fromPreMul_bit0AlignedSigC = mulAddRecFNToRaw_preMul_io_toPostMul_bit0AlignedSigC; // @[MulAddRecFN.scala 328:44]
  assign mulAddRecFNToRaw_postMul_io_mulAddResult = _mulAddResult_T + mulAddRecFNToRaw_preMul_io_mulAddC; // @[MulAddRecFN.scala 325:50]
  assign roundRawFNToRecFN_io_invalidExc = mulAddRecFNToRaw_postMul_io_invalidExc; // @[MulAddRecFN.scala 337:39]
  assign roundRawFNToRecFN_io_in_isNaN = mulAddRecFNToRaw_postMul_io_rawOut_isNaN; // @[MulAddRecFN.scala 339:39]
  assign roundRawFNToRecFN_io_in_isInf = mulAddRecFNToRaw_postMul_io_rawOut_isInf; // @[MulAddRecFN.scala 339:39]
  assign roundRawFNToRecFN_io_in_isZero = mulAddRecFNToRaw_postMul_io_rawOut_isZero; // @[MulAddRecFN.scala 339:39]
  assign roundRawFNToRecFN_io_in_sign = mulAddRecFNToRaw_postMul_io_rawOut_sign; // @[MulAddRecFN.scala 339:39]
  assign roundRawFNToRecFN_io_in_sExp = mulAddRecFNToRaw_postMul_io_rawOut_sExp; // @[MulAddRecFN.scala 339:39]
  assign roundRawFNToRecFN_io_in_sig = mulAddRecFNToRaw_postMul_io_rawOut_sig; // @[MulAddRecFN.scala 339:39]
endmodule
module SystolicPe(
  input         clock,
  input         reset,
  input  [32:0] io_in_act,
  input  [32:0] io_in_acc,
  input  [32:0] io_in_weight,
  output [32:0] io_out
);
`ifdef RANDOMIZE_REG_INIT
  reg [63:0] _RAND_0;
  reg [63:0] _RAND_1;
  reg [63:0] _RAND_2;
`endif // RANDOMIZE_REG_INIT
  wire [32:0] muladd_io_a; // @[ValExec_MulAddRecFN.scala 62:24]
  wire [32:0] muladd_io_b; // @[ValExec_MulAddRecFN.scala 62:24]
  wire [32:0] muladd_io_c; // @[ValExec_MulAddRecFN.scala 62:24]
  wire [32:0] muladd_io_out; // @[ValExec_MulAddRecFN.scala 62:24]
  reg [32:0] act_reg; // @[ValExec_MulAddRecFN.scala 56:26]
  reg [32:0] acc_reg; // @[ValExec_MulAddRecFN.scala 58:26]
  reg [32:0] weight_reg; // @[ValExec_MulAddRecFN.scala 60:29]
  MulAddRecFN muladd ( // @[ValExec_MulAddRecFN.scala 62:24]
    .io_a(muladd_io_a),
    .io_b(muladd_io_b),
    .io_c(muladd_io_c),
    .io_out(muladd_io_out)
  );
  assign io_out = muladd_io_out; // @[ValExec_MulAddRecFN.scala 75:12]
  assign muladd_io_a = act_reg; // @[ValExec_MulAddRecFN.scala 68:17]
  assign muladd_io_b = weight_reg; // @[ValExec_MulAddRecFN.scala 69:17]
  assign muladd_io_c = acc_reg; // @[ValExec_MulAddRecFN.scala 70:17]
  always @(posedge clock) begin
    if (reset) begin // @[ValExec_MulAddRecFN.scala 56:26]
      act_reg <= 33'h0; // @[ValExec_MulAddRecFN.scala 56:26]
    end else begin
      act_reg <= io_in_act; // @[ValExec_MulAddRecFN.scala 64:13]
    end
    if (reset) begin // @[ValExec_MulAddRecFN.scala 58:26]
      acc_reg <= 33'h0; // @[ValExec_MulAddRecFN.scala 58:26]
    end else begin
      acc_reg <= io_in_acc; // @[ValExec_MulAddRecFN.scala 65:13]
    end
    if (reset) begin // @[ValExec_MulAddRecFN.scala 60:29]
      weight_reg <= 33'h0; // @[ValExec_MulAddRecFN.scala 60:29]
    end else begin
      weight_reg <= io_in_weight; // @[ValExec_MulAddRecFN.scala 66:16]
    end
  end
// Register and memory initialization
`ifdef RANDOMIZE_GARBAGE_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_INVALID_ASSIGN
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_REG_INIT
`define RANDOMIZE
`endif
`ifdef RANDOMIZE_MEM_INIT
`define RANDOMIZE
`endif
`ifndef RANDOM
`define RANDOM $random
`endif
`ifdef RANDOMIZE_MEM_INIT
  integer initvar;
`endif
`ifndef SYNTHESIS
`ifdef FIRRTL_BEFORE_INITIAL
`FIRRTL_BEFORE_INITIAL
`endif
initial begin
  `ifdef RANDOMIZE
    `ifdef INIT_RANDOM
      `INIT_RANDOM
    `endif
    `ifndef VERILATOR
      `ifdef RANDOMIZE_DELAY
        #`RANDOMIZE_DELAY begin end
      `else
        #0.002 begin end
      `endif
    `endif
`ifdef RANDOMIZE_REG_INIT
  _RAND_0 = {2{`RANDOM}};
  act_reg = _RAND_0[32:0];
  _RAND_1 = {2{`RANDOM}};
  acc_reg = _RAND_1[32:0];
  _RAND_2 = {2{`RANDOM}};
  weight_reg = _RAND_2[32:0];
`endif // RANDOMIZE_REG_INIT
  `endif // RANDOMIZE
end // initial
`ifdef FIRRTL_AFTER_INITIAL
`FIRRTL_AFTER_INITIAL
`endif
`endif // SYNTHESIS
endmodule
module SystolicArray(
  input         clock,
  input         reset,
  input  [32:0] io_in_rows_0,
  input  [32:0] io_in_rows_1,
  input  [32:0] io_in_rows_2,
  input  [32:0] io_in_rows_3,
  input  [32:0] io_in_rows_4,
  input  [32:0] io_in_rows_5,
  input  [32:0] io_in_rows_6,
  input  [32:0] io_in_rows_7,
  input  [32:0] io_in_rows_8,
  input  [32:0] io_in_rows_9,
  input  [32:0] io_in_rows_10,
  input  [32:0] io_in_rows_11,
  input  [32:0] io_in_rows_12,
  input  [32:0] io_in_rows_13,
  input  [32:0] io_in_rows_14,
  input  [32:0] io_in_rows_15,
  input  [32:0] io_in_cols_0,
  input  [32:0] io_in_cols_1,
  input  [32:0] io_in_cols_2,
  input  [32:0] io_in_cols_3,
  input  [32:0] io_in_cols_4,
  input  [32:0] io_in_cols_5,
  input  [32:0] io_in_cols_6,
  input  [32:0] io_in_cols_7,
  input  [32:0] io_in_cols_8,
  input  [32:0] io_in_cols_9,
  input  [32:0] io_in_cols_10,
  input  [32:0] io_in_cols_11,
  input  [32:0] io_in_cols_12,
  input  [32:0] io_in_cols_13,
  input  [32:0] io_in_cols_14,
  input  [32:0] io_in_cols_15,
  input  [32:0] io_weight_0,
  input  [32:0] io_weight_1,
  input  [32:0] io_weight_2,
  input  [32:0] io_weight_3,
  input  [32:0] io_weight_4,
  input  [32:0] io_weight_5,
  input  [32:0] io_weight_6,
  input  [32:0] io_weight_7,
  input  [32:0] io_weight_8,
  input  [32:0] io_weight_9,
  input  [32:0] io_weight_10,
  input  [32:0] io_weight_11,
  input  [32:0] io_weight_12,
  input  [32:0] io_weight_13,
  input  [32:0] io_weight_14,
  input  [32:0] io_weight_15,
  input  [32:0] io_weight_16,
  input  [32:0] io_weight_17,
  input  [32:0] io_weight_18,
  input  [32:0] io_weight_19,
  input  [32:0] io_weight_20,
  input  [32:0] io_weight_21,
  input  [32:0] io_weight_22,
  input  [32:0] io_weight_23,
  input  [32:0] io_weight_24,
  input  [32:0] io_weight_25,
  input  [32:0] io_weight_26,
  input  [32:0] io_weight_27,
  input  [32:0] io_weight_28,
  input  [32:0] io_weight_29,
  input  [32:0] io_weight_30,
  input  [32:0] io_weight_31,
  input  [32:0] io_weight_32,
  input  [32:0] io_weight_33,
  input  [32:0] io_weight_34,
  input  [32:0] io_weight_35,
  input  [32:0] io_weight_36,
  input  [32:0] io_weight_37,
  input  [32:0] io_weight_38,
  input  [32:0] io_weight_39,
  input  [32:0] io_weight_40,
  input  [32:0] io_weight_41,
  input  [32:0] io_weight_42,
  input  [32:0] io_weight_43,
  input  [32:0] io_weight_44,
  input  [32:0] io_weight_45,
  input  [32:0] io_weight_46,
  input  [32:0] io_weight_47,
  input  [32:0] io_weight_48,
  input  [32:0] io_weight_49,
  input  [32:0] io_weight_50,
  input  [32:0] io_weight_51,
  input  [32:0] io_weight_52,
  input  [32:0] io_weight_53,
  input  [32:0] io_weight_54,
  input  [32:0] io_weight_55,
  input  [32:0] io_weight_56,
  input  [32:0] io_weight_57,
  input  [32:0] io_weight_58,
  input  [32:0] io_weight_59,
  input  [32:0] io_weight_60,
  input  [32:0] io_weight_61,
  input  [32:0] io_weight_62,
  input  [32:0] io_weight_63,
  input  [32:0] io_weight_64,
  input  [32:0] io_weight_65,
  input  [32:0] io_weight_66,
  input  [32:0] io_weight_67,
  input  [32:0] io_weight_68,
  input  [32:0] io_weight_69,
  input  [32:0] io_weight_70,
  input  [32:0] io_weight_71,
  input  [32:0] io_weight_72,
  input  [32:0] io_weight_73,
  input  [32:0] io_weight_74,
  input  [32:0] io_weight_75,
  input  [32:0] io_weight_76,
  input  [32:0] io_weight_77,
  input  [32:0] io_weight_78,
  input  [32:0] io_weight_79,
  input  [32:0] io_weight_80,
  input  [32:0] io_weight_81,
  input  [32:0] io_weight_82,
  input  [32:0] io_weight_83,
  input  [32:0] io_weight_84,
  input  [32:0] io_weight_85,
  input  [32:0] io_weight_86,
  input  [32:0] io_weight_87,
  input  [32:0] io_weight_88,
  input  [32:0] io_weight_89,
  input  [32:0] io_weight_90,
  input  [32:0] io_weight_91,
  input  [32:0] io_weight_92,
  input  [32:0] io_weight_93,
  input  [32:0] io_weight_94,
  input  [32:0] io_weight_95,
  input  [32:0] io_weight_96,
  input  [32:0] io_weight_97,
  input  [32:0] io_weight_98,
  input  [32:0] io_weight_99,
  input  [32:0] io_weight_100,
  input  [32:0] io_weight_101,
  input  [32:0] io_weight_102,
  input  [32:0] io_weight_103,
  input  [32:0] io_weight_104,
  input  [32:0] io_weight_105,
  input  [32:0] io_weight_106,
  input  [32:0] io_weight_107,
  input  [32:0] io_weight_108,
  input  [32:0] io_weight_109,
  input  [32:0] io_weight_110,
  input  [32:0] io_weight_111,
  input  [32:0] io_weight_112,
  input  [32:0] io_weight_113,
  input  [32:0] io_weight_114,
  input  [32:0] io_weight_115,
  input  [32:0] io_weight_116,
  input  [32:0] io_weight_117,
  input  [32:0] io_weight_118,
  input  [32:0] io_weight_119,
  input  [32:0] io_weight_120,
  input  [32:0] io_weight_121,
  input  [32:0] io_weight_122,
  input  [32:0] io_weight_123,
  input  [32:0] io_weight_124,
  input  [32:0] io_weight_125,
  input  [32:0] io_weight_126,
  input  [32:0] io_weight_127,
  input  [32:0] io_weight_128,
  input  [32:0] io_weight_129,
  input  [32:0] io_weight_130,
  input  [32:0] io_weight_131,
  input  [32:0] io_weight_132,
  input  [32:0] io_weight_133,
  input  [32:0] io_weight_134,
  input  [32:0] io_weight_135,
  input  [32:0] io_weight_136,
  input  [32:0] io_weight_137,
  input  [32:0] io_weight_138,
  input  [32:0] io_weight_139,
  input  [32:0] io_weight_140,
  input  [32:0] io_weight_141,
  input  [32:0] io_weight_142,
  input  [32:0] io_weight_143,
  input  [32:0] io_weight_144,
  input  [32:0] io_weight_145,
  input  [32:0] io_weight_146,
  input  [32:0] io_weight_147,
  input  [32:0] io_weight_148,
  input  [32:0] io_weight_149,
  input  [32:0] io_weight_150,
  input  [32:0] io_weight_151,
  input  [32:0] io_weight_152,
  input  [32:0] io_weight_153,
  input  [32:0] io_weight_154,
  input  [32:0] io_weight_155,
  input  [32:0] io_weight_156,
  input  [32:0] io_weight_157,
  input  [32:0] io_weight_158,
  input  [32:0] io_weight_159,
  input  [32:0] io_weight_160,
  input  [32:0] io_weight_161,
  input  [32:0] io_weight_162,
  input  [32:0] io_weight_163,
  input  [32:0] io_weight_164,
  input  [32:0] io_weight_165,
  input  [32:0] io_weight_166,
  input  [32:0] io_weight_167,
  input  [32:0] io_weight_168,
  input  [32:0] io_weight_169,
  input  [32:0] io_weight_170,
  input  [32:0] io_weight_171,
  input  [32:0] io_weight_172,
  input  [32:0] io_weight_173,
  input  [32:0] io_weight_174,
  input  [32:0] io_weight_175,
  input  [32:0] io_weight_176,
  input  [32:0] io_weight_177,
  input  [32:0] io_weight_178,
  input  [32:0] io_weight_179,
  input  [32:0] io_weight_180,
  input  [32:0] io_weight_181,
  input  [32:0] io_weight_182,
  input  [32:0] io_weight_183,
  input  [32:0] io_weight_184,
  input  [32:0] io_weight_185,
  input  [32:0] io_weight_186,
  input  [32:0] io_weight_187,
  input  [32:0] io_weight_188,
  input  [32:0] io_weight_189,
  input  [32:0] io_weight_190,
  input  [32:0] io_weight_191,
  input  [32:0] io_weight_192,
  input  [32:0] io_weight_193,
  input  [32:0] io_weight_194,
  input  [32:0] io_weight_195,
  input  [32:0] io_weight_196,
  input  [32:0] io_weight_197,
  input  [32:0] io_weight_198,
  input  [32:0] io_weight_199,
  input  [32:0] io_weight_200,
  input  [32:0] io_weight_201,
  input  [32:0] io_weight_202,
  input  [32:0] io_weight_203,
  input  [32:0] io_weight_204,
  input  [32:0] io_weight_205,
  input  [32:0] io_weight_206,
  input  [32:0] io_weight_207,
  input  [32:0] io_weight_208,
  input  [32:0] io_weight_209,
  input  [32:0] io_weight_210,
  input  [32:0] io_weight_211,
  input  [32:0] io_weight_212,
  input  [32:0] io_weight_213,
  input  [32:0] io_weight_214,
  input  [32:0] io_weight_215,
  input  [32:0] io_weight_216,
  input  [32:0] io_weight_217,
  input  [32:0] io_weight_218,
  input  [32:0] io_weight_219,
  input  [32:0] io_weight_220,
  input  [32:0] io_weight_221,
  input  [32:0] io_weight_222,
  input  [32:0] io_weight_223,
  input  [32:0] io_weight_224,
  input  [32:0] io_weight_225,
  input  [32:0] io_weight_226,
  input  [32:0] io_weight_227,
  input  [32:0] io_weight_228,
  input  [32:0] io_weight_229,
  input  [32:0] io_weight_230,
  input  [32:0] io_weight_231,
  input  [32:0] io_weight_232,
  input  [32:0] io_weight_233,
  input  [32:0] io_weight_234,
  input  [32:0] io_weight_235,
  input  [32:0] io_weight_236,
  input  [32:0] io_weight_237,
  input  [32:0] io_weight_238,
  input  [32:0] io_weight_239,
  input  [32:0] io_weight_240,
  input  [32:0] io_weight_241,
  input  [32:0] io_weight_242,
  input  [32:0] io_weight_243,
  input  [32:0] io_weight_244,
  input  [32:0] io_weight_245,
  input  [32:0] io_weight_246,
  input  [32:0] io_weight_247,
  input  [32:0] io_weight_248,
  input  [32:0] io_weight_249,
  input  [32:0] io_weight_250,
  input  [32:0] io_weight_251,
  input  [32:0] io_weight_252,
  input  [32:0] io_weight_253,
  input  [32:0] io_weight_254,
  input  [32:0] io_weight_255,
  output [32:0] io_out_0,
  output [32:0] io_out_1,
  output [32:0] io_out_2,
  output [32:0] io_out_3,
  output [32:0] io_out_4,
  output [32:0] io_out_5,
  output [32:0] io_out_6,
  output [32:0] io_out_7,
  output [32:0] io_out_8,
  output [32:0] io_out_9,
  output [32:0] io_out_10,
  output [32:0] io_out_11,
  output [32:0] io_out_12,
  output [32:0] io_out_13,
  output [32:0] io_out_14,
  output [32:0] io_out_15
);
  wire  pe_array_0_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_0_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_0_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_1_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_1_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_2_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_2_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_3_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_3_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_4_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_4_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_5_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_5_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_6_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_6_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_7_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_7_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_8_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_8_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_9_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_9_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_10_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_10_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_11_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_11_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_12_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_12_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_13_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_13_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_14_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_14_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_0_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_0_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_0_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_0_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_0_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_0_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_1_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_1_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_1_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_1_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_1_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_1_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_2_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_2_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_2_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_2_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_2_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_2_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_3_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_3_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_3_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_3_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_3_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_3_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_4_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_4_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_4_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_4_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_4_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_4_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_5_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_5_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_5_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_5_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_5_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_5_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_6_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_6_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_6_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_6_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_6_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_6_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_7_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_7_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_7_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_7_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_7_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_7_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_8_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_8_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_8_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_8_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_8_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_8_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_9_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_9_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_9_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_9_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_9_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_9_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_10_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_10_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_10_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_10_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_10_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_10_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_11_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_11_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_11_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_11_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_11_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_11_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_12_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_12_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_12_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_12_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_12_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_12_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_13_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_13_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_13_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_13_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_13_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_13_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_14_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_14_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_14_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_14_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_14_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_14_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_15_clock; // @[ValExec_MulAddRecFN.scala 90:67]
  wire  pe_array_15_15_reset; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_15_io_in_act; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_15_io_in_acc; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_15_io_in_weight; // @[ValExec_MulAddRecFN.scala 90:67]
  wire [32:0] pe_array_15_15_io_out; // @[ValExec_MulAddRecFN.scala 90:67]
  SystolicPe pe_array_0_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_0_clock),
    .reset(pe_array_0_0_reset),
    .io_in_act(pe_array_0_0_io_in_act),
    .io_in_acc(pe_array_0_0_io_in_acc),
    .io_in_weight(pe_array_0_0_io_in_weight),
    .io_out(pe_array_0_0_io_out)
  );
  SystolicPe pe_array_0_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_1_clock),
    .reset(pe_array_0_1_reset),
    .io_in_act(pe_array_0_1_io_in_act),
    .io_in_acc(pe_array_0_1_io_in_acc),
    .io_in_weight(pe_array_0_1_io_in_weight),
    .io_out(pe_array_0_1_io_out)
  );
  SystolicPe pe_array_0_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_2_clock),
    .reset(pe_array_0_2_reset),
    .io_in_act(pe_array_0_2_io_in_act),
    .io_in_acc(pe_array_0_2_io_in_acc),
    .io_in_weight(pe_array_0_2_io_in_weight),
    .io_out(pe_array_0_2_io_out)
  );
  SystolicPe pe_array_0_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_3_clock),
    .reset(pe_array_0_3_reset),
    .io_in_act(pe_array_0_3_io_in_act),
    .io_in_acc(pe_array_0_3_io_in_acc),
    .io_in_weight(pe_array_0_3_io_in_weight),
    .io_out(pe_array_0_3_io_out)
  );
  SystolicPe pe_array_0_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_4_clock),
    .reset(pe_array_0_4_reset),
    .io_in_act(pe_array_0_4_io_in_act),
    .io_in_acc(pe_array_0_4_io_in_acc),
    .io_in_weight(pe_array_0_4_io_in_weight),
    .io_out(pe_array_0_4_io_out)
  );
  SystolicPe pe_array_0_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_5_clock),
    .reset(pe_array_0_5_reset),
    .io_in_act(pe_array_0_5_io_in_act),
    .io_in_acc(pe_array_0_5_io_in_acc),
    .io_in_weight(pe_array_0_5_io_in_weight),
    .io_out(pe_array_0_5_io_out)
  );
  SystolicPe pe_array_0_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_6_clock),
    .reset(pe_array_0_6_reset),
    .io_in_act(pe_array_0_6_io_in_act),
    .io_in_acc(pe_array_0_6_io_in_acc),
    .io_in_weight(pe_array_0_6_io_in_weight),
    .io_out(pe_array_0_6_io_out)
  );
  SystolicPe pe_array_0_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_7_clock),
    .reset(pe_array_0_7_reset),
    .io_in_act(pe_array_0_7_io_in_act),
    .io_in_acc(pe_array_0_7_io_in_acc),
    .io_in_weight(pe_array_0_7_io_in_weight),
    .io_out(pe_array_0_7_io_out)
  );
  SystolicPe pe_array_0_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_8_clock),
    .reset(pe_array_0_8_reset),
    .io_in_act(pe_array_0_8_io_in_act),
    .io_in_acc(pe_array_0_8_io_in_acc),
    .io_in_weight(pe_array_0_8_io_in_weight),
    .io_out(pe_array_0_8_io_out)
  );
  SystolicPe pe_array_0_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_9_clock),
    .reset(pe_array_0_9_reset),
    .io_in_act(pe_array_0_9_io_in_act),
    .io_in_acc(pe_array_0_9_io_in_acc),
    .io_in_weight(pe_array_0_9_io_in_weight),
    .io_out(pe_array_0_9_io_out)
  );
  SystolicPe pe_array_0_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_10_clock),
    .reset(pe_array_0_10_reset),
    .io_in_act(pe_array_0_10_io_in_act),
    .io_in_acc(pe_array_0_10_io_in_acc),
    .io_in_weight(pe_array_0_10_io_in_weight),
    .io_out(pe_array_0_10_io_out)
  );
  SystolicPe pe_array_0_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_11_clock),
    .reset(pe_array_0_11_reset),
    .io_in_act(pe_array_0_11_io_in_act),
    .io_in_acc(pe_array_0_11_io_in_acc),
    .io_in_weight(pe_array_0_11_io_in_weight),
    .io_out(pe_array_0_11_io_out)
  );
  SystolicPe pe_array_0_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_12_clock),
    .reset(pe_array_0_12_reset),
    .io_in_act(pe_array_0_12_io_in_act),
    .io_in_acc(pe_array_0_12_io_in_acc),
    .io_in_weight(pe_array_0_12_io_in_weight),
    .io_out(pe_array_0_12_io_out)
  );
  SystolicPe pe_array_0_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_13_clock),
    .reset(pe_array_0_13_reset),
    .io_in_act(pe_array_0_13_io_in_act),
    .io_in_acc(pe_array_0_13_io_in_acc),
    .io_in_weight(pe_array_0_13_io_in_weight),
    .io_out(pe_array_0_13_io_out)
  );
  SystolicPe pe_array_0_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_14_clock),
    .reset(pe_array_0_14_reset),
    .io_in_act(pe_array_0_14_io_in_act),
    .io_in_acc(pe_array_0_14_io_in_acc),
    .io_in_weight(pe_array_0_14_io_in_weight),
    .io_out(pe_array_0_14_io_out)
  );
  SystolicPe pe_array_0_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_0_15_clock),
    .reset(pe_array_0_15_reset),
    .io_in_act(pe_array_0_15_io_in_act),
    .io_in_acc(pe_array_0_15_io_in_acc),
    .io_in_weight(pe_array_0_15_io_in_weight),
    .io_out(pe_array_0_15_io_out)
  );
  SystolicPe pe_array_1_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_0_clock),
    .reset(pe_array_1_0_reset),
    .io_in_act(pe_array_1_0_io_in_act),
    .io_in_acc(pe_array_1_0_io_in_acc),
    .io_in_weight(pe_array_1_0_io_in_weight),
    .io_out(pe_array_1_0_io_out)
  );
  SystolicPe pe_array_1_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_1_clock),
    .reset(pe_array_1_1_reset),
    .io_in_act(pe_array_1_1_io_in_act),
    .io_in_acc(pe_array_1_1_io_in_acc),
    .io_in_weight(pe_array_1_1_io_in_weight),
    .io_out(pe_array_1_1_io_out)
  );
  SystolicPe pe_array_1_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_2_clock),
    .reset(pe_array_1_2_reset),
    .io_in_act(pe_array_1_2_io_in_act),
    .io_in_acc(pe_array_1_2_io_in_acc),
    .io_in_weight(pe_array_1_2_io_in_weight),
    .io_out(pe_array_1_2_io_out)
  );
  SystolicPe pe_array_1_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_3_clock),
    .reset(pe_array_1_3_reset),
    .io_in_act(pe_array_1_3_io_in_act),
    .io_in_acc(pe_array_1_3_io_in_acc),
    .io_in_weight(pe_array_1_3_io_in_weight),
    .io_out(pe_array_1_3_io_out)
  );
  SystolicPe pe_array_1_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_4_clock),
    .reset(pe_array_1_4_reset),
    .io_in_act(pe_array_1_4_io_in_act),
    .io_in_acc(pe_array_1_4_io_in_acc),
    .io_in_weight(pe_array_1_4_io_in_weight),
    .io_out(pe_array_1_4_io_out)
  );
  SystolicPe pe_array_1_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_5_clock),
    .reset(pe_array_1_5_reset),
    .io_in_act(pe_array_1_5_io_in_act),
    .io_in_acc(pe_array_1_5_io_in_acc),
    .io_in_weight(pe_array_1_5_io_in_weight),
    .io_out(pe_array_1_5_io_out)
  );
  SystolicPe pe_array_1_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_6_clock),
    .reset(pe_array_1_6_reset),
    .io_in_act(pe_array_1_6_io_in_act),
    .io_in_acc(pe_array_1_6_io_in_acc),
    .io_in_weight(pe_array_1_6_io_in_weight),
    .io_out(pe_array_1_6_io_out)
  );
  SystolicPe pe_array_1_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_7_clock),
    .reset(pe_array_1_7_reset),
    .io_in_act(pe_array_1_7_io_in_act),
    .io_in_acc(pe_array_1_7_io_in_acc),
    .io_in_weight(pe_array_1_7_io_in_weight),
    .io_out(pe_array_1_7_io_out)
  );
  SystolicPe pe_array_1_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_8_clock),
    .reset(pe_array_1_8_reset),
    .io_in_act(pe_array_1_8_io_in_act),
    .io_in_acc(pe_array_1_8_io_in_acc),
    .io_in_weight(pe_array_1_8_io_in_weight),
    .io_out(pe_array_1_8_io_out)
  );
  SystolicPe pe_array_1_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_9_clock),
    .reset(pe_array_1_9_reset),
    .io_in_act(pe_array_1_9_io_in_act),
    .io_in_acc(pe_array_1_9_io_in_acc),
    .io_in_weight(pe_array_1_9_io_in_weight),
    .io_out(pe_array_1_9_io_out)
  );
  SystolicPe pe_array_1_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_10_clock),
    .reset(pe_array_1_10_reset),
    .io_in_act(pe_array_1_10_io_in_act),
    .io_in_acc(pe_array_1_10_io_in_acc),
    .io_in_weight(pe_array_1_10_io_in_weight),
    .io_out(pe_array_1_10_io_out)
  );
  SystolicPe pe_array_1_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_11_clock),
    .reset(pe_array_1_11_reset),
    .io_in_act(pe_array_1_11_io_in_act),
    .io_in_acc(pe_array_1_11_io_in_acc),
    .io_in_weight(pe_array_1_11_io_in_weight),
    .io_out(pe_array_1_11_io_out)
  );
  SystolicPe pe_array_1_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_12_clock),
    .reset(pe_array_1_12_reset),
    .io_in_act(pe_array_1_12_io_in_act),
    .io_in_acc(pe_array_1_12_io_in_acc),
    .io_in_weight(pe_array_1_12_io_in_weight),
    .io_out(pe_array_1_12_io_out)
  );
  SystolicPe pe_array_1_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_13_clock),
    .reset(pe_array_1_13_reset),
    .io_in_act(pe_array_1_13_io_in_act),
    .io_in_acc(pe_array_1_13_io_in_acc),
    .io_in_weight(pe_array_1_13_io_in_weight),
    .io_out(pe_array_1_13_io_out)
  );
  SystolicPe pe_array_1_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_14_clock),
    .reset(pe_array_1_14_reset),
    .io_in_act(pe_array_1_14_io_in_act),
    .io_in_acc(pe_array_1_14_io_in_acc),
    .io_in_weight(pe_array_1_14_io_in_weight),
    .io_out(pe_array_1_14_io_out)
  );
  SystolicPe pe_array_1_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_1_15_clock),
    .reset(pe_array_1_15_reset),
    .io_in_act(pe_array_1_15_io_in_act),
    .io_in_acc(pe_array_1_15_io_in_acc),
    .io_in_weight(pe_array_1_15_io_in_weight),
    .io_out(pe_array_1_15_io_out)
  );
  SystolicPe pe_array_2_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_0_clock),
    .reset(pe_array_2_0_reset),
    .io_in_act(pe_array_2_0_io_in_act),
    .io_in_acc(pe_array_2_0_io_in_acc),
    .io_in_weight(pe_array_2_0_io_in_weight),
    .io_out(pe_array_2_0_io_out)
  );
  SystolicPe pe_array_2_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_1_clock),
    .reset(pe_array_2_1_reset),
    .io_in_act(pe_array_2_1_io_in_act),
    .io_in_acc(pe_array_2_1_io_in_acc),
    .io_in_weight(pe_array_2_1_io_in_weight),
    .io_out(pe_array_2_1_io_out)
  );
  SystolicPe pe_array_2_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_2_clock),
    .reset(pe_array_2_2_reset),
    .io_in_act(pe_array_2_2_io_in_act),
    .io_in_acc(pe_array_2_2_io_in_acc),
    .io_in_weight(pe_array_2_2_io_in_weight),
    .io_out(pe_array_2_2_io_out)
  );
  SystolicPe pe_array_2_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_3_clock),
    .reset(pe_array_2_3_reset),
    .io_in_act(pe_array_2_3_io_in_act),
    .io_in_acc(pe_array_2_3_io_in_acc),
    .io_in_weight(pe_array_2_3_io_in_weight),
    .io_out(pe_array_2_3_io_out)
  );
  SystolicPe pe_array_2_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_4_clock),
    .reset(pe_array_2_4_reset),
    .io_in_act(pe_array_2_4_io_in_act),
    .io_in_acc(pe_array_2_4_io_in_acc),
    .io_in_weight(pe_array_2_4_io_in_weight),
    .io_out(pe_array_2_4_io_out)
  );
  SystolicPe pe_array_2_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_5_clock),
    .reset(pe_array_2_5_reset),
    .io_in_act(pe_array_2_5_io_in_act),
    .io_in_acc(pe_array_2_5_io_in_acc),
    .io_in_weight(pe_array_2_5_io_in_weight),
    .io_out(pe_array_2_5_io_out)
  );
  SystolicPe pe_array_2_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_6_clock),
    .reset(pe_array_2_6_reset),
    .io_in_act(pe_array_2_6_io_in_act),
    .io_in_acc(pe_array_2_6_io_in_acc),
    .io_in_weight(pe_array_2_6_io_in_weight),
    .io_out(pe_array_2_6_io_out)
  );
  SystolicPe pe_array_2_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_7_clock),
    .reset(pe_array_2_7_reset),
    .io_in_act(pe_array_2_7_io_in_act),
    .io_in_acc(pe_array_2_7_io_in_acc),
    .io_in_weight(pe_array_2_7_io_in_weight),
    .io_out(pe_array_2_7_io_out)
  );
  SystolicPe pe_array_2_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_8_clock),
    .reset(pe_array_2_8_reset),
    .io_in_act(pe_array_2_8_io_in_act),
    .io_in_acc(pe_array_2_8_io_in_acc),
    .io_in_weight(pe_array_2_8_io_in_weight),
    .io_out(pe_array_2_8_io_out)
  );
  SystolicPe pe_array_2_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_9_clock),
    .reset(pe_array_2_9_reset),
    .io_in_act(pe_array_2_9_io_in_act),
    .io_in_acc(pe_array_2_9_io_in_acc),
    .io_in_weight(pe_array_2_9_io_in_weight),
    .io_out(pe_array_2_9_io_out)
  );
  SystolicPe pe_array_2_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_10_clock),
    .reset(pe_array_2_10_reset),
    .io_in_act(pe_array_2_10_io_in_act),
    .io_in_acc(pe_array_2_10_io_in_acc),
    .io_in_weight(pe_array_2_10_io_in_weight),
    .io_out(pe_array_2_10_io_out)
  );
  SystolicPe pe_array_2_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_11_clock),
    .reset(pe_array_2_11_reset),
    .io_in_act(pe_array_2_11_io_in_act),
    .io_in_acc(pe_array_2_11_io_in_acc),
    .io_in_weight(pe_array_2_11_io_in_weight),
    .io_out(pe_array_2_11_io_out)
  );
  SystolicPe pe_array_2_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_12_clock),
    .reset(pe_array_2_12_reset),
    .io_in_act(pe_array_2_12_io_in_act),
    .io_in_acc(pe_array_2_12_io_in_acc),
    .io_in_weight(pe_array_2_12_io_in_weight),
    .io_out(pe_array_2_12_io_out)
  );
  SystolicPe pe_array_2_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_13_clock),
    .reset(pe_array_2_13_reset),
    .io_in_act(pe_array_2_13_io_in_act),
    .io_in_acc(pe_array_2_13_io_in_acc),
    .io_in_weight(pe_array_2_13_io_in_weight),
    .io_out(pe_array_2_13_io_out)
  );
  SystolicPe pe_array_2_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_14_clock),
    .reset(pe_array_2_14_reset),
    .io_in_act(pe_array_2_14_io_in_act),
    .io_in_acc(pe_array_2_14_io_in_acc),
    .io_in_weight(pe_array_2_14_io_in_weight),
    .io_out(pe_array_2_14_io_out)
  );
  SystolicPe pe_array_2_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_2_15_clock),
    .reset(pe_array_2_15_reset),
    .io_in_act(pe_array_2_15_io_in_act),
    .io_in_acc(pe_array_2_15_io_in_acc),
    .io_in_weight(pe_array_2_15_io_in_weight),
    .io_out(pe_array_2_15_io_out)
  );
  SystolicPe pe_array_3_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_0_clock),
    .reset(pe_array_3_0_reset),
    .io_in_act(pe_array_3_0_io_in_act),
    .io_in_acc(pe_array_3_0_io_in_acc),
    .io_in_weight(pe_array_3_0_io_in_weight),
    .io_out(pe_array_3_0_io_out)
  );
  SystolicPe pe_array_3_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_1_clock),
    .reset(pe_array_3_1_reset),
    .io_in_act(pe_array_3_1_io_in_act),
    .io_in_acc(pe_array_3_1_io_in_acc),
    .io_in_weight(pe_array_3_1_io_in_weight),
    .io_out(pe_array_3_1_io_out)
  );
  SystolicPe pe_array_3_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_2_clock),
    .reset(pe_array_3_2_reset),
    .io_in_act(pe_array_3_2_io_in_act),
    .io_in_acc(pe_array_3_2_io_in_acc),
    .io_in_weight(pe_array_3_2_io_in_weight),
    .io_out(pe_array_3_2_io_out)
  );
  SystolicPe pe_array_3_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_3_clock),
    .reset(pe_array_3_3_reset),
    .io_in_act(pe_array_3_3_io_in_act),
    .io_in_acc(pe_array_3_3_io_in_acc),
    .io_in_weight(pe_array_3_3_io_in_weight),
    .io_out(pe_array_3_3_io_out)
  );
  SystolicPe pe_array_3_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_4_clock),
    .reset(pe_array_3_4_reset),
    .io_in_act(pe_array_3_4_io_in_act),
    .io_in_acc(pe_array_3_4_io_in_acc),
    .io_in_weight(pe_array_3_4_io_in_weight),
    .io_out(pe_array_3_4_io_out)
  );
  SystolicPe pe_array_3_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_5_clock),
    .reset(pe_array_3_5_reset),
    .io_in_act(pe_array_3_5_io_in_act),
    .io_in_acc(pe_array_3_5_io_in_acc),
    .io_in_weight(pe_array_3_5_io_in_weight),
    .io_out(pe_array_3_5_io_out)
  );
  SystolicPe pe_array_3_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_6_clock),
    .reset(pe_array_3_6_reset),
    .io_in_act(pe_array_3_6_io_in_act),
    .io_in_acc(pe_array_3_6_io_in_acc),
    .io_in_weight(pe_array_3_6_io_in_weight),
    .io_out(pe_array_3_6_io_out)
  );
  SystolicPe pe_array_3_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_7_clock),
    .reset(pe_array_3_7_reset),
    .io_in_act(pe_array_3_7_io_in_act),
    .io_in_acc(pe_array_3_7_io_in_acc),
    .io_in_weight(pe_array_3_7_io_in_weight),
    .io_out(pe_array_3_7_io_out)
  );
  SystolicPe pe_array_3_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_8_clock),
    .reset(pe_array_3_8_reset),
    .io_in_act(pe_array_3_8_io_in_act),
    .io_in_acc(pe_array_3_8_io_in_acc),
    .io_in_weight(pe_array_3_8_io_in_weight),
    .io_out(pe_array_3_8_io_out)
  );
  SystolicPe pe_array_3_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_9_clock),
    .reset(pe_array_3_9_reset),
    .io_in_act(pe_array_3_9_io_in_act),
    .io_in_acc(pe_array_3_9_io_in_acc),
    .io_in_weight(pe_array_3_9_io_in_weight),
    .io_out(pe_array_3_9_io_out)
  );
  SystolicPe pe_array_3_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_10_clock),
    .reset(pe_array_3_10_reset),
    .io_in_act(pe_array_3_10_io_in_act),
    .io_in_acc(pe_array_3_10_io_in_acc),
    .io_in_weight(pe_array_3_10_io_in_weight),
    .io_out(pe_array_3_10_io_out)
  );
  SystolicPe pe_array_3_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_11_clock),
    .reset(pe_array_3_11_reset),
    .io_in_act(pe_array_3_11_io_in_act),
    .io_in_acc(pe_array_3_11_io_in_acc),
    .io_in_weight(pe_array_3_11_io_in_weight),
    .io_out(pe_array_3_11_io_out)
  );
  SystolicPe pe_array_3_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_12_clock),
    .reset(pe_array_3_12_reset),
    .io_in_act(pe_array_3_12_io_in_act),
    .io_in_acc(pe_array_3_12_io_in_acc),
    .io_in_weight(pe_array_3_12_io_in_weight),
    .io_out(pe_array_3_12_io_out)
  );
  SystolicPe pe_array_3_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_13_clock),
    .reset(pe_array_3_13_reset),
    .io_in_act(pe_array_3_13_io_in_act),
    .io_in_acc(pe_array_3_13_io_in_acc),
    .io_in_weight(pe_array_3_13_io_in_weight),
    .io_out(pe_array_3_13_io_out)
  );
  SystolicPe pe_array_3_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_14_clock),
    .reset(pe_array_3_14_reset),
    .io_in_act(pe_array_3_14_io_in_act),
    .io_in_acc(pe_array_3_14_io_in_acc),
    .io_in_weight(pe_array_3_14_io_in_weight),
    .io_out(pe_array_3_14_io_out)
  );
  SystolicPe pe_array_3_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_3_15_clock),
    .reset(pe_array_3_15_reset),
    .io_in_act(pe_array_3_15_io_in_act),
    .io_in_acc(pe_array_3_15_io_in_acc),
    .io_in_weight(pe_array_3_15_io_in_weight),
    .io_out(pe_array_3_15_io_out)
  );
  SystolicPe pe_array_4_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_0_clock),
    .reset(pe_array_4_0_reset),
    .io_in_act(pe_array_4_0_io_in_act),
    .io_in_acc(pe_array_4_0_io_in_acc),
    .io_in_weight(pe_array_4_0_io_in_weight),
    .io_out(pe_array_4_0_io_out)
  );
  SystolicPe pe_array_4_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_1_clock),
    .reset(pe_array_4_1_reset),
    .io_in_act(pe_array_4_1_io_in_act),
    .io_in_acc(pe_array_4_1_io_in_acc),
    .io_in_weight(pe_array_4_1_io_in_weight),
    .io_out(pe_array_4_1_io_out)
  );
  SystolicPe pe_array_4_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_2_clock),
    .reset(pe_array_4_2_reset),
    .io_in_act(pe_array_4_2_io_in_act),
    .io_in_acc(pe_array_4_2_io_in_acc),
    .io_in_weight(pe_array_4_2_io_in_weight),
    .io_out(pe_array_4_2_io_out)
  );
  SystolicPe pe_array_4_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_3_clock),
    .reset(pe_array_4_3_reset),
    .io_in_act(pe_array_4_3_io_in_act),
    .io_in_acc(pe_array_4_3_io_in_acc),
    .io_in_weight(pe_array_4_3_io_in_weight),
    .io_out(pe_array_4_3_io_out)
  );
  SystolicPe pe_array_4_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_4_clock),
    .reset(pe_array_4_4_reset),
    .io_in_act(pe_array_4_4_io_in_act),
    .io_in_acc(pe_array_4_4_io_in_acc),
    .io_in_weight(pe_array_4_4_io_in_weight),
    .io_out(pe_array_4_4_io_out)
  );
  SystolicPe pe_array_4_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_5_clock),
    .reset(pe_array_4_5_reset),
    .io_in_act(pe_array_4_5_io_in_act),
    .io_in_acc(pe_array_4_5_io_in_acc),
    .io_in_weight(pe_array_4_5_io_in_weight),
    .io_out(pe_array_4_5_io_out)
  );
  SystolicPe pe_array_4_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_6_clock),
    .reset(pe_array_4_6_reset),
    .io_in_act(pe_array_4_6_io_in_act),
    .io_in_acc(pe_array_4_6_io_in_acc),
    .io_in_weight(pe_array_4_6_io_in_weight),
    .io_out(pe_array_4_6_io_out)
  );
  SystolicPe pe_array_4_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_7_clock),
    .reset(pe_array_4_7_reset),
    .io_in_act(pe_array_4_7_io_in_act),
    .io_in_acc(pe_array_4_7_io_in_acc),
    .io_in_weight(pe_array_4_7_io_in_weight),
    .io_out(pe_array_4_7_io_out)
  );
  SystolicPe pe_array_4_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_8_clock),
    .reset(pe_array_4_8_reset),
    .io_in_act(pe_array_4_8_io_in_act),
    .io_in_acc(pe_array_4_8_io_in_acc),
    .io_in_weight(pe_array_4_8_io_in_weight),
    .io_out(pe_array_4_8_io_out)
  );
  SystolicPe pe_array_4_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_9_clock),
    .reset(pe_array_4_9_reset),
    .io_in_act(pe_array_4_9_io_in_act),
    .io_in_acc(pe_array_4_9_io_in_acc),
    .io_in_weight(pe_array_4_9_io_in_weight),
    .io_out(pe_array_4_9_io_out)
  );
  SystolicPe pe_array_4_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_10_clock),
    .reset(pe_array_4_10_reset),
    .io_in_act(pe_array_4_10_io_in_act),
    .io_in_acc(pe_array_4_10_io_in_acc),
    .io_in_weight(pe_array_4_10_io_in_weight),
    .io_out(pe_array_4_10_io_out)
  );
  SystolicPe pe_array_4_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_11_clock),
    .reset(pe_array_4_11_reset),
    .io_in_act(pe_array_4_11_io_in_act),
    .io_in_acc(pe_array_4_11_io_in_acc),
    .io_in_weight(pe_array_4_11_io_in_weight),
    .io_out(pe_array_4_11_io_out)
  );
  SystolicPe pe_array_4_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_12_clock),
    .reset(pe_array_4_12_reset),
    .io_in_act(pe_array_4_12_io_in_act),
    .io_in_acc(pe_array_4_12_io_in_acc),
    .io_in_weight(pe_array_4_12_io_in_weight),
    .io_out(pe_array_4_12_io_out)
  );
  SystolicPe pe_array_4_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_13_clock),
    .reset(pe_array_4_13_reset),
    .io_in_act(pe_array_4_13_io_in_act),
    .io_in_acc(pe_array_4_13_io_in_acc),
    .io_in_weight(pe_array_4_13_io_in_weight),
    .io_out(pe_array_4_13_io_out)
  );
  SystolicPe pe_array_4_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_14_clock),
    .reset(pe_array_4_14_reset),
    .io_in_act(pe_array_4_14_io_in_act),
    .io_in_acc(pe_array_4_14_io_in_acc),
    .io_in_weight(pe_array_4_14_io_in_weight),
    .io_out(pe_array_4_14_io_out)
  );
  SystolicPe pe_array_4_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_4_15_clock),
    .reset(pe_array_4_15_reset),
    .io_in_act(pe_array_4_15_io_in_act),
    .io_in_acc(pe_array_4_15_io_in_acc),
    .io_in_weight(pe_array_4_15_io_in_weight),
    .io_out(pe_array_4_15_io_out)
  );
  SystolicPe pe_array_5_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_0_clock),
    .reset(pe_array_5_0_reset),
    .io_in_act(pe_array_5_0_io_in_act),
    .io_in_acc(pe_array_5_0_io_in_acc),
    .io_in_weight(pe_array_5_0_io_in_weight),
    .io_out(pe_array_5_0_io_out)
  );
  SystolicPe pe_array_5_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_1_clock),
    .reset(pe_array_5_1_reset),
    .io_in_act(pe_array_5_1_io_in_act),
    .io_in_acc(pe_array_5_1_io_in_acc),
    .io_in_weight(pe_array_5_1_io_in_weight),
    .io_out(pe_array_5_1_io_out)
  );
  SystolicPe pe_array_5_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_2_clock),
    .reset(pe_array_5_2_reset),
    .io_in_act(pe_array_5_2_io_in_act),
    .io_in_acc(pe_array_5_2_io_in_acc),
    .io_in_weight(pe_array_5_2_io_in_weight),
    .io_out(pe_array_5_2_io_out)
  );
  SystolicPe pe_array_5_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_3_clock),
    .reset(pe_array_5_3_reset),
    .io_in_act(pe_array_5_3_io_in_act),
    .io_in_acc(pe_array_5_3_io_in_acc),
    .io_in_weight(pe_array_5_3_io_in_weight),
    .io_out(pe_array_5_3_io_out)
  );
  SystolicPe pe_array_5_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_4_clock),
    .reset(pe_array_5_4_reset),
    .io_in_act(pe_array_5_4_io_in_act),
    .io_in_acc(pe_array_5_4_io_in_acc),
    .io_in_weight(pe_array_5_4_io_in_weight),
    .io_out(pe_array_5_4_io_out)
  );
  SystolicPe pe_array_5_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_5_clock),
    .reset(pe_array_5_5_reset),
    .io_in_act(pe_array_5_5_io_in_act),
    .io_in_acc(pe_array_5_5_io_in_acc),
    .io_in_weight(pe_array_5_5_io_in_weight),
    .io_out(pe_array_5_5_io_out)
  );
  SystolicPe pe_array_5_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_6_clock),
    .reset(pe_array_5_6_reset),
    .io_in_act(pe_array_5_6_io_in_act),
    .io_in_acc(pe_array_5_6_io_in_acc),
    .io_in_weight(pe_array_5_6_io_in_weight),
    .io_out(pe_array_5_6_io_out)
  );
  SystolicPe pe_array_5_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_7_clock),
    .reset(pe_array_5_7_reset),
    .io_in_act(pe_array_5_7_io_in_act),
    .io_in_acc(pe_array_5_7_io_in_acc),
    .io_in_weight(pe_array_5_7_io_in_weight),
    .io_out(pe_array_5_7_io_out)
  );
  SystolicPe pe_array_5_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_8_clock),
    .reset(pe_array_5_8_reset),
    .io_in_act(pe_array_5_8_io_in_act),
    .io_in_acc(pe_array_5_8_io_in_acc),
    .io_in_weight(pe_array_5_8_io_in_weight),
    .io_out(pe_array_5_8_io_out)
  );
  SystolicPe pe_array_5_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_9_clock),
    .reset(pe_array_5_9_reset),
    .io_in_act(pe_array_5_9_io_in_act),
    .io_in_acc(pe_array_5_9_io_in_acc),
    .io_in_weight(pe_array_5_9_io_in_weight),
    .io_out(pe_array_5_9_io_out)
  );
  SystolicPe pe_array_5_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_10_clock),
    .reset(pe_array_5_10_reset),
    .io_in_act(pe_array_5_10_io_in_act),
    .io_in_acc(pe_array_5_10_io_in_acc),
    .io_in_weight(pe_array_5_10_io_in_weight),
    .io_out(pe_array_5_10_io_out)
  );
  SystolicPe pe_array_5_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_11_clock),
    .reset(pe_array_5_11_reset),
    .io_in_act(pe_array_5_11_io_in_act),
    .io_in_acc(pe_array_5_11_io_in_acc),
    .io_in_weight(pe_array_5_11_io_in_weight),
    .io_out(pe_array_5_11_io_out)
  );
  SystolicPe pe_array_5_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_12_clock),
    .reset(pe_array_5_12_reset),
    .io_in_act(pe_array_5_12_io_in_act),
    .io_in_acc(pe_array_5_12_io_in_acc),
    .io_in_weight(pe_array_5_12_io_in_weight),
    .io_out(pe_array_5_12_io_out)
  );
  SystolicPe pe_array_5_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_13_clock),
    .reset(pe_array_5_13_reset),
    .io_in_act(pe_array_5_13_io_in_act),
    .io_in_acc(pe_array_5_13_io_in_acc),
    .io_in_weight(pe_array_5_13_io_in_weight),
    .io_out(pe_array_5_13_io_out)
  );
  SystolicPe pe_array_5_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_14_clock),
    .reset(pe_array_5_14_reset),
    .io_in_act(pe_array_5_14_io_in_act),
    .io_in_acc(pe_array_5_14_io_in_acc),
    .io_in_weight(pe_array_5_14_io_in_weight),
    .io_out(pe_array_5_14_io_out)
  );
  SystolicPe pe_array_5_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_5_15_clock),
    .reset(pe_array_5_15_reset),
    .io_in_act(pe_array_5_15_io_in_act),
    .io_in_acc(pe_array_5_15_io_in_acc),
    .io_in_weight(pe_array_5_15_io_in_weight),
    .io_out(pe_array_5_15_io_out)
  );
  SystolicPe pe_array_6_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_0_clock),
    .reset(pe_array_6_0_reset),
    .io_in_act(pe_array_6_0_io_in_act),
    .io_in_acc(pe_array_6_0_io_in_acc),
    .io_in_weight(pe_array_6_0_io_in_weight),
    .io_out(pe_array_6_0_io_out)
  );
  SystolicPe pe_array_6_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_1_clock),
    .reset(pe_array_6_1_reset),
    .io_in_act(pe_array_6_1_io_in_act),
    .io_in_acc(pe_array_6_1_io_in_acc),
    .io_in_weight(pe_array_6_1_io_in_weight),
    .io_out(pe_array_6_1_io_out)
  );
  SystolicPe pe_array_6_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_2_clock),
    .reset(pe_array_6_2_reset),
    .io_in_act(pe_array_6_2_io_in_act),
    .io_in_acc(pe_array_6_2_io_in_acc),
    .io_in_weight(pe_array_6_2_io_in_weight),
    .io_out(pe_array_6_2_io_out)
  );
  SystolicPe pe_array_6_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_3_clock),
    .reset(pe_array_6_3_reset),
    .io_in_act(pe_array_6_3_io_in_act),
    .io_in_acc(pe_array_6_3_io_in_acc),
    .io_in_weight(pe_array_6_3_io_in_weight),
    .io_out(pe_array_6_3_io_out)
  );
  SystolicPe pe_array_6_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_4_clock),
    .reset(pe_array_6_4_reset),
    .io_in_act(pe_array_6_4_io_in_act),
    .io_in_acc(pe_array_6_4_io_in_acc),
    .io_in_weight(pe_array_6_4_io_in_weight),
    .io_out(pe_array_6_4_io_out)
  );
  SystolicPe pe_array_6_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_5_clock),
    .reset(pe_array_6_5_reset),
    .io_in_act(pe_array_6_5_io_in_act),
    .io_in_acc(pe_array_6_5_io_in_acc),
    .io_in_weight(pe_array_6_5_io_in_weight),
    .io_out(pe_array_6_5_io_out)
  );
  SystolicPe pe_array_6_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_6_clock),
    .reset(pe_array_6_6_reset),
    .io_in_act(pe_array_6_6_io_in_act),
    .io_in_acc(pe_array_6_6_io_in_acc),
    .io_in_weight(pe_array_6_6_io_in_weight),
    .io_out(pe_array_6_6_io_out)
  );
  SystolicPe pe_array_6_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_7_clock),
    .reset(pe_array_6_7_reset),
    .io_in_act(pe_array_6_7_io_in_act),
    .io_in_acc(pe_array_6_7_io_in_acc),
    .io_in_weight(pe_array_6_7_io_in_weight),
    .io_out(pe_array_6_7_io_out)
  );
  SystolicPe pe_array_6_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_8_clock),
    .reset(pe_array_6_8_reset),
    .io_in_act(pe_array_6_8_io_in_act),
    .io_in_acc(pe_array_6_8_io_in_acc),
    .io_in_weight(pe_array_6_8_io_in_weight),
    .io_out(pe_array_6_8_io_out)
  );
  SystolicPe pe_array_6_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_9_clock),
    .reset(pe_array_6_9_reset),
    .io_in_act(pe_array_6_9_io_in_act),
    .io_in_acc(pe_array_6_9_io_in_acc),
    .io_in_weight(pe_array_6_9_io_in_weight),
    .io_out(pe_array_6_9_io_out)
  );
  SystolicPe pe_array_6_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_10_clock),
    .reset(pe_array_6_10_reset),
    .io_in_act(pe_array_6_10_io_in_act),
    .io_in_acc(pe_array_6_10_io_in_acc),
    .io_in_weight(pe_array_6_10_io_in_weight),
    .io_out(pe_array_6_10_io_out)
  );
  SystolicPe pe_array_6_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_11_clock),
    .reset(pe_array_6_11_reset),
    .io_in_act(pe_array_6_11_io_in_act),
    .io_in_acc(pe_array_6_11_io_in_acc),
    .io_in_weight(pe_array_6_11_io_in_weight),
    .io_out(pe_array_6_11_io_out)
  );
  SystolicPe pe_array_6_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_12_clock),
    .reset(pe_array_6_12_reset),
    .io_in_act(pe_array_6_12_io_in_act),
    .io_in_acc(pe_array_6_12_io_in_acc),
    .io_in_weight(pe_array_6_12_io_in_weight),
    .io_out(pe_array_6_12_io_out)
  );
  SystolicPe pe_array_6_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_13_clock),
    .reset(pe_array_6_13_reset),
    .io_in_act(pe_array_6_13_io_in_act),
    .io_in_acc(pe_array_6_13_io_in_acc),
    .io_in_weight(pe_array_6_13_io_in_weight),
    .io_out(pe_array_6_13_io_out)
  );
  SystolicPe pe_array_6_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_14_clock),
    .reset(pe_array_6_14_reset),
    .io_in_act(pe_array_6_14_io_in_act),
    .io_in_acc(pe_array_6_14_io_in_acc),
    .io_in_weight(pe_array_6_14_io_in_weight),
    .io_out(pe_array_6_14_io_out)
  );
  SystolicPe pe_array_6_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_6_15_clock),
    .reset(pe_array_6_15_reset),
    .io_in_act(pe_array_6_15_io_in_act),
    .io_in_acc(pe_array_6_15_io_in_acc),
    .io_in_weight(pe_array_6_15_io_in_weight),
    .io_out(pe_array_6_15_io_out)
  );
  SystolicPe pe_array_7_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_0_clock),
    .reset(pe_array_7_0_reset),
    .io_in_act(pe_array_7_0_io_in_act),
    .io_in_acc(pe_array_7_0_io_in_acc),
    .io_in_weight(pe_array_7_0_io_in_weight),
    .io_out(pe_array_7_0_io_out)
  );
  SystolicPe pe_array_7_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_1_clock),
    .reset(pe_array_7_1_reset),
    .io_in_act(pe_array_7_1_io_in_act),
    .io_in_acc(pe_array_7_1_io_in_acc),
    .io_in_weight(pe_array_7_1_io_in_weight),
    .io_out(pe_array_7_1_io_out)
  );
  SystolicPe pe_array_7_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_2_clock),
    .reset(pe_array_7_2_reset),
    .io_in_act(pe_array_7_2_io_in_act),
    .io_in_acc(pe_array_7_2_io_in_acc),
    .io_in_weight(pe_array_7_2_io_in_weight),
    .io_out(pe_array_7_2_io_out)
  );
  SystolicPe pe_array_7_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_3_clock),
    .reset(pe_array_7_3_reset),
    .io_in_act(pe_array_7_3_io_in_act),
    .io_in_acc(pe_array_7_3_io_in_acc),
    .io_in_weight(pe_array_7_3_io_in_weight),
    .io_out(pe_array_7_3_io_out)
  );
  SystolicPe pe_array_7_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_4_clock),
    .reset(pe_array_7_4_reset),
    .io_in_act(pe_array_7_4_io_in_act),
    .io_in_acc(pe_array_7_4_io_in_acc),
    .io_in_weight(pe_array_7_4_io_in_weight),
    .io_out(pe_array_7_4_io_out)
  );
  SystolicPe pe_array_7_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_5_clock),
    .reset(pe_array_7_5_reset),
    .io_in_act(pe_array_7_5_io_in_act),
    .io_in_acc(pe_array_7_5_io_in_acc),
    .io_in_weight(pe_array_7_5_io_in_weight),
    .io_out(pe_array_7_5_io_out)
  );
  SystolicPe pe_array_7_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_6_clock),
    .reset(pe_array_7_6_reset),
    .io_in_act(pe_array_7_6_io_in_act),
    .io_in_acc(pe_array_7_6_io_in_acc),
    .io_in_weight(pe_array_7_6_io_in_weight),
    .io_out(pe_array_7_6_io_out)
  );
  SystolicPe pe_array_7_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_7_clock),
    .reset(pe_array_7_7_reset),
    .io_in_act(pe_array_7_7_io_in_act),
    .io_in_acc(pe_array_7_7_io_in_acc),
    .io_in_weight(pe_array_7_7_io_in_weight),
    .io_out(pe_array_7_7_io_out)
  );
  SystolicPe pe_array_7_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_8_clock),
    .reset(pe_array_7_8_reset),
    .io_in_act(pe_array_7_8_io_in_act),
    .io_in_acc(pe_array_7_8_io_in_acc),
    .io_in_weight(pe_array_7_8_io_in_weight),
    .io_out(pe_array_7_8_io_out)
  );
  SystolicPe pe_array_7_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_9_clock),
    .reset(pe_array_7_9_reset),
    .io_in_act(pe_array_7_9_io_in_act),
    .io_in_acc(pe_array_7_9_io_in_acc),
    .io_in_weight(pe_array_7_9_io_in_weight),
    .io_out(pe_array_7_9_io_out)
  );
  SystolicPe pe_array_7_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_10_clock),
    .reset(pe_array_7_10_reset),
    .io_in_act(pe_array_7_10_io_in_act),
    .io_in_acc(pe_array_7_10_io_in_acc),
    .io_in_weight(pe_array_7_10_io_in_weight),
    .io_out(pe_array_7_10_io_out)
  );
  SystolicPe pe_array_7_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_11_clock),
    .reset(pe_array_7_11_reset),
    .io_in_act(pe_array_7_11_io_in_act),
    .io_in_acc(pe_array_7_11_io_in_acc),
    .io_in_weight(pe_array_7_11_io_in_weight),
    .io_out(pe_array_7_11_io_out)
  );
  SystolicPe pe_array_7_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_12_clock),
    .reset(pe_array_7_12_reset),
    .io_in_act(pe_array_7_12_io_in_act),
    .io_in_acc(pe_array_7_12_io_in_acc),
    .io_in_weight(pe_array_7_12_io_in_weight),
    .io_out(pe_array_7_12_io_out)
  );
  SystolicPe pe_array_7_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_13_clock),
    .reset(pe_array_7_13_reset),
    .io_in_act(pe_array_7_13_io_in_act),
    .io_in_acc(pe_array_7_13_io_in_acc),
    .io_in_weight(pe_array_7_13_io_in_weight),
    .io_out(pe_array_7_13_io_out)
  );
  SystolicPe pe_array_7_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_14_clock),
    .reset(pe_array_7_14_reset),
    .io_in_act(pe_array_7_14_io_in_act),
    .io_in_acc(pe_array_7_14_io_in_acc),
    .io_in_weight(pe_array_7_14_io_in_weight),
    .io_out(pe_array_7_14_io_out)
  );
  SystolicPe pe_array_7_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_7_15_clock),
    .reset(pe_array_7_15_reset),
    .io_in_act(pe_array_7_15_io_in_act),
    .io_in_acc(pe_array_7_15_io_in_acc),
    .io_in_weight(pe_array_7_15_io_in_weight),
    .io_out(pe_array_7_15_io_out)
  );
  SystolicPe pe_array_8_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_0_clock),
    .reset(pe_array_8_0_reset),
    .io_in_act(pe_array_8_0_io_in_act),
    .io_in_acc(pe_array_8_0_io_in_acc),
    .io_in_weight(pe_array_8_0_io_in_weight),
    .io_out(pe_array_8_0_io_out)
  );
  SystolicPe pe_array_8_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_1_clock),
    .reset(pe_array_8_1_reset),
    .io_in_act(pe_array_8_1_io_in_act),
    .io_in_acc(pe_array_8_1_io_in_acc),
    .io_in_weight(pe_array_8_1_io_in_weight),
    .io_out(pe_array_8_1_io_out)
  );
  SystolicPe pe_array_8_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_2_clock),
    .reset(pe_array_8_2_reset),
    .io_in_act(pe_array_8_2_io_in_act),
    .io_in_acc(pe_array_8_2_io_in_acc),
    .io_in_weight(pe_array_8_2_io_in_weight),
    .io_out(pe_array_8_2_io_out)
  );
  SystolicPe pe_array_8_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_3_clock),
    .reset(pe_array_8_3_reset),
    .io_in_act(pe_array_8_3_io_in_act),
    .io_in_acc(pe_array_8_3_io_in_acc),
    .io_in_weight(pe_array_8_3_io_in_weight),
    .io_out(pe_array_8_3_io_out)
  );
  SystolicPe pe_array_8_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_4_clock),
    .reset(pe_array_8_4_reset),
    .io_in_act(pe_array_8_4_io_in_act),
    .io_in_acc(pe_array_8_4_io_in_acc),
    .io_in_weight(pe_array_8_4_io_in_weight),
    .io_out(pe_array_8_4_io_out)
  );
  SystolicPe pe_array_8_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_5_clock),
    .reset(pe_array_8_5_reset),
    .io_in_act(pe_array_8_5_io_in_act),
    .io_in_acc(pe_array_8_5_io_in_acc),
    .io_in_weight(pe_array_8_5_io_in_weight),
    .io_out(pe_array_8_5_io_out)
  );
  SystolicPe pe_array_8_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_6_clock),
    .reset(pe_array_8_6_reset),
    .io_in_act(pe_array_8_6_io_in_act),
    .io_in_acc(pe_array_8_6_io_in_acc),
    .io_in_weight(pe_array_8_6_io_in_weight),
    .io_out(pe_array_8_6_io_out)
  );
  SystolicPe pe_array_8_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_7_clock),
    .reset(pe_array_8_7_reset),
    .io_in_act(pe_array_8_7_io_in_act),
    .io_in_acc(pe_array_8_7_io_in_acc),
    .io_in_weight(pe_array_8_7_io_in_weight),
    .io_out(pe_array_8_7_io_out)
  );
  SystolicPe pe_array_8_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_8_clock),
    .reset(pe_array_8_8_reset),
    .io_in_act(pe_array_8_8_io_in_act),
    .io_in_acc(pe_array_8_8_io_in_acc),
    .io_in_weight(pe_array_8_8_io_in_weight),
    .io_out(pe_array_8_8_io_out)
  );
  SystolicPe pe_array_8_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_9_clock),
    .reset(pe_array_8_9_reset),
    .io_in_act(pe_array_8_9_io_in_act),
    .io_in_acc(pe_array_8_9_io_in_acc),
    .io_in_weight(pe_array_8_9_io_in_weight),
    .io_out(pe_array_8_9_io_out)
  );
  SystolicPe pe_array_8_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_10_clock),
    .reset(pe_array_8_10_reset),
    .io_in_act(pe_array_8_10_io_in_act),
    .io_in_acc(pe_array_8_10_io_in_acc),
    .io_in_weight(pe_array_8_10_io_in_weight),
    .io_out(pe_array_8_10_io_out)
  );
  SystolicPe pe_array_8_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_11_clock),
    .reset(pe_array_8_11_reset),
    .io_in_act(pe_array_8_11_io_in_act),
    .io_in_acc(pe_array_8_11_io_in_acc),
    .io_in_weight(pe_array_8_11_io_in_weight),
    .io_out(pe_array_8_11_io_out)
  );
  SystolicPe pe_array_8_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_12_clock),
    .reset(pe_array_8_12_reset),
    .io_in_act(pe_array_8_12_io_in_act),
    .io_in_acc(pe_array_8_12_io_in_acc),
    .io_in_weight(pe_array_8_12_io_in_weight),
    .io_out(pe_array_8_12_io_out)
  );
  SystolicPe pe_array_8_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_13_clock),
    .reset(pe_array_8_13_reset),
    .io_in_act(pe_array_8_13_io_in_act),
    .io_in_acc(pe_array_8_13_io_in_acc),
    .io_in_weight(pe_array_8_13_io_in_weight),
    .io_out(pe_array_8_13_io_out)
  );
  SystolicPe pe_array_8_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_14_clock),
    .reset(pe_array_8_14_reset),
    .io_in_act(pe_array_8_14_io_in_act),
    .io_in_acc(pe_array_8_14_io_in_acc),
    .io_in_weight(pe_array_8_14_io_in_weight),
    .io_out(pe_array_8_14_io_out)
  );
  SystolicPe pe_array_8_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_8_15_clock),
    .reset(pe_array_8_15_reset),
    .io_in_act(pe_array_8_15_io_in_act),
    .io_in_acc(pe_array_8_15_io_in_acc),
    .io_in_weight(pe_array_8_15_io_in_weight),
    .io_out(pe_array_8_15_io_out)
  );
  SystolicPe pe_array_9_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_0_clock),
    .reset(pe_array_9_0_reset),
    .io_in_act(pe_array_9_0_io_in_act),
    .io_in_acc(pe_array_9_0_io_in_acc),
    .io_in_weight(pe_array_9_0_io_in_weight),
    .io_out(pe_array_9_0_io_out)
  );
  SystolicPe pe_array_9_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_1_clock),
    .reset(pe_array_9_1_reset),
    .io_in_act(pe_array_9_1_io_in_act),
    .io_in_acc(pe_array_9_1_io_in_acc),
    .io_in_weight(pe_array_9_1_io_in_weight),
    .io_out(pe_array_9_1_io_out)
  );
  SystolicPe pe_array_9_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_2_clock),
    .reset(pe_array_9_2_reset),
    .io_in_act(pe_array_9_2_io_in_act),
    .io_in_acc(pe_array_9_2_io_in_acc),
    .io_in_weight(pe_array_9_2_io_in_weight),
    .io_out(pe_array_9_2_io_out)
  );
  SystolicPe pe_array_9_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_3_clock),
    .reset(pe_array_9_3_reset),
    .io_in_act(pe_array_9_3_io_in_act),
    .io_in_acc(pe_array_9_3_io_in_acc),
    .io_in_weight(pe_array_9_3_io_in_weight),
    .io_out(pe_array_9_3_io_out)
  );
  SystolicPe pe_array_9_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_4_clock),
    .reset(pe_array_9_4_reset),
    .io_in_act(pe_array_9_4_io_in_act),
    .io_in_acc(pe_array_9_4_io_in_acc),
    .io_in_weight(pe_array_9_4_io_in_weight),
    .io_out(pe_array_9_4_io_out)
  );
  SystolicPe pe_array_9_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_5_clock),
    .reset(pe_array_9_5_reset),
    .io_in_act(pe_array_9_5_io_in_act),
    .io_in_acc(pe_array_9_5_io_in_acc),
    .io_in_weight(pe_array_9_5_io_in_weight),
    .io_out(pe_array_9_5_io_out)
  );
  SystolicPe pe_array_9_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_6_clock),
    .reset(pe_array_9_6_reset),
    .io_in_act(pe_array_9_6_io_in_act),
    .io_in_acc(pe_array_9_6_io_in_acc),
    .io_in_weight(pe_array_9_6_io_in_weight),
    .io_out(pe_array_9_6_io_out)
  );
  SystolicPe pe_array_9_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_7_clock),
    .reset(pe_array_9_7_reset),
    .io_in_act(pe_array_9_7_io_in_act),
    .io_in_acc(pe_array_9_7_io_in_acc),
    .io_in_weight(pe_array_9_7_io_in_weight),
    .io_out(pe_array_9_7_io_out)
  );
  SystolicPe pe_array_9_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_8_clock),
    .reset(pe_array_9_8_reset),
    .io_in_act(pe_array_9_8_io_in_act),
    .io_in_acc(pe_array_9_8_io_in_acc),
    .io_in_weight(pe_array_9_8_io_in_weight),
    .io_out(pe_array_9_8_io_out)
  );
  SystolicPe pe_array_9_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_9_clock),
    .reset(pe_array_9_9_reset),
    .io_in_act(pe_array_9_9_io_in_act),
    .io_in_acc(pe_array_9_9_io_in_acc),
    .io_in_weight(pe_array_9_9_io_in_weight),
    .io_out(pe_array_9_9_io_out)
  );
  SystolicPe pe_array_9_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_10_clock),
    .reset(pe_array_9_10_reset),
    .io_in_act(pe_array_9_10_io_in_act),
    .io_in_acc(pe_array_9_10_io_in_acc),
    .io_in_weight(pe_array_9_10_io_in_weight),
    .io_out(pe_array_9_10_io_out)
  );
  SystolicPe pe_array_9_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_11_clock),
    .reset(pe_array_9_11_reset),
    .io_in_act(pe_array_9_11_io_in_act),
    .io_in_acc(pe_array_9_11_io_in_acc),
    .io_in_weight(pe_array_9_11_io_in_weight),
    .io_out(pe_array_9_11_io_out)
  );
  SystolicPe pe_array_9_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_12_clock),
    .reset(pe_array_9_12_reset),
    .io_in_act(pe_array_9_12_io_in_act),
    .io_in_acc(pe_array_9_12_io_in_acc),
    .io_in_weight(pe_array_9_12_io_in_weight),
    .io_out(pe_array_9_12_io_out)
  );
  SystolicPe pe_array_9_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_13_clock),
    .reset(pe_array_9_13_reset),
    .io_in_act(pe_array_9_13_io_in_act),
    .io_in_acc(pe_array_9_13_io_in_acc),
    .io_in_weight(pe_array_9_13_io_in_weight),
    .io_out(pe_array_9_13_io_out)
  );
  SystolicPe pe_array_9_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_14_clock),
    .reset(pe_array_9_14_reset),
    .io_in_act(pe_array_9_14_io_in_act),
    .io_in_acc(pe_array_9_14_io_in_acc),
    .io_in_weight(pe_array_9_14_io_in_weight),
    .io_out(pe_array_9_14_io_out)
  );
  SystolicPe pe_array_9_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_9_15_clock),
    .reset(pe_array_9_15_reset),
    .io_in_act(pe_array_9_15_io_in_act),
    .io_in_acc(pe_array_9_15_io_in_acc),
    .io_in_weight(pe_array_9_15_io_in_weight),
    .io_out(pe_array_9_15_io_out)
  );
  SystolicPe pe_array_10_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_0_clock),
    .reset(pe_array_10_0_reset),
    .io_in_act(pe_array_10_0_io_in_act),
    .io_in_acc(pe_array_10_0_io_in_acc),
    .io_in_weight(pe_array_10_0_io_in_weight),
    .io_out(pe_array_10_0_io_out)
  );
  SystolicPe pe_array_10_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_1_clock),
    .reset(pe_array_10_1_reset),
    .io_in_act(pe_array_10_1_io_in_act),
    .io_in_acc(pe_array_10_1_io_in_acc),
    .io_in_weight(pe_array_10_1_io_in_weight),
    .io_out(pe_array_10_1_io_out)
  );
  SystolicPe pe_array_10_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_2_clock),
    .reset(pe_array_10_2_reset),
    .io_in_act(pe_array_10_2_io_in_act),
    .io_in_acc(pe_array_10_2_io_in_acc),
    .io_in_weight(pe_array_10_2_io_in_weight),
    .io_out(pe_array_10_2_io_out)
  );
  SystolicPe pe_array_10_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_3_clock),
    .reset(pe_array_10_3_reset),
    .io_in_act(pe_array_10_3_io_in_act),
    .io_in_acc(pe_array_10_3_io_in_acc),
    .io_in_weight(pe_array_10_3_io_in_weight),
    .io_out(pe_array_10_3_io_out)
  );
  SystolicPe pe_array_10_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_4_clock),
    .reset(pe_array_10_4_reset),
    .io_in_act(pe_array_10_4_io_in_act),
    .io_in_acc(pe_array_10_4_io_in_acc),
    .io_in_weight(pe_array_10_4_io_in_weight),
    .io_out(pe_array_10_4_io_out)
  );
  SystolicPe pe_array_10_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_5_clock),
    .reset(pe_array_10_5_reset),
    .io_in_act(pe_array_10_5_io_in_act),
    .io_in_acc(pe_array_10_5_io_in_acc),
    .io_in_weight(pe_array_10_5_io_in_weight),
    .io_out(pe_array_10_5_io_out)
  );
  SystolicPe pe_array_10_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_6_clock),
    .reset(pe_array_10_6_reset),
    .io_in_act(pe_array_10_6_io_in_act),
    .io_in_acc(pe_array_10_6_io_in_acc),
    .io_in_weight(pe_array_10_6_io_in_weight),
    .io_out(pe_array_10_6_io_out)
  );
  SystolicPe pe_array_10_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_7_clock),
    .reset(pe_array_10_7_reset),
    .io_in_act(pe_array_10_7_io_in_act),
    .io_in_acc(pe_array_10_7_io_in_acc),
    .io_in_weight(pe_array_10_7_io_in_weight),
    .io_out(pe_array_10_7_io_out)
  );
  SystolicPe pe_array_10_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_8_clock),
    .reset(pe_array_10_8_reset),
    .io_in_act(pe_array_10_8_io_in_act),
    .io_in_acc(pe_array_10_8_io_in_acc),
    .io_in_weight(pe_array_10_8_io_in_weight),
    .io_out(pe_array_10_8_io_out)
  );
  SystolicPe pe_array_10_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_9_clock),
    .reset(pe_array_10_9_reset),
    .io_in_act(pe_array_10_9_io_in_act),
    .io_in_acc(pe_array_10_9_io_in_acc),
    .io_in_weight(pe_array_10_9_io_in_weight),
    .io_out(pe_array_10_9_io_out)
  );
  SystolicPe pe_array_10_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_10_clock),
    .reset(pe_array_10_10_reset),
    .io_in_act(pe_array_10_10_io_in_act),
    .io_in_acc(pe_array_10_10_io_in_acc),
    .io_in_weight(pe_array_10_10_io_in_weight),
    .io_out(pe_array_10_10_io_out)
  );
  SystolicPe pe_array_10_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_11_clock),
    .reset(pe_array_10_11_reset),
    .io_in_act(pe_array_10_11_io_in_act),
    .io_in_acc(pe_array_10_11_io_in_acc),
    .io_in_weight(pe_array_10_11_io_in_weight),
    .io_out(pe_array_10_11_io_out)
  );
  SystolicPe pe_array_10_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_12_clock),
    .reset(pe_array_10_12_reset),
    .io_in_act(pe_array_10_12_io_in_act),
    .io_in_acc(pe_array_10_12_io_in_acc),
    .io_in_weight(pe_array_10_12_io_in_weight),
    .io_out(pe_array_10_12_io_out)
  );
  SystolicPe pe_array_10_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_13_clock),
    .reset(pe_array_10_13_reset),
    .io_in_act(pe_array_10_13_io_in_act),
    .io_in_acc(pe_array_10_13_io_in_acc),
    .io_in_weight(pe_array_10_13_io_in_weight),
    .io_out(pe_array_10_13_io_out)
  );
  SystolicPe pe_array_10_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_14_clock),
    .reset(pe_array_10_14_reset),
    .io_in_act(pe_array_10_14_io_in_act),
    .io_in_acc(pe_array_10_14_io_in_acc),
    .io_in_weight(pe_array_10_14_io_in_weight),
    .io_out(pe_array_10_14_io_out)
  );
  SystolicPe pe_array_10_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_10_15_clock),
    .reset(pe_array_10_15_reset),
    .io_in_act(pe_array_10_15_io_in_act),
    .io_in_acc(pe_array_10_15_io_in_acc),
    .io_in_weight(pe_array_10_15_io_in_weight),
    .io_out(pe_array_10_15_io_out)
  );
  SystolicPe pe_array_11_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_0_clock),
    .reset(pe_array_11_0_reset),
    .io_in_act(pe_array_11_0_io_in_act),
    .io_in_acc(pe_array_11_0_io_in_acc),
    .io_in_weight(pe_array_11_0_io_in_weight),
    .io_out(pe_array_11_0_io_out)
  );
  SystolicPe pe_array_11_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_1_clock),
    .reset(pe_array_11_1_reset),
    .io_in_act(pe_array_11_1_io_in_act),
    .io_in_acc(pe_array_11_1_io_in_acc),
    .io_in_weight(pe_array_11_1_io_in_weight),
    .io_out(pe_array_11_1_io_out)
  );
  SystolicPe pe_array_11_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_2_clock),
    .reset(pe_array_11_2_reset),
    .io_in_act(pe_array_11_2_io_in_act),
    .io_in_acc(pe_array_11_2_io_in_acc),
    .io_in_weight(pe_array_11_2_io_in_weight),
    .io_out(pe_array_11_2_io_out)
  );
  SystolicPe pe_array_11_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_3_clock),
    .reset(pe_array_11_3_reset),
    .io_in_act(pe_array_11_3_io_in_act),
    .io_in_acc(pe_array_11_3_io_in_acc),
    .io_in_weight(pe_array_11_3_io_in_weight),
    .io_out(pe_array_11_3_io_out)
  );
  SystolicPe pe_array_11_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_4_clock),
    .reset(pe_array_11_4_reset),
    .io_in_act(pe_array_11_4_io_in_act),
    .io_in_acc(pe_array_11_4_io_in_acc),
    .io_in_weight(pe_array_11_4_io_in_weight),
    .io_out(pe_array_11_4_io_out)
  );
  SystolicPe pe_array_11_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_5_clock),
    .reset(pe_array_11_5_reset),
    .io_in_act(pe_array_11_5_io_in_act),
    .io_in_acc(pe_array_11_5_io_in_acc),
    .io_in_weight(pe_array_11_5_io_in_weight),
    .io_out(pe_array_11_5_io_out)
  );
  SystolicPe pe_array_11_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_6_clock),
    .reset(pe_array_11_6_reset),
    .io_in_act(pe_array_11_6_io_in_act),
    .io_in_acc(pe_array_11_6_io_in_acc),
    .io_in_weight(pe_array_11_6_io_in_weight),
    .io_out(pe_array_11_6_io_out)
  );
  SystolicPe pe_array_11_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_7_clock),
    .reset(pe_array_11_7_reset),
    .io_in_act(pe_array_11_7_io_in_act),
    .io_in_acc(pe_array_11_7_io_in_acc),
    .io_in_weight(pe_array_11_7_io_in_weight),
    .io_out(pe_array_11_7_io_out)
  );
  SystolicPe pe_array_11_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_8_clock),
    .reset(pe_array_11_8_reset),
    .io_in_act(pe_array_11_8_io_in_act),
    .io_in_acc(pe_array_11_8_io_in_acc),
    .io_in_weight(pe_array_11_8_io_in_weight),
    .io_out(pe_array_11_8_io_out)
  );
  SystolicPe pe_array_11_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_9_clock),
    .reset(pe_array_11_9_reset),
    .io_in_act(pe_array_11_9_io_in_act),
    .io_in_acc(pe_array_11_9_io_in_acc),
    .io_in_weight(pe_array_11_9_io_in_weight),
    .io_out(pe_array_11_9_io_out)
  );
  SystolicPe pe_array_11_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_10_clock),
    .reset(pe_array_11_10_reset),
    .io_in_act(pe_array_11_10_io_in_act),
    .io_in_acc(pe_array_11_10_io_in_acc),
    .io_in_weight(pe_array_11_10_io_in_weight),
    .io_out(pe_array_11_10_io_out)
  );
  SystolicPe pe_array_11_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_11_clock),
    .reset(pe_array_11_11_reset),
    .io_in_act(pe_array_11_11_io_in_act),
    .io_in_acc(pe_array_11_11_io_in_acc),
    .io_in_weight(pe_array_11_11_io_in_weight),
    .io_out(pe_array_11_11_io_out)
  );
  SystolicPe pe_array_11_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_12_clock),
    .reset(pe_array_11_12_reset),
    .io_in_act(pe_array_11_12_io_in_act),
    .io_in_acc(pe_array_11_12_io_in_acc),
    .io_in_weight(pe_array_11_12_io_in_weight),
    .io_out(pe_array_11_12_io_out)
  );
  SystolicPe pe_array_11_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_13_clock),
    .reset(pe_array_11_13_reset),
    .io_in_act(pe_array_11_13_io_in_act),
    .io_in_acc(pe_array_11_13_io_in_acc),
    .io_in_weight(pe_array_11_13_io_in_weight),
    .io_out(pe_array_11_13_io_out)
  );
  SystolicPe pe_array_11_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_14_clock),
    .reset(pe_array_11_14_reset),
    .io_in_act(pe_array_11_14_io_in_act),
    .io_in_acc(pe_array_11_14_io_in_acc),
    .io_in_weight(pe_array_11_14_io_in_weight),
    .io_out(pe_array_11_14_io_out)
  );
  SystolicPe pe_array_11_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_11_15_clock),
    .reset(pe_array_11_15_reset),
    .io_in_act(pe_array_11_15_io_in_act),
    .io_in_acc(pe_array_11_15_io_in_acc),
    .io_in_weight(pe_array_11_15_io_in_weight),
    .io_out(pe_array_11_15_io_out)
  );
  SystolicPe pe_array_12_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_0_clock),
    .reset(pe_array_12_0_reset),
    .io_in_act(pe_array_12_0_io_in_act),
    .io_in_acc(pe_array_12_0_io_in_acc),
    .io_in_weight(pe_array_12_0_io_in_weight),
    .io_out(pe_array_12_0_io_out)
  );
  SystolicPe pe_array_12_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_1_clock),
    .reset(pe_array_12_1_reset),
    .io_in_act(pe_array_12_1_io_in_act),
    .io_in_acc(pe_array_12_1_io_in_acc),
    .io_in_weight(pe_array_12_1_io_in_weight),
    .io_out(pe_array_12_1_io_out)
  );
  SystolicPe pe_array_12_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_2_clock),
    .reset(pe_array_12_2_reset),
    .io_in_act(pe_array_12_2_io_in_act),
    .io_in_acc(pe_array_12_2_io_in_acc),
    .io_in_weight(pe_array_12_2_io_in_weight),
    .io_out(pe_array_12_2_io_out)
  );
  SystolicPe pe_array_12_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_3_clock),
    .reset(pe_array_12_3_reset),
    .io_in_act(pe_array_12_3_io_in_act),
    .io_in_acc(pe_array_12_3_io_in_acc),
    .io_in_weight(pe_array_12_3_io_in_weight),
    .io_out(pe_array_12_3_io_out)
  );
  SystolicPe pe_array_12_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_4_clock),
    .reset(pe_array_12_4_reset),
    .io_in_act(pe_array_12_4_io_in_act),
    .io_in_acc(pe_array_12_4_io_in_acc),
    .io_in_weight(pe_array_12_4_io_in_weight),
    .io_out(pe_array_12_4_io_out)
  );
  SystolicPe pe_array_12_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_5_clock),
    .reset(pe_array_12_5_reset),
    .io_in_act(pe_array_12_5_io_in_act),
    .io_in_acc(pe_array_12_5_io_in_acc),
    .io_in_weight(pe_array_12_5_io_in_weight),
    .io_out(pe_array_12_5_io_out)
  );
  SystolicPe pe_array_12_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_6_clock),
    .reset(pe_array_12_6_reset),
    .io_in_act(pe_array_12_6_io_in_act),
    .io_in_acc(pe_array_12_6_io_in_acc),
    .io_in_weight(pe_array_12_6_io_in_weight),
    .io_out(pe_array_12_6_io_out)
  );
  SystolicPe pe_array_12_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_7_clock),
    .reset(pe_array_12_7_reset),
    .io_in_act(pe_array_12_7_io_in_act),
    .io_in_acc(pe_array_12_7_io_in_acc),
    .io_in_weight(pe_array_12_7_io_in_weight),
    .io_out(pe_array_12_7_io_out)
  );
  SystolicPe pe_array_12_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_8_clock),
    .reset(pe_array_12_8_reset),
    .io_in_act(pe_array_12_8_io_in_act),
    .io_in_acc(pe_array_12_8_io_in_acc),
    .io_in_weight(pe_array_12_8_io_in_weight),
    .io_out(pe_array_12_8_io_out)
  );
  SystolicPe pe_array_12_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_9_clock),
    .reset(pe_array_12_9_reset),
    .io_in_act(pe_array_12_9_io_in_act),
    .io_in_acc(pe_array_12_9_io_in_acc),
    .io_in_weight(pe_array_12_9_io_in_weight),
    .io_out(pe_array_12_9_io_out)
  );
  SystolicPe pe_array_12_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_10_clock),
    .reset(pe_array_12_10_reset),
    .io_in_act(pe_array_12_10_io_in_act),
    .io_in_acc(pe_array_12_10_io_in_acc),
    .io_in_weight(pe_array_12_10_io_in_weight),
    .io_out(pe_array_12_10_io_out)
  );
  SystolicPe pe_array_12_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_11_clock),
    .reset(pe_array_12_11_reset),
    .io_in_act(pe_array_12_11_io_in_act),
    .io_in_acc(pe_array_12_11_io_in_acc),
    .io_in_weight(pe_array_12_11_io_in_weight),
    .io_out(pe_array_12_11_io_out)
  );
  SystolicPe pe_array_12_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_12_clock),
    .reset(pe_array_12_12_reset),
    .io_in_act(pe_array_12_12_io_in_act),
    .io_in_acc(pe_array_12_12_io_in_acc),
    .io_in_weight(pe_array_12_12_io_in_weight),
    .io_out(pe_array_12_12_io_out)
  );
  SystolicPe pe_array_12_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_13_clock),
    .reset(pe_array_12_13_reset),
    .io_in_act(pe_array_12_13_io_in_act),
    .io_in_acc(pe_array_12_13_io_in_acc),
    .io_in_weight(pe_array_12_13_io_in_weight),
    .io_out(pe_array_12_13_io_out)
  );
  SystolicPe pe_array_12_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_14_clock),
    .reset(pe_array_12_14_reset),
    .io_in_act(pe_array_12_14_io_in_act),
    .io_in_acc(pe_array_12_14_io_in_acc),
    .io_in_weight(pe_array_12_14_io_in_weight),
    .io_out(pe_array_12_14_io_out)
  );
  SystolicPe pe_array_12_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_12_15_clock),
    .reset(pe_array_12_15_reset),
    .io_in_act(pe_array_12_15_io_in_act),
    .io_in_acc(pe_array_12_15_io_in_acc),
    .io_in_weight(pe_array_12_15_io_in_weight),
    .io_out(pe_array_12_15_io_out)
  );
  SystolicPe pe_array_13_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_0_clock),
    .reset(pe_array_13_0_reset),
    .io_in_act(pe_array_13_0_io_in_act),
    .io_in_acc(pe_array_13_0_io_in_acc),
    .io_in_weight(pe_array_13_0_io_in_weight),
    .io_out(pe_array_13_0_io_out)
  );
  SystolicPe pe_array_13_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_1_clock),
    .reset(pe_array_13_1_reset),
    .io_in_act(pe_array_13_1_io_in_act),
    .io_in_acc(pe_array_13_1_io_in_acc),
    .io_in_weight(pe_array_13_1_io_in_weight),
    .io_out(pe_array_13_1_io_out)
  );
  SystolicPe pe_array_13_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_2_clock),
    .reset(pe_array_13_2_reset),
    .io_in_act(pe_array_13_2_io_in_act),
    .io_in_acc(pe_array_13_2_io_in_acc),
    .io_in_weight(pe_array_13_2_io_in_weight),
    .io_out(pe_array_13_2_io_out)
  );
  SystolicPe pe_array_13_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_3_clock),
    .reset(pe_array_13_3_reset),
    .io_in_act(pe_array_13_3_io_in_act),
    .io_in_acc(pe_array_13_3_io_in_acc),
    .io_in_weight(pe_array_13_3_io_in_weight),
    .io_out(pe_array_13_3_io_out)
  );
  SystolicPe pe_array_13_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_4_clock),
    .reset(pe_array_13_4_reset),
    .io_in_act(pe_array_13_4_io_in_act),
    .io_in_acc(pe_array_13_4_io_in_acc),
    .io_in_weight(pe_array_13_4_io_in_weight),
    .io_out(pe_array_13_4_io_out)
  );
  SystolicPe pe_array_13_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_5_clock),
    .reset(pe_array_13_5_reset),
    .io_in_act(pe_array_13_5_io_in_act),
    .io_in_acc(pe_array_13_5_io_in_acc),
    .io_in_weight(pe_array_13_5_io_in_weight),
    .io_out(pe_array_13_5_io_out)
  );
  SystolicPe pe_array_13_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_6_clock),
    .reset(pe_array_13_6_reset),
    .io_in_act(pe_array_13_6_io_in_act),
    .io_in_acc(pe_array_13_6_io_in_acc),
    .io_in_weight(pe_array_13_6_io_in_weight),
    .io_out(pe_array_13_6_io_out)
  );
  SystolicPe pe_array_13_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_7_clock),
    .reset(pe_array_13_7_reset),
    .io_in_act(pe_array_13_7_io_in_act),
    .io_in_acc(pe_array_13_7_io_in_acc),
    .io_in_weight(pe_array_13_7_io_in_weight),
    .io_out(pe_array_13_7_io_out)
  );
  SystolicPe pe_array_13_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_8_clock),
    .reset(pe_array_13_8_reset),
    .io_in_act(pe_array_13_8_io_in_act),
    .io_in_acc(pe_array_13_8_io_in_acc),
    .io_in_weight(pe_array_13_8_io_in_weight),
    .io_out(pe_array_13_8_io_out)
  );
  SystolicPe pe_array_13_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_9_clock),
    .reset(pe_array_13_9_reset),
    .io_in_act(pe_array_13_9_io_in_act),
    .io_in_acc(pe_array_13_9_io_in_acc),
    .io_in_weight(pe_array_13_9_io_in_weight),
    .io_out(pe_array_13_9_io_out)
  );
  SystolicPe pe_array_13_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_10_clock),
    .reset(pe_array_13_10_reset),
    .io_in_act(pe_array_13_10_io_in_act),
    .io_in_acc(pe_array_13_10_io_in_acc),
    .io_in_weight(pe_array_13_10_io_in_weight),
    .io_out(pe_array_13_10_io_out)
  );
  SystolicPe pe_array_13_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_11_clock),
    .reset(pe_array_13_11_reset),
    .io_in_act(pe_array_13_11_io_in_act),
    .io_in_acc(pe_array_13_11_io_in_acc),
    .io_in_weight(pe_array_13_11_io_in_weight),
    .io_out(pe_array_13_11_io_out)
  );
  SystolicPe pe_array_13_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_12_clock),
    .reset(pe_array_13_12_reset),
    .io_in_act(pe_array_13_12_io_in_act),
    .io_in_acc(pe_array_13_12_io_in_acc),
    .io_in_weight(pe_array_13_12_io_in_weight),
    .io_out(pe_array_13_12_io_out)
  );
  SystolicPe pe_array_13_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_13_clock),
    .reset(pe_array_13_13_reset),
    .io_in_act(pe_array_13_13_io_in_act),
    .io_in_acc(pe_array_13_13_io_in_acc),
    .io_in_weight(pe_array_13_13_io_in_weight),
    .io_out(pe_array_13_13_io_out)
  );
  SystolicPe pe_array_13_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_14_clock),
    .reset(pe_array_13_14_reset),
    .io_in_act(pe_array_13_14_io_in_act),
    .io_in_acc(pe_array_13_14_io_in_acc),
    .io_in_weight(pe_array_13_14_io_in_weight),
    .io_out(pe_array_13_14_io_out)
  );
  SystolicPe pe_array_13_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_13_15_clock),
    .reset(pe_array_13_15_reset),
    .io_in_act(pe_array_13_15_io_in_act),
    .io_in_acc(pe_array_13_15_io_in_acc),
    .io_in_weight(pe_array_13_15_io_in_weight),
    .io_out(pe_array_13_15_io_out)
  );
  SystolicPe pe_array_14_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_0_clock),
    .reset(pe_array_14_0_reset),
    .io_in_act(pe_array_14_0_io_in_act),
    .io_in_acc(pe_array_14_0_io_in_acc),
    .io_in_weight(pe_array_14_0_io_in_weight),
    .io_out(pe_array_14_0_io_out)
  );
  SystolicPe pe_array_14_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_1_clock),
    .reset(pe_array_14_1_reset),
    .io_in_act(pe_array_14_1_io_in_act),
    .io_in_acc(pe_array_14_1_io_in_acc),
    .io_in_weight(pe_array_14_1_io_in_weight),
    .io_out(pe_array_14_1_io_out)
  );
  SystolicPe pe_array_14_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_2_clock),
    .reset(pe_array_14_2_reset),
    .io_in_act(pe_array_14_2_io_in_act),
    .io_in_acc(pe_array_14_2_io_in_acc),
    .io_in_weight(pe_array_14_2_io_in_weight),
    .io_out(pe_array_14_2_io_out)
  );
  SystolicPe pe_array_14_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_3_clock),
    .reset(pe_array_14_3_reset),
    .io_in_act(pe_array_14_3_io_in_act),
    .io_in_acc(pe_array_14_3_io_in_acc),
    .io_in_weight(pe_array_14_3_io_in_weight),
    .io_out(pe_array_14_3_io_out)
  );
  SystolicPe pe_array_14_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_4_clock),
    .reset(pe_array_14_4_reset),
    .io_in_act(pe_array_14_4_io_in_act),
    .io_in_acc(pe_array_14_4_io_in_acc),
    .io_in_weight(pe_array_14_4_io_in_weight),
    .io_out(pe_array_14_4_io_out)
  );
  SystolicPe pe_array_14_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_5_clock),
    .reset(pe_array_14_5_reset),
    .io_in_act(pe_array_14_5_io_in_act),
    .io_in_acc(pe_array_14_5_io_in_acc),
    .io_in_weight(pe_array_14_5_io_in_weight),
    .io_out(pe_array_14_5_io_out)
  );
  SystolicPe pe_array_14_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_6_clock),
    .reset(pe_array_14_6_reset),
    .io_in_act(pe_array_14_6_io_in_act),
    .io_in_acc(pe_array_14_6_io_in_acc),
    .io_in_weight(pe_array_14_6_io_in_weight),
    .io_out(pe_array_14_6_io_out)
  );
  SystolicPe pe_array_14_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_7_clock),
    .reset(pe_array_14_7_reset),
    .io_in_act(pe_array_14_7_io_in_act),
    .io_in_acc(pe_array_14_7_io_in_acc),
    .io_in_weight(pe_array_14_7_io_in_weight),
    .io_out(pe_array_14_7_io_out)
  );
  SystolicPe pe_array_14_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_8_clock),
    .reset(pe_array_14_8_reset),
    .io_in_act(pe_array_14_8_io_in_act),
    .io_in_acc(pe_array_14_8_io_in_acc),
    .io_in_weight(pe_array_14_8_io_in_weight),
    .io_out(pe_array_14_8_io_out)
  );
  SystolicPe pe_array_14_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_9_clock),
    .reset(pe_array_14_9_reset),
    .io_in_act(pe_array_14_9_io_in_act),
    .io_in_acc(pe_array_14_9_io_in_acc),
    .io_in_weight(pe_array_14_9_io_in_weight),
    .io_out(pe_array_14_9_io_out)
  );
  SystolicPe pe_array_14_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_10_clock),
    .reset(pe_array_14_10_reset),
    .io_in_act(pe_array_14_10_io_in_act),
    .io_in_acc(pe_array_14_10_io_in_acc),
    .io_in_weight(pe_array_14_10_io_in_weight),
    .io_out(pe_array_14_10_io_out)
  );
  SystolicPe pe_array_14_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_11_clock),
    .reset(pe_array_14_11_reset),
    .io_in_act(pe_array_14_11_io_in_act),
    .io_in_acc(pe_array_14_11_io_in_acc),
    .io_in_weight(pe_array_14_11_io_in_weight),
    .io_out(pe_array_14_11_io_out)
  );
  SystolicPe pe_array_14_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_12_clock),
    .reset(pe_array_14_12_reset),
    .io_in_act(pe_array_14_12_io_in_act),
    .io_in_acc(pe_array_14_12_io_in_acc),
    .io_in_weight(pe_array_14_12_io_in_weight),
    .io_out(pe_array_14_12_io_out)
  );
  SystolicPe pe_array_14_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_13_clock),
    .reset(pe_array_14_13_reset),
    .io_in_act(pe_array_14_13_io_in_act),
    .io_in_acc(pe_array_14_13_io_in_acc),
    .io_in_weight(pe_array_14_13_io_in_weight),
    .io_out(pe_array_14_13_io_out)
  );
  SystolicPe pe_array_14_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_14_clock),
    .reset(pe_array_14_14_reset),
    .io_in_act(pe_array_14_14_io_in_act),
    .io_in_acc(pe_array_14_14_io_in_acc),
    .io_in_weight(pe_array_14_14_io_in_weight),
    .io_out(pe_array_14_14_io_out)
  );
  SystolicPe pe_array_14_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_14_15_clock),
    .reset(pe_array_14_15_reset),
    .io_in_act(pe_array_14_15_io_in_act),
    .io_in_acc(pe_array_14_15_io_in_acc),
    .io_in_weight(pe_array_14_15_io_in_weight),
    .io_out(pe_array_14_15_io_out)
  );
  SystolicPe pe_array_15_0 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_0_clock),
    .reset(pe_array_15_0_reset),
    .io_in_act(pe_array_15_0_io_in_act),
    .io_in_acc(pe_array_15_0_io_in_acc),
    .io_in_weight(pe_array_15_0_io_in_weight),
    .io_out(pe_array_15_0_io_out)
  );
  SystolicPe pe_array_15_1 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_1_clock),
    .reset(pe_array_15_1_reset),
    .io_in_act(pe_array_15_1_io_in_act),
    .io_in_acc(pe_array_15_1_io_in_acc),
    .io_in_weight(pe_array_15_1_io_in_weight),
    .io_out(pe_array_15_1_io_out)
  );
  SystolicPe pe_array_15_2 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_2_clock),
    .reset(pe_array_15_2_reset),
    .io_in_act(pe_array_15_2_io_in_act),
    .io_in_acc(pe_array_15_2_io_in_acc),
    .io_in_weight(pe_array_15_2_io_in_weight),
    .io_out(pe_array_15_2_io_out)
  );
  SystolicPe pe_array_15_3 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_3_clock),
    .reset(pe_array_15_3_reset),
    .io_in_act(pe_array_15_3_io_in_act),
    .io_in_acc(pe_array_15_3_io_in_acc),
    .io_in_weight(pe_array_15_3_io_in_weight),
    .io_out(pe_array_15_3_io_out)
  );
  SystolicPe pe_array_15_4 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_4_clock),
    .reset(pe_array_15_4_reset),
    .io_in_act(pe_array_15_4_io_in_act),
    .io_in_acc(pe_array_15_4_io_in_acc),
    .io_in_weight(pe_array_15_4_io_in_weight),
    .io_out(pe_array_15_4_io_out)
  );
  SystolicPe pe_array_15_5 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_5_clock),
    .reset(pe_array_15_5_reset),
    .io_in_act(pe_array_15_5_io_in_act),
    .io_in_acc(pe_array_15_5_io_in_acc),
    .io_in_weight(pe_array_15_5_io_in_weight),
    .io_out(pe_array_15_5_io_out)
  );
  SystolicPe pe_array_15_6 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_6_clock),
    .reset(pe_array_15_6_reset),
    .io_in_act(pe_array_15_6_io_in_act),
    .io_in_acc(pe_array_15_6_io_in_acc),
    .io_in_weight(pe_array_15_6_io_in_weight),
    .io_out(pe_array_15_6_io_out)
  );
  SystolicPe pe_array_15_7 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_7_clock),
    .reset(pe_array_15_7_reset),
    .io_in_act(pe_array_15_7_io_in_act),
    .io_in_acc(pe_array_15_7_io_in_acc),
    .io_in_weight(pe_array_15_7_io_in_weight),
    .io_out(pe_array_15_7_io_out)
  );
  SystolicPe pe_array_15_8 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_8_clock),
    .reset(pe_array_15_8_reset),
    .io_in_act(pe_array_15_8_io_in_act),
    .io_in_acc(pe_array_15_8_io_in_acc),
    .io_in_weight(pe_array_15_8_io_in_weight),
    .io_out(pe_array_15_8_io_out)
  );
  SystolicPe pe_array_15_9 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_9_clock),
    .reset(pe_array_15_9_reset),
    .io_in_act(pe_array_15_9_io_in_act),
    .io_in_acc(pe_array_15_9_io_in_acc),
    .io_in_weight(pe_array_15_9_io_in_weight),
    .io_out(pe_array_15_9_io_out)
  );
  SystolicPe pe_array_15_10 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_10_clock),
    .reset(pe_array_15_10_reset),
    .io_in_act(pe_array_15_10_io_in_act),
    .io_in_acc(pe_array_15_10_io_in_acc),
    .io_in_weight(pe_array_15_10_io_in_weight),
    .io_out(pe_array_15_10_io_out)
  );
  SystolicPe pe_array_15_11 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_11_clock),
    .reset(pe_array_15_11_reset),
    .io_in_act(pe_array_15_11_io_in_act),
    .io_in_acc(pe_array_15_11_io_in_acc),
    .io_in_weight(pe_array_15_11_io_in_weight),
    .io_out(pe_array_15_11_io_out)
  );
  SystolicPe pe_array_15_12 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_12_clock),
    .reset(pe_array_15_12_reset),
    .io_in_act(pe_array_15_12_io_in_act),
    .io_in_acc(pe_array_15_12_io_in_acc),
    .io_in_weight(pe_array_15_12_io_in_weight),
    .io_out(pe_array_15_12_io_out)
  );
  SystolicPe pe_array_15_13 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_13_clock),
    .reset(pe_array_15_13_reset),
    .io_in_act(pe_array_15_13_io_in_act),
    .io_in_acc(pe_array_15_13_io_in_acc),
    .io_in_weight(pe_array_15_13_io_in_weight),
    .io_out(pe_array_15_13_io_out)
  );
  SystolicPe pe_array_15_14 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_14_clock),
    .reset(pe_array_15_14_reset),
    .io_in_act(pe_array_15_14_io_in_act),
    .io_in_acc(pe_array_15_14_io_in_acc),
    .io_in_weight(pe_array_15_14_io_in_weight),
    .io_out(pe_array_15_14_io_out)
  );
  SystolicPe pe_array_15_15 ( // @[ValExec_MulAddRecFN.scala 90:67]
    .clock(pe_array_15_15_clock),
    .reset(pe_array_15_15_reset),
    .io_in_act(pe_array_15_15_io_in_act),
    .io_in_acc(pe_array_15_15_io_in_acc),
    .io_in_weight(pe_array_15_15_io_in_weight),
    .io_out(pe_array_15_15_io_out)
  );
  assign io_out_0 = pe_array_15_0_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_1 = pe_array_15_1_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_2 = pe_array_15_2_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_3 = pe_array_15_3_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_4 = pe_array_15_4_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_5 = pe_array_15_5_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_6 = pe_array_15_6_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_7 = pe_array_15_7_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_8 = pe_array_15_8_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_9 = pe_array_15_9_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_10 = pe_array_15_10_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_11 = pe_array_15_11_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_12 = pe_array_15_12_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_13 = pe_array_15_13_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_14 = pe_array_15_14_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign io_out_15 = pe_array_15_15_io_out; // @[ValExec_MulAddRecFN.scala 120:19]
  assign pe_array_0_0_clock = clock;
  assign pe_array_0_0_reset = reset;
  assign pe_array_0_0_io_in_act = io_in_rows_0; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_0_0_io_in_acc = io_in_cols_0; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_0_io_in_weight = io_weight_0; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_1_clock = clock;
  assign pe_array_0_1_reset = reset;
  assign pe_array_0_1_io_in_act = pe_array_0_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_1_io_in_acc = io_in_cols_1; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_1_io_in_weight = io_weight_1; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_2_clock = clock;
  assign pe_array_0_2_reset = reset;
  assign pe_array_0_2_io_in_act = pe_array_0_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_2_io_in_acc = io_in_cols_2; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_2_io_in_weight = io_weight_2; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_3_clock = clock;
  assign pe_array_0_3_reset = reset;
  assign pe_array_0_3_io_in_act = pe_array_0_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_3_io_in_acc = io_in_cols_3; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_3_io_in_weight = io_weight_3; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_4_clock = clock;
  assign pe_array_0_4_reset = reset;
  assign pe_array_0_4_io_in_act = pe_array_0_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_4_io_in_acc = io_in_cols_4; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_4_io_in_weight = io_weight_4; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_5_clock = clock;
  assign pe_array_0_5_reset = reset;
  assign pe_array_0_5_io_in_act = pe_array_0_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_5_io_in_acc = io_in_cols_5; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_5_io_in_weight = io_weight_5; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_6_clock = clock;
  assign pe_array_0_6_reset = reset;
  assign pe_array_0_6_io_in_act = pe_array_0_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_6_io_in_acc = io_in_cols_6; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_6_io_in_weight = io_weight_6; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_7_clock = clock;
  assign pe_array_0_7_reset = reset;
  assign pe_array_0_7_io_in_act = pe_array_0_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_7_io_in_acc = io_in_cols_7; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_7_io_in_weight = io_weight_7; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_8_clock = clock;
  assign pe_array_0_8_reset = reset;
  assign pe_array_0_8_io_in_act = pe_array_0_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_8_io_in_acc = io_in_cols_8; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_8_io_in_weight = io_weight_8; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_9_clock = clock;
  assign pe_array_0_9_reset = reset;
  assign pe_array_0_9_io_in_act = pe_array_0_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_9_io_in_acc = io_in_cols_9; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_9_io_in_weight = io_weight_9; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_10_clock = clock;
  assign pe_array_0_10_reset = reset;
  assign pe_array_0_10_io_in_act = pe_array_0_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_10_io_in_acc = io_in_cols_10; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_10_io_in_weight = io_weight_10; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_11_clock = clock;
  assign pe_array_0_11_reset = reset;
  assign pe_array_0_11_io_in_act = pe_array_0_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_11_io_in_acc = io_in_cols_11; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_11_io_in_weight = io_weight_11; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_12_clock = clock;
  assign pe_array_0_12_reset = reset;
  assign pe_array_0_12_io_in_act = pe_array_0_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_12_io_in_acc = io_in_cols_12; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_12_io_in_weight = io_weight_12; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_13_clock = clock;
  assign pe_array_0_13_reset = reset;
  assign pe_array_0_13_io_in_act = pe_array_0_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_13_io_in_acc = io_in_cols_13; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_13_io_in_weight = io_weight_13; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_14_clock = clock;
  assign pe_array_0_14_reset = reset;
  assign pe_array_0_14_io_in_act = pe_array_0_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_14_io_in_acc = io_in_cols_14; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_14_io_in_weight = io_weight_14; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_0_15_clock = clock;
  assign pe_array_0_15_reset = reset;
  assign pe_array_0_15_io_in_act = pe_array_0_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_0_15_io_in_acc = io_in_cols_15; // @[ValExec_MulAddRecFN.scala 104:34]
  assign pe_array_0_15_io_in_weight = io_weight_15; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_0_clock = clock;
  assign pe_array_1_0_reset = reset;
  assign pe_array_1_0_io_in_act = io_in_rows_1; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_1_0_io_in_acc = pe_array_0_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_0_io_in_weight = io_weight_16; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_1_clock = clock;
  assign pe_array_1_1_reset = reset;
  assign pe_array_1_1_io_in_act = pe_array_1_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_1_io_in_acc = pe_array_0_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_1_io_in_weight = io_weight_17; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_2_clock = clock;
  assign pe_array_1_2_reset = reset;
  assign pe_array_1_2_io_in_act = pe_array_1_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_2_io_in_acc = pe_array_0_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_2_io_in_weight = io_weight_18; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_3_clock = clock;
  assign pe_array_1_3_reset = reset;
  assign pe_array_1_3_io_in_act = pe_array_1_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_3_io_in_acc = pe_array_0_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_3_io_in_weight = io_weight_19; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_4_clock = clock;
  assign pe_array_1_4_reset = reset;
  assign pe_array_1_4_io_in_act = pe_array_1_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_4_io_in_acc = pe_array_0_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_4_io_in_weight = io_weight_20; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_5_clock = clock;
  assign pe_array_1_5_reset = reset;
  assign pe_array_1_5_io_in_act = pe_array_1_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_5_io_in_acc = pe_array_0_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_5_io_in_weight = io_weight_21; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_6_clock = clock;
  assign pe_array_1_6_reset = reset;
  assign pe_array_1_6_io_in_act = pe_array_1_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_6_io_in_acc = pe_array_0_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_6_io_in_weight = io_weight_22; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_7_clock = clock;
  assign pe_array_1_7_reset = reset;
  assign pe_array_1_7_io_in_act = pe_array_1_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_7_io_in_acc = pe_array_0_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_7_io_in_weight = io_weight_23; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_8_clock = clock;
  assign pe_array_1_8_reset = reset;
  assign pe_array_1_8_io_in_act = pe_array_1_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_8_io_in_acc = pe_array_0_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_8_io_in_weight = io_weight_24; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_9_clock = clock;
  assign pe_array_1_9_reset = reset;
  assign pe_array_1_9_io_in_act = pe_array_1_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_9_io_in_acc = pe_array_0_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_9_io_in_weight = io_weight_25; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_10_clock = clock;
  assign pe_array_1_10_reset = reset;
  assign pe_array_1_10_io_in_act = pe_array_1_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_10_io_in_acc = pe_array_0_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_10_io_in_weight = io_weight_26; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_11_clock = clock;
  assign pe_array_1_11_reset = reset;
  assign pe_array_1_11_io_in_act = pe_array_1_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_11_io_in_acc = pe_array_0_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_11_io_in_weight = io_weight_27; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_12_clock = clock;
  assign pe_array_1_12_reset = reset;
  assign pe_array_1_12_io_in_act = pe_array_1_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_12_io_in_acc = pe_array_0_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_12_io_in_weight = io_weight_28; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_13_clock = clock;
  assign pe_array_1_13_reset = reset;
  assign pe_array_1_13_io_in_act = pe_array_1_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_13_io_in_acc = pe_array_0_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_13_io_in_weight = io_weight_29; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_14_clock = clock;
  assign pe_array_1_14_reset = reset;
  assign pe_array_1_14_io_in_act = pe_array_1_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_14_io_in_acc = pe_array_0_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_14_io_in_weight = io_weight_30; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_1_15_clock = clock;
  assign pe_array_1_15_reset = reset;
  assign pe_array_1_15_io_in_act = pe_array_1_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_1_15_io_in_acc = pe_array_0_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_1_15_io_in_weight = io_weight_31; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_0_clock = clock;
  assign pe_array_2_0_reset = reset;
  assign pe_array_2_0_io_in_act = io_in_rows_2; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_2_0_io_in_acc = pe_array_1_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_0_io_in_weight = io_weight_32; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_1_clock = clock;
  assign pe_array_2_1_reset = reset;
  assign pe_array_2_1_io_in_act = pe_array_2_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_1_io_in_acc = pe_array_1_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_1_io_in_weight = io_weight_33; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_2_clock = clock;
  assign pe_array_2_2_reset = reset;
  assign pe_array_2_2_io_in_act = pe_array_2_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_2_io_in_acc = pe_array_1_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_2_io_in_weight = io_weight_34; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_3_clock = clock;
  assign pe_array_2_3_reset = reset;
  assign pe_array_2_3_io_in_act = pe_array_2_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_3_io_in_acc = pe_array_1_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_3_io_in_weight = io_weight_35; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_4_clock = clock;
  assign pe_array_2_4_reset = reset;
  assign pe_array_2_4_io_in_act = pe_array_2_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_4_io_in_acc = pe_array_1_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_4_io_in_weight = io_weight_36; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_5_clock = clock;
  assign pe_array_2_5_reset = reset;
  assign pe_array_2_5_io_in_act = pe_array_2_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_5_io_in_acc = pe_array_1_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_5_io_in_weight = io_weight_37; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_6_clock = clock;
  assign pe_array_2_6_reset = reset;
  assign pe_array_2_6_io_in_act = pe_array_2_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_6_io_in_acc = pe_array_1_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_6_io_in_weight = io_weight_38; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_7_clock = clock;
  assign pe_array_2_7_reset = reset;
  assign pe_array_2_7_io_in_act = pe_array_2_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_7_io_in_acc = pe_array_1_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_7_io_in_weight = io_weight_39; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_8_clock = clock;
  assign pe_array_2_8_reset = reset;
  assign pe_array_2_8_io_in_act = pe_array_2_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_8_io_in_acc = pe_array_1_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_8_io_in_weight = io_weight_40; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_9_clock = clock;
  assign pe_array_2_9_reset = reset;
  assign pe_array_2_9_io_in_act = pe_array_2_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_9_io_in_acc = pe_array_1_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_9_io_in_weight = io_weight_41; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_10_clock = clock;
  assign pe_array_2_10_reset = reset;
  assign pe_array_2_10_io_in_act = pe_array_2_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_10_io_in_acc = pe_array_1_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_10_io_in_weight = io_weight_42; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_11_clock = clock;
  assign pe_array_2_11_reset = reset;
  assign pe_array_2_11_io_in_act = pe_array_2_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_11_io_in_acc = pe_array_1_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_11_io_in_weight = io_weight_43; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_12_clock = clock;
  assign pe_array_2_12_reset = reset;
  assign pe_array_2_12_io_in_act = pe_array_2_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_12_io_in_acc = pe_array_1_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_12_io_in_weight = io_weight_44; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_13_clock = clock;
  assign pe_array_2_13_reset = reset;
  assign pe_array_2_13_io_in_act = pe_array_2_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_13_io_in_acc = pe_array_1_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_13_io_in_weight = io_weight_45; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_14_clock = clock;
  assign pe_array_2_14_reset = reset;
  assign pe_array_2_14_io_in_act = pe_array_2_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_14_io_in_acc = pe_array_1_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_14_io_in_weight = io_weight_46; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_2_15_clock = clock;
  assign pe_array_2_15_reset = reset;
  assign pe_array_2_15_io_in_act = pe_array_2_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_2_15_io_in_acc = pe_array_1_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_2_15_io_in_weight = io_weight_47; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_0_clock = clock;
  assign pe_array_3_0_reset = reset;
  assign pe_array_3_0_io_in_act = io_in_rows_3; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_3_0_io_in_acc = pe_array_2_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_0_io_in_weight = io_weight_48; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_1_clock = clock;
  assign pe_array_3_1_reset = reset;
  assign pe_array_3_1_io_in_act = pe_array_3_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_1_io_in_acc = pe_array_2_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_1_io_in_weight = io_weight_49; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_2_clock = clock;
  assign pe_array_3_2_reset = reset;
  assign pe_array_3_2_io_in_act = pe_array_3_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_2_io_in_acc = pe_array_2_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_2_io_in_weight = io_weight_50; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_3_clock = clock;
  assign pe_array_3_3_reset = reset;
  assign pe_array_3_3_io_in_act = pe_array_3_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_3_io_in_acc = pe_array_2_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_3_io_in_weight = io_weight_51; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_4_clock = clock;
  assign pe_array_3_4_reset = reset;
  assign pe_array_3_4_io_in_act = pe_array_3_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_4_io_in_acc = pe_array_2_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_4_io_in_weight = io_weight_52; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_5_clock = clock;
  assign pe_array_3_5_reset = reset;
  assign pe_array_3_5_io_in_act = pe_array_3_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_5_io_in_acc = pe_array_2_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_5_io_in_weight = io_weight_53; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_6_clock = clock;
  assign pe_array_3_6_reset = reset;
  assign pe_array_3_6_io_in_act = pe_array_3_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_6_io_in_acc = pe_array_2_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_6_io_in_weight = io_weight_54; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_7_clock = clock;
  assign pe_array_3_7_reset = reset;
  assign pe_array_3_7_io_in_act = pe_array_3_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_7_io_in_acc = pe_array_2_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_7_io_in_weight = io_weight_55; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_8_clock = clock;
  assign pe_array_3_8_reset = reset;
  assign pe_array_3_8_io_in_act = pe_array_3_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_8_io_in_acc = pe_array_2_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_8_io_in_weight = io_weight_56; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_9_clock = clock;
  assign pe_array_3_9_reset = reset;
  assign pe_array_3_9_io_in_act = pe_array_3_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_9_io_in_acc = pe_array_2_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_9_io_in_weight = io_weight_57; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_10_clock = clock;
  assign pe_array_3_10_reset = reset;
  assign pe_array_3_10_io_in_act = pe_array_3_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_10_io_in_acc = pe_array_2_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_10_io_in_weight = io_weight_58; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_11_clock = clock;
  assign pe_array_3_11_reset = reset;
  assign pe_array_3_11_io_in_act = pe_array_3_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_11_io_in_acc = pe_array_2_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_11_io_in_weight = io_weight_59; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_12_clock = clock;
  assign pe_array_3_12_reset = reset;
  assign pe_array_3_12_io_in_act = pe_array_3_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_12_io_in_acc = pe_array_2_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_12_io_in_weight = io_weight_60; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_13_clock = clock;
  assign pe_array_3_13_reset = reset;
  assign pe_array_3_13_io_in_act = pe_array_3_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_13_io_in_acc = pe_array_2_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_13_io_in_weight = io_weight_61; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_14_clock = clock;
  assign pe_array_3_14_reset = reset;
  assign pe_array_3_14_io_in_act = pe_array_3_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_14_io_in_acc = pe_array_2_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_14_io_in_weight = io_weight_62; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_3_15_clock = clock;
  assign pe_array_3_15_reset = reset;
  assign pe_array_3_15_io_in_act = pe_array_3_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_3_15_io_in_acc = pe_array_2_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_3_15_io_in_weight = io_weight_63; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_0_clock = clock;
  assign pe_array_4_0_reset = reset;
  assign pe_array_4_0_io_in_act = io_in_rows_4; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_4_0_io_in_acc = pe_array_3_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_0_io_in_weight = io_weight_64; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_1_clock = clock;
  assign pe_array_4_1_reset = reset;
  assign pe_array_4_1_io_in_act = pe_array_4_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_1_io_in_acc = pe_array_3_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_1_io_in_weight = io_weight_65; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_2_clock = clock;
  assign pe_array_4_2_reset = reset;
  assign pe_array_4_2_io_in_act = pe_array_4_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_2_io_in_acc = pe_array_3_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_2_io_in_weight = io_weight_66; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_3_clock = clock;
  assign pe_array_4_3_reset = reset;
  assign pe_array_4_3_io_in_act = pe_array_4_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_3_io_in_acc = pe_array_3_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_3_io_in_weight = io_weight_67; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_4_clock = clock;
  assign pe_array_4_4_reset = reset;
  assign pe_array_4_4_io_in_act = pe_array_4_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_4_io_in_acc = pe_array_3_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_4_io_in_weight = io_weight_68; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_5_clock = clock;
  assign pe_array_4_5_reset = reset;
  assign pe_array_4_5_io_in_act = pe_array_4_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_5_io_in_acc = pe_array_3_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_5_io_in_weight = io_weight_69; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_6_clock = clock;
  assign pe_array_4_6_reset = reset;
  assign pe_array_4_6_io_in_act = pe_array_4_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_6_io_in_acc = pe_array_3_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_6_io_in_weight = io_weight_70; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_7_clock = clock;
  assign pe_array_4_7_reset = reset;
  assign pe_array_4_7_io_in_act = pe_array_4_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_7_io_in_acc = pe_array_3_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_7_io_in_weight = io_weight_71; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_8_clock = clock;
  assign pe_array_4_8_reset = reset;
  assign pe_array_4_8_io_in_act = pe_array_4_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_8_io_in_acc = pe_array_3_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_8_io_in_weight = io_weight_72; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_9_clock = clock;
  assign pe_array_4_9_reset = reset;
  assign pe_array_4_9_io_in_act = pe_array_4_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_9_io_in_acc = pe_array_3_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_9_io_in_weight = io_weight_73; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_10_clock = clock;
  assign pe_array_4_10_reset = reset;
  assign pe_array_4_10_io_in_act = pe_array_4_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_10_io_in_acc = pe_array_3_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_10_io_in_weight = io_weight_74; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_11_clock = clock;
  assign pe_array_4_11_reset = reset;
  assign pe_array_4_11_io_in_act = pe_array_4_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_11_io_in_acc = pe_array_3_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_11_io_in_weight = io_weight_75; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_12_clock = clock;
  assign pe_array_4_12_reset = reset;
  assign pe_array_4_12_io_in_act = pe_array_4_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_12_io_in_acc = pe_array_3_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_12_io_in_weight = io_weight_76; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_13_clock = clock;
  assign pe_array_4_13_reset = reset;
  assign pe_array_4_13_io_in_act = pe_array_4_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_13_io_in_acc = pe_array_3_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_13_io_in_weight = io_weight_77; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_14_clock = clock;
  assign pe_array_4_14_reset = reset;
  assign pe_array_4_14_io_in_act = pe_array_4_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_14_io_in_acc = pe_array_3_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_14_io_in_weight = io_weight_78; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_4_15_clock = clock;
  assign pe_array_4_15_reset = reset;
  assign pe_array_4_15_io_in_act = pe_array_4_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_4_15_io_in_acc = pe_array_3_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_4_15_io_in_weight = io_weight_79; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_0_clock = clock;
  assign pe_array_5_0_reset = reset;
  assign pe_array_5_0_io_in_act = io_in_rows_5; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_5_0_io_in_acc = pe_array_4_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_0_io_in_weight = io_weight_80; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_1_clock = clock;
  assign pe_array_5_1_reset = reset;
  assign pe_array_5_1_io_in_act = pe_array_5_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_1_io_in_acc = pe_array_4_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_1_io_in_weight = io_weight_81; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_2_clock = clock;
  assign pe_array_5_2_reset = reset;
  assign pe_array_5_2_io_in_act = pe_array_5_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_2_io_in_acc = pe_array_4_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_2_io_in_weight = io_weight_82; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_3_clock = clock;
  assign pe_array_5_3_reset = reset;
  assign pe_array_5_3_io_in_act = pe_array_5_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_3_io_in_acc = pe_array_4_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_3_io_in_weight = io_weight_83; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_4_clock = clock;
  assign pe_array_5_4_reset = reset;
  assign pe_array_5_4_io_in_act = pe_array_5_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_4_io_in_acc = pe_array_4_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_4_io_in_weight = io_weight_84; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_5_clock = clock;
  assign pe_array_5_5_reset = reset;
  assign pe_array_5_5_io_in_act = pe_array_5_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_5_io_in_acc = pe_array_4_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_5_io_in_weight = io_weight_85; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_6_clock = clock;
  assign pe_array_5_6_reset = reset;
  assign pe_array_5_6_io_in_act = pe_array_5_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_6_io_in_acc = pe_array_4_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_6_io_in_weight = io_weight_86; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_7_clock = clock;
  assign pe_array_5_7_reset = reset;
  assign pe_array_5_7_io_in_act = pe_array_5_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_7_io_in_acc = pe_array_4_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_7_io_in_weight = io_weight_87; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_8_clock = clock;
  assign pe_array_5_8_reset = reset;
  assign pe_array_5_8_io_in_act = pe_array_5_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_8_io_in_acc = pe_array_4_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_8_io_in_weight = io_weight_88; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_9_clock = clock;
  assign pe_array_5_9_reset = reset;
  assign pe_array_5_9_io_in_act = pe_array_5_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_9_io_in_acc = pe_array_4_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_9_io_in_weight = io_weight_89; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_10_clock = clock;
  assign pe_array_5_10_reset = reset;
  assign pe_array_5_10_io_in_act = pe_array_5_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_10_io_in_acc = pe_array_4_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_10_io_in_weight = io_weight_90; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_11_clock = clock;
  assign pe_array_5_11_reset = reset;
  assign pe_array_5_11_io_in_act = pe_array_5_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_11_io_in_acc = pe_array_4_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_11_io_in_weight = io_weight_91; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_12_clock = clock;
  assign pe_array_5_12_reset = reset;
  assign pe_array_5_12_io_in_act = pe_array_5_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_12_io_in_acc = pe_array_4_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_12_io_in_weight = io_weight_92; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_13_clock = clock;
  assign pe_array_5_13_reset = reset;
  assign pe_array_5_13_io_in_act = pe_array_5_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_13_io_in_acc = pe_array_4_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_13_io_in_weight = io_weight_93; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_14_clock = clock;
  assign pe_array_5_14_reset = reset;
  assign pe_array_5_14_io_in_act = pe_array_5_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_14_io_in_acc = pe_array_4_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_14_io_in_weight = io_weight_94; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_5_15_clock = clock;
  assign pe_array_5_15_reset = reset;
  assign pe_array_5_15_io_in_act = pe_array_5_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_5_15_io_in_acc = pe_array_4_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_5_15_io_in_weight = io_weight_95; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_0_clock = clock;
  assign pe_array_6_0_reset = reset;
  assign pe_array_6_0_io_in_act = io_in_rows_6; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_6_0_io_in_acc = pe_array_5_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_0_io_in_weight = io_weight_96; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_1_clock = clock;
  assign pe_array_6_1_reset = reset;
  assign pe_array_6_1_io_in_act = pe_array_6_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_1_io_in_acc = pe_array_5_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_1_io_in_weight = io_weight_97; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_2_clock = clock;
  assign pe_array_6_2_reset = reset;
  assign pe_array_6_2_io_in_act = pe_array_6_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_2_io_in_acc = pe_array_5_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_2_io_in_weight = io_weight_98; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_3_clock = clock;
  assign pe_array_6_3_reset = reset;
  assign pe_array_6_3_io_in_act = pe_array_6_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_3_io_in_acc = pe_array_5_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_3_io_in_weight = io_weight_99; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_4_clock = clock;
  assign pe_array_6_4_reset = reset;
  assign pe_array_6_4_io_in_act = pe_array_6_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_4_io_in_acc = pe_array_5_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_4_io_in_weight = io_weight_100; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_5_clock = clock;
  assign pe_array_6_5_reset = reset;
  assign pe_array_6_5_io_in_act = pe_array_6_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_5_io_in_acc = pe_array_5_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_5_io_in_weight = io_weight_101; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_6_clock = clock;
  assign pe_array_6_6_reset = reset;
  assign pe_array_6_6_io_in_act = pe_array_6_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_6_io_in_acc = pe_array_5_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_6_io_in_weight = io_weight_102; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_7_clock = clock;
  assign pe_array_6_7_reset = reset;
  assign pe_array_6_7_io_in_act = pe_array_6_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_7_io_in_acc = pe_array_5_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_7_io_in_weight = io_weight_103; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_8_clock = clock;
  assign pe_array_6_8_reset = reset;
  assign pe_array_6_8_io_in_act = pe_array_6_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_8_io_in_acc = pe_array_5_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_8_io_in_weight = io_weight_104; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_9_clock = clock;
  assign pe_array_6_9_reset = reset;
  assign pe_array_6_9_io_in_act = pe_array_6_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_9_io_in_acc = pe_array_5_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_9_io_in_weight = io_weight_105; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_10_clock = clock;
  assign pe_array_6_10_reset = reset;
  assign pe_array_6_10_io_in_act = pe_array_6_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_10_io_in_acc = pe_array_5_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_10_io_in_weight = io_weight_106; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_11_clock = clock;
  assign pe_array_6_11_reset = reset;
  assign pe_array_6_11_io_in_act = pe_array_6_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_11_io_in_acc = pe_array_5_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_11_io_in_weight = io_weight_107; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_12_clock = clock;
  assign pe_array_6_12_reset = reset;
  assign pe_array_6_12_io_in_act = pe_array_6_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_12_io_in_acc = pe_array_5_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_12_io_in_weight = io_weight_108; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_13_clock = clock;
  assign pe_array_6_13_reset = reset;
  assign pe_array_6_13_io_in_act = pe_array_6_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_13_io_in_acc = pe_array_5_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_13_io_in_weight = io_weight_109; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_14_clock = clock;
  assign pe_array_6_14_reset = reset;
  assign pe_array_6_14_io_in_act = pe_array_6_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_14_io_in_acc = pe_array_5_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_14_io_in_weight = io_weight_110; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_6_15_clock = clock;
  assign pe_array_6_15_reset = reset;
  assign pe_array_6_15_io_in_act = pe_array_6_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_6_15_io_in_acc = pe_array_5_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_6_15_io_in_weight = io_weight_111; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_0_clock = clock;
  assign pe_array_7_0_reset = reset;
  assign pe_array_7_0_io_in_act = io_in_rows_7; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_7_0_io_in_acc = pe_array_6_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_0_io_in_weight = io_weight_112; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_1_clock = clock;
  assign pe_array_7_1_reset = reset;
  assign pe_array_7_1_io_in_act = pe_array_7_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_1_io_in_acc = pe_array_6_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_1_io_in_weight = io_weight_113; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_2_clock = clock;
  assign pe_array_7_2_reset = reset;
  assign pe_array_7_2_io_in_act = pe_array_7_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_2_io_in_acc = pe_array_6_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_2_io_in_weight = io_weight_114; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_3_clock = clock;
  assign pe_array_7_3_reset = reset;
  assign pe_array_7_3_io_in_act = pe_array_7_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_3_io_in_acc = pe_array_6_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_3_io_in_weight = io_weight_115; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_4_clock = clock;
  assign pe_array_7_4_reset = reset;
  assign pe_array_7_4_io_in_act = pe_array_7_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_4_io_in_acc = pe_array_6_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_4_io_in_weight = io_weight_116; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_5_clock = clock;
  assign pe_array_7_5_reset = reset;
  assign pe_array_7_5_io_in_act = pe_array_7_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_5_io_in_acc = pe_array_6_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_5_io_in_weight = io_weight_117; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_6_clock = clock;
  assign pe_array_7_6_reset = reset;
  assign pe_array_7_6_io_in_act = pe_array_7_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_6_io_in_acc = pe_array_6_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_6_io_in_weight = io_weight_118; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_7_clock = clock;
  assign pe_array_7_7_reset = reset;
  assign pe_array_7_7_io_in_act = pe_array_7_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_7_io_in_acc = pe_array_6_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_7_io_in_weight = io_weight_119; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_8_clock = clock;
  assign pe_array_7_8_reset = reset;
  assign pe_array_7_8_io_in_act = pe_array_7_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_8_io_in_acc = pe_array_6_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_8_io_in_weight = io_weight_120; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_9_clock = clock;
  assign pe_array_7_9_reset = reset;
  assign pe_array_7_9_io_in_act = pe_array_7_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_9_io_in_acc = pe_array_6_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_9_io_in_weight = io_weight_121; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_10_clock = clock;
  assign pe_array_7_10_reset = reset;
  assign pe_array_7_10_io_in_act = pe_array_7_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_10_io_in_acc = pe_array_6_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_10_io_in_weight = io_weight_122; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_11_clock = clock;
  assign pe_array_7_11_reset = reset;
  assign pe_array_7_11_io_in_act = pe_array_7_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_11_io_in_acc = pe_array_6_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_11_io_in_weight = io_weight_123; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_12_clock = clock;
  assign pe_array_7_12_reset = reset;
  assign pe_array_7_12_io_in_act = pe_array_7_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_12_io_in_acc = pe_array_6_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_12_io_in_weight = io_weight_124; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_13_clock = clock;
  assign pe_array_7_13_reset = reset;
  assign pe_array_7_13_io_in_act = pe_array_7_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_13_io_in_acc = pe_array_6_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_13_io_in_weight = io_weight_125; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_14_clock = clock;
  assign pe_array_7_14_reset = reset;
  assign pe_array_7_14_io_in_act = pe_array_7_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_14_io_in_acc = pe_array_6_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_14_io_in_weight = io_weight_126; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_7_15_clock = clock;
  assign pe_array_7_15_reset = reset;
  assign pe_array_7_15_io_in_act = pe_array_7_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_7_15_io_in_acc = pe_array_6_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_7_15_io_in_weight = io_weight_127; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_0_clock = clock;
  assign pe_array_8_0_reset = reset;
  assign pe_array_8_0_io_in_act = io_in_rows_8; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_8_0_io_in_acc = pe_array_7_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_0_io_in_weight = io_weight_128; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_1_clock = clock;
  assign pe_array_8_1_reset = reset;
  assign pe_array_8_1_io_in_act = pe_array_8_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_1_io_in_acc = pe_array_7_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_1_io_in_weight = io_weight_129; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_2_clock = clock;
  assign pe_array_8_2_reset = reset;
  assign pe_array_8_2_io_in_act = pe_array_8_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_2_io_in_acc = pe_array_7_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_2_io_in_weight = io_weight_130; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_3_clock = clock;
  assign pe_array_8_3_reset = reset;
  assign pe_array_8_3_io_in_act = pe_array_8_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_3_io_in_acc = pe_array_7_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_3_io_in_weight = io_weight_131; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_4_clock = clock;
  assign pe_array_8_4_reset = reset;
  assign pe_array_8_4_io_in_act = pe_array_8_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_4_io_in_acc = pe_array_7_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_4_io_in_weight = io_weight_132; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_5_clock = clock;
  assign pe_array_8_5_reset = reset;
  assign pe_array_8_5_io_in_act = pe_array_8_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_5_io_in_acc = pe_array_7_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_5_io_in_weight = io_weight_133; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_6_clock = clock;
  assign pe_array_8_6_reset = reset;
  assign pe_array_8_6_io_in_act = pe_array_8_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_6_io_in_acc = pe_array_7_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_6_io_in_weight = io_weight_134; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_7_clock = clock;
  assign pe_array_8_7_reset = reset;
  assign pe_array_8_7_io_in_act = pe_array_8_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_7_io_in_acc = pe_array_7_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_7_io_in_weight = io_weight_135; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_8_clock = clock;
  assign pe_array_8_8_reset = reset;
  assign pe_array_8_8_io_in_act = pe_array_8_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_8_io_in_acc = pe_array_7_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_8_io_in_weight = io_weight_136; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_9_clock = clock;
  assign pe_array_8_9_reset = reset;
  assign pe_array_8_9_io_in_act = pe_array_8_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_9_io_in_acc = pe_array_7_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_9_io_in_weight = io_weight_137; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_10_clock = clock;
  assign pe_array_8_10_reset = reset;
  assign pe_array_8_10_io_in_act = pe_array_8_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_10_io_in_acc = pe_array_7_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_10_io_in_weight = io_weight_138; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_11_clock = clock;
  assign pe_array_8_11_reset = reset;
  assign pe_array_8_11_io_in_act = pe_array_8_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_11_io_in_acc = pe_array_7_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_11_io_in_weight = io_weight_139; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_12_clock = clock;
  assign pe_array_8_12_reset = reset;
  assign pe_array_8_12_io_in_act = pe_array_8_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_12_io_in_acc = pe_array_7_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_12_io_in_weight = io_weight_140; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_13_clock = clock;
  assign pe_array_8_13_reset = reset;
  assign pe_array_8_13_io_in_act = pe_array_8_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_13_io_in_acc = pe_array_7_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_13_io_in_weight = io_weight_141; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_14_clock = clock;
  assign pe_array_8_14_reset = reset;
  assign pe_array_8_14_io_in_act = pe_array_8_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_14_io_in_acc = pe_array_7_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_14_io_in_weight = io_weight_142; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_8_15_clock = clock;
  assign pe_array_8_15_reset = reset;
  assign pe_array_8_15_io_in_act = pe_array_8_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_8_15_io_in_acc = pe_array_7_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_8_15_io_in_weight = io_weight_143; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_0_clock = clock;
  assign pe_array_9_0_reset = reset;
  assign pe_array_9_0_io_in_act = io_in_rows_9; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_9_0_io_in_acc = pe_array_8_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_0_io_in_weight = io_weight_144; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_1_clock = clock;
  assign pe_array_9_1_reset = reset;
  assign pe_array_9_1_io_in_act = pe_array_9_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_1_io_in_acc = pe_array_8_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_1_io_in_weight = io_weight_145; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_2_clock = clock;
  assign pe_array_9_2_reset = reset;
  assign pe_array_9_2_io_in_act = pe_array_9_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_2_io_in_acc = pe_array_8_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_2_io_in_weight = io_weight_146; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_3_clock = clock;
  assign pe_array_9_3_reset = reset;
  assign pe_array_9_3_io_in_act = pe_array_9_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_3_io_in_acc = pe_array_8_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_3_io_in_weight = io_weight_147; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_4_clock = clock;
  assign pe_array_9_4_reset = reset;
  assign pe_array_9_4_io_in_act = pe_array_9_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_4_io_in_acc = pe_array_8_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_4_io_in_weight = io_weight_148; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_5_clock = clock;
  assign pe_array_9_5_reset = reset;
  assign pe_array_9_5_io_in_act = pe_array_9_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_5_io_in_acc = pe_array_8_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_5_io_in_weight = io_weight_149; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_6_clock = clock;
  assign pe_array_9_6_reset = reset;
  assign pe_array_9_6_io_in_act = pe_array_9_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_6_io_in_acc = pe_array_8_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_6_io_in_weight = io_weight_150; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_7_clock = clock;
  assign pe_array_9_7_reset = reset;
  assign pe_array_9_7_io_in_act = pe_array_9_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_7_io_in_acc = pe_array_8_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_7_io_in_weight = io_weight_151; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_8_clock = clock;
  assign pe_array_9_8_reset = reset;
  assign pe_array_9_8_io_in_act = pe_array_9_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_8_io_in_acc = pe_array_8_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_8_io_in_weight = io_weight_152; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_9_clock = clock;
  assign pe_array_9_9_reset = reset;
  assign pe_array_9_9_io_in_act = pe_array_9_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_9_io_in_acc = pe_array_8_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_9_io_in_weight = io_weight_153; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_10_clock = clock;
  assign pe_array_9_10_reset = reset;
  assign pe_array_9_10_io_in_act = pe_array_9_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_10_io_in_acc = pe_array_8_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_10_io_in_weight = io_weight_154; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_11_clock = clock;
  assign pe_array_9_11_reset = reset;
  assign pe_array_9_11_io_in_act = pe_array_9_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_11_io_in_acc = pe_array_8_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_11_io_in_weight = io_weight_155; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_12_clock = clock;
  assign pe_array_9_12_reset = reset;
  assign pe_array_9_12_io_in_act = pe_array_9_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_12_io_in_acc = pe_array_8_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_12_io_in_weight = io_weight_156; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_13_clock = clock;
  assign pe_array_9_13_reset = reset;
  assign pe_array_9_13_io_in_act = pe_array_9_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_13_io_in_acc = pe_array_8_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_13_io_in_weight = io_weight_157; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_14_clock = clock;
  assign pe_array_9_14_reset = reset;
  assign pe_array_9_14_io_in_act = pe_array_9_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_14_io_in_acc = pe_array_8_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_14_io_in_weight = io_weight_158; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_9_15_clock = clock;
  assign pe_array_9_15_reset = reset;
  assign pe_array_9_15_io_in_act = pe_array_9_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_9_15_io_in_acc = pe_array_8_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_9_15_io_in_weight = io_weight_159; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_0_clock = clock;
  assign pe_array_10_0_reset = reset;
  assign pe_array_10_0_io_in_act = io_in_rows_10; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_10_0_io_in_acc = pe_array_9_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_0_io_in_weight = io_weight_160; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_1_clock = clock;
  assign pe_array_10_1_reset = reset;
  assign pe_array_10_1_io_in_act = pe_array_10_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_1_io_in_acc = pe_array_9_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_1_io_in_weight = io_weight_161; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_2_clock = clock;
  assign pe_array_10_2_reset = reset;
  assign pe_array_10_2_io_in_act = pe_array_10_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_2_io_in_acc = pe_array_9_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_2_io_in_weight = io_weight_162; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_3_clock = clock;
  assign pe_array_10_3_reset = reset;
  assign pe_array_10_3_io_in_act = pe_array_10_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_3_io_in_acc = pe_array_9_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_3_io_in_weight = io_weight_163; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_4_clock = clock;
  assign pe_array_10_4_reset = reset;
  assign pe_array_10_4_io_in_act = pe_array_10_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_4_io_in_acc = pe_array_9_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_4_io_in_weight = io_weight_164; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_5_clock = clock;
  assign pe_array_10_5_reset = reset;
  assign pe_array_10_5_io_in_act = pe_array_10_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_5_io_in_acc = pe_array_9_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_5_io_in_weight = io_weight_165; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_6_clock = clock;
  assign pe_array_10_6_reset = reset;
  assign pe_array_10_6_io_in_act = pe_array_10_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_6_io_in_acc = pe_array_9_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_6_io_in_weight = io_weight_166; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_7_clock = clock;
  assign pe_array_10_7_reset = reset;
  assign pe_array_10_7_io_in_act = pe_array_10_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_7_io_in_acc = pe_array_9_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_7_io_in_weight = io_weight_167; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_8_clock = clock;
  assign pe_array_10_8_reset = reset;
  assign pe_array_10_8_io_in_act = pe_array_10_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_8_io_in_acc = pe_array_9_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_8_io_in_weight = io_weight_168; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_9_clock = clock;
  assign pe_array_10_9_reset = reset;
  assign pe_array_10_9_io_in_act = pe_array_10_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_9_io_in_acc = pe_array_9_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_9_io_in_weight = io_weight_169; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_10_clock = clock;
  assign pe_array_10_10_reset = reset;
  assign pe_array_10_10_io_in_act = pe_array_10_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_10_io_in_acc = pe_array_9_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_10_io_in_weight = io_weight_170; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_11_clock = clock;
  assign pe_array_10_11_reset = reset;
  assign pe_array_10_11_io_in_act = pe_array_10_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_11_io_in_acc = pe_array_9_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_11_io_in_weight = io_weight_171; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_12_clock = clock;
  assign pe_array_10_12_reset = reset;
  assign pe_array_10_12_io_in_act = pe_array_10_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_12_io_in_acc = pe_array_9_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_12_io_in_weight = io_weight_172; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_13_clock = clock;
  assign pe_array_10_13_reset = reset;
  assign pe_array_10_13_io_in_act = pe_array_10_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_13_io_in_acc = pe_array_9_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_13_io_in_weight = io_weight_173; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_14_clock = clock;
  assign pe_array_10_14_reset = reset;
  assign pe_array_10_14_io_in_act = pe_array_10_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_14_io_in_acc = pe_array_9_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_14_io_in_weight = io_weight_174; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_10_15_clock = clock;
  assign pe_array_10_15_reset = reset;
  assign pe_array_10_15_io_in_act = pe_array_10_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_10_15_io_in_acc = pe_array_9_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_10_15_io_in_weight = io_weight_175; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_0_clock = clock;
  assign pe_array_11_0_reset = reset;
  assign pe_array_11_0_io_in_act = io_in_rows_11; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_11_0_io_in_acc = pe_array_10_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_0_io_in_weight = io_weight_176; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_1_clock = clock;
  assign pe_array_11_1_reset = reset;
  assign pe_array_11_1_io_in_act = pe_array_11_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_1_io_in_acc = pe_array_10_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_1_io_in_weight = io_weight_177; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_2_clock = clock;
  assign pe_array_11_2_reset = reset;
  assign pe_array_11_2_io_in_act = pe_array_11_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_2_io_in_acc = pe_array_10_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_2_io_in_weight = io_weight_178; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_3_clock = clock;
  assign pe_array_11_3_reset = reset;
  assign pe_array_11_3_io_in_act = pe_array_11_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_3_io_in_acc = pe_array_10_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_3_io_in_weight = io_weight_179; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_4_clock = clock;
  assign pe_array_11_4_reset = reset;
  assign pe_array_11_4_io_in_act = pe_array_11_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_4_io_in_acc = pe_array_10_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_4_io_in_weight = io_weight_180; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_5_clock = clock;
  assign pe_array_11_5_reset = reset;
  assign pe_array_11_5_io_in_act = pe_array_11_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_5_io_in_acc = pe_array_10_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_5_io_in_weight = io_weight_181; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_6_clock = clock;
  assign pe_array_11_6_reset = reset;
  assign pe_array_11_6_io_in_act = pe_array_11_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_6_io_in_acc = pe_array_10_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_6_io_in_weight = io_weight_182; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_7_clock = clock;
  assign pe_array_11_7_reset = reset;
  assign pe_array_11_7_io_in_act = pe_array_11_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_7_io_in_acc = pe_array_10_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_7_io_in_weight = io_weight_183; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_8_clock = clock;
  assign pe_array_11_8_reset = reset;
  assign pe_array_11_8_io_in_act = pe_array_11_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_8_io_in_acc = pe_array_10_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_8_io_in_weight = io_weight_184; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_9_clock = clock;
  assign pe_array_11_9_reset = reset;
  assign pe_array_11_9_io_in_act = pe_array_11_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_9_io_in_acc = pe_array_10_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_9_io_in_weight = io_weight_185; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_10_clock = clock;
  assign pe_array_11_10_reset = reset;
  assign pe_array_11_10_io_in_act = pe_array_11_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_10_io_in_acc = pe_array_10_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_10_io_in_weight = io_weight_186; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_11_clock = clock;
  assign pe_array_11_11_reset = reset;
  assign pe_array_11_11_io_in_act = pe_array_11_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_11_io_in_acc = pe_array_10_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_11_io_in_weight = io_weight_187; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_12_clock = clock;
  assign pe_array_11_12_reset = reset;
  assign pe_array_11_12_io_in_act = pe_array_11_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_12_io_in_acc = pe_array_10_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_12_io_in_weight = io_weight_188; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_13_clock = clock;
  assign pe_array_11_13_reset = reset;
  assign pe_array_11_13_io_in_act = pe_array_11_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_13_io_in_acc = pe_array_10_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_13_io_in_weight = io_weight_189; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_14_clock = clock;
  assign pe_array_11_14_reset = reset;
  assign pe_array_11_14_io_in_act = pe_array_11_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_14_io_in_acc = pe_array_10_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_14_io_in_weight = io_weight_190; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_11_15_clock = clock;
  assign pe_array_11_15_reset = reset;
  assign pe_array_11_15_io_in_act = pe_array_11_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_11_15_io_in_acc = pe_array_10_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_11_15_io_in_weight = io_weight_191; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_0_clock = clock;
  assign pe_array_12_0_reset = reset;
  assign pe_array_12_0_io_in_act = io_in_rows_12; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_12_0_io_in_acc = pe_array_11_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_0_io_in_weight = io_weight_192; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_1_clock = clock;
  assign pe_array_12_1_reset = reset;
  assign pe_array_12_1_io_in_act = pe_array_12_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_1_io_in_acc = pe_array_11_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_1_io_in_weight = io_weight_193; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_2_clock = clock;
  assign pe_array_12_2_reset = reset;
  assign pe_array_12_2_io_in_act = pe_array_12_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_2_io_in_acc = pe_array_11_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_2_io_in_weight = io_weight_194; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_3_clock = clock;
  assign pe_array_12_3_reset = reset;
  assign pe_array_12_3_io_in_act = pe_array_12_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_3_io_in_acc = pe_array_11_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_3_io_in_weight = io_weight_195; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_4_clock = clock;
  assign pe_array_12_4_reset = reset;
  assign pe_array_12_4_io_in_act = pe_array_12_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_4_io_in_acc = pe_array_11_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_4_io_in_weight = io_weight_196; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_5_clock = clock;
  assign pe_array_12_5_reset = reset;
  assign pe_array_12_5_io_in_act = pe_array_12_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_5_io_in_acc = pe_array_11_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_5_io_in_weight = io_weight_197; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_6_clock = clock;
  assign pe_array_12_6_reset = reset;
  assign pe_array_12_6_io_in_act = pe_array_12_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_6_io_in_acc = pe_array_11_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_6_io_in_weight = io_weight_198; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_7_clock = clock;
  assign pe_array_12_7_reset = reset;
  assign pe_array_12_7_io_in_act = pe_array_12_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_7_io_in_acc = pe_array_11_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_7_io_in_weight = io_weight_199; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_8_clock = clock;
  assign pe_array_12_8_reset = reset;
  assign pe_array_12_8_io_in_act = pe_array_12_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_8_io_in_acc = pe_array_11_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_8_io_in_weight = io_weight_200; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_9_clock = clock;
  assign pe_array_12_9_reset = reset;
  assign pe_array_12_9_io_in_act = pe_array_12_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_9_io_in_acc = pe_array_11_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_9_io_in_weight = io_weight_201; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_10_clock = clock;
  assign pe_array_12_10_reset = reset;
  assign pe_array_12_10_io_in_act = pe_array_12_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_10_io_in_acc = pe_array_11_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_10_io_in_weight = io_weight_202; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_11_clock = clock;
  assign pe_array_12_11_reset = reset;
  assign pe_array_12_11_io_in_act = pe_array_12_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_11_io_in_acc = pe_array_11_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_11_io_in_weight = io_weight_203; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_12_clock = clock;
  assign pe_array_12_12_reset = reset;
  assign pe_array_12_12_io_in_act = pe_array_12_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_12_io_in_acc = pe_array_11_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_12_io_in_weight = io_weight_204; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_13_clock = clock;
  assign pe_array_12_13_reset = reset;
  assign pe_array_12_13_io_in_act = pe_array_12_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_13_io_in_acc = pe_array_11_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_13_io_in_weight = io_weight_205; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_14_clock = clock;
  assign pe_array_12_14_reset = reset;
  assign pe_array_12_14_io_in_act = pe_array_12_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_14_io_in_acc = pe_array_11_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_14_io_in_weight = io_weight_206; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_12_15_clock = clock;
  assign pe_array_12_15_reset = reset;
  assign pe_array_12_15_io_in_act = pe_array_12_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_12_15_io_in_acc = pe_array_11_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_12_15_io_in_weight = io_weight_207; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_0_clock = clock;
  assign pe_array_13_0_reset = reset;
  assign pe_array_13_0_io_in_act = io_in_rows_13; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_13_0_io_in_acc = pe_array_12_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_0_io_in_weight = io_weight_208; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_1_clock = clock;
  assign pe_array_13_1_reset = reset;
  assign pe_array_13_1_io_in_act = pe_array_13_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_1_io_in_acc = pe_array_12_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_1_io_in_weight = io_weight_209; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_2_clock = clock;
  assign pe_array_13_2_reset = reset;
  assign pe_array_13_2_io_in_act = pe_array_13_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_2_io_in_acc = pe_array_12_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_2_io_in_weight = io_weight_210; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_3_clock = clock;
  assign pe_array_13_3_reset = reset;
  assign pe_array_13_3_io_in_act = pe_array_13_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_3_io_in_acc = pe_array_12_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_3_io_in_weight = io_weight_211; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_4_clock = clock;
  assign pe_array_13_4_reset = reset;
  assign pe_array_13_4_io_in_act = pe_array_13_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_4_io_in_acc = pe_array_12_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_4_io_in_weight = io_weight_212; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_5_clock = clock;
  assign pe_array_13_5_reset = reset;
  assign pe_array_13_5_io_in_act = pe_array_13_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_5_io_in_acc = pe_array_12_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_5_io_in_weight = io_weight_213; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_6_clock = clock;
  assign pe_array_13_6_reset = reset;
  assign pe_array_13_6_io_in_act = pe_array_13_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_6_io_in_acc = pe_array_12_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_6_io_in_weight = io_weight_214; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_7_clock = clock;
  assign pe_array_13_7_reset = reset;
  assign pe_array_13_7_io_in_act = pe_array_13_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_7_io_in_acc = pe_array_12_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_7_io_in_weight = io_weight_215; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_8_clock = clock;
  assign pe_array_13_8_reset = reset;
  assign pe_array_13_8_io_in_act = pe_array_13_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_8_io_in_acc = pe_array_12_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_8_io_in_weight = io_weight_216; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_9_clock = clock;
  assign pe_array_13_9_reset = reset;
  assign pe_array_13_9_io_in_act = pe_array_13_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_9_io_in_acc = pe_array_12_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_9_io_in_weight = io_weight_217; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_10_clock = clock;
  assign pe_array_13_10_reset = reset;
  assign pe_array_13_10_io_in_act = pe_array_13_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_10_io_in_acc = pe_array_12_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_10_io_in_weight = io_weight_218; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_11_clock = clock;
  assign pe_array_13_11_reset = reset;
  assign pe_array_13_11_io_in_act = pe_array_13_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_11_io_in_acc = pe_array_12_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_11_io_in_weight = io_weight_219; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_12_clock = clock;
  assign pe_array_13_12_reset = reset;
  assign pe_array_13_12_io_in_act = pe_array_13_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_12_io_in_acc = pe_array_12_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_12_io_in_weight = io_weight_220; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_13_clock = clock;
  assign pe_array_13_13_reset = reset;
  assign pe_array_13_13_io_in_act = pe_array_13_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_13_io_in_acc = pe_array_12_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_13_io_in_weight = io_weight_221; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_14_clock = clock;
  assign pe_array_13_14_reset = reset;
  assign pe_array_13_14_io_in_act = pe_array_13_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_14_io_in_acc = pe_array_12_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_14_io_in_weight = io_weight_222; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_13_15_clock = clock;
  assign pe_array_13_15_reset = reset;
  assign pe_array_13_15_io_in_act = pe_array_13_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_13_15_io_in_acc = pe_array_12_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_13_15_io_in_weight = io_weight_223; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_0_clock = clock;
  assign pe_array_14_0_reset = reset;
  assign pe_array_14_0_io_in_act = io_in_rows_14; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_14_0_io_in_acc = pe_array_13_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_0_io_in_weight = io_weight_224; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_1_clock = clock;
  assign pe_array_14_1_reset = reset;
  assign pe_array_14_1_io_in_act = pe_array_14_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_1_io_in_acc = pe_array_13_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_1_io_in_weight = io_weight_225; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_2_clock = clock;
  assign pe_array_14_2_reset = reset;
  assign pe_array_14_2_io_in_act = pe_array_14_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_2_io_in_acc = pe_array_13_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_2_io_in_weight = io_weight_226; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_3_clock = clock;
  assign pe_array_14_3_reset = reset;
  assign pe_array_14_3_io_in_act = pe_array_14_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_3_io_in_acc = pe_array_13_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_3_io_in_weight = io_weight_227; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_4_clock = clock;
  assign pe_array_14_4_reset = reset;
  assign pe_array_14_4_io_in_act = pe_array_14_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_4_io_in_acc = pe_array_13_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_4_io_in_weight = io_weight_228; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_5_clock = clock;
  assign pe_array_14_5_reset = reset;
  assign pe_array_14_5_io_in_act = pe_array_14_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_5_io_in_acc = pe_array_13_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_5_io_in_weight = io_weight_229; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_6_clock = clock;
  assign pe_array_14_6_reset = reset;
  assign pe_array_14_6_io_in_act = pe_array_14_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_6_io_in_acc = pe_array_13_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_6_io_in_weight = io_weight_230; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_7_clock = clock;
  assign pe_array_14_7_reset = reset;
  assign pe_array_14_7_io_in_act = pe_array_14_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_7_io_in_acc = pe_array_13_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_7_io_in_weight = io_weight_231; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_8_clock = clock;
  assign pe_array_14_8_reset = reset;
  assign pe_array_14_8_io_in_act = pe_array_14_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_8_io_in_acc = pe_array_13_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_8_io_in_weight = io_weight_232; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_9_clock = clock;
  assign pe_array_14_9_reset = reset;
  assign pe_array_14_9_io_in_act = pe_array_14_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_9_io_in_acc = pe_array_13_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_9_io_in_weight = io_weight_233; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_10_clock = clock;
  assign pe_array_14_10_reset = reset;
  assign pe_array_14_10_io_in_act = pe_array_14_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_10_io_in_acc = pe_array_13_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_10_io_in_weight = io_weight_234; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_11_clock = clock;
  assign pe_array_14_11_reset = reset;
  assign pe_array_14_11_io_in_act = pe_array_14_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_11_io_in_acc = pe_array_13_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_11_io_in_weight = io_weight_235; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_12_clock = clock;
  assign pe_array_14_12_reset = reset;
  assign pe_array_14_12_io_in_act = pe_array_14_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_12_io_in_acc = pe_array_13_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_12_io_in_weight = io_weight_236; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_13_clock = clock;
  assign pe_array_14_13_reset = reset;
  assign pe_array_14_13_io_in_act = pe_array_14_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_13_io_in_acc = pe_array_13_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_13_io_in_weight = io_weight_237; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_14_clock = clock;
  assign pe_array_14_14_reset = reset;
  assign pe_array_14_14_io_in_act = pe_array_14_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_14_io_in_acc = pe_array_13_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_14_io_in_weight = io_weight_238; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_14_15_clock = clock;
  assign pe_array_14_15_reset = reset;
  assign pe_array_14_15_io_in_act = pe_array_14_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_14_15_io_in_acc = pe_array_13_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_14_15_io_in_weight = io_weight_239; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_0_clock = clock;
  assign pe_array_15_0_reset = reset;
  assign pe_array_15_0_io_in_act = io_in_rows_15; // @[ValExec_MulAddRecFN.scala 100:34]
  assign pe_array_15_0_io_in_acc = pe_array_14_0_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_0_io_in_weight = io_weight_240; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_1_clock = clock;
  assign pe_array_15_1_reset = reset;
  assign pe_array_15_1_io_in_act = pe_array_15_0_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_1_io_in_acc = pe_array_14_1_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_1_io_in_weight = io_weight_241; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_2_clock = clock;
  assign pe_array_15_2_reset = reset;
  assign pe_array_15_2_io_in_act = pe_array_15_1_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_2_io_in_acc = pe_array_14_2_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_2_io_in_weight = io_weight_242; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_3_clock = clock;
  assign pe_array_15_3_reset = reset;
  assign pe_array_15_3_io_in_act = pe_array_15_2_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_3_io_in_acc = pe_array_14_3_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_3_io_in_weight = io_weight_243; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_4_clock = clock;
  assign pe_array_15_4_reset = reset;
  assign pe_array_15_4_io_in_act = pe_array_15_3_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_4_io_in_acc = pe_array_14_4_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_4_io_in_weight = io_weight_244; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_5_clock = clock;
  assign pe_array_15_5_reset = reset;
  assign pe_array_15_5_io_in_act = pe_array_15_4_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_5_io_in_acc = pe_array_14_5_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_5_io_in_weight = io_weight_245; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_6_clock = clock;
  assign pe_array_15_6_reset = reset;
  assign pe_array_15_6_io_in_act = pe_array_15_5_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_6_io_in_acc = pe_array_14_6_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_6_io_in_weight = io_weight_246; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_7_clock = clock;
  assign pe_array_15_7_reset = reset;
  assign pe_array_15_7_io_in_act = pe_array_15_6_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_7_io_in_acc = pe_array_14_7_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_7_io_in_weight = io_weight_247; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_8_clock = clock;
  assign pe_array_15_8_reset = reset;
  assign pe_array_15_8_io_in_act = pe_array_15_7_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_8_io_in_acc = pe_array_14_8_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_8_io_in_weight = io_weight_248; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_9_clock = clock;
  assign pe_array_15_9_reset = reset;
  assign pe_array_15_9_io_in_act = pe_array_15_8_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_9_io_in_acc = pe_array_14_9_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_9_io_in_weight = io_weight_249; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_10_clock = clock;
  assign pe_array_15_10_reset = reset;
  assign pe_array_15_10_io_in_act = pe_array_15_9_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_10_io_in_acc = pe_array_14_10_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_10_io_in_weight = io_weight_250; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_11_clock = clock;
  assign pe_array_15_11_reset = reset;
  assign pe_array_15_11_io_in_act = pe_array_15_10_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_11_io_in_acc = pe_array_14_11_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_11_io_in_weight = io_weight_251; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_12_clock = clock;
  assign pe_array_15_12_reset = reset;
  assign pe_array_15_12_io_in_act = pe_array_15_11_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_12_io_in_acc = pe_array_14_12_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_12_io_in_weight = io_weight_252; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_13_clock = clock;
  assign pe_array_15_13_reset = reset;
  assign pe_array_15_13_io_in_act = pe_array_15_12_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_13_io_in_acc = pe_array_14_13_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_13_io_in_weight = io_weight_253; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_14_clock = clock;
  assign pe_array_15_14_reset = reset;
  assign pe_array_15_14_io_in_act = pe_array_15_13_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_14_io_in_acc = pe_array_14_14_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_14_io_in_weight = io_weight_254; // @[ValExec_MulAddRecFN.scala 95:41]
  assign pe_array_15_15_clock = clock;
  assign pe_array_15_15_reset = reset;
  assign pe_array_15_15_io_in_act = pe_array_15_14_io_out; // @[ValExec_MulAddRecFN.scala 109:38]
  assign pe_array_15_15_io_in_acc = pe_array_14_15_io_out; // @[ValExec_MulAddRecFN.scala 115:38]
  assign pe_array_15_15_io_in_weight = io_weight_255; // @[ValExec_MulAddRecFN.scala 95:41]
endmodule
