// =======================================================================================
// This Sail RISC-Y architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// Definitions for tensor registers (Y extension)

type ylenbits = bits(ylen)

// tensor instruction types

enum y_yyfunct6 = {
  Y_YY_YADD,
  Y_YY_YSUB,
  Y_YY_YMINU,
  Y_YY_YMIN,
  Y_YY_YMAXU,
  Y_YY_YMAX,
  Y_YY_YAND,
  Y_YY_YOR,
  Y_YY_YXOR,
  Y_YY_YRGATHER,
  Y_YY_YRGATHEREI16,
  Y_YY_YSADDU,
  Y_YY_YSADD,
  Y_YY_YSSUBU,
  Y_YY_YSSUB,
  Y_YY_YSLL,
  Y_YY_YSMUL,
  Y_YY_YSRL,
  Y_YY_YSRA,
  Y_YY_YSSRL,
  Y_YY_YSSRA,
}

enum y_yycmpfunct6 = { Y_YYCMP_YMSEQ, Y_YYCMP_YMSNE, Y_YYCMP_YMSLTU, Y_YYCMP_YMSLT, Y_YYCMP_YMSLEU, Y_YYCMP_YMSLE }

enum y_yymfunct6 = { Y_YYM_YMADC, Y_YYM_YMSBC }

enum y_yymcfunct6 = { Y_YYMC_YMADC, Y_YYMC_YMSBC }

enum y_yymsfunct6 = { Y_YYMS_YADC, Y_YYMS_YSBC }

enum y_yxmfunct6 = { Y_YXM_YMADC, Y_YXM_YMSBC }

enum y_yxmcfunct6 = { Y_YXMC_YMADC, Y_YXMC_YMSBC }

enum y_yxmsfunct6 = { Y_YXMS_YADC, Y_YXMS_YSBC }

enum y_yimfunct6 = { Y_YIM_YMADC }

enum y_yimcfunct6 = { Y_YIMC_YMADC }

enum y_yimsfunct6 = { Y_YIMS_YADC }

enum y_yxcmpfunct6 = {
  Y_YXCMP_YMSEQ,
  Y_YXCMP_YMSNE,
  Y_YXCMP_YMSLTU,
  Y_YXCMP_YMSLT,
  Y_YXCMP_YMSLEU,
  Y_YXCMP_YMSLE,
  Y_YXCMP_YMSGTU,
  Y_YXCMP_YMSGT,
}

enum y_yicmpfunct6 = { Y_YICMP_YMSEQ, Y_YICMP_YMSNE, Y_YICMP_YMSLEU, Y_YICMP_YMSLE, Y_YICMP_YMSGTU, Y_YICMP_YMSGT }

enum y_nyfunct6 = { Y_NY_YNCLIPU, Y_NY_YNCLIP }

enum y_nysfunct6 = { Y_NYS_YNSRL, Y_NYS_YNSRA }

enum y_nxfunct6 = { Y_NX_YNCLIPU, Y_NX_YNCLIP }

enum y_nxsfunct6 = { Y_NXS_YNSRL, Y_NXS_YNSRA }

enum y_mmfunct6 = { Y_MM_YMAND, Y_MM_YMNAND, Y_MM_YMANDN, Y_MM_YMXOR, Y_MM_YMOR, Y_MM_YMNOR, Y_MM_YMORN, Y_MM_YMXNOR }

enum y_nifunct6 = { Y_NI_YNCLIPU, Y_NI_YNCLIP }

enum y_nisfunct6 = { Y_NIS_YNSRL, Y_NIS_YNSRA }

enum y_wide_yyfunct6 = {
  Y_WIDE_YY_YADD,
  Y_WIDE_YY_YSUB,
  Y_WIDE_YY_YADDU,
  Y_WIDE_YY_YSUBU,
  Y_WIDE_YY_YWMUL,
  Y_WIDE_YY_YWMULU,
  Y_WIDE_YY_YWMULSU,
}

enum y_wide_yfunct6 = { Y_WIDE_Y_YADD, Y_WIDE_Y_YSUB, Y_WIDE_Y_YADDU, Y_WIDE_Y_YSUBU }

enum y_wide_yxfunct6 = {
  Y_WIDE_YX_YADD,
  Y_WIDE_YX_YSUB,
  Y_WIDE_YX_YADDU,
  Y_WIDE_YX_YSUBU,
  Y_WIDE_YX_YWMUL,
  Y_WIDE_YX_YWMULU,
  Y_WIDE_YX_YWMULSU,
}

enum y_wide_xfunct6 = { Y_WIDE_X_YADD, Y_WIDE_X_YSUB, Y_WIDE_X_YADDU, Y_WIDE_X_YSUBU }

enum y_yextfunct6 = { Y_YEXT2_ZVF2, Y_YEXT2_SVF2, Y_YEXT4_ZVF4, Y_YEXT4_SVF4, Y_YEXT8_ZVF8, Y_YEXT8_SVF8 }

enum y_yxfunct6 = {
  Y_YX_YADD,
  Y_YX_YSUB,
  Y_YX_YRSUB,
  Y_YX_YMINU,
  Y_YX_YMIN,
  Y_YX_YMAXU,
  Y_YX_YMAX,
  Y_YX_YAND,
  Y_YX_YOR,
  Y_YX_YXOR,
  Y_YX_YSADDU,
  Y_YX_YSADD,
  Y_YX_YSSUBU,
  Y_YX_YSSUB,
  Y_YX_YSLL,
  Y_YX_YSMUL,
  Y_YX_YSRL,
  Y_YX_YSRA,
  Y_YX_YSSRL,
  Y_YX_YSSRA,
}

enum y_yifunct6 = {
  Y_YI_YADD,
  Y_YI_YRSUB,
  Y_YI_YAND,
  Y_YI_YOR,
  Y_YI_YXOR,
  Y_YI_YSADDU,
  Y_YI_YSADD,
  Y_YI_YSLL,
  Y_YI_YSRL,
  Y_YI_YSRA,
  Y_YI_YSSRL,
  Y_YI_YSSRA,
}

enum y_yxsgfunct6 = { Y_YX_YSLIDEUP, Y_YX_YSLIDEDOWN, Y_YX_YRGATHER }

enum y_yisgfunct6 = { Y_YI_YSLIDEUP, Y_YI_YSLIDEDOWN, Y_YI_YRGATHER }

enum y_myyfunct6 = {
  Y_MYY_YAADDU,
  Y_MYY_YAADD,
  Y_MYY_YASUBU,
  Y_MYY_YASUB,
  Y_MYY_YMUL,
  Y_MYY_YMULH,
  Y_MYY_YMULHU,
  Y_MYY_YMULHSU,
  Y_MYY_YDIVU,
  Y_MYY_YDIV,
  Y_MYY_YREMU,
  Y_MYY_YREM,
}

enum y_myymafunct6 = { Y_MYY_YMACC, Y_MYY_YNMSAC, Y_MYY_YMADD, Y_MYY_YNMSUB }

enum y_rmyyfunct6 = {
  Y_MYY_YREDSUM,
  Y_MYY_YREDAND,
  Y_MYY_YREDOR,
  Y_MYY_YREDXOR,
  Y_MYY_YREDMINU,
  Y_MYY_YREDMIN,
  Y_MYY_YREDMAXU,
  Y_MYY_YREDMAX,
}

enum y_riyyfunct6 = { Y_IVV_YWREDSUMU, Y_IVV_YWREDSUM }

enum y_rfyyfunct6 = { Y_FYY_YFREDOSUM, Y_FYY_YFREDUSUM, Y_FYY_YFREDMAX, Y_FYY_YFREDMIN }

enum y_rfwide_yyfunct6 = { Y_FYY_YFWREDOSUM, Y_FYY_YFWREDUSUM }

enum y_wide_myyfunct6 = { Y_WIDE_MYY_YWMACCU, Y_WIDE_MYY_YWMACC, Y_WIDE_MYY_YWMACCSU }

enum y_myxfunct6 = {
  Y_MYX_YAADDU,
  Y_MYX_YAADD,
  Y_MYX_YASUBU,
  Y_MYX_YASUB,
  Y_MYX_YSLIDE1UP,
  Y_MYX_YSLIDE1DOWN,
  Y_MYX_YMUL,
  Y_MYX_YMULH,
  Y_MYX_YMULHU,
  Y_MYX_YMULHSU,
  Y_MYX_YDIVU,
  Y_MYX_YDIV,
  Y_MYX_YREMU,
  Y_MYX_YREM,
}

enum y_myxmafunct6 = { Y_MYX_YMACC, Y_MYX_YNMSAC, Y_MYX_YMADD, Y_MYX_YNMSUB }

enum y_wide_myxfunct6 = { Y_WIDE_MYX_YWMACCU, Y_WIDE_MYX_YWMACC, Y_WIDE_MYX_YWMACCUS, Y_WIDE_MYX_YWMACCSU }

enum y_maskfunct3 = { Y_YY_YMERGE, Y_YI_YMERGE, Y_YX_YMERGE }

enum y_ylewidth = { Y_YLE8, Y_YLE16, Y_YLE32, Y_YLE64 }

enum y_fyyfunct6 = {
  Y_FYY_YADD,
  Y_FYY_YSUB,
  Y_FYY_YMIN,
  Y_FYY_YMAX,
  Y_FYY_YSGNJ,
  Y_FYY_YSGNJN,
  Y_FYY_YSGNJX,
  Y_FYY_YDIV,
  Y_FYY_YMUL,
}

enum y_fyymafunct6 = {
  Y_FYY_YMADD,
  Y_FYY_YNMADD,
  Y_FYY_YMSUB,
  Y_FYY_YNMSUB,
  Y_FYY_YMACC,
  Y_FYY_YNMACC,
  Y_FYY_YMSAC,
  Y_FYY_YNMSAC,
}

enum y_fwide_yyfunct6 = { Y_FWIDE_YY_YADD, Y_FWIDE_YY_YSUB, Y_FWIDE_YY_YMUL }

enum y_fwide_yymafunct6 = { Y_FWIDE_YY_YMACC, Y_FWIDE_YY_YNMACC, Y_FWIDE_YY_YMSAC, Y_FWIDE_YY_YNMSAC }

enum y_fwide_yfunct6 = { Y_FWIDE_Y_YADD, Y_FWIDE_Y_YSUB }

enum y_fyymfunct6 = { Y_FYYM_YMFEQ, Y_FYYM_YMFLE, Y_FYYM_YMFLT, Y_FYYM_YMFNE }

enum y_yfunary0 = { Y_FY_CVT_XU_F, Y_FY_CVT_X_F, Y_FY_CVT_F_XU, Y_FY_CVT_F_X, Y_FY_CVT_RTZ_XU_F, Y_FY_CVT_RTZ_X_F }

enum y_vfwunary0 = {
  Y_FWIDE_Y_CVT_XU_F,
  Y_FWIDE_Y_CVT_X_F,
  Y_FWIDE_Y_CVT_F_XU,
  Y_FWIDE_Y_CVT_F_X,
  Y_FWIDE_Y_CVT_F_F,
  Y_FWIDE_Y_CVT_RTZ_XU_F,
  Y_FWIDE_Y_CVT_RTZ_X_F,
}

enum y_vfnunary0 = {
  Y_FNV_CVT_XU_F,
  Y_FNV_CVT_X_F,
  Y_FNV_CVT_F_XU,
  Y_FNV_CVT_F_X,
  Y_FNV_CVT_F_F,
  Y_FNV_CVT_ROD_F_F,
  Y_FNV_CVT_RTZ_XU_F,
  Y_FNV_CVT_RTZ_X_F,
}

enum y_yfunary1 = { Y_FYY_YSQRT, Y_FYY_YRSQRT7, Y_FYY_YREC7, Y_FYY_YCLASS }

enum y_fyffunct6 = {
  Y_YF_YADD,
  Y_YF_YSUB,
  Y_YF_YMIN,
  Y_YF_YMAX,
  Y_YF_YSGNJ,
  Y_YF_YSGNJN,
  Y_YF_YSGNJX,
  Y_YF_YDIV,
  Y_YF_YRDIV,
  Y_YF_YMUL,
  Y_YF_YRSUB,
  Y_YF_YSLIDE1UP,
  Y_YF_YSLIDE1DOWN,
}

enum y_fyfmafunct6 = {
  Y_YF_YMADD,
  Y_YF_YNMADD,
  Y_YF_YMSUB,
  Y_YF_YNMSUB,
  Y_YF_YMACC,
  Y_YF_YNMACC,
  Y_YF_YMSAC,
  Y_YF_YNMSAC,
}

enum y_fwide_yffunct6 = { Y_FWIDE_YF_YADD, Y_FWIDE_YF_YSUB, Y_FWIDE_YF_YMUL }

enum y_fwide_yfmafunct6 = { Y_FWIDE_YF_YMACC, Y_FWIDE_YF_YNMACC, Y_FWIDE_YF_YMSAC, Y_FWIDE_YF_YNMSAC }

enum y_fwide_ffunct6 = { Y_FWIDE_F_YADD, Y_FWIDE_F_YSUB }

enum y_fyfmfunct6 = { Y_YFM_YMFEQ, Y_YFM_YMFLE, Y_YFM_YMFLT, Y_YFM_YMFNE, Y_YFM_YMFGT, Y_YFM_YMFGE }

enum y_ymlsop = { Y_YLM, Y_YSM }

enum y_indexed_mop = { Y_INDEXED_UNORDERED, Y_INDEXED_ORDERED }

// Classifies tensor instructions by their ystart trap policy
enum y_ystart_class = {
  Y_YSTART_ARITH, // tensor arithmetic: trap on nonzero ystart (configurable)
  Y_YSTART_LOAD_STORE, // memory ops: always accept any ystart
  Y_YSTART_SCALAR_MOVE, // vmv.x.s, vfmv.f.s etc: always accept any ystart
  Y_YSTART_MANDATORY, // reductions, vcompress, etc.: always trap on nonzero ystart
}
