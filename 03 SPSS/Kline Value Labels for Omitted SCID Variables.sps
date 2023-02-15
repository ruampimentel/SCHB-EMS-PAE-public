
* Encoding: windows-1252.
* After copying and pasting from Excel to start the data file, assign value labels.

* First, assign variable formatting. No variables need to be alphanumeric.
FORMATS ID TO SCID2.Chron.Type.Depressed (F8.0).

VALUE LABELS
  SCID1.CMS.NoBasis SCID1.PAS.NNOD SCID1.DDPD.No3
  SCID1.Mood.NonSA_Mood SCID1.Mood.NeverManicHypomanic
  SCID1.Bipolar.OtherPM
  SCID1.DepressedOnPsychoticPM
  SCID2.CMS.NoBasis SCID2.PAS.NNOD SCID2.DDPD.No3
  SCID2.Mood.NonSA_Mood SCID2.Mood.NeverManicHypomanic
  SCID2.Bipolar.OtherPM
  SCID2.DepressedOnPsychoticPM
  3 'Check'
 /SCID1.DDPD.NonMoodPSx SCID1.BRP.A SCID1.BRP.B
  SCID1.Sz.A SCID1.Sz.B1 SCID1.Sz.B2 SCID1.Sz.C
  SCID1.SzType.PT SCID1.SzType.SPT SCID1.SzType.CT SCID1.SzType.DT SCID1.SzType.UT SCID1.SzType.RT
  SCID1.SfG.FastOnset SCID1.SfG.Confusion SCID1.SfG.GoodPremorbid SCID1.SfG.NoFlattening
  SCID1.SA.A
  SCID1.DD.A1 SCID1.DD.A2
  SCID1.DD.B SCID1.DD.C
  SCID1.Chron.PsychoticMetPM
  SCID1.Chron.MoodMetPM
  SCID2.DDPD.NonMoodPSx SCID2.BRP.A SCID2.BRP.B
  SCID2.Sz.A SCID2.Sz.B1 SCID2.Sz.B2 SCID2.Sz.C
  SCID2.SzType.PT SCID2.SzType.SPT SCID2.SzType.CT SCID2.SzType.DT SCID2.SzType.UT SCID2.SzType.RT
  SCID2.SfG.FastOnset SCID2.SfG.Confusion SCID2.SfG.GoodPremorbid SCID2.SfG.NoFlattening
  SCID2.SA.A
  SCID2.DD.A1 SCID2.DD.A2
  SCID2.DD.B SCID2.DD.C
  SCID2.Chron.PsychoticMetPM
  SCID2.Chron.MoodMetPM
  0 'Inadequate Info'
  1 'Absent or False'
  3 'Threshold or True'
 /SCID1.BRP.C SCID1.BRP.D
  SCID2.BRP.C SCID2.BRP.D
  0 'Inadequate Info'
  1 'Absent or False'
  2 'Subthreshold'
  3 'Threshold or True'
 /SCID1.BRP.E
  SCID2.BRP.E
  0 'Inadequate Info'
  1 'Absent or False'
  2 'Provisional BRP'
  3 'Brief Reactive Psychosis'
 /SCID1.Sz.D
  SCID2.Sz.D
  0 'Inadequate Info'
  1 'Absent or False'
  3 'Schizophrenia'
 /SCID1.Sf.LT6Mo
  SCID2.Sf.LT6Mo
  2 'Provisional SfD'
  3 'Schizophreniform Disorder'
 /SCID1.SfG.2GoodSigns
  SCID2.SfG.2GoodSigns
  1 'SfD - Not Good Prognosis'
  3 'SfD - Good Prognosis'
 /SCID1.SA.B
  SCID2.SA.B
  0 'Inadequate Info'
  1 'Psychotic Mood Disorder'
  3 'Schizoaffective Disorder'
 /SCID1.SA.Type
  SCID2.SA.Type
  0 'Inadequate Info'
  1 'SA - Depressed Type'
  3 'SA - Bipolar Type'
 /SCID1.DD.WithMood
  SCID2.DD.WithMood
  0 'Inadequate Info'
  1 'Absent or False'
  3 'Psychotic Mood Disorder'
 /SCID1.DD.D
  SCID2.DD.D
  0 'Inadequate Info'
  1 'Absent or False'
  3 'Delusional Disorder'
 /SCID1.DD.Type
  SCID2.DD.Type
  1 'Persecutory'
  2 'Jealous'
  3 'Erotomanic'
  4 'Somatic'
  5 'Grandiose'
  6 'Other'
 /SCID1.PDNOS
  SCID2.PDNOS
  3 'Psychotic Disorder NOS'
 /SCID1.Mood.PureManic
  SCID2.Mood.PureManic
  0 'Inadequate Info'
  1 'Absent or False'
  3 'Bipolar Disorder'
 /SCID1.Bipolar.Type
  SCID2.Bipolar.Type
  1 'Manic'
  2 'Depressed'
  3 'Mixed'
 /SCID1.Mood.PureMajDep
  SCID2.Mood.PureMajDep
  0 'Inadequate Info'
  1 'Absent or False'
  3 'Major Depression'
 /SCID1.Chron.Remission
  SCID2.Chron.Remission
  6 'Partial Remission'
  7 'Full Remission'
 /SCID1.Chron.Type.HypoManicMixed SCID1.Chron.Type.Depressed
  SCID2.Chron.Type.HypoManicMixed SCID2.Chron.Type.Depressed
  1 'Mild'
  2 'Moderate'
  3 'Severe'
  4 'Mood-Congruent Psychotic'
  5 'Mood-Incongruent Psychotic'.

CD 'C:\Users\gmeyer\Dropbox\My Documents\The R-PAS\Research Projects\Kline Protocols'.

SAVE OUTFILE=
  'Kline Omitted SCID Vars for Data Entry.sav'
 /COMPRESSED.
