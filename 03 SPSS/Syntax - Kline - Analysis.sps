* Encoding: UTF-8.

* working directory.
CD 'C:\Users\ruamp\OneDrive - University of Toledo\Conferences\'+
'SPA 2020\Kline\SPSS_archives\Reviewed - FINAL\FINAL FILES'.

* open dataset.
GET
  FILE='Kline Db Complete - SCID Updated & Recoded - SCHB, EMS, PAE, MOR, Complexity included.sav'.
DATASET NAME kline WINDOW=FRONT.

* FILE='Kline Db Complete - SCID Updated & Recoded - SCHB, EMS, PAE, MOR included.sav'.


* calculating ICC for SCID composite and isolated BPRS items ------------------.

* ICC SCID composites (single = .975, average = .987).
RELIABILITY
  /VARIABLES=SCID1.CMDS.composite SCID2.CMDS.composite
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR ANOVA
  /SUMMARY=MEANS
  /ICC=MODEL(MIXED) TYPE(CONSISTENCY) CIN=95 TESTVAL=0.


* ICC SCID A1(single = , average = ).
RELIABILITY
  /VARIABLES=SCID1.CMDS.A1r SCID2.CMDS.A1r
  /SCALE('Depressive Mood') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR ANOVA
  /SUMMARY=MEANS
  /ICC=MODEL(MIXED) TYPE(CONSISTENCY) CIN=95 TESTVAL=0.


* ICC SCID A7(single = , average = ).
RELIABILITY
  /VARIABLES=SCID1.CMDS.A7r SCID2.CMDS.A7r
  /SCALE('Worthlessness or Guilt') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR ANOVA
  /SUMMARY=MEANS
  /ICC=MODEL(MIXED) TYPE(CONSISTENCY) CIN=95 TESTVAL=0.


* ICC BPRS 03(single = .401, average = .573).
RELIABILITY
  /VARIABLES= BPRS1.03 BPRS2.03 
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR ANOVA
  /SUMMARY=MEANS
  /ICC=MODEL(MIXED) TYPE(CONSISTENCY) CIN=95 TESTVAL=0.

* ICC BPRS 05 (single = .769, average = .869).
RELIABILITY
  /VARIABLES= BPRS1.05 BPRS2.05 
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR ANOVA
  /SUMMARY=MEANS
  /ICC=MODEL(MIXED) TYPE(CONSISTENCY) CIN=95 TESTVAL=0.

* ICC BPRS 09 (single = .708, average = .829).
RELIABILITY
  /VARIABLES= BPRS1.09 BPRS2.09
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR ANOVA
  /SUMMARY=MEANS
  /ICC=MODEL(MIXED) TYPE(CONSISTENCY) CIN=95 TESTVAL=0.

* ICC BPRS 13 (single = .551, average = .711).
RELIABILITY
  /VARIABLES= BPRS1.13 BPRS2.13 
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR ANOVA
  /SUMMARY=MEANS
  /ICC=MODEL(MIXED) TYPE(CONSISTENCY) CIN=95 TESTVAL=0.

* ICC BPRS 16 (single = .450, average = .620).
RELIABILITY
  /VARIABLES= BPRS1.16 BPRS2.16
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR ANOVA
  /SUMMARY=MEANS
  /ICC=MODEL(MIXED) TYPE(CONSISTENCY) CIN=95 TESTVAL=0.

* ICC BPRS 17 (single = .767, average = .868).
RELIABILITY
  /VARIABLES= BPRS1.17 BPRS2.17 
  /SCALE('ALL VARIABLES') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR ANOVA
  /SUMMARY=MEANS
  /ICC=MODEL(MIXED) TYPE(CONSISTENCY) CIN=95 TESTVAL=0.


* Matrix of correlation - exploring variables SCID and BPRS.
CORRELATIONS
  /VARIABLES=BPRS.03 BPRS.13 BPRS.16 BPRS.17 BPRS.05 BPRS.09
  /PRINT=TWOTAIL NOSIG
  /STATISTICS DESCRIPTIVES
  /MISSING=PAIRWISE.
* highest corr depressive mood and guilt feelings (r = .637).
* and excitement and blunted affect (r= -.609)
* everything else was lower than .41.

CORRELATIONS
  /VARIABLES= SCID.CMDS.A1r SCID.CMDS.A2r SCID.CMDS.A3r 
    SCID.CMDS.A4r SCID.CMDS.A5r SCID.CMDS.A6r 
    SCID.CMDS.A7r SCID.CMDS.A8r SCID.CMDS.A9r 
  /PRINT=TWOTAIL NOSIG
  /STATISTICS DESCRIPTIVES
  /MISSING=PAIRWISE.
* fair-strong relationships overall.

CORRELATIONS
  /VARIABLES= BPRS.03 BPRS.13 BPRS.16 BPRS.17 BPRS.05 BPRS.09 WITH
    SCID.CMDS.A1r SCID.CMDS.A2r SCID.CMDS.A3r 
    SCID.CMDS.A4r SCID.CMDS.A5r SCID.CMDS.A6r 
    SCID.CMDS.A7r SCID.CMDS.A8r SCID.CMDS.A9r 
  /PRINT=TWOTAIL NOSIG
  /STATISTICS DESCRIPTIVES
  /MISSING=PAIRWISE.
* fair-strong relationships between guilt/depressive mood and SCID (.36 to .793, most of it was >.45).
* poor-fair relationships between emotiona withdrawal/motor retardation with SCID (.22 to .326)
* no sig. corr between blunted affect/excitement and SCIDs, except one r = .256.


* descriptives.
DESCRIPTIVES VARIABLES=EMS_GM PAE_GM SCHB_GM EMS_pct PAE_pct SCHB_pct
  SCHB_pct_sqrt SCHB_GM_sqrt MOR MOR_pct MOR_pct_sqrt Dep_PC1
  /STATISTICS=MEAN STDDEV RANGE MIN MAX KURTOSIS SKEWNESS.

CORRELATIONS
  /VARIABLES=  Dep_PC1 WITH EMS_GM PAE_GM SCHB_GM EMS_pct PAE_pct SCHB_pct
  SCHB_pct_sqrt SCHB_GM_sqrt MOR MOR_pct MOR_pct_sqrt 
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

CORRELATIONS
  /VARIABLES=  EMS_GM PAE_GM SCHB_GM EMS_pct PAE_pct SCHB_pct
  SCHB_pct_sqrt SCHB_GM_sqrt MOR MOR_pct MOR_pct_sqrt  Dep_PC1
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* EMS.
ONEWAY
  EMS_pct BY Group2
 /CONTRAST = -1 0 1
 /STATISTICS DESCRIPTIVES
 /MISSING ANALYSIS.

* Compute r directly rather than by formula.
RECODE  Group2
  (1 = -1) (2 = 0) (3 = 1) INTO Group2_POS_Wgt.
EXECUTE.

CORRELATIONS
 /VARIABLES= EMS_pct WITH Group2_POS_Wgt 
 /PRINT=TWOTAIL NOSIG
 /MISSING=PAIRWISE.


* PAE.
ONEWAY
  PAE_pct BY Group2
 /CONTRAST = -1 0 1
 /STATISTICS DESCRIPTIVES
 /MISSING ANALYSIS.

CORRELATIONS
 /VARIABLES= PAE_pct WITH Group2_POS_Wgt
 /PRINT=TWOTAIL NOSIG
 /MISSING=PAIRWISE.


* SCHB.
ONEWAY
  SCHB_pct_sqrt BY Group2
 /CONTRAST = 1 0 -1
 /STATISTICS DESCRIPTIVES
 /MISSING ANALYSIS.

* Compute r directly rather than by formula.
RECODE  Group2
  (1 = 1) (2 = 0) (3 = -1) INTO Group2_NEG_Wgt.
EXECUTE.

CORRELATIONS
 /VARIABLES= SCHB_pct_sqrt WITH Group2_NEG_Wgt
 /PRINT=TWOTAIL NOSIG
 /MISSING=PAIRWISE.

*GRAPH
*  /SCATTERPLOT(MATRIX)=Group2_Wgt Group2_NEG_Wgt SCHB_pct_sqrt EMS_pct PAE_pct
*  /MISSING=LISTWISE.

* MOR MOR_pct MOR_pct_sqrt.
CORRELATIONS
  /VARIABLES=Dep_PC1 WITH MOR MOR_pct MOR_pct_sqrt 
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* MOR.
ONEWAY
  MOR BY Group2
 /CONTRAST = 1 0 -1
 /STATISTICS DESCRIPTIVES
 /MISSING ANALYSIS.

* MOR_pct.
ONEWAY
  MOR_pct BY Group2
 /CONTRAST = 1 0 -1
 /STATISTICS DESCRIPTIVES
 /MISSING ANALYSIS.

* MOR_pct_sqrt.
ONEWAY
  MOR_pct_sqrt BY Group2
 /CONTRAST = 1 0 -1
 /STATISTICS DESCRIPTIVES
 /MISSING ANALYSIS.

CORRELATIONS
 /VARIABLES= MOR MOR_pct MOR_pct_sqrt  WITH Group2_NEG_Wgt
 /PRINT=TWOTAIL NOSIG
 /MISSING=PAIRWISE.


* SCHB2_pct_sqrt.
ONEWAY
  SCHB2_pct_sqrt BY Group2
 /CONTRAST = 1 0 -1
 /STATISTICS DESCRIPTIVES
 /MISSING ANALYSIS.

CORRELATIONS
 /VARIABLES= SCHB2_pct_sqrt WITH Group2_NEG_Wgt
 /PRINT=TWOTAIL NOSIG
 /MISSING=PAIRWISE.


CORRELATIONS
  /VARIABLES= EMS_pct PAE_pct SCHB_pct_sqrt MOR_pct_sqrt WITH BPRS.05 BPRS.09 SCID.CMDS.A1r SCID.CMDS.A7r
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.
