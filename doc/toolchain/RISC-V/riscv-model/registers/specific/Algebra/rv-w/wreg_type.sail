// =======================================================================================
// This Sail RISC-W architecture model, comprising all files and
// directories except where otherwise noted is subject the BSD
// two-clause license in the LICENSE file.
//
// SPDX-License-Identifier: BSD-2-Clause
// =======================================================================================

// Definitions for matrix registers (W extension)

type wlenbits = bits(wlen)

// matrix instruction types

enum w_wwfunct6 = {
  W_WW_WADD,
  W_WW_WSUB,
  W_WW_WMINU,
  W_WW_WMIN,
  W_WW_WMAXU,
  W_WW_WMAX,
  W_WW_WAND,
  W_WW_WOR,
  W_WW_WXOR,
  W_WW_WRGATHER,
  W_WW_WRGATHEREI16,
  W_WW_WSADDU,
  W_WW_WSADD,
  W_WW_WSSUBU,
  W_WW_WSSUB,
  W_WW_WSLL,
  W_WW_WSMUL,
  W_WW_WSRL,
  W_WW_WSRA,
  W_WW_WSSRL,
  W_WW_WSSRA,
}

enum w_wwcmpfunct6 = { W_WWCMP_WMSEQ, W_WWCMP_WMSNE, W_WWCMP_WMSLTU, W_WWCMP_WMSLT, W_WWCMP_WMSLEU, W_WWCMP_WMSLE }

enum w_wwmfunct6 = { W_WWM_WMADC, W_WWM_WMSBC }

enum w_wwmcfunct6 = { W_WWMC_WMADC, W_WWMC_WMSBC }

enum w_wwmsfunct6 = { W_WWMS_WADC, W_WWMS_WSBC }

enum w_wxmfunct6 = { W_WXM_WMADC, W_WXM_WMSBC }

enum w_wxmcfunct6 = { W_WXMC_WMADC, W_WXMC_WMSBC }

enum w_wxmsfunct6 = { W_WXMS_WADC, W_WXMS_WSBC }

enum w_wimfunct6 = { W_WIM_WMADC }

enum w_wimcfunct6 = { W_WIMC_WMADC }

enum w_wimsfunct6 = { W_WIMS_WADC }

enum w_wxcmpfunct6 = {
  W_WXCMP_WMSEQ,
  W_WXCMP_WMSNE,
  W_WXCMP_WMSLTU,
  W_WXCMP_WMSLT,
  W_WXCMP_WMSLEU,
  W_WXCMP_WMSLE,
  W_WXCMP_WMSGTU,
  W_WXCMP_WMSGT,
}

enum w_wicmpfunct6 = { W_WICMP_WMSEQ, W_WICMP_WMSNE, W_WICMP_WMSLEU, W_WICMP_WMSLE, W_WICMP_WMSGTU, W_WICMP_WMSGT }

enum w_nwfunct6 = { W_NW_WNCLIPU, W_NW_WNCLIP }

enum w_nwsfunct6 = { W_NWS_WNSRL, W_NWS_WNSRA }

enum w_nxfunct6 = { W_NX_WNCLIPU, W_NX_WNCLIP }

enum w_nxsfunct6 = { W_NXS_WNSRL, W_NXS_WNSRA }

enum w_mmfunct6 = { W_MM_WMAND, W_MM_WMNAND, W_MM_WMANDN, W_MM_WMXOR, W_MM_WMOR, W_MM_WMNOR, W_MM_WMORN, W_MM_WMXNOR }

enum w_nifunct6 = { W_NI_WNCLIPU, W_NI_WNCLIP }

enum w_nisfunct6 = { W_NIS_WNSRL, W_NIS_WNSRA }

enum w_wide_wwfunct6 = {
  W_WIDE_WW_WADD,
  W_WIDE_WW_WSUB,
  W_WIDE_WW_WADDU,
  W_WIDE_WW_WSUBU,
  W_WIDE_WW_WWMUL,
  W_WIDE_WW_WWMULU,
  W_WIDE_WW_WWMULSU,
}

enum w_wide_wfunct6 = { W_WIDE_W_WADD, W_WIDE_W_WSUB, W_WIDE_W_WADDU, W_WIDE_W_WSUBU }

enum w_wide_wxfunct6 = {
  W_WIDE_WX_WADD,
  W_WIDE_WX_WSUB,
  W_WIDE_WX_WADDU,
  W_WIDE_WX_WSUBU,
  W_WIDE_WX_WWMUL,
  W_WIDE_WX_WWMULU,
  W_WIDE_WX_WWMULSU,
}

enum w_wide_xfunct6 = { W_WIDE_X_WADD, W_WIDE_X_WSUB, W_WIDE_X_WADDU, W_WIDE_X_WSUBU }

enum w_wextfunct6 = { W_WEXT2_ZVF2, W_WEXT2_SVF2, W_WEXT4_ZVF4, W_WEXT4_SVF4, W_WEXT8_ZVF8, W_WEXT8_SVF8 }

enum w_wxfunct6 = {
  W_WX_WADD,
  W_WX_WSUB,
  W_WX_WRSUB,
  W_WX_WMINU,
  W_WX_WMIN,
  W_WX_WMAXU,
  W_WX_WMAX,
  W_WX_WAND,
  W_WX_WOR,
  W_WX_WXOR,
  W_WX_WSADDU,
  W_WX_WSADD,
  W_WX_WSSUBU,
  W_WX_WSSUB,
  W_WX_WSLL,
  W_WX_WSMUL,
  W_WX_WSRL,
  W_WX_WSRA,
  W_WX_WSSRL,
  W_WX_WSSRA,
}

enum w_wifunct6 = {
  W_WI_WADD,
  W_WI_WRSUB,
  W_WI_WAND,
  W_WI_WOR,
  W_WI_WXOR,
  W_WI_WSADDU,
  W_WI_WSADD,
  W_WI_WSLL,
  W_WI_WSRL,
  W_WI_WSRA,
  W_WI_WSSRL,
  W_WI_WSSRA,
}

enum w_wxsgfunct6 = { W_WX_WSLIDEUP, W_WX_WSLIDEDOWN, W_WX_WRGATHER }

enum w_wisgfunct6 = { W_WI_WSLIDEUP, W_WI_WSLIDEDOWN, W_WI_WRGATHER }

enum w_mwwfunct6 = {
  W_MWW_WAADDU,
  W_MWW_WAADD,
  W_MWW_WASUBU,
  W_MWW_WASUB,
  W_MWW_WMUL,
  W_MWW_WMULH,
  W_MWW_WMULHU,
  W_MWW_WMULHSU,
  W_MWW_WDIVU,
  W_MWW_WDIV,
  W_MWW_WREMU,
  W_MWW_WREM,
}

enum w_mwwmafunct6 = { W_MWW_WMACC, W_MWW_WNMSAC, W_MWW_WMADD, W_MWW_WNMSUB }

enum w_rmwwfunct6 = {
  W_MWW_WREDSUM,
  W_MWW_WREDAND,
  W_MWW_WREDOR,
  W_MWW_WREDXOR,
  W_MWW_WREDMINU,
  W_MWW_WREDMIN,
  W_MWW_WREDMAXU,
  W_MWW_WREDMAX,
}

enum w_riwwfunct6 = { W_IVV_WWREDSUMU, W_IVV_WWREDSUM }

enum w_rfwwfunct6 = { W_FWW_WFREDOSUM, W_FWW_WFREDUSUM, W_FWW_WFREDMAX, W_FWW_WFREDMIN }

enum w_rfwide_wwfunct6 = { W_FWW_WFWREDOSUM, W_FWW_WFWREDUSUM }

enum w_wide_mwwfunct6 = { W_WIDE_MWW_WWMACCU, W_WIDE_MWW_WWMACC, W_WIDE_MWW_WWMACCSU }

enum w_mwxfunct6 = {
  W_MWX_WAADDU,
  W_MWX_WAADD,
  W_MWX_WASUBU,
  W_MWX_WASUB,
  W_MWX_WSLIDE1UP,
  W_MWX_WSLIDE1DOWN,
  W_MWX_WMUL,
  W_MWX_WMULH,
  W_MWX_WMULHU,
  W_MWX_WMULHSU,
  W_MWX_WDIVU,
  W_MWX_WDIV,
  W_MWX_WREMU,
  W_MWX_WREM,
}

enum w_mwxmafunct6 = { W_MWX_WMACC, W_MWX_WNMSAC, W_MWX_WMADD, W_MWX_WNMSUB }

enum w_wide_mwxfunct6 = { W_WIDE_MWX_WWMACCU, W_WIDE_MWX_WWMACC, W_WIDE_MWX_WWMACCUS, W_WIDE_MWX_WWMACCSU }

enum w_maskfunct3 = { W_WW_WMERGE, W_WI_WMERGE, W_WX_WMERGE }

enum w_wlewidth = { W_WLE8, W_WLE16, W_WLE32, W_WLE64 }

enum w_fwwfunct6 = {
  W_FWW_WADD,
  W_FWW_WSUB,
  W_FWW_WMIN,
  W_FWW_WMAX,
  W_FWW_WSGNJ,
  W_FWW_WSGNJN,
  W_FWW_WSGNJX,
  W_FWW_WDIV,
  W_FWW_WMUL,
}

enum w_fwwmafunct6 = {
  W_FWW_WMADD,
  W_FWW_WNMADD,
  W_FWW_WMSUB,
  W_FWW_WNMSUB,
  W_FWW_WMACC,
  W_FWW_WNMACC,
  W_FWW_WMSAC,
  W_FWW_WNMSAC,
}

enum w_fwide_wwfunct6 = { W_FWIDE_WW_WADD, W_FWIDE_WW_WSUB, W_FWIDE_WW_WMUL }

enum w_fwide_wwmafunct6 = { W_FWIDE_WW_WMACC, W_FWIDE_WW_WNMACC, W_FWIDE_WW_WMSAC, W_FWIDE_WW_WNMSAC }

enum w_fwide_wfunct6 = { W_FWIDE_W_WADD, W_FWIDE_W_WSUB }

enum w_fwwmfunct6 = { W_FWWM_WMFEQ, W_FWWM_WMFLE, W_FWWM_WMFLT, W_FWWM_WMFNE }

enum w_wfunary0 = { W_FW_CVT_XU_F, W_FW_CVT_X_F, W_FW_CVT_F_XU, W_FW_CVT_F_X, W_FW_CVT_RTZ_XU_F, W_FW_CVT_RTZ_X_F }

enum w_vfwunary0 = {
  W_FWIDE_W_CVT_XU_F,
  W_FWIDE_W_CVT_X_F,
  W_FWIDE_W_CVT_F_XU,
  W_FWIDE_W_CVT_F_X,
  W_FWIDE_W_CVT_F_F,
  W_FWIDE_W_CVT_RTZ_XU_F,
  W_FWIDE_W_CVT_RTZ_X_F,
}

enum w_vfnunary0 = {
  W_FNV_CVT_XU_F,
  W_FNV_CVT_X_F,
  W_FNV_CVT_F_XU,
  W_FNV_CVT_F_X,
  W_FNV_CVT_F_F,
  W_FNV_CVT_ROD_F_F,
  W_FNV_CVT_RTZ_XU_F,
  W_FNV_CVT_RTZ_X_F,
}

enum w_wfunary1 = { W_FWW_WSQRT, W_FWW_WRSQRT7, W_FWW_WREC7, W_FWW_WCLASS }

enum w_fwffunct6 = {
  W_WF_WADD,
  W_WF_WSUB,
  W_WF_WMIN,
  W_WF_WMAX,
  W_WF_WSGNJ,
  W_WF_WSGNJN,
  W_WF_WSGNJX,
  W_WF_WDIV,
  W_WF_WRDIV,
  W_WF_WMUL,
  W_WF_WRSUB,
  W_WF_WSLIDE1UP,
  W_WF_WSLIDE1DOWN,
}

enum w_fwfmafunct6 = {
  W_WF_WMADD,
  W_WF_WNMADD,
  W_WF_WMSUB,
  W_WF_WNMSUB,
  W_WF_WMACC,
  W_WF_WNMACC,
  W_WF_WMSAC,
  W_WF_WNMSAC,
}

enum w_fwide_wffunct6 = { W_FWIDE_WF_WADD, W_FWIDE_WF_WSUB, W_FWIDE_WF_WMUL }

enum w_fwide_wfmafunct6 = { W_FWIDE_WF_WMACC, W_FWIDE_WF_WNMACC, W_FWIDE_WF_WMSAC, W_FWIDE_WF_WNMSAC }

enum w_fwide_ffunct6 = { W_FWIDE_F_WADD, W_FWIDE_F_WSUB }

enum w_fwfmfunct6 = { W_WFM_WMFEQ, W_WFM_WMFLE, W_WFM_WMFLT, W_WFM_WMFNE, W_WFM_WMFGT, W_WFM_WMFGE }

enum w_wmlsop = { W_WLM, W_WSM }

enum w_indexed_mop = { W_INDEXED_UNORDERED, W_INDEXED_ORDERED }

// Classifies matrix instructions by their wstart trap policy
enum w_wstart_class = {
  W_WSTART_ARITH, // matrix arithmetic: trap on nonzero wstart (configurable)
  W_WSTART_LOAD_STORE, // memory ops: always accept any wstart
  W_WSTART_SCALAR_MOVE, // vmv.x.s, vfmv.f.s etc: always accept any wstart
  W_WSTART_MANDATORY, // reductions, vcompress, etc.: always trap on nonzero wstart
}
