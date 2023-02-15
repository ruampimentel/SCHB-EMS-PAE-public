* Encoding: windows-1252.
CD 'D:\Dropbox\My Documents\R-PAS\Norms'.

GET  FILE=
 'Int1396 - Legacy Protocol Level with Demographics.sav'.
DATASET NAME Legacy WINDOW=FRONT.

SELECT IF (SR GE 0).
EXECUTE.

* Create an Ed variable to match with Kline data. 
* We have no way to know if people obtained a 2-year college degree, so treat 13-15 the same.
* We also cannot differentiate some graduat work from obtained a degree.
NUMERIC EdLevel.
IF (YrsEduc LE  6)                   EdLevel = 1.
IF (YrsEduc GE  7 AND YrsEduc LE 11) EdLevel = 2.
IF (YrsEduc EQ 12)                   EdLevel = 3.
IF (YrsEduc GE 13 AND YrsEduc LE 15) EdLevel = 4.
IF (YrsEduc EQ 16)                   EdLevel = 5.
IF (YrsEduc GE 17)                   EdLevel = 6.

VALUE LABELS EdLevel
 1 '<= 6th Grade'
 2 'Grade 7-11'
 3 'HS Grad or GED'
 4 'Some College'
 5 'Grad 4 Year College'
 6 'Any Post-Graduate'.

FREQUENCIES VARIABLES=YrsEduc EdLevel
  /ORDER=ANALYSIS.

MATCH FILES FILE=*
 /KEEP = ID_Num TO Source Name TO YrsEduc EdLevel R.
EXECUTE.

VARIABLE WIDTH ID_Num to FileName2 (12) Age TO R (8).

SAVE OUTFILE=
  'Int1396 - 145 Full-Text IDs and Demographics.sav'
  /COMPRESSED.
