
* Encoding: windows-1252.
* After copying and pasting from Excel to start the data file, assign value labels.

* First, assign variable types.
FORMATS ID TO SCID2.Chron.MoodP5YSev (F8.0).
ALTER TYPE Meds1 TO Meds6 (A25) CR_AxisI.1 TO CR_AxisII.2 (A60) SCID1.PAS.Dates SCID2.PAS.Dates (A60).

VALUE LABELS
  Dx1 Dx2 Group
  1 'Dep'
  2 'SA Dep'
  3 'SA BP'
  4 'Sz Par'
  5 'Sz Disorg'
  6 'Sz Undiff'
  7 'Sz Resid'
 /Drugs
  0 'Unknown'
  1 'Yes, in last 6 months'
  2 'No or Deny'
  3 'History, more than 6 months ago'
 /Ethnicity
  1 'Black'
  2 'Hispanic'
  3 'White'
  4 'Native Amer'
  5 'Asian'
 /Marital
  1 'Never Married'
  2 'Married Once'
  3 'Divorced'
  4 'Divorced & Remarried'
  5 'Widowed'
 /Hospital
  1 '< 4 (weeks?)'
  2 '1-4 (months?)'
  3 '> 4 (months?)'
 /Home
  1 'Family'
  2 'Independent Living'
  3 'Residential Program'
  4 'B&C'
  5 'L-Facility'
  6 'Jail'
  7 'Homeless'
 /Education
  1 '<= 6th Grade'
  2 'Grade 7-12'
  3 'HS Grad or GED'
  4 'Some College'
  5 'Grad 2 Year College'
  6 'Grad 4 Year College'
  7 'Some Graduate or Professional School'
  8 'Completed Graduate or Professional School'
 /BPRS1.01 TO BPRS2.18
  1 'Not Present'
  2 'Very Mild'
  3 'Mild'
  4 'Moderate'
  5 'Moderately Severe'
  6 'Severe'
  7 'Extremely Severe'
 /PANAS01 TO PANAS20
  1 'Very Slightly'
  2 'A Little'
  3 'Moderately'
  4 'Quite a Bit'
  5 'Extremely'
 /ISI01 TO ISI55
  1 'Feel Comfortable & Handle OK'
  2 'Feel Uncomfortable but Handle OK'
  3 'Feel Comfortable & Not Handle OK'
  4 'Feel Uncomfortable & Not Handle OK'
  5 'Not Relevant'
 /IBRT01 TO IBRT25
  1 'No Criteria Met'
  2 'Some Criteria Met'
  3 'All Criteria Met'
 /Faces01 TO Faces40 
  1 'Neutral'
  2 'Surprise'
  3 'Distress (Sadness)'
  4 'Fear'
  5 'Shame'
  6 'Interest'
  7 'Contempt'
  8 'Disgust'
  9 'Anger'
 10 'Joy (Happy)'
 /Gender
  1 'Male'
  2 'Female'
 /BentonX01 TO BentonX27
  1 'Correct'
  2 'Incorrect'
 /CR_Reviewer SCID1.Interviewer SCID2.Interviewer
  1 'Jeff Kline'
  2 'Kate Mehler'
  3 'C Vavak'
  4 'Phil Alex'
  5 'Judie Bowman'
  6 'Phyllis Lee'
 /SCID1.Observer SCID2.Observer
  0 'None'
  1 'Jeff Kline'
  2 'Kate Mehler'
  3 'C Vavak'
  4 'Phil Alex'
  5 'Judie Bowman'
  6 'Phyllis Lee'
 /SCID1.SumBP.LP SCID1.SumOBP.LP SCID1.SumMD.LP SCID1.SumDys.LP 
  SCID1.SumSz.LP SCID1.SumSf.LP SCID1.SumSA.LP SCID1.SumDD.LP SCID1.SumBRP.LP SCID1.SumPDNOS.LP
  SCID1.CMDS.A1 TO SCID1.CMDS.A9
  SCID1.PMDS.A1 TO SCID1.PMDS.A9
  SCID1.CMS.A1 TO SCID1.CMS.B7
  SCID1.PMS.A1 TO SCID1.PMS.B7
  SCID1.PAS.D1 SCID1.PAS.D2 SCID1.PAS.D3 SCID1.PAS.D4 SCID1.PAS.D5 SCID1.PAS.D6 SCID1.PAS.D7 SCID1.PAS.D8 SCID1.PAS.D9
  SCID1.PAS.H1 SCID1.PAS.H2 SCID1.PAS.H3 SCID1.PAS.H4 SCID1.PAS.H5 SCID1.PAS.H6 SCID1.PAS.H7
  SCID1.PAS.CB SCID1.PAS.FA SCID1.PAS.GIA SCID1.PAS.Inc SCID1.PAS.MLA SCID1.PAS.ET
  SCID2.SumBP.LP SCID2.SumOBP.LP SCID2.SumMD.LP SCID2.SumDys.LP 
  SCID2.SumSz.LP SCID2.SumSf.LP SCID2.SumSA.LP SCID2.SumDD.LP SCID2.SumBRP.LP SCID2.SumPDNOS.LP
  SCID2.CMDS.A1 TO SCID2.CMDS.A9
  SCID2.PMDS.A1 TO SCID2.PMDS.A9
  SCID2.CMS.A1 TO SCID2.CMS.B7
  SCID2.PMS.A1 TO SCID2.PMS.B7
  SCID2.PAS.D1 SCID2.PAS.D2 SCID2.PAS.D3 SCID2.PAS.D4 SCID2.PAS.D5 SCID2.PAS.D6 SCID2.PAS.D7 SCID2.PAS.D8 SCID2.PAS.D9
  SCID2.PAS.H1 SCID2.PAS.H2 SCID2.PAS.H3 SCID2.PAS.H4 SCID2.PAS.H5 SCID2.PAS.H6 SCID2.PAS.H7
  SCID2.PAS.CB SCID2.PAS.FA SCID2.PAS.GIA SCID2.PAS.Inc SCID2.PAS.MLA SCID2.PAS.ET
  0 'Inadequate Info'
  1 'Absent or False'
  2 'Subthreshold'
  3 'Threshold or True'
 /SCID1.SumDSonCP.LP SCID1.CMDS.B1 SCID1.CMDS.B2 SCID1.PMDS.B1 SCID1.PMDS.B2 SCID1.CMS.D SCID1.PMS.D
  SCID2.SumDSonCP.LP SCID2.CMDS.B1 SCID2.CMDS.B2 SCID2.PMDS.B1 SCID2.PMDS.B2 SCID2.CMS.D SCID2.PMS.D
  0 'Inadequate Info'
  1 'Absent or False'
  3 'Threshold or True'
 /SCID1.SumSz.PM.Type SCID2.SumSz.PM.Type
  1 'Paranoid'
  2 'Catatonic'
  3 'Disorganized'
  4 'Undifferentiated'
  5 'Residual'
 /SCID1.SumBP.PM.Type SCID2.SumBP.PM.Type
  1 'Manic'
  2 'Depressed'
  3 'Mixed'
 /SCID1.Source1 SCID1.Source2 SCID1.Source3 
  SCID1.SumBP.PM SCID1.SumOBP.PM SCID1.SumMD.PM SCID1.SumDSonCP.PM 
  SCID1.SumSz.PM SCID1.SumSf.PM SCID1.SumSA.PM SCID1.SumDD.PM SCID1.SumBRP.PM SCID1.SumPDNOS.PM 
  SCID1.CMDS.A5p SCID1.CMDS.AB SCID1.PMDS.A5p SCID1.PMDS.AB 
  SCID1.CMS.B3p SCID1.CMS.C SCID1.CMS.ABC 
  SCID1.PMS.B3p SCID1.PMS.C SCID1.PMS.ABC 
  SCID1.PAS.DO1 SCID1.PAS.DO2 SCID1.PAS.DO3 SCID1.PAS.DO4 SCID1.PAS.DO5 SCID1.PAS.DO6 SCID1.PAS.DO7 SCID1.PAS.DO8 SCID1.PAS.DO9 
  SCID1.PAS.HO1 SCID1.PAS.HO5 SCID1.PAS.HO6 SCID1.PAS.HO7 
  SCID1.PAS.CBO SCID1.PAS.FAO SCID1.PAS.GIAO SCID1.PAS.IncO SCID1.PAS.MLAO SCID1.PAS.ETO SCID1.PAS.PastMonth 
  SCID2.Source1 SCID2.Source2 SCID2.Source3 
  SCID2.SumBP.PM SCID2.SumOBP.PM SCID2.SumMD.PM SCID2.SumDSonCP.PM 
  SCID2.SumSz.PM SCID2.SumSf.PM SCID2.SumSA.PM SCID2.SumDD.PM SCID2.SumBRP.PM SCID2.SumPDNOS.PM 
  SCID2.CMDS.A5p SCID2.CMDS.AB SCID2.PMDS.A5p SCID2.PMDS.AB 
  SCID2.CMS.B3p SCID2.CMS.C SCID2.CMS.ABC 
  SCID2.PMS.B3p SCID2.PMS.C SCID2.PMS.ABC 
  SCID2.PAS.DO1 SCID2.PAS.DO2 SCID2.PAS.DO3 SCID2.PAS.DO4 SCID2.PAS.DO5 SCID2.PAS.DO6 SCID2.PAS.DO7 SCID2.PAS.DO8 SCID2.PAS.DO9 
  SCID2.PAS.HO1 SCID2.PAS.HO5 SCID2.PAS.HO6 SCID2.PAS.HO7 
  SCID2.PAS.CBO SCID2.PAS.FAO SCID2.PAS.GIAO SCID2.PAS.IncO SCID2.PAS.MLAO SCID2.PAS.ETO SCID2.PAS.PastMonth
  1 'Absent or False'
  3 'Threshold or True'
 /SCID1.SumSA.PM.Type SCID2.SumSA.PM.Type
  1 'Bipolar'
  2 'Depressed'
 /SCID1.SumBP.PM.Sev SCID1.SumMD.PM.Sev
  SCID2.SumBP.PM.Sev SCID2.SumMD.PM.Sev
  1 'Mild'
  2 'Moderate'
  3 'Severe, no psychotic'
  4 'Congruent psychotic'
  5 'Incongruent psychotic'
 /SCID1.SumMoodCert SCID1.SumPsychoticCert SCID1.SumSubAbuseCert
  SCID2.SumMoodCert SCID2.SumPsychoticCert SCID2.SumSubAbuseCert
  1 'Poor'
  2 'Fair'
  3 'Good'
 /SCID1.SumDys.Type SCID2.SumDys.Type
  1 'Primary'
  2 'Secondary'
 /SCID1.SumSf.PM.Type SCID2.SumSf.PM.Type
  1 'Good Prognosis'
  2 'Not Good Prognosis'
 /SCID1.CMDS.Num SCID1.PMDS.Num SCID1.CMS.Num SCID1.PMS.Num SCID1.Chron.PsychoticNum
  SCID2.CMDS.Num SCID2.PMDS.Num SCID2.CMS.Num SCID2.PMS.Num SCID2.Chron.PsychoticNum
  99 'Too many to count'
 /SCID1.Chron.PsychoticP5YSev SCID1.Chron.MoodP5YSev
  SCID2.Chron.PsychoticP5YSev SCID2.Chron.MoodP5YSev
  1 'Not at all (0%)'
  2 'Rarely (5-10%)'
  3 'Sig Minority (20-30%)'
  4 'About half'
  5 'Sig Majority (70-80%)'
  6 'Almost always (90-100%)'
  9 'Unknown'
 /SCID1.Chron.PsychoticPMSev SCID2.Chron.PsychoticPMSev
  1 'Mild'
  2 'Moderate'
  3 'Severe'
 /SCID1.Chron.PsychoticOnset SCID1.Chron.PsychoticProdrome
  SCID2.Chron.PsychoticOnset SCID2.Chron.PsychoticProdrome
  99 'Unknown'.
  
