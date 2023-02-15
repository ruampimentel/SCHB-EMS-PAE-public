* Encoding: windows-1252.
* Join Normative responses with IDs matching to Kline inpatients.

CD 'D:\Dropbox\My Documents\R-PAS\Norms\e-Protocols'.

GET  FILE=
  'rpas norms 70 matched with kline - Full-Text IDs and Demographics.sav'.
DATASET NAME IDs WINDOW=FRONT.

SORT CASES BY ID_Num (A).
DELETE VARIABLES ID TO EdLevel.


GET DATA  /TYPE=XLSX  /FILE=
  'Norm145 Responses with Joint (Jessa Reviewed) and Individual R-PAS Codes.xlsx'
  /SHEET=name 'Norm145 Responses with R-PAS Co'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0.
EXECUTE.
DATASET NAME Responses WINDOW=FRONT.

SORT CASES BY ID_Num Card_Num R_InCard (A).


MATCH FILES /FILE=*
 /TABLE='IDs'
 /BY ID_Num.
EXECUTE.

SELECT IF (R GT 0).
EXECUTE.


SAVE TRANSLATE OUTFILE=
 'Norm145 Responses - 70 Cases Matched to Kline Inpatients.xlsx'
 /TYPE=XLS  /VERSION=12  /MAP  /FIELDNAMES VALUE=NAMES  /CELLS=VALUES  /REPLACE.
