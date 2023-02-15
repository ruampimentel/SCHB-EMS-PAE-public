* Encoding: windows-1252.

* My directory -----------------------------------------------------------.
CD 'C:\Users\ruamp\OneDrive - University of Toledo\Conferences\'+
   'SPA 2020\Kline\SPSS_archives\Omitted SCID'.


* Open datasets ------------------------------------------------------------.
GET
  FILE='Kline Omitted SCID Vars for Data Entry GM.sav'.
DATASET NAME Kline_GM.

GET
  FILE='Kline Omitted SCID Vars for Data Entry RP.sav'.
DATASET NAME Kline_RP.

* Merge datasets ------------------------------------------------------------.
* I've excluded S49 (ID = 49) because it is a missing case 
* that I've forgot to delete previously.

DATASET ACTIVATE Kline_RP.
DATASET COPY  Kline_complete.
DATASET ACTIVATE  Kline_complete.
FILTER OFF.
USE ALL.
SELECT IF ( ID> 48 & ID<>49).
ADD FILES /FILE=*
  /FILE='Kline_GM'.
SORT CASES BY ID(A).
EXECUTE.
* Close datasets that we don't need anymore .
DATASET CLOSE Kline_GM.
DATASET CLOSE Kline_RP.

* Fixing mismatches/errors ------------------------------------------------------------.

DATASET ACTIVATE Kline_complete.
DO IF (ID = 31).
RECODE SCID1.DDPD.NonMoodPSx (ELSE=3).
END IF.

DO IF (ID = 32).
RECODE SCID1.Mood.NonSA_Mood (ELSE=3).
END IF.

DO IF (ID = 33).
RECODE SCID1.Chron.PsychoticMonthsSince (ELSE=2).
RECODE SCID2.Chron.PsychoticMonthsSince (ELSE=2).
END IF.

DO IF (ID = 35).
RECODE SCID1.Sz.B2 (ELSE=1).
END IF.

DO IF (ID = 38).
RECODE SCID2.PAS.NNOD (ELSE=999).
END IF.

DO IF (ID = 39).
RECODE SCID1.BRP.E (ELSE=999).
RECODE SCID1.Chron.PsychoticMetPM (ELSE=3).
END IF.
EXECUTE.
 
* Save final file as SPSS data -------------------------------------------------------------------.
SAVE OUTFILE='Kline_omitted_complete.sav'
  /COMPRESSED.






