* Encoding: UTF-8.

GET
  FILE='C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA '+
    '2020\Kline\SPSS_archives\Reviewed - FINAL\Kline_complete_2.sav'.
DATASET NAME criteria.
RENAME VARIABLES (N001.ID  = ID ).
SORT CASES BY ID.

GET
  FILE='C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA '+
    '2020\Kline\SPSS_archives\Reviewed - FINAL\SPCT.sav'.
DATASET NAME spct WINDOW=FRONT.
SORT CASES BY ID.


DATASET ACTIVATE spct.
MATCH FILES /FILE=*
  /FILE='criteria'
  /BY ID.
EXECUTE.

DATASET ACTIVATE spct.
SAVE OUTFILE='C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA 2020\Kline\SPSS_archives\Reviewed - FINAL\SPCT_with_criteria.sav'
  /COMPRESSED.

DATASET CLOSE criteria.
