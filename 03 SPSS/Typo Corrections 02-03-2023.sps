* Encoding: UTF-8.
* Fix another typo in the Kline dataset.

CD 'C:\Users\gmeyer\Dropbox\My Documents\R-PAS\Research Projects\Kline Protocols'. 

GET FILE=
    'Kline Db Complete - SCID Updated.sav'.
ALTER TYPE ALL(A=AMIN).
DATASET NAME Kline1 WINDOW=FRONT.
GET FILE=
    'Kline Db Complete - SCID Updated & Recoded.sav'.
ALTER TYPE ALL(A=AMIN).
DATASET NAME Kline2 WINDOW=FRONT.

DO IF (ID = 34). 
RECODE GAF1 Ethnicity (3 = 35) (35 = 3) (ELSE = COPY).
END IF.
EXECUTE.

DATASET ACTIVATE Kline1.
DO IF (ID = 34). 
RECODE GAF1 Ethnicity (3 = 35) (35 = 3) (ELSE = COPY).
END IF.
EXECUTE.

SAVE OUTFILE=
  'Kline Db Complete - SCID Updated.sav'
 /COMPRESSED.


DATASET ACTIVATE Kline2.
SAVE OUTFILE=
    'Kline Db Complete - SCID Updated & Recoded.sav'
 /COMPRESSED.
