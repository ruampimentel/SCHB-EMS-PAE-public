* Encoding: windows-1252.

* Working directory.
CD 'C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA 2020\Gis Protocols\Analysis'. 

* Creating count of N and SCHB, SCHB2, EMS and PAE per subject ---------------------------------------------------.
* open dataset with SCHB, EMS, PAE.

GET DATA
  /TYPE=XLSX
  /FILE='bd.brazil.patients_n.43_response.lvl.GP.xlsx'
  /SHEET=name 'Responses'
  /CELLRANGE=FULL
  /READNAMES=ON.
EXECUTE.
DATASET NAME response_lvl WINDOW=FRONT.

* coding SCHB2.
RECODE SCHB (0=0) (1=0) (2=1) INTO SCHB2.
EXECUTE.

* OMS.
DATASET DECLARE  new_dep_codes.
OMS
  /SELECT TABLES
  /IF COMMANDS=['OLAP Cubes'] SUBTYPES=['Layered Reports']
  /DESTINATION FORMAT=SAV NUMBERED=TableNumber_
   OUTFILE='new_dep_codes' VIEWER=YES
  /TAG='codes_sum'.

DATASET ACTIVATE new_dep_codes.
SORT CASES  BY PID1.
SPLIT FILE LAYERED BY PID1.
OLAP CUBES SCHB SCHB2 EMS PAE
  /CELLS=SUM COUNT
  /TITLE='OLAP Cubes'.
SPLIT FILE OFF.

* OMSEND.
OMSEND TAG=['codes_sum'].

* cleaning dataset.
DATASET ACTIVATE  new_dep_codes.
DELETE VARIABLES  TableNumber_ Command_ Subtype_ Label_.
EXECUTE.

RENAME VARIABLES ( Var1 Var2 = PID1 codes). 
EXECUTE.
****** error with Var2 (undefined variable name)
* Var2 nao tinha sido calculada pq o bando nao tinha sido separado por PID1. 
* a syntaxe anterior continha o nome ID do meu banco de dados (RID) assim que 
* eu ssubstitui pelo nome ID do seu banco de dados (PID1), funcionou. 
* tambem tem q substituit aq embaixo. ja estou fazendo. 

* Define Variable Properties.
ALTER TYPE  PID1(F3.0).
VARIABLE LEVEL  PID1(SCALE).
FORMATS  PID1(F3.0).
EXECUTE.

* restructuring file.
SORT CASES BY PID1 codes.
CASESTOVARS
  /ID=PID1
  /INDEX=codes.

* save in the same directory.
SAVE OUTFILE='SCHB SCHB2 EMS PAE protocol level.sav'
 /COMPRESSED.

* open complete database with protocol level.
GET
  FILE='bd.brazil.patients_n43_protocol.lv.GP.SCHB.EMS.PAE.PANSS.BPRS_1.sav'.
DATASET NAME protocol_lvl WINDOW=FRONT.

* deleting original SCHB EMS and PAE from the database.
DELETE VARIABLES  SCHB EMS PAE PAE_sqrt.
EXECUTE.

* merging datasets.
DATASET ACTIVATE protocol_lvl.
SORT CASES BY PID1.
DATASET ACTIVATE new_dep_codes.
SORT CASES BY PID1.
DATASET ACTIVATE protocol_lvl.
MATCH FILES /FILE=*
  /FILE='new_dep_codes'
  /BY PID1.
EXECUTE.

*rename variables.
RENAME VARIABLES(N = N_rorschach).
VARIABLE LABELS N_rorschach 'Number of responses in the Rorschach protocol'.
EXECUTE.

* creating PAE_sqrt.
COMPUTE PAE_sqrt = sqrt(PAE).
EXECUTE.

* closing datasets.
DATASET CLOSE new_dep_codes.
DATASET CLOSE response_lvl.

* save in the same directory.
SAVE OUTFILE='bd.brazil.patients_n43_protocol.lv.GP.SCHB.EMS.PAE.PANSS.BPRS_1.SCHB2.sav'
 /COMPRESSED.

* RUNNING ANALYSIS ---------------------------------------------------------------------------------------.

* frequency.
DESCRIPTIVES VARIABLES=SCHB2
  /STATISTICS=MEAN STDDEV MIN MAX KURTOSIS SKEWNESS.
* skew = 1.658. No need to apply sqrt transformation.

* comparing depressives vs non-depressives.
T-TEST GROUPS=diagnosis(0 1)
  /MISSING=ANALYSIS
  /VARIABLES=SCHB2
  /CRITERIA=CI(.95).

* SCHB2 and depressive composite.
CORRELATIONS
  /VARIABLES=ZPANSS.BPRS3av SCHB2
  /PRINT=TWOTAIL NOSIG
  /MISSING=PAIRWISE.

* Barchart comparing Non-depressive vs Depressives.
* Chart Builder.
GGRAPH
  /GRAPHDATASET NAME="graphdataset" VARIABLES=diagnosis SCHB2 MISSING=LISTWISE REPORTMISSING=NO
  /GRAPHSPEC SOURCE=INLINE.
BEGIN GPL
  SOURCE: s=userSource(id("graphdataset"))
  DATA: diagnosis=col(source(s), name("diagnosis"), unit.category())
  DATA: SCHB2=col(source(s), name("SCHB2"))
  DATA: id=col(source(s), name("$CASENUM"), unit.category())
  GUIDE: axis(dim(1), label("diagnosis"))
  GUIDE: axis(dim(2), label("SCHB2: Sum"))
  GUIDE: text.title(label("Simple Boxplot of SCHB2: Sum by diagnosis"))
  SCALE: cat(dim(1), include("0", "1"))
  SCALE: linear(dim(2), include(0))
  ELEMENT: schema(position(bin.quantile.letter(diagnosis*SCHB2)), label(id))
END GPL.
