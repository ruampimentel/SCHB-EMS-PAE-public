﻿* Encoding: windows-1252.

CD 'C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA 2020\'+
   'Depressive Indicators\ICC - third round\fourth, fifth and sixth - 55'.

GET
  FILE='Kline Protocols R-ID - fourth, fifth, sixth 55 GM GP RP AZ.sav'.
DATASET NAME DataSet1 WINDOW=FRONT.

DATASET DECLARE PL.
AGGREGATE
  /OUTFILE='PL'
  /BREAK=RID
  /R = NU(R) 
  /SCHB_GM = SUM(SCHB_GM) 
  /SCHB_GP = SUM(SCHB_GP) 
  /SCHB_RP = SUM(SCHB_RP) 
  /SCHB_AZ = SUM(SCHB_AZ) 
  /EMS_GM = SUM(EMS_GM) 
  /EMS_GP = SUM(EMS_GP) 
  /EMS_RP = SUM(EMS_RP) 
  /EMS_AZ = SUM(EMS_AZ) 
  /PAE_GM = SUM(PAE_GM) 
  /PAE_GP = SUM(PAE_GP) 
  /PAE_RP = SUM(PAE_RP) 
  /PAE_AZ = SUM(PAE_AZ).

DATASET ACTIVATE PL.

RELIABILITY
  /VARIABLES=SCHB_GM SCHB_GP SCHB_RP SCHB_AZ
  /SCALE('SCHB') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR
  /SUMMARY=MEANS CORR
  /ICC=MODEL(RANDOM) TYPE(ABSOLUTE) CIN=95 TESTVAL=0.

RELIABILITY
  /VARIABLES=EMS_GM EMS_GP EMS_RP EMS_AZ
  /SCALE('EMS') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR
  /SUMMARY=MEANS CORR
  /ICC=MODEL(RANDOM) TYPE(ABSOLUTE) CIN=95 TESTVAL=0.

RELIABILITY
  /VARIABLES=PAE_GM PAE_GP PAE_RP PAE_AZ
  /SCALE('PAE') ALL
  /MODEL=ALPHA
  /STATISTICS=DESCRIPTIVE CORR
  /SUMMARY=MEANS CORR
  /ICC=MODEL(RANDOM) TYPE(ABSOLUTE) CIN=95 TESTVAL=0.


OUTPUT SAVE NAME=Document1 OUTFILE=
 'Interrater Reliability Results - fourth, fifth, sixth - 55.spv'
  LOCK=NO.

OUTPUT EXPORT  /CONTENTS  EXPORT=ALL  LAYERS=PRINTSETTING  MODELVIEWS=PRINTSETTING  /XLSX  DOCUMENTFILE=
 'Interrater Reliability Results - fourth, fifth, sixth - 55.xlsx'
  OPERATION=CREATEFILE
  LOCATION=LASTCOLUMN  NOTESCAPTIONS=YES.

SAVE OUTFILE=
 'Interrater Reliability - fourth, fifth, sixth - 55.sav'
 /COMPRESSED.

SAVE TRANSLATE OUTFILE=
 'Interrater Reliability - fourth, fifth, sixth - 55.xlsx'
 /TYPE=XLS  /VERSION=12  /MAP  /FIELDNAMES VALUE=NAMES  /CELLS=VALUES  /REPLACE.



