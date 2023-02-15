* Encoding: UTF-8.
* Ruam's Laptop.
CD 'C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA 2020\Normative Data Protocols'. 

GET
  FILE= 'Kline and norms - 140 protocols MOR, SCHB, EMS, PAE.sav'.
DATASET NAME merged WINDOW=FRONT.


DATASET ACTIVATE merged.
* Define Variable Properties.
*Group.
VARIABLE LABELS  Group 'Consensus Dx'.
VALUE LABELS Group
  .00 'CS Norms'
  1.00 'Dep'
  2.00 'SA Dep'
  3.00 'SA BP'
  4.00 'Sz Par'
  5.00 'Sz Disorg'
  6.00 'Sz Undiff'
  7.00 'Sz Resid'.
*Group2.
VALUE LABELS Group2
  .00 'CS Norms'
  1.00 'Dep'
  2.00 'Bip'
  3.00 'Scz'.
*Group3.
VALUE LABELS Group3
  .00 'CS Norms'
  1.00 'Clinical'.
*Group4.
VALUE LABELS Group4
  .00 'CS Norms'
  1.00 'Dep'
  2.00 'Scz + Bip'.
EXECUTE.


* Descriptives.
SORT CASES  BY Group3.
SPLIT FILE LAYERED BY Group3.

DATASET ACTIVATE merged.
DESCRIPTIVES VARIABLES=Rorschach_N Form MOR EMS SCHB SCHB2 PAE EMS_PAE Form_pct MOR_pct EMS_pct SCHB_pct 
    SCHB2_pct PAE_pct EMS_PAE_pct
  /STATISTICS=MEAN STDDEV MIN MAX KURTOSIS SKEWNESS.
SPLIT FILE OFF.

* Greg's comment about whether using raw or % variables:
* Although you don’t need to do more now, looking at the SD in R in both groups leaves me 
* thinking that we are artificially inflating the SDs of any variables correlated with R. 
* This would impair power and produce smaller effect sizes. Thus, it makes me want to consider 
* using % values instead. They in turn would have to be transformed by square root. 
*  Notice how almost uniformly the % values are more skewed than the raw values. 
* That is because the SDs are better controlled (smaller) with % scores, allowing 
* outliers to appear even slightly more aberrant as a % than a raw score. 
* For instance, the raw SCHB SD is about 2.87 times larger for patients than nonpatients, 
* but the % SD is 3.56 times larger. Thus, % scores provide increased statistical power 
*(within group homogeneity).   

* Checking R, F, and F%.
T-TEST GROUPS=Group3(1 0)
  /MISSING=ANALYSIS
  /VARIABLES=Rorschach_N Form Form_pct
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).

*****************************************************************************************************.
***************************** MAIN ANALYSIS *********************************************************.
*****************************************************************************************************.


* OMS.
DATASET DECLARE  stats.
OMS
  /SELECT TABLES
  /IF COMMANDS=['T-Test'] SUBTYPES=['Independent Samples Test']
  /DESTINATION FORMAT=SAV NUMBERED=TableNumber_
   OUTFILE='stats' VIEWER=YES
  /TAG='t_test'.
* OMS.
DATASET DECLARE  effect_size.
OMS
  /SELECT TABLES
  /IF COMMANDS=['T-Test'] SUBTYPES=['Independent Samples Effect Sizes']
  /DESTINATION FORMAT=SAV NUMBERED=TableNumber_
   OUTFILE='effect_size' VIEWER=YES
  /TAG='es'.



* Nonclinical vs. Clinical.
* Checking MOR, EMS, SCHB, PAE. 
T-TEST GROUPS=Group3(1 0)
  /MISSING=ANALYSIS
  /VARIABLES=  Form_pct_sqrt MOR_pct_sqrt EMS_pct_sqrt SCHB_pct_sqrt SCHB2_pct_sqrt PAE_pct_sqrt 
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).

*Nonclinical vs. Dep.
* Checking MOR, EMS, SCHB, PAE.
T-TEST GROUPS=Group2(1 0)
  /MISSING=ANALYSIS
  /VARIABLES= Form_pct_sqrt MOR_pct_sqrt EMS_pct_sqrt SCHB_pct_sqrt SCHB2_pct_sqrt PAE_pct_sqrt 
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).

*****************************************************************************************************.
***************************** SECONDARY ANALYSIS ****************************************************.
*****************************************************************************************************.



* Dep vs. Scz+Bip.
* Checking MOR, EMS, SCHB, PAE.
T-TEST GROUPS=Group4(1 2)
  /MISSING=ANALYSIS
  /VARIABLES= Form_pct_sqrt MOR_pct_sqrt EMS_pct_sqrt SCHB_pct_sqrt SCHB2_pct_sqrt PAE_pct_sqrt
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).


*Scz+Bip vs. CS Norms.
* Checking MOR, EMS, SCHB, PAE.
T-TEST GROUPS=Group4(2 0)
  /MISSING=ANALYSIS
  /VARIABLES= Form_pct_sqrt MOR_pct_sqrt EMS_pct_sqrt SCHB_pct_sqrt SCHB2_pct_sqrt PAE_pct_sqrt
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).


* OMSEND.
OMSEND TAG=['t_test'].
OMSEND TAG=['es'].
 
DATASET ACTIVATE effect_size.
* Define Variable Properties.
*TableNumber_.
VARIABLE LEVEL  TableNumber_(ORDINAL).
VARIABLE LABELS  TableNumber_ 'Contrast'.
VALUE LABELS TableNumber_
  1 'Clinical vs. CS Norms'
  2 'Dep vs. CS Norms'
  3 'Dep vs. Scz+Bip'
  4 'Scz+Bip vs. CS Norms'.
EXECUTE.

DATASET ACTIVATE stats.
* Define Variable Properties.
*TableNumber_.
VARIABLE LEVEL  TableNumber_(ORDINAL).
VARIABLE LABELS  TableNumber_ 'Contrast'.
VALUE LABELS TableNumber_
  1 'Clinical vs. CS Norms'
  2 'Dep vs. CS Norms'
  3 'Dep vs. Scz+Bip'
  4 'Scz+Bip vs. CS Norms'.
EXECUTE.

DATASET ACTIVATE effect_size.
SAVE OUTFILE='effect sizes ISR 2022 output.sav'
  /COMPRESSED.

DATASET ACTIVATE stats.
SAVE OUTFILE='t test ISR 2022 output.sav'
  /COMPRESSED.

DATASET ACTIVATE merged. 
DATASET CLOSE stats. 
DATASET CLOSE effect_size.
* data organized on R from here on. Use file called 'SPSS Output data wrangling.R'.


