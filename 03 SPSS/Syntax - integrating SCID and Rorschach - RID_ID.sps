* Encoding: windows-1252.

* working directory.
CD 'C:\Users\ruamp\OneDrive - University of Toledo\Conferences\'+
'SPA 2020\Kline\SPSS_archives\Reviewed - FINAL\FINAL FILES'.

* open dataset.
GET
  FILE='Kline Db Complete - SCID Updated & Recoded.sav'.
DATASET NAME kline WINDOW=FRONT.

*fixing a new typo.
DO IF (ID = 37).
RECODE SCID1.CMDS.A2 (ELSE=1).
END IF.

DO IF (ID = 32).
RECODE  Dx1 (ELSE=2).
END IF.
EXECUTE.

* recoding into differet variable (CMDS) for 0, 0.5, 1 and change labels.
RECODE SCID1.CMDS.A1 SCID1.CMDS.A2 SCID1.CMDS.A3 
    SCID1.CMDS.A4 SCID1.CMDS.A5 SCID1.CMDS.A6 
    SCID1.CMDS.A7 SCID1.CMDS.A8 SCID1.CMDS.A9 
    SCID2.CMDS.A1 SCID2.CMDS.A2 SCID2.CMDS.A3 
    SCID2.CMDS.A4 SCID2.CMDS.A5 SCID2.CMDS.A6 
    SCID2.CMDS.A7 SCID2.CMDS.A8 SCID2.CMDS.A9 (1=0) (2=0.5) (3=1) INTO 
    SCID1.CMDS.A1r SCID1.CMDS.A2r SCID1.CMDS.A3r 
    SCID1.CMDS.A4r SCID1.CMDS.A5r SCID1.CMDS.A6r 
    SCID1.CMDS.A7r SCID1.CMDS.A8r SCID1.CMDS.A9r 
    SCID2.CMDS.A1r SCID2.CMDS.A2r SCID2.CMDS.A3r 
    SCID2.CMDS.A4r SCID2.CMDS.A5r SCID2.CMDS.A6r 
    SCID2.CMDS.A7r SCID2.CMDS.A8r SCID2.CMDS.A9r .
VARIABLE LABELS SCID1.CMDS.A1r 'Curr: Depressed mood'
   /SCID1.CMDS.A2r 'Curr: Diminished interest or pleasure '
   /SCID1.CMDS.A3r 'Curr: Weight loss or gain '
   /SCID1.CMDS.A4r 'Curr: Insomnia or hypersomnia '
   /SCID1.CMDS.A5r 'Curr: Agitation or retardation '
   /SCID1.CMDS.A6r 'Curr: Fatigue or loss of energy '
   /SCID1.CMDS.A7r 'Curr: Worthlessness or guilt '
   /SCID1.CMDS.A8r 'Curr: Diminished concentration or indecisive '
   /SCID1.CMDS.A9r 'Curr: Suicidality '
   /SCID2.CMDS.A1r 'Curr: Depressed mood'
   /SCID2.CMDS.A2r 'Curr: Diminished interest or pleasure '
   /SCID2.CMDS.A3r 'Curr: Weight loss or gain '
   /SCID2.CMDS.A4r 'Curr: Insomnia or hypersomnia '
   /SCID2.CMDS.A5r 'Curr: Agitation or retardation '
   /SCID2.CMDS.A6r 'Curr: Fatigue or loss of energy '
   /SCID2.CMDS.A7r 'Curr: Worthlessness or guilt '
   /SCID2.CMDS.A8r 'Curr: Diminished concentration or indecisive '
   /SCID2.CMDS.A9r 'Curr: Suicidality '.
VALUE LABELS SCID1.CMDS.A1r SCID1.CMDS.A2r SCID1.CMDS.A3r 
    SCID1.CMDS.A4r SCID1.CMDS.A5r SCID1.CMDS.A6r 
    SCID1.CMDS.A7r SCID1.CMDS.A8r SCID1.CMDS.A9r 
    SCID2.CMDS.A1r SCID2.CMDS.A2r SCID2.CMDS.A3r 
    SCID2.CMDS.A4r SCID2.CMDS.A5r SCID2.CMDS.A6r 
    SCID2.CMDS.A7r SCID2.CMDS.A8r SCID2.CMDS.A9r
  .00 'Absent or False'
  .50 'Subthreshold'
  1.00 'Threshold or True'.
EXECUTE.
* I didn't include the "Inadequate information" label because there was no instance
* in which the value of the CMDS A1-A9 was equal zero. 
* The only instance was a typo (ID = 37, SCID.CMDS.A2).


* CMDS COMPOSITES.
* composites used for the ICC (composites are not computed when thre is a missing case, 
* result would be missing).
COMPUTE SCID1.CMDS.composite=MEAN(SCID1.CMDS.A1r,SCID1.CMDS.A2r,SCID1.CMDS.A3r,SCID1.CMDS.A4r,
    SCID1.CMDS.A5r,SCID1.CMDS.A6r,SCID1.CMDS.A7r,SCID1.CMDS.A8r,SCID1.CMDS.A9r).
COMPUTE SCID2.CMDS.composite=MEAN(SCID2.CMDS.A1r,SCID2.CMDS.A2r,SCID2.CMDS.A3r,SCID2.CMDS.A4r,
    SCID2.CMDS.A5r,SCID2.CMDS.A6r,SCID2.CMDS.A7r,SCID2.CMDS.A8r,SCID2.CMDS.A9r).
EXECUTE.



* unified CMDS and Important BPRS items.COMPUTE SCID.CMDS.A1 = MEAN(SCID1.CMDS.A1,SCID2.CMDS.A1).
* missing values are ok.
COMPUTE SCID.CMDS.A1r = MEAN(SCID1.CMDS.A1r,SCID2.CMDS.A1r).
COMPUTE SCID.CMDS.A2r = MEAN(SCID1.CMDS.A2r,SCID2.CMDS.A2r).
COMPUTE SCID.CMDS.A3r = MEAN(SCID1.CMDS.A3r,SCID2.CMDS.A3r).
COMPUTE SCID.CMDS.A4r = MEAN(SCID1.CMDS.A4r,SCID2.CMDS.A4r).
COMPUTE SCID.CMDS.A5r = MEAN(SCID1.CMDS.A5r,SCID2.CMDS.A5r).
COMPUTE SCID.CMDS.A6r = MEAN(SCID1.CMDS.A6r,SCID2.CMDS.A6r).
COMPUTE SCID.CMDS.A7r = MEAN(SCID1.CMDS.A7r,SCID2.CMDS.A7r).
COMPUTE SCID.CMDS.A8r = MEAN(SCID1.CMDS.A8r,SCID2.CMDS.A8r).
COMPUTE SCID.CMDS.A9r = MEAN(SCID1.CMDS.A9r,SCID2.CMDS.A9r).
COMPUTE BPRS.03 = MEAN(BPRS1.03 , BPRS2.03 ).
COMPUTE BPRS.05 = MEAN(BPRS1.05 , BPRS2.05 ).
COMPUTE BPRS.09 = MEAN(BPRS1.09 , BPRS2.09 ).
COMPUTE BPRS.13 = MEAN(BPRS1.13 , BPRS2.13 ).
COMPUTE BPRS.16 = MEAN(BPRS1.16 , BPRS2.16 ).
COMPUTE BPRS.17 = MEAN(BPRS1.17 , BPRS2.17 ).
EXECUTE.

* Define Variable Properties.
* is there a better wat to do that?.
VARIABLE LABELS  SCID.CMDS.A1r 'Curr: Depressed mood'.
VARIABLE LABELS  SCID.CMDS.A2r 'Curr: Diminished interest or pleasure '.
VARIABLE LABELS  SCID.CMDS.A3r 'Curr: Weight loss or gain '.
VARIABLE LABELS  SCID.CMDS.A4r 'Curr: Insomnia or hypersomnia '.
VARIABLE LABELS  SCID.CMDS.A5r 'Curr: Agitation or retardation '.
VARIABLE LABELS  SCID.CMDS.A6r 'Curr: Fatigue or loss of energy '.
VARIABLE LABELS  SCID.CMDS.A7r 'Curr: Worthlessness or guilt '.
VARIABLE LABELS  SCID.CMDS.A8r 'Curr: Diminished concentration or indecisive '.
VARIABLE LABELS  SCID.CMDS.A9r 'Curr: Suicidality '.
VARIABLE LABELS  BPRS.03 'Emotional Withdrawal '.
VARIABLE LABELS  BPRS.05 'Guilt Feelings '.
VARIABLE LABELS  BPRS.09 'Depressive Mood '.
VARIABLE LABELS  BPRS.13 'Motor Retardation '.
VARIABLE LABELS  BPRS.16 'Blunted Affect '.
VARIABLE LABELS  BPRS.17 'Excitement '.
EXECUTE.


* final component - extracting factorial scores.
FACTOR
  /VARIABLES SCID.CMDS.A1r SCID.CMDS.A2r SCID.CMDS.A3r SCID.CMDS.A4r SCID.CMDS.A5r SCID.CMDS.A6r 
    SCID.CMDS.A7r SCID.CMDS.A8r SCID.CMDS.A9r BPRS.05 BPRS.09
  /MISSING LISTWISE 
  /ANALYSIS SCID.CMDS.A1r SCID.CMDS.A2r SCID.CMDS.A3r SCID.CMDS.A4r SCID.CMDS.A5r SCID.CMDS.A6r 
    SCID.CMDS.A7r SCID.CMDS.A8r SCID.CMDS.A9r BPRS.05 BPRS.09
  /PRINT INITIAL KMO EXTRACTION DEFAULT
  /FORMAT SORT
  /PLOT EIGEN
  /CRITERIA FACTORS(1) ITERATE(25)
  /EXTRACTION PC
  /METHOD=CORRELATION
  /SAVE = REG(1,Dep_PC).
* interpretation = Dep_PC are z-scores.


* Creating count of N and SCHB, EMS and PAE per subject ---------------------------------------------------.
* open dataset with SCHB, EMS, PAE.
GET DATA
  /TYPE=XLSX
  /FILE= 'Kline Protocols R-ID - All with Updated '+
         'GM SCHB and EMS.xlsx'
  /SHEET=name 'Sheet1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME new_dep_codes WINDOW=FRONT.


RECODE SCHB_GM (0=0) (1=0) (2=1) INTO SCHB2_GM.
EXECUTE.

* OMS.
DATASET DECLARE  new_dep_codes_sum.
OMS
  /SELECT TABLES
  /IF COMMANDS=['OLAP Cubes'] SUBTYPES=['Layered Reports']
  /DESTINATION FORMAT=SAV NUMBERED=TableNumber_
   OUTFILE='new_dep_codes_sum' VIEWER=YES
  /TAG='codes_sum'.


DATASET ACTIVATE new_dep_codes.
SORT CASES  BY RID.
SPLIT FILE LAYERED BY RID.
OLAP CUBES SCHB_GM SCHB2_GM EMS_GM PAE_GM
  /CELLS=SUM COUNT
  /TITLE='OLAP Cubes'.
SPLIT FILE OFF.

* OMSEND.
OMSEND TAG=['codes_sum'].
 
DATASET DECLARE  new_dep_codes_sum.
DELETE VARIABLES  TableNumber_ Command_ Subtype_ Label_.
EXECUTE.

RENAME VARIABLES ( Var1 Var2 = RID codes).
EXECUTE.

* Define Variable Properties.
ALTER TYPE  RID(F3.0).
VARIABLE LEVEL  RID(SCALE).
FORMATS  RID(F3.0).
EXECUTE.

* restructuring file.
SORT CASES BY RID codes.
CASESTOVARS
  /ID=RID
  /INDEX=codes.

COMPUTE EMS_pct=EMS_GM / N.
COMPUTE PAE_pct= PAE_GM/ N.
COMPUTE SCHB_pct= SCHB_GM / N.
COMPUTE SCHB2_pct= SCHB2_GM / N.
EXECUTE.



* transformations and computing new variables.
COMPUTE SCHB_pct_sqrt = SQRT(SCHB_pct).
COMPUTE SCHB_GM_sqrt  = SQRT(SCHB_GM).
COMPUTE SCHB2_pct_sqrt = SQRT(SCHB2_pct).
EXECUTE.

VARIABLE LABELS SCHB_pct_sqrt  'square root of SCHB_pct'
   /SCHB_GM_sqrt 'square root of SCHB_GM'.
EXECUTE.


* merging datasets.

GET DATA
  /TYPE=XLSX
  /FILE='Kline ID Key for Rorschach Protocols.xlsx'
  /SHEET=name 'Kline ID Key'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME RID_ID.
DELETE VARIABLES  RID_Recalculating RID_With2Duplicates Order.


DATASET ACTIVATE new_dep_codes_sum.
SORT CASES BY RID.
DATASET ACTIVATE RID_ID.
SORT CASES BY RID.
DATASET ACTIVATE new_dep_codes_sum.
MATCH FILES /FILE=*
  /FILE='RID_ID'
  /BY RID.
EXECUTE.


DATASET ACTIVATE kline.
SORT CASES BY ID.
DATASET ACTIVATE new_dep_codes_sum.
SORT CASES BY ID.
DATASET ACTIVATE kline.
MATCH FILES /FILE=*
  /FILE='new_dep_codes_sum'
  /BY ID.
EXECUTE.

RENAME VARIABLES(N = Rorschach_N ).
VARIABLE LABELS Rorschach_N 'Number of responses in the Rorschach protocol'
   /EMS_pct 'EMS divided by Rorschach_N'
   /PAE_pct 'PAE divided by Rorschach_N'
   /SCHB_pct 'SCHB divided by Rorschach_N'.
EXECUTE.


COMPUTE Group2 = 0.
IF (Group = 1) Group2 = 1.
IF (Group = 2 AND SCID.CMDS.A1r > .5 AND (SCID.CMDS.A7r > .5 OR SCID.CMDS.A9r > .5 )) Group2 = 1.
IF (Group = 3) Group2 = 2.
IF (Group = 4) Group2 = 3.
IF (Group = 5) Group2 = 3.
IF (Group = 6) Group2 = 3.
IF (Group = 7) Group2 = 3.
IF (Group2 = 0) Group2 = 3.
EXECUTE.

DATASET CLOSE RID_ID.
DATASET CLOSE new_dep_codes.
DATASET CLOSE new_dep_codes_sum.


* including Jessas protocols.
GET DATA
  /TYPE=XLSX
  /FILE='Jessa Coded Responses - Kline Dataset 04-23-2020.xlsx'
  /SHEET=name 'Responses (2)'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME Jessa.

DELETE VARIABLES AccountOwner to  PER
         AGP to CP . 

* OMS.
DATASET DECLARE  mor_protocol.
OMS
  /SELECT TABLES
  /IF COMMANDS=['OLAP Cubes'] SUBTYPES=['Layered Reports']
  /DESTINATION FORMAT=SAV NUMBERED=TableNumber_
   OUTFILE='mor_protocol' VIEWER=YES
  /TAG='mor_count'.

DATASET ACTIVATE Jessa.
SORT CASES  BY CID.
SPLIT FILE LAYERED BY CID.
OLAP CUBES MOR
  /CELLS=SUM COUNT
  /TITLE='OLAP Cubes'.
SPLIT FILE OFF.

* OMSEND.
OMSEND TAG=['mor_count'].

DATASET DECLARE  mor_protocol.
DELETE VARIABLES  TableNumber_ Command_ Subtype_ Label_ Var2.
EXECUTE.

RENAME VARIABLES(Sum = MOR).
RENAME VARIABLES(N = N_jessa).
VARIABLE LABELS MOR 'Number of Morbid responses in the protocol'.
EXECUTE.

STRING ID (a3).
COMPUTE ID = char.substr(Var1,2).
EXECUTE.

ALTER TYPE  ID(F3.0).
VARIABLE LEVEL  ID(SCALE).
FORMATS  ID(F3.0).
EXECUTE.

DELETE VARIABLES Var1.
EXECUTE.


* computing new variables.
COMPUTE MOR_pct = MOR/N_jessa.
EXECUTE.



* transformations and computing new variables.
COMPUTE MOR_pct_sqrt = SQRT(MOR_pct).
EXECUTE.

VARIABLE LABELS MOR_pct_sqrt  'square root of MOR_pct'.
EXECUTE.

DATASET ACTIVATE kline.
SORT CASES BY ID.
DATASET ACTIVATE mor_protocol.
SORT CASES BY ID.
DATASET ACTIVATE kline.
MATCH FILES /FILE=*
  /FILE='mor_protocol'
  /BY ID.
EXECUTE.

* integrating complexity from Jessa protocol level.
GET DATA
  /TYPE=XLSX
  /FILE='C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA '+
    '2020\Kline\SPSS_archives\Reviewed - FINAL\FINAL FILES\Jessa Coded Protocols - Kline Dataset.xlsx'
  /SHEET=name 'Sheet1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME Jessa_protocol_lvl WINDOW=FRONT.

DELETE VARIABLES   AccountOwner to CritCont_Per
W_SI_Sy to CFC_Min_FC.
EXECUTE.


STRING ID (a3).
COMPUTE ID = char.substr(CID,2).
EXECUTE.

ALTER TYPE  ID(F3.0).
VARIABLE LEVEL  ID(SCALE).
FORMATS  ID(F3.0).
EXECUTE.

DELETE VARIABLES CID.
EXECUTE.


DATASET ACTIVATE kline.
SORT CASES BY ID.
DATASET ACTIVATE Jessa_protocol_lvl.
SORT CASES BY ID.
DATASET ACTIVATE kline.
MATCH FILES /FILE=*
  /FILE='Jessa_protocol_lvl'
  /BY ID.
EXECUTE.


FILTER OFF.
USE ALL.
SELECT IF (ID<> 11 AND ID<> 43 AND ID <> 44 AND ID <> 49 AND ID <> 55).
EXECUTE.

DATASET ACTIVATE kline.
SAVE OUTFILE='Kline Db Complete - SCID Updated & Recoded - SCHB, EMS, PAE, MOR, Complexity included.sav'
  /COMPRESSED.




