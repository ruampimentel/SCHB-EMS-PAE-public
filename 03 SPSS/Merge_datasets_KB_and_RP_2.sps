* Encoding: UTF-8.

GET
  FILE='C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA '+
    '2020\Kline\SPSS_archives\Reviewed - FINAL\Kline Db for Data Entry_KB_reviewed_RP.sav'.
DATASET NAME Kline_KB WINDOW=FRONT.

GET
  FILE='C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA '+
    '2020\Kline\SPSS_archives\Reviewed - FINAL\Kline Db for Data Entry_RP_reviewed_KB2.sav'.
DATASET NAME Kline_RP WINDOW=FRONT.


DATASET ACTIVATE Kline_RP.
DATASET COPY  Kline_complete.
DATASET ACTIVATE  Kline_complete.
FILTER OFF.
USE ALL.
SELECT IF ( N001.ID> 48).
ADD FILES /FILE=*
  /FILE='Kline_KB'.
SORT CASES BY N001.ID(A).
EXECUTE.

DATASET CLOSE Kline_KB.
DATASET CLOSE Kline_RP.

SAVE OUTFILE='C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA 2020\Kline\SPSS_archives\Reviewed - FINAL\Kline_complete_2.sav'
  /COMPRESSED.
