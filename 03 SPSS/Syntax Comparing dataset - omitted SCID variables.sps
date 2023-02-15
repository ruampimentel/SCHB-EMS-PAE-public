 * Encoding: windows-1252.

*set work directory.
CD 'C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA 2020\'+
   'Kline\SPSS_archives\Omitted SCID'.


***-------------------------------------------ORGANIZING DATASETS ---------------------------------------------.
*----------------------------------------Get file  --- Ruam's File-----------------------------------.
GET
  FILE='Kline Omitted SCID Vars for Data Entry RP.sav'.
DATASET NAME Kline_omitted_RP WINDOW=FRONT.

*Selecting only double-coded responses.
DATASET COPY  Kline_omitted_17_RP.
DATASET ACTIVATE  Kline_omitted_17_RP.
FILTER OFF.
USE ALL.
SELECT IF ((ID >= 30)  &  (ID<= 48)).
EXECUTE.

*save new dataset as a new file.
SAVE OUTFILE = 'Kline_omitted_17_RP.sav'.

 * Close the datasets no longer needed.
DATASET CLOSE Kline_omitted_RP.



*-----------------------------------------Get file  --- Greg's File---------------------------------------------.
GET
  FILE='Kline Omitted SCID Vars for Data Entry GM.sav'.
DATASET NAME Kline_omitted_GM WINDOW=FRONT.
DATASET ACTIVATE  Kline_omitted_GM.

*Selecting only double-coded responses.
DATASET COPY Kline_omitted_17_GM.
DATASET ACTIVATE  Kline_omitted_17_GM.
FILTER OFF.
USE ALL.
SELECT IF ((ID >= 30)  &  (ID <= 48)).
EXECUTE.

*save new dataset as a new file.
SAVE OUTFILE = 'Kline_omitted_17_GM.sav'.

* Close the datasets no longer needed.
DATASET CLOSE Kline_omitted_GM.


***-------------------------------------COMPARING DATASETS -----------------------------------------------------------.

*This syntax also create other two dataset:
*'Mismatched_kline_omitted' dataset shows all the mismatched cases whereas the 
*'Matched_kline_omitted' shows all the matched cases. 
* Just so we can see it separatly [if needed]. 


*For output consideration:
*Greg's dataset = (1)
*Ruam's dataset = (2)


* OMS.
DATASET DECLARE  mis_by_var.
OMS
  /SELECT TABLES
  /IF COMMANDS=['Compare Datasets'] SUBTYPES=['Mismatched By Variables']
  /DESTINATION FORMAT=SAV NUMBERED=TableNumber_
   OUTFILE='mis_by_var' VIEWER=YES
  /TAG='mis.var'.

DATASET DECLARE Mismatched_kline_omitted.

DATASET DECLARE Matched_kline_omitted.

DATASET ACTIVATE Kline_omitted_17_RP.

SORT CASES BY ID .

DATASET ACTIVATE Kline_omitted_17_GM WINDOW=ASIS.

SORT CASES BY ID .
 
COMPARE DATASETS  
  /COMPDATASET = Kline_omitted_17_RP
  /VARIABLES   SCID1.CMS.NoBasis SCID1.PAS.NNOD SCID1.DDPD.No3 SCID1.DDPD.NonMoodPSx SCID1.BRP.A SCID1.BRP.B 
    SCID1.BRP.C SCID1.BRP.D SCID1.BRP.E SCID1.Sz.A SCID1.Sz.B1 SCID1.Sz.B2 SCID1.Sz.C SCID1.Sz.D 
    SCID1.SzType.PT SCID1.SzType.SPT SCID1.SzType.CT SCID1.SzType.DT SCID1.SzType.UT SCID1.SzType.RT 
    SCID1.Sf.LT6Mo SCID1.SfG.FastOnset SCID1.SfG.Confusion SCID1.SfG.GoodPremorbid 
    SCID1.SfG.NoFlattening SCID1.SfG.2GoodSigns SCID1.SA.A SCID1.SA.B SCID1.SA.Type SCID1.DD.A1 
    SCID1.DD.A2 SCID1.DD.WithMood SCID1.DD.B SCID1.DD.C SCID1.DD.D SCID1.DD.Type SCID1.PDNOS 
    SCID1.Chron.PsychoticMetPM SCID1.Chron.PsychoticMonthsSince SCID1.Mood.NonSA_Mood 
    SCID1.Mood.NeverManicHypomanic SCID1.Mood.PureManic SCID1.Bipolar.Type SCID1.Bipolar.OtherPM 
    SCID1.Mood.PureMajDep SCID1.DepressedOnPsychoticPM SCID1.Chron.MoodMetPM 
    SCID1.Chron.MoodMonthsSince SCID1.Chron.Remission SCID1.Chron.Type.HypoManicMixed 
    SCID1.Chron.Type.Depressed SCID2.CMS.NoBasis SCID2.PAS.NNOD SCID2.DDPD.No3 SCID2.DDPD.NonMoodPSx 
    SCID2.BRP.A SCID2.BRP.B SCID2.BRP.C SCID2.BRP.D SCID2.BRP.E SCID2.Sz.A SCID2.Sz.B1 SCID2.Sz.B2 
    SCID2.Sz.C SCID2.Sz.D SCID2.SzType.PT SCID2.SzType.SPT SCID2.SzType.CT SCID2.SzType.DT 
    SCID2.SzType.UT SCID2.SzType.RT SCID2.Sf.LT6Mo SCID2.SfG.FastOnset SCID2.SfG.Confusion 
    SCID2.SfG.GoodPremorbid SCID2.SfG.NoFlattening SCID2.SfG.2GoodSigns SCID2.SA.A SCID2.SA.B 
    SCID2.SA.Type SCID2.DD.A1 SCID2.DD.A2 SCID2.DD.WithMood SCID2.DD.B SCID2.DD.C SCID2.DD.D 
    SCID2.DD.Type SCID2.PDNOS SCID2.Chron.PsychoticMetPM SCID2.Chron.PsychoticMonthsSince 
    SCID2.Mood.NonSA_Mood SCID2.Mood.NeverManicHypomanic SCID2.Mood.PureManic SCID2.Bipolar.Type 
    SCID2.Bipolar.OtherPM SCID2.Mood.PureMajDep SCID2.DepressedOnPsychoticPM SCID2.Chron.MoodMetPM 
    SCID2.Chron.MoodMonthsSince SCID2.Chron.Remission SCID2.Chron.Type.HypoManicMixed 
    SCID2.Chron.Type.Depressed
  /CASEID  ID 
  /SAVE FLAGMISMATCHES=YES VARNAME=CasesCompare MATCHDATASET=YES MATCHNAME=Matched_kline_omitted 
    MISMATCHDATASET=YES MISMATCHNAME= Mismatched_kline_omitted
  /OUTPUT VARPROPERTIES=NONE CASETABLE=YES TABLELIMIT=NONE.

OMSEND tag='mis.var'.

DATASET ACTIVATE mis_by_var.
FREQUENCIES VARIABLES=Percent
  /FORMAT=NOTABLE
  /STATISTICS=MINIMUM MAXIMUM MEAN MEDIAN MODE
  /ORDER=ANALYSIS.

SORT CASES BY Percent(D).

DATASET CLOSE mis_by_var.

* Export Output.
OUTPUT EXPORT
  /CONTENTS  EXPORT=ALL  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING
  /XLSX  DOCUMENTFILE= 'OUTPUT_comparing_kline_omitted_data_entry.xlsx'
     OPERATION=CREATEFILE
     LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.

OUTPUT SAVE NAME=Document1
 OUTFILE='OUTPUT_comparing_kline_omitted_data_entry.spv'
 LOCK=NO.












