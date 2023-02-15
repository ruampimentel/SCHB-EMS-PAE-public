library(haven)
library(dplyr)
library(readxl)
library(stringr)
library(sjmisc)
library(sjlabelled)
library(labelled)
library(janitor)
library(readr)
library(magrittr)

source("02 R Script/00_functions.R")


# ISR dataset ----
##%######################################################%##
#                                                          #
####                       Kline                        ####
#                                                          #
##%######################################################%##

# Rorschach protocols for Kline's dataset coded by jessa
# No SCHB, EMS, PAE
kline_rorschach_rsp <- read_excel("00 Raw Data/Jessa Coded Responses - Kline Dataset 04-23-2020.xlsx") %>%  
  mutate( ID = str_sub(CID, 2, 3) %>% as.numeric)

kline_rorschch_ptl_standard_codes <- kline_rorschach_rsp %>%
  group_by(CID, ID) %>% 
  summarise(across(c(MOR, `F`), ~sum(.x, na.rm = TRUE) ),
            R = n())

# SCHB, EMS, PAE for Kline's response
kline_rorschach_rsp_new_codes <- read_excel("00 Raw Data/Kline Protocols R-ID - All with Updated GM SCHB and EMS.xlsx") %>% 
  rename(RID = `R-ID`)
# SCHB, EMS, PAE, protocol level
kline_rorschach_ptl_new_codes <- kline_rorschach_rsp_new_codes %>% 
  rename(SCHB = SCHB_GM,
         EMS  = EMS_GM,
         PAE = PAE_GM) %>% 
  mutate(SCHB1 = ifelse(SCHB == 1, 1, NA_integer_),
         SCHB2 = ifelse(SCHB == 2, 1, NA_integer_)) %>% 
  group_by(RID) %>% 
  summarise(across(c(SCHB1, SCHB2, SCHB, EMS, PAE), ~sum(.x, na.rm = TRUE) ),
            R_n = n())


# Kline dataset with SCHB, EMS, PAE, MOR, and Complexity (complete)
kline_complete <- read_sav("01 Processed data/Kline Db Complete - SCID Updated & Recoded - SCHB, EMS, PAE, MOR, Complexity included.sav")

kline_complete %>% select(ID:RID) %>% glimpse

## kline demographics and DV. 
kline_focus <- kline_complete %>% 
  select(ID:Duration, Dep_PC1:Group2_NEG_Wgt) %>% # include criterion as well (check SPSS file)
  identity() 

# [done] merge all the datasets below. 
## kline_rorschach_ptl_new_codes
## kline_rorschch_ptl_standard_codes
## kline_complete

kline_complete <- kline_complete %>% 
  select(ID:RID) %>% 
  select(ID, RID, everything()) %>% 
  full_join(kline_rorschch_ptl_standard_codes) %>% 
  full_join(kline_rorschach_ptl_new_codes)

## Merged dataset
kline_complete %>% glimpse

# note that R and R_n is not identical in all cases. Maybe it is a problem with deleting NAs?
# For now use R, nor R_n

# cases in which R and R_n are different
kline_complete %>% 
  select(ID, RID, R, R_n) %>% 
  mutate(diff_R = ifelse(R != R_n, 1, 0 )) %>% 
  filter(diff_R == 1)

##%######################################################%##
#                                                          #
####                     145 Norms                      ####
#                                                          #
##%######################################################%##

# Full norms demographics (145 protocols)
norms_demographics <- read_sav("00 Raw Data/Int1396 - 145 Full-Text IDs and Demographics.sav")

# 70 norms demographics
control_demographics <- read_sav("01 Processed data/rpas norms 70 matched with kline - Full-Text IDs and Demographics.sav") %>% mutate(across(c(ID:FileName, FileName2), ~str_replace_all(.x, " ", ""))) 
control_demographics 

# Rorschach response level
control_rorscahch_rsp <- read_excel("01 Processed data/Norm145 Responses - 70 Cases Matched to Kline Inpatients.xlsx") %>% mutate(across(FileName, ~str_replace_all(.x, " ", "")))
control_rorscahch_rsp %>% glimpse()

# Rorschach protocol (ptl) level
control_rorscahch_ptl <- control_rorscahch_rsp %>% 
  mutate(SCHB1 = ifelse(SCHB == "1", 1, NA_integer_),
         SCHB2 = ifelse(SCHB == "2", 1, NA_integer_),
         across(SCHB:PAE, ~case_when(!.x %in% c('2','1','0') ~ NA_character_,
                                     TRUE ~ .x)),
         across(SCHB:PAE, ~as.numeric(.x)),
         across(c(`F`, MOR),~ifelse(.x == cur_column(),1 , NA_integer_) )
         ) %>% 
  # glimpse 
  group_by(FileName) %>% 
  summarise(R = median(R),
            across(c(`F`, MOR, SCHB1, SCHB2, SCHB, EMS, PAE ), ~sum(.x, na.rm = TRUE)))


##%######################################################%##
#                                                          #
####              Organize data to Merge                ####
#                                                          #
##%######################################################%##


## Control data ----------------------------------------------------------------
control_complete <- control_demographics %>% 
  full_join(control_rorscahch_ptl)

control_complete <- control_complete %>% 
  mutate(Marital = recode(Marital,
                          `1` = 1L, # single (includes never married)
                          `2` = 2L, # married or cohabiting
                          `3` = 2L, 
                          `4` = 3L, # separated, divorced, or widowed
                          `5` = 3L,
                          `6` = 3L,
                          .keep_value_labels = FALSE)) %>% 
  add_value_labels(Marital = c("single" = 1,
                               "married or cohabiting" = 2,
                               "separated, divorced or widowed " = 3)) 

# final merge - bind_rows

control_complete %>% count(EdLevel)
kline_complete %>% count(Education)

## Kline Data -----------------------------------------------------------------
kline_complete %>% count(Marital)
kline_complete <- kline_complete %>% 
  mutate(EdLevel = dplyr::recode(Education,
                       `1` = 1L, 
                       `2` = 2L, 
                       `3` = 3L, 
                       `4` = 4L,
                       `5` = 4L,
                       `6` = 5L, 
                       `7` = 6L,
                       .combine_value_labels = TRUE),
         Ethnicity = dplyr::recode(Ethnicity,
                                   `1` = 2L, 
                                   `2` = 3L, 
                                   `3` = 1L, 
                                   `5` = 4L,
                                   .keep_value_labels = TRUE),
         Marital = recode(Marital,
                          `1` = 1L, # single (includes never married)
                          `2` = 2L, # married or cohabiting
                          `3` = 3L, # separated, divorced, or widowed
                          `4` = 3L,
                          `5` = 3L,
                          .keep_value_labels = FALSE)) %>% 
  labelled::add_value_labels(EdLevel = c( "Some Graduate or Professional School / Any Post-Graduate" = 6),
                             Ethnicity = c( "White" = 1,
                                            "Black" = 2,
                                            "Hispanic" = 3,
                                            "Asian" = 4,
                                            "Other or Mixed" = 5),
                             Marital = c("single" = 1,
                                         "married or cohabiting" = 2,
                                         "separated, divorced or widowed " = 3)) 


# [x] Check Ethnicity, 
# [x] Check marital,  
# [x] Check Educational Level

kline_complete %>% count(Marital)
control_complete %>% count(Marital)

kline_complete %>% count(EdLevel)
control_complete %>% count(EdLevel)

kline_complete %>% count(Ethnicity)
control_complete %>% count(Ethnicity)

kline_complete %>% count(Gender)
control_complete %>% count(Gender)

rm(control_demographics, control_rorscahch_ptl, control_rorscahch_rsp,
   kline_focus, kline_rorschach_ptl_new_codes, kline_rorschach_rsp,
   kline_rorschach_rsp_new_codes, kline_rorschch_ptl_standard_codes,
   norms_demographics)

##%######################################################%##
#                                                          #
####  df_complete - Kline and Control Complete Merge    ####
#                                                          #
##%######################################################%##

df_complete <- kline_complete %>%
  mutate(ID = as.character(ID)) %>% 
  full_join(control_complete) 

df_complete <- df_complete %>%
  mutate(EMS_PAE = EMS + PAE,
         Group1 = recode(Group, 
                         .missing = 0),
         Group2 = case_when(Group == 0 ~ 0,
                            Group == 1 ~ 1,
                            Group == 2 & SCID.CMDS.A1r > .5 & (SCID.CMDS.A7r > .5 | SCID.CMDS.A9r > .5) ~ 1,
                            Group == 2 ~ 3,
                            Group == 3 ~ 2,
                            Group %in% c(4, 5, 6, 7) ~ 3,
                            TRUE ~ 0),
         control = case_when(Group1 == 0 ~ 1,
                             TRUE ~ 0),
         patient = case_when(control == 1 ~ 0,
                             control == 0 ~ 1),
         Group3 = case_when(Group2 == 0 ~ 0,
                            Group2 == 1 ~ 2,
                            Group2 == 2 ~ 1,
                            TRUE ~ 1)) %>% 
  labelled::add_value_labels(Group1 = c("Control" = 0),
                             control = c("Control" = 1,
                                         "Patient" = 0),
                             patient = c("Patient" = 1,
                                         "Control" = 0),
                             Group2 = c("Control" = 0,
                                        "Dep" = 1,
                                        "Bip" = 2,
                                        "SA and Scz" = 3) ,
                             Group3 = c("Control" = 0,
                                        "SA and Sz" = 1,
                                        "Dep" = 2)) %>% 
  select(ID:CID, R, `F`, MOR, SCHB, SCHB1, SCHB2, EMS, PAE, EMS_PAE, everything() ) %>% 
  mutate(
    across(`F`:EMS_PAE, ~./R, .names = "{.col}_pct"),
    across(`F`:EMS_PAE, ~sqrt(.), .names = "{.col}_sqrt"),
    across(F_pct:EMS_PAE_pct, ~sqrt(.), .names = "{.col}_sqrt")) %>%
  # organizing contrasts
  mutate(contrast1 = case_when( Group2 == 1 ~ 2,
                                Group2 == 2 ~ 1, 
                                Group2 == 3 ~ 0, 
                                TRUE ~ NA_real_),
         contrast2 = case_when( control == 0 ~ 1,
                                control == 1 ~ 0),
         contrast3 = case_when(Group3 == 2 ~ 2, 
                               Group3 == 1 ~ 1,
                               Group3 == 0 ~ 0))


##%######################################################%##
#                                                          #
####                   MOR 2nd coder                    ####
#                                                          #
##%######################################################%##

id_key <- read_excel("04 output/id_key_MOR_reliability.xlsx") %>% 
  select(-`...1`) %>% 
  mutate(ID_Num = if_else(str_detect(id_merge, "_c"),
                          parse_number(id_merge),
                          NA_real_),
         RID = if_else(str_detect(id_merge, "_k"),
                       parse_number(id_merge),
                       NA_real_)
  ) 

mor_gm <- read_excel("00 Raw Data/MOR_responses_for_reliability RP GM.xlsx") %>% 
  filter(coder == "GM")

mor_gp <- read_excel("00 Raw Data/MOR_responses_for_reliability RP_GP.xlsx") %>% 
  filter(coder == "GP") %>% 
  mutate(across(c(Order, Card_Num), ~as.double(.x) ))

mor_rp <- read_excel("00 Raw Data/MOR_responses_for_reliability RP3 GM.xlsx") %>% 
  filter(coder == "RP") %>% # coding questions reviewed by Greg. See "comment" column for "GM = ..."
  mutate(across(c(Order, Card_Num), ~as.double(.x) ))

## MOR response level -------
mor_rsp <- mor_gm %>% 
  full_join(mor_gp) %>% 
  full_join(mor_rp) %>% 
  arrange(Order) %>% 
  full_join(id_key) %>% 
  select(Order, id_merge, ID_Num, RID, id_random, everything())


# writexl::write_xlsx(mor_rsp, "00 Raw Data/MOR_response_for_reliability_2nd_coders.xlsx")

rm(mor_gm, mor_gp, mor_rp)

mor_ptl <- mor_rsp %>%
  group_by(id_merge, ID_Num, RID, id_random) %>% 
  summarise(MOR_2nd = sum(MOR),
            MOR_2nd_coder = first(coder)) %>% # MOR_2nd = MOR for reliability
  ungroup() 

df_complete %<>% 
  full_join(mor_ptl) %>% 
  select(ID, RID, ID_Num, CID, id_random, id_merge, everything()) %>% 
  relocate(MOR_2nd, .after = MOR) %>% 
  relocate(MOR_2nd_coder, .after = MOR_2nd) 

# Adding Dep_composite by raters
# df_complete %<>% bind_cols(df_dep_comp3) # from 04.01_Dep_composite_by_rater.R file

rm(mor_ptl, id_key)
df_complete %>% glimpse()

save.image("01 Processed data/df_complete.Rdata")

