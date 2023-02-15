* Encoding: windows-1252.

* My directory ---------------------------------------------------------------------------.
CD 'C:\Users\ruamp\OneDrive - University of Toledo\Conferences\'+
'SPA 2020\Kline\SPSS_archives\Reviewed - FINAL'.

* Open file --------------------------------------------------------------------------------.
GET 
  FILE = 'Kline_complete_2 - testing.sav'.
DATASET NAME Kline WINDOW=FRONT.
SORT CASES BY ID.

* Before testing the syntax in an old dataset, include the new variables (omitted) -----------.

* Open file.
GET 
  FILE = 'Kline_omitted_complete - Copy.sav'.
DATASET NAME Kline_omitted WINDOW=FRONT.
SORT CASES BY ID.

* merge files.
DATASET ACTIVATE Kline.
MATCH FILES /FILE=*
  /FILE='Kline_omitted'
  /BY ID.
EXECUTE.

* use TO and separate by cluster! (REDO).
*Reorder variables .
ADD FILES FILE *
/KEEP ID to SCID1.PMDS.Age 
      SCID1.CMS.NoBasis 
      SCID1.CMS.A1 to SCID1.PAS.DO5 
      SCID1.PAS.NNOD 
      SCID1.PAS.D6 to SCID1.PAS.PastMonth 
      SCID1.DDPD.No3 SCID1.DDPD.NonMoodPSx SCID1.BRP.A SCID1.BRP.B SCID1.BRP.C SCID1.BRP.D 
      SCID1.BRP.E SCID1.Sz.A SCID1.Sz.B1 SCID1.Sz.B2 SCID1.Sz.C SCID1.Sz.D SCID1.SzType.PT SCID1.SzType.SPT SCID1.SzType.CT 
      SCID1.SzType.DT SCID1.SzType.UT SCID1.SzType.RT SCID1.Sf.LT6Mo SCID1.SfG.FastOnset SCID1.SfG.Confusion SCID1.SfG.GoodPremorbid
      SCID1.SfG.NoFlattening SCID1.SfG.2GoodSigns SCID1.SA.A SCID1.SA.B SCID1.SA.Type SCID1.DD.A1 SCID1.DD.A2 SCID1.DD.WithMood 
      SCID1.DD.B SCID1.DD.C SCID1.DD.D SCID1.DD.Type SCID1.PDNOS SCID1.Chron.PsychoticMetPM 
      SCID1.Chron.PsychoticMonthsSince 
      SCID1.Chron.PsychoticPMSev to SCID1.Chron.PsychoticNum 
      SCID1.Mood.NonSA_Mood SCID1.Mood.NeverManicHypomanic
      SCID1.Mood.PureManic SCID1.Bipolar.Type SCID1.Bipolar.OtherPM SCID1.Mood.PureMajDep SCID1.DepressedOnPsychoticPM 
      SCID1.Chron.MoodMetPM SCID1.Chron.MoodMonthsSince SCID1.Chron.Remission SCID1.Chron.Type.HypoManicMixed  
      SCID1.Chron.Type.Depressed SCID1.Chron.MoodP5YSev 
      SCID2.Interviewer to SCID2.PMDS.Age 
      SCID2.CMS.NoBasis 
      SCID2.CMS.A1 to SCID2.PAS.DO5 
      SCID2.PAS.NNOD 
      SCID2.PAS.D6 to SCID2.PAS.PastMonth 
      SCID2.DDPD.No3 SCID2.DDPD.NonMoodPSx SCID2.BRP.A SCID2.BRP.B SCID2.BRP.C SCID2.BRP.D 
      SCID2.BRP.E SCID2.Sz.A SCID2.Sz.B1 SCID2.Sz.B2 SCID2.Sz.C SCID2.Sz.D SCID2.SzType.PT SCID2.SzType.SPT SCID2.SzType.CT 
      SCID2.SzType.DT SCID2.SzType.UT SCID2.SzType.RT SCID2.Sf.LT6Mo SCID2.SfG.FastOnset SCID2.SfG.Confusion SCID2.SfG.GoodPremorbid
      SCID2.SfG.NoFlattening SCID2.SfG.2GoodSigns SCID2.SA.A SCID2.SA.B SCID2.SA.Type SCID2.DD.A1 SCID2.DD.A2 SCID2.DD.WithMood 
      SCID2.DD.B SCID2.DD.C SCID2.DD.D SCID2.DD.Type SCID2.PDNOS SCID2.Chron.PsychoticMetPM 
      SCID2.Chron.PsychoticMonthsSince 
      SCID2.Chron.PsychoticPMSev to SCID2.Chron.PsychoticNum 
      SCID2.Mood.NonSA_Mood SCID2.Mood.NeverManicHypomanic
      SCID2.Mood.PureManic SCID2.Bipolar.Type SCID2.Bipolar.OtherPM SCID2.Mood.PureMajDep SCID2.DepressedOnPsychoticPM 
      SCID2.Chron.MoodMetPM SCID2.Chron.MoodMonthsSince SCID2.Chron.Remission SCID2.Chron.Type.HypoManicMixed  
      SCID2.Chron.Type.Depressed SCID2.Chron.MoodP5YSev.
EXECUTE.


* save file ----------------------------------------------------------------------------.
SAVE OUTFILE='Kline_3 - testing.sav'
  /COMPRESSED.
