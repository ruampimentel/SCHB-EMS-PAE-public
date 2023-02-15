* Encoding: windows-1252.
* Encoding: .


* My directory ---------------------------------------------------------------------------.
CD 'C:\Users\ruamp\OneDrive - University of Toledo\Conferences\'+
   'SPA 2020\Kline\SPSS_archives\Reviewed - FINAL'.

* Open file --------------------------------------------------------------------------------.
GET 
  FILE = 'Kline_3 - testing.sav'.
DATASET NAME Kline WINDOW=FRONT.


* correcting typos and incorrect labels -------------------------------------------------------.

* example for correcting values.
*DO IF (ID = 2).
*RECODE SCID1.CMDS.A3 (ELSE = 99).
*END IF.
*EXECUTE.

* example for correcting labels.


* ----- SCID 1 --------------------------------------------------------------------------------.
* SECTION A -----------------------------------------------------------------------------------.
DATASET ACTIVATE Kline.

* rule CMDS.A2 . 
DO IF (SCID1.CMDS.A1 < 3 AND SCID1.CMDS.A2 < 3).
RECODE
    SCID1.CMDS.A3 
    SCID1.CMDS.A4 
    SCID1.CMDS.A5 
    SCID1.CMDS.A6 
    SCID1.CMDS.A7 
    SCID1.CMDS.A8 
    SCID1.CMDS.A9 
    SCID1.CMDS.A5p 
    SCID1.CMDS.AB (999 = 1).
RECODE
    SCID1.CMDS.Num (999 = 0). 
END IF.

* rule CMDS.A5p .
DO IF ( SCID1.CMDS.A5p = 1 ).
RECODE 
    SCID1.CMDS.AB (999 = 1).
RECODE
    SCID1.CMDS.Num (999 = 0).
END IF.


* rule CMDS.B1.
DO IF ( SCID1.CMDS.B1 = 1).
RECODE 
    SCID1.CMDS.AB (999 = 1).
RECODE
    SCID1.CMDS.Num (999 = 0).
END IF.

* rule CMDS.B2.
DO IF ( SCID1.CMDS.B2 = 1).
RECODE 
    SCID1.CMDS.AB (999 = 1).
RECODE    
    SCID1.CMDS.Num (999 = 0).
END IF.

* rule CMDS.AB (AB = 1).
DO IF ( SCID1.CMDS.AB = 1).
RECODE SCID1.CMDS.Num (999 = 0).
* GM: The following logic is not correct. If CMDS is present (i.e., AB=3), it is likely
* that PMDS A1 to A9 would be present too. Thus, we cannot say these are absent. 
* We also cannot say PMDS.Num is 0 (line 92). 
* I do not follow why we would recode CMDS.Num=0 if CMDS.AB=3 and CMDS.Num=999 (line 93).

* RP: I see what you mean, but if CMDS is present, the reviewer would skip PMDS entirely,
* would we just like to consider 999 = 999 then?.
* about PMDS.Num, so the correct would be just remove it? 
* about CMDS.Num, it was probably my mistake, we should remove it.
* in conclusion, I believe I can just remove the following syntax, do you agree? (lines 83-99).
ELSE IF ( SCID1.CMDS.AB = 3).
RECODE 
    SCID1.PMDS.A1 
    SCID1.PMDS.A2 
    SCID1.PMDS.A3
    SCID1.PMDS.A4
    SCID1.PMDS.A5
    SCID1.PMDS.A6
    SCID1.PMDS.A7
    SCID1.PMDS.A8
    SCID1.PMDS.A9
    SCID1.PMDS.A5p
    SCID1.PMDS.AB (999 = 1).
RECODE
    SCID1.PMDS.Num 
    SCID1.CMDS.Num (999 = 0). 
END IF.

* rule PMDS.A2.
DO IF (SCID1.PMDS.A1 <> 3 AND SCID1.PMDS.A2 <> 3).
RECODE
    SCID1.PMDS.A3
    SCID1.PMDS.A4
    SCID1.PMDS.A5
    SCID1.PMDS.A6
    SCID1.PMDS.A7
    SCID1.PMDS.A8
    SCID1.PMDS.A9
    SCID1.PMDS.A5p
    SCID1.PMDS.AB (999 = 1).
RECODE
    SCID1.PMDS.Num (999 = 0).
END IF.

* rule PMDS.5p.
DO IF (SCID1.PMDS.A5p = 1 ).
* GM: I don't think we can code CMS.NoBasis=1 just b/c PMDS.A5p=1 and NoBasis=999 (line 118).
* CMS.NoBasis could be 999 because there is a basis to suspect.

* RP: Ok, I've just updated it and removed CMS.NoBasis from the syntax.
RECODE
    SCID1.PMDS.AB (999 = 1).
RECODE
    SCID1.PMDS.Num (999 = 0).
END IF.

* rule PMDS.B1.
DO IF (SCID1.PMDS.B1 = 1 ).
* GM: I don't think we can code CMS.NoBasis=1 just b/c PMDS.B1=1 and NoBasis=999 (line 129).
* CMS.NoBasis could be 999 because there is a basis to suspect.

* RP: Ok, I've just updated it and removed CMS.NoBasis from the syntax.
RECODE
    SCID1.PMDS.AB (999 = 1).
RECODE
    SCID1.PMDS.Num (999 = 0).
END IF.

* rule PMDS.B2.
DO IF (SCID1.PMDS.B2 = 1 ).
* I don't think we can code CMS.NoBasis=1 just b/c PMDS.B2=1 and NoBasis=999 (line 140).
* CMS.NoBasis could be 999 because there is a basis to suspect.


* RP: Ok, I've just updated it and removed CMS.NoBasis from the syntax.
RECODE
    SCID1.PMDS.AB(999 = 1).
RECODE
    SCID1.PMDS.Num (999 = 0).
END IF.

* rule PMDS.AB.
DO IF (SCID1.PMDS.AB = 1).
RECODE SCID1.PMDS.Num (999 = 0).
END IF.

* rule CMS.NoBasis.
DO IF (SCID1.CMS.NoBasis = 3).
RECODE 
    SCID1.CMS.A1
    SCID1.CMS.B1
    SCID1.CMS.B2
    SCID1.CMS.B3
    SCID1.CMS.B4
    SCID1.CMS.B5
    SCID1.CMS.B6
    SCID1.CMS.B7
    SCID1.CMS.B3p
    SCID1.CMS.ABC (999 = 1).
RECODE
    SCID1.CMS.Num (999 = 0). 
END IF.

* rule CMS.A1.
DO IF (SCID1.CMS.A1 = 1).
RECODE
    SCID1.CMS.B1
    SCID1.CMS.B2
    SCID1.CMS.B3
    SCID1.CMS.B4
    SCID1.CMS.B5
    SCID1.CMS.B6
    SCID1.CMS.B7
    SCID1.CMS.B3p
    SCID1.CMS.ABC (999 = 1).
RECODE
    SCID1.CMS.Num (999 = 0).
END IF.

* rule CMS.B3p.
DO IF (SCID1.CMS.B3p = 1).
RECODE
    SCID1.CMS.ABC (999 = 1).
RECODE   
    SCID1.CMS.Num (999 = 0).
END IF.

* rule CMS.D.
DO IF (SCID1.CMS.D = 1).
RECODE
   SCID1.CMS.ABC (999 = 1).
RECODE
   SCID1.CMS.Num (999 = 0).
END IF.


*rule CMS.ABC.
DO IF (SCID1.CMS.ABC= 1).
RECODE
   SCID1.CMS.Num (999 = 0).
END IF.

* rule PMS.A1.
DO IF (SCID1.PMS.A1 = 1).
RECODE
    SCID1.PMS.B1
    SCID1.PMS.B2
    SCID1.PMS.B3
    SCID1.PMS.B4
    SCID1.PMS.B5
    SCID1.PMS.B6
    SCID1.PMS.B7
    SCID1.PMS.B3p
    SCID1.PMS.ABC (999 = 1).
RECODE
    SCID1.PMS.Num (999 = 0).
END IF.

* rule PMS.B3p.
DO IF (SCID1.PMS.B3p = 1).
RECODE 
    SCID1.PMS.ABC (999 = 1).
RECODE 
    SCID1.PMS.Num (999 = 0).
END IF.


* rule PMS.D and "no/yes"
* missing variable? review codebook.
* GM: If the above was a note for me, I'm not following it.

* SECTION B -----------------------------------------------------------------------------------.

* rule PAS.NNOD.
DO IF (SCID1.PAS.NNOD = 3).
RECODE
    SCID1.PAS.D6
    SCID1.PAS.D7
    SCID1.PAS.D8
    SCID1.PAS.D9 (999 = 1).
END IF.

* rule PAS.H1. 
DO IF (SCID1.PAS.H1 = 1).
RECODE    
    SCID1.PAS.H2
    SCID1.PAS.H3
    SCID1.PAS.H4 (999 = 1).
END IF.


* SECTION C -----------------------------------------------------------------------------------.

* rule DDPD.No3.
DO IF (SCID1.DDPD.No3 = 3).
RECODE
    SCID1.Sz.A
    SCID1.Sz.C
    SCID1.SA.A
    SCID1.Chron.PsychoticMetPM (999 = 1).
* For MonthsSince, shouldn't we leave 999=999? Seems so.
RECODE
    SCID1.Chron.PsychoticMonthsSince
    SCID1.Chron.PsychoticNum (999 = 0).
END IF.

* rule DDPD.NonMoodPSx.
DO IF (SCID1.DDPD.NonMoodPSx = 1).
RECODE 
    SCID1.Sz.A
    SCID1.Sz.C
    SCID1.SA.A
    SCID1.Chron.PsychoticMetPM (999 = 1).
RECODE
    SCID1.Chron.PsychoticMonthsSince
    SCID1.Chron.PsychoticNum (999 = 0).
END IF.


* rule BRP.E.
DO IF (SCID1.BRP.E = 1).
RECODE 
    SCID1.Sz.A
    SCID1.Sz.C
    SCID1.SA.A
    SCID1.Chron.PsychoticMetPM (999 = 1).
* Why would PsychoticNum=0 below on line 293? I don't follow that.
RECODE
    SCID1.Chron.PsychoticMonthsSince
    SCID1.Chron.PsychoticNum (999 = 0).
ELSE IF (SCID1.BRP.E = 2 OR 
         SCID1.BRP.E = 3).
RECODE
    SCID1.Sz.A
    SCID1.Sz.C
    SCID1.SA.A (999 = 1).
END IF.

* rule Sz.A.
DO IF (SCID1.Sz.A = 1).
RECODE 
    SCID1.Sz.C
    SCID1.SA.A (999 = 1).
END IF.

* rule Sz.B1.
DO IF (SCID1.Sz.B1 = 0).
RECODE 
    SCID1.Sz.C
    SCID1.SA.A(999 = 1).
END IF.

* rule Sz.B2.
DO IF (SCID1.Sz.B2 = 0).
RECODE
    SCID1.Sz.C
    SCID1.SA.A (999 = 1).
ELSE IF (SCID1.Sz.B2 = 1).
RECODE
    SCID1.Sz.C (999 = 1).
END IF.

* rule Sz.D.
* I didn't include "else if" because it continues in the next variable.
DO IF (SCID1.Sz.D = 1).
RECODE 
    SCID1.SA.A (999 = 1).
END IF.
 
* rule SzType.PT.
DO IF (SCID1.SzType.PT = 3).
RECODE
    SCID1.SA.A (999 = 1).
END IF. 

* rule SzType.SPT.
DO IF (SCID1.SzType.SPT = 0 OR 
       SCID1.SzType.SPT = 1 OR
       SCID1.SzType.SPT = 3).
RECODE
    SCID1.SA.A (999 = 1).
END IF.
 
* rule SzType.CT. 
DO IF (SCID1.SzType.CT = 3).
RECODE
    SCID1.SA.A (999 = 1).
END IF.

* rule SzType.DT. 
DO IF (SCID1.SzType.DT = 3).
RECODE
    SCID1.SA.A (999 = 1).
END IF.

* rule SzType.UT. 
DO IF (SCID1.SzType.UT = 3).
RECODE
    SCID1.SA.A (999 = 1).
END IF.

* rule SzType.RT. 
DO IF (SCID1.SzType.RT = 3).
RECODE
    SCID1.SA.A (999 = 1).
END IF.

* rule SfG.2GoodSigns.
DO IF (SCID1.SfG.2GoodSigns = 1 OR SCID1.SfG.2GoodSigns = 3).
RECODE 
    SCID1.SA.A (999 = 1).
END IF.

* rule SA.B.
DO IF (SCID1.SA.B = 1).
RECODE 
    SCID1.Chron.PsychoticMetPM (999 = 1).
* For MonthsSince, shouldn't we leave 999=999? Seems so.
RECODE
    SCID1.Chron.PsychoticMonthsSince
    SCID1.Chron.PsychoticNum (999 = 0).
END IF.

* rule DD.WithMood.
DO IF (SCID1.DD.WithMood = 3). 
RECODE
    SCID1.Chron.PsychoticMetPM (999 = 1).
* For MonthsSince, shouldn't we leave 999=999? Seems so.
RECODE
    SCID1.Chron.PsychoticMonthsSince
    SCID1.Chron.PsychoticNum (999 = 0).
END IF.

* rule PDNOS.
* no need to include this rule because the next variable is the correct following.


* SECTION D -----------------------------------------------------------------------------------.
* (REVIEW SECTION D).

* rule Mood.NonSA_Mood.
DO IF (SCID1.Mood.NonSA_Mood = 3).
RECODE 
    SCID1.Mood.PureManic
    SCID1.Mood.PureMajDep
    SCID1.Chron.MoodMetPM
    SCID1.Chron.MoodP5YSev (999 = 1).
END IF.

* rule Mood.NeverManicHypomanic.
DO IF (SCID1.Mood.NeverManicHypomanic = 3).
RECODE
    SCID1.Mood.PureManic (999 = 1).
END IF.

* rule Bipolar.Type.
DO IF (SCID1.Bipolar.Type = 1 OR
       SCID1.Bipolar.Type = 2 OR
       SCID1.Bipolar.Type = 3 ). 
* I don't see why Chron.MoodMetPM would be 1 if Type is 1, 2, or 3.
RECODE 
    SCID1.Mood.PureMajDep
    SCID1.Chron.MoodMetPM (999 = 1). 
END IF.

* rule Bipolar.OtherPM.
DO IF (SCID1.Bipolar.OtherPM = 3).
RECODE
    SCID1.Mood.PureMajDep
    SCID1.Chron.MoodMetPM (999 = 1).
END IF.

* rule Mood.PureMajDep.
* not included because next one is already the correct following.

* rule DepressedOnPsychoticPM.
DO IF (SCID1.DepressedOnPsychoticPM = 3).
* I don't see why Chron.MoodMetPM would be 1 if DepOnPsychoticPM is 3.
RECODE 
    SCID1.Chron.MoodMetPM (999 = 1).
END IF.

* rule Chron.MoodMetPM.
* not included because all following variables are not included.

EXECUTE.
 

* save file ----------------------------------------------------------------------------.
SAVE OUTFILE='Kline_3 - testing - with skip rules.sav'
  /COMPRESSED.


* ----- SCID 2 --------------------------------------------------------------------------------.
