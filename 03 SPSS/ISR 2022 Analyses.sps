* Encoding: UTF-8.

* Ruam's Laptop.
CD 'C:\Users\ruamp\OneDrive - University of Toledo\Conferences\SPA 2020\Normative Data Protocols'. 

* Greg's Laptop.
*CD 'C:\Users\gmeyer\Dropbox\My Documents\UT\Students\Ruam Pimentel\Depression'.


GET FILE= 
    'Kline and norms - 140 protocols MOR, SCHB, EMS, PAE.sav'.
DATASET NAME merged WINDOW=FRONT.


* Define Variable Properties.
*Group.
VARIABLE LABELS  Group 'Consensus Dx'.
VALUE LABELS Group
  0.00 'CS Norms'
  1.00 'Dep'
  2.00 'SA Dep'
  3.00 'SA BP'
  4.00 'Sz Par'
  5.00 'Sz Disorg'
  6.00 'Sz Undiff'
  7.00 'Sz Resid'.
*Group2.
VALUE LABELS Group2
  0.00 'CS Norms'
  1.00 'Dep'
  2.00 'Bip'
  3.00 'Scz'.
*Group3.
VALUE LABELS Group3
  0.00 'CS Norms'
  1.00 'Clinical'.
*Group4.
VALUE LABELS Group4
  0.00 'CS Norms'
  1.00 'Dep'
  2.00 'Scz + Bip'.
EXECUTE.



* Descriptives.
SORT CASES  BY Group3.
SPLIT FILE LAYERED BY Group3.

DESCRIPTIVES VARIABLES=
   Rorschach_N Form MOR EMS SCHB SCHB2 PAE 
   Form_pct MOR_pct EMS_pct SCHB_pct SCHB2_pct PAE_pct 
  /STATISTICS=MEAN STDDEV MIN MAX KURTOSIS SKEWNESS.
SPLIT FILE OFF.
* GM: Note, EMS_PAE had been listed, but that variable is no longer in the data file.

* Greg's comment about whether using raw or % variables:
* Although you don’t need to do more now, looking at the SD in R in both groups leaves me 
* thinking that we are artificially inflating the SDs of any variables correlated with R. 
* This would impair power and produce smaller effect sizes. Thus, it makes me want to consider 
* using % values instead. They in turn would have to be transformed by square root. 
* Notice how almost uniformly the % values are more skewed than the raw values. 
* That is because the SDs are better controlled (smaller) with % scores, allowing 
* outliers to appear even slightly more aberrant as a % than a raw score. 
* For instance, the raw SCHB SD is about 2.87 times larger for patients than nonpatients, 
* but the % SD is 3.56 times larger. Thus, % scores provide increased statistical power 
* (within group homogeneity).   

* Given skew in R, transform it along with the others.
COMPUTE R_SqRt = SQRT(Rorschach_N).
EXECUTE.

* Check the effectiveness of the square root transformations.
* Descriptives.
SORT CASES BY Group3.
SPLIT FILE LAYERED BY Group3.

DESCRIPTIVES VARIABLES=
   Rorschach_N Form MOR EMS SCHB SCHB2 PAE 
   Form_pct MOR_pct EMS_pct SCHB_pct SCHB2_pct PAE_pct 
   R_SqRt Form_pct_sqrt MOR_pct_sqrt EMS_pct_sqrt SCHB_pct_sqrt SCHB2_pct_sqrt PAE_pct_sqrt
  /STATISTICS=MEAN STDDEV MIN MAX KURTOSIS SKEWNESS.
SPLIT FILE OFF.
* SCHB2 is still quite skewed in the CS norms (2.62). Other variables are fine to OK in both samples. 


*****************************************************************************************************.
***************************** Preliminary Analyses **************************************************.
*****************************************************************************************************.

* Checking R, F, and F%.
T-TEST GROUPS=Group3(1 0)
  /MISSING=ANALYSIS
  /VARIABLES=Rorschach_N R_SqRt Form Form_pct
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).
* Only F% differs.


*****************************************************************************************************.
***************************** MAIN ANALYSIS *********************************************************.
*****************************************************************************************************.

* GM: Ruam, if you run this again, add a command to get the Group Statistics tables too. 
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
  /VARIABLES= Form_pct_sqrt MOR_pct_sqrt EMS_pct_sqrt SCHB_pct_sqrt SCHB2_pct_sqrt PAE_pct_sqrt 
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).
* Although unlikely, check the SCHB results to ensure they are not compromised by an outlier.
EXAMINE VARIABLES= SCHB_pct_sqrt SCHB2_pct_sqrt BY Group3
  /PLOT BOXPLOT HISTOGRAM
  /COMPARE GROUPS
  /STATISTICS NONE
  /NOTOTAL.
* ID 59 is a near outlier in the clinical group for both variables; so he is likely influential. 
* We will winsorize him. 
* For SCHB, current value is 1.14 and next highest is 0.89, so assign him 0.90.
* For SCHB2, current value is 0.62 and next highest is 0.51, so assign him 0.52.
COMPUTE SCHB_P_S_W = SCHB_pct_sqrt.
IF (ID EQ 59) SCHB_P_S_W = 0.90.
COMPUTE SCHB2_P_S_W = SCHB2_pct_sqrt.
IF (ID EQ 59) SCHB2_P_S_W = 0.52.
EXECUTE.
T-TEST GROUPS=Group3(1 0)
  /VARIABLES= SCHB_pct_sqrt SCHB_P_S_W SCHB2_pct_sqrt SCHB2_P_S_W
  /ES DISPLAY(TRUE).
* Barely perceptable differences. Interestingly, the winzorized variables meet homogeneity 
    assumptions a bit better, giving them a slightly smaller SE and larger t, despite 
    slightly smaller mean difference. 


*Nonclinical vs. Dep.
* Checking MOR, EMS, SCHB, PAE.
T-TEST GROUPS=Group2(1 0)
  /MISSING=ANALYSIS
  /VARIABLES= Form_pct_sqrt MOR_pct_sqrt EMS_pct_sqrt SCHB_pct_sqrt SCHB2_pct_sqrt PAE_pct_sqrt 
  /ES DISPLAY(TRUE)
  /CRITERIA=CI(.95).
* ESs are larger than using all patients, which is good and a bit surprising. Again, check data.
TEMPORARY.
SELECT IF (Group2 LE 1).
EXAMINE VARIABLES= SCHB_pct_sqrt SCHB2_pct_sqrt BY Group2
  /PLOT BOXPLOT HISTOGRAM
  /COMPARE GROUPS
  /STATISTICS NONE
  /NOTOTAL.
* No issues of concern (though obviously the Norm sample follows a zero inflated negative binomial 
    distribution, or even a linked logistic-poission distribution - i.e., 0 vs. not, then the dimension).

*****************************************************************************************************.
***************************** SECONDARY ANALYSIS ****************************************************.
*****************************************************************************************************.

* GM: I reordered these by importance.
*Scz+Bip vs. CS Norms.
* Checking MOR, EMS, SCHB, PAE.
T-TEST GROUPS=Group4(2 0)
  /VARIABLES= Form_pct_sqrt MOR_pct_sqrt EMS_pct_sqrt SCHB_pct_sqrt SCHB2_pct_sqrt PAE_pct_sqrt
  /ES DISPLAY(TRUE).
* Clearly smaller effects than Dep vs. Norm. SCHB clearly better than SCHB2.
* Examine outliers.
TEMPORARY.
SELECT IF (Group4 EQ 0 OR Group4 EQ 2).
EXAMINE VARIABLES= SCHB_pct_sqrt SCHB2_pct_sqrt BY Group4
  /PLOT BOXPLOT HISTOGRAM
  /COMPARE GROUPS
  /STATISTICS NONE
  /NOTOTAL.
* Possible issue with SCHB2, but hard to tell because so few non-0 cases in either group.

* Dep vs. Scz+Bip.
* Checking MOR, EMS, SCHB, PAE.
T-TEST GROUPS=Group4(1 2)
  /VARIABLES= Form_pct_sqrt MOR_pct_sqrt EMS_pct_sqrt SCHB_pct_sqrt SCHB2_pct_sqrt PAE_pct_sqrt
  /ES DISPLAY(TRUE).
* The reversal of superiority in SCHB2 over SCHB is interesting and suggests that level of expression
    may be more specific for depression than other types of conditions, even though it is generally 
    less sensitive than SCHB itself. We'd need to replicate this in at least one more sample before
    trusting it. It would be nice if true...
* Check outliers. 
TEMPORARY.
SELECT IF (Group4 EQ 1 OR Group4 EQ 2).
EXAMINE VARIABLES= SCHB_pct_sqrt SCHB2_pct_sqrt BY Group4
  /PLOT BOXPLOT HISTOGRAM
  /COMPARE GROUPS
  /STATISTICS NONE
  /NOTOTAL.
* Looks okay, though again hard to tell for SCHB2 in the psychotic group because so few non-0 cases.


*****************************************************************************************************.
***************************** Finalize and Organize *************************************************.
*****************************************************************************************************.


* OMSEND.
OMSEND TAG=['t_test'].
OMSEND TAG=['es'].
 
DATASET ACTIVATE effect_size.
* Define Variable Properties.
VARIABLE LEVEL TableNumber_ (ORDINAL).
VARIABLE LABELS 
    TableNumber_ ''
   /Standardizer ''
   /PointEstimate ''
   /Lower ''
   /Upper ''.
VALUE LABELS TableNumber_
  1 'NP vs Pt'
  2 'NP vs Pt_W'
  3 'NP vs Dep'
  4 'NP vs Psychotic'
  5 'Dep vs Psychotic'.
DELETE VARIABLES Command_ Subtype_ Label_ Standardizer.
RENAME VARIABLES 
  (TableNumber_ Var1 Var2 PointEstimate Lower Upper = 
   Analysis DV Effect ES Lo95 Hi95).
RECODE Effect
    ("Cohen's d" = "g") ("Hedges' correction" = "gC") ("Glass's delta" = "Delta").
EXECUTE.

* Put all ESs on one row.
CASESTOVARS
  /ID=Analysis DV
  /INDEX=Effect
  /GROUPBY=INDEX.
MATCH FILES FILE=*
  /KEEP=Analysis DV ES.g TO Hi95.gC ALL.
EXECUTE.

RENAME VARIABLES (ES.g ES.gC ES.Delta = g gC Delta).


DATASET ACTIVATE stats.
* Define Variable Properties.
VARIABLE LEVEL TableNumber_ (ORDINAL).
VARIABLE LABELS 
    TableNumber_ ''
   /F ''
   /Sig ''
   /t ''
   /df ''
   /Sig.2tailed ''
   /MeanDifference ''
   /Std.ErrorDifference ''
   /Lower ''
   /Upper ''.
VALUE LABELS TableNumber_
  1 'NP vs Pt'
  2 'NP vs Pt_W'
  3 'NP vs Dep'
  4 'NP vs Psychotic'
  5 'Dep vs Psychotic'.
DELETE VARIABLES Command_ Subtype_ Label_.
RENAME VARIABLES 
  (TableNumber_ Var1 Var2 Sig Sig.2tailed MeanDifference Std.ErrorDifference Lower Upper = 
   Analysis DV EQ_Var p_F p_t Diff SE Lo95 Hi95).
RECODE EQ_Var
    ("Equal variances assumed" = "EQ") ("Equal variances not assumed" = "NE").
EXECUTE.

* Put all cases on one row.
CASESTOVARS
  /ID=Analysis DV
  /INDEX=EQ_Var
  /GROUPBY=INDEX.


DATASET ACTIVATE effect_size.
SAVE OUTFILE='ISR 2022 ESs.sav'
  /COMPRESSED.
SAVE TRANSLATE OUTFILE=
  'ISR 2022 ESs.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=LABELS
  /REPLACE.


DATASET ACTIVATE stats.
SAVE OUTFILE='ISR 2022 NHST.sav'
  /COMPRESSED.
SAVE TRANSLATE OUTFILE=
  'ISR 2022 NHST.xlsx'
  /TYPE=XLS
  /VERSION=12
  /MAP
  /FIELDNAMES VALUE=NAMES
  /CELLS=LABELS
  /REPLACE.


DATASET ACTIVATE merged. 
DATASET CLOSE stats. 
DATASET CLOSE effect_size.


OUTPUT SAVE NAME=Document1 OUTFILE=
    'ISR 2022 Analyses.spv'
 LOCK=YES.


* RP organized data in R from here on. Use file called 'SPSS Output data wrangling.R'.

