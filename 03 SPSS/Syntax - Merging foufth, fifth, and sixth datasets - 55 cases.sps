* Encoding: windows-1252.

CD 'C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA 2020\Depressive Indicators\ICC - third round'.


* fourth dataset.
GET DATA
  /TYPE=XLSX
  /FILE='Kline Protocols R-ID - Fourth 20 GM GP RP AZ.xlsx'
  /SHEET=name 'Sheet1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=100.0.
EXECUTE.
DATASET NAME fourth WINDOW=FRONT.

SELECT IF (RID GE 214 AND RID LE 540).
EXECUTE.

ALTER TYPE
 SCHB_GM EMS_GM PAE_GM SCHB_GP EMS_GP PAE_GP
 SCHB_RP EMS_RP PAE_RP SCHB_AZ EMS_AZ PAE_AZ (F8.0).

* fifth dataset.
GET DATA
  /TYPE=XLSX
  /FILE='Kline Protocols R-ID - Fifth 20 GM GP RM AZ.xlsx'
  /SHEET=name 'Sheet1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=100.0.
EXECUTE.
DATASET NAME fifth WINDOW=FRONT.

SELECT IF (RID GE 546 AND RID LE 749).
EXECUTE.

ALTER TYPE
 SCHB_GM EMS_GM PAE_GM SCHB_GP EMS_GP PAE_GP
 SCHB_RP EMS_RP PAE_RP SCHB_AZ EMS_AZ PAE_AZ (F8.0).


* sixth dataset.
GET DATA
  /TYPE=XLSX
  /FILE='Kline Protocols R-ID - Sixth 15 GM GP RP AZ.xlsx'
  /SHEET=name 'Sheet1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=100.0.
EXECUTE.
DATASET NAME sixth WINDOW=FRONT.

SELECT IF (RID GE 763 AND RID LE 987).
EXECUTE.

ALTER TYPE
 SCHB_GM EMS_GM PAE_GM SCHB_GP EMS_GP PAE_GP
 SCHB_RP EMS_RP PAE_RP SCHB_AZ EMS_AZ PAE_AZ (F8.0).


DATASET ACTIVATE fourth.
ADD FILES /FILE=*
  /RENAME (Disagree=d0)
  /FILE='fifth'
  /RENAME (Disagree=d1)
  /DROP=d0 d1.
EXECUTE.

ADD FILES /FILE=*
  /RENAME (Inquiry=d0)
  /FILE='sixth'
  /RENAME (Disagree Inquiry=d1 d2)
  /DROP=d0 d1 d2.
EXECUTE.

DATASET CLOSE fifth.
DATASET CLOSE sixth.


SAVE OUTFILE='C:\Users\ruamp\OneDrive - University of Toledo\Conferences\'+
  'SPA 2020\Depressive Indicators\ICC - third round\fourth, fifth and sixth - 55\'+
  'Kline Protocols R-ID - fourth, fifth, sixth 55 GM GP RP AZ.sav'
  /COMPRESSED.


SAVE OUTFILE='C:\Users\ruamp\OneDrive - University of Toledo\Conferences\'+
  'SPA 2020\Depressive Indicators\ICC - third round\fourth, fifth and sixth - 55 - excluding AZ\'+
  'Kline Protocols R-ID - fourth, fifth, sixth 55 GM GP RP AZ.sav'
  /COMPRESSED.
