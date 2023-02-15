* Encoding: windows-1252.


* Creating count of N and SCHB, EMS and PAE per subject ---------------------------------------------------.
* open dataset with SCHB, EMS, PAE.
GET DATA
  /TYPE=XLSX
  /FILE= 'Kline Protocols R-ID - All with Updated '+
         'GM SCHB and EMS.xlsx'
  /SHEET=name 'Sheet1'
  /CELLRANGE=FULL
  /READNAMES=ON
  /DATATYPEMIN PERCENTAGE=95.0
  /HIDDEN IGNORE=YES.
EXECUTE.
DATASET NAME new_dep_codes WINDOW=FRONT.

* OMS.
DATASET DECLARE  new_dep_codes_sum.
OMS
  /SELECT TABLES
  /IF COMMANDS=['OLAP Cubes'] SUBTYPES=['Layered Reports']
  /DESTINATION FORMAT=SAV NUMBERED=TableNumber_
   OUTFILE='new_dep_codes_sum' VIEWER=YES
  /TAG='codes_sum'.


DATASET ACTIVATE new_dep_codes.
SORT CASES  BY RID.
SPLIT FILE LAYERED BY RID.
OLAP CUBES SCHB_GM EMS_GM PAE_GM
  /CELLS=SUM COUNT
  /TITLE='OLAP Cubes'.
SPLIT FILE OFF.

* OMSEND.
OMSEND TAG=['codes_sum'].

* cleaning dataset.
DATASET DECLARE  new_dep_codes_sum.
DELETE VARIABLES  TableNumber_ Command_ Subtype_ Label_.
EXECUTE.

RENAME VARIABLES ( Var1 Var2 = RID codes).
EXECUTE.

* Define Variable Properties.
ALTER TYPE  RID(F3.0).
VARIABLE LEVEL  RID(SCALE).
FORMATS  RID(F3.0).
EXECUTE.

