source("02 R Script/00_functions.R")
load("01 Processed data/df_complete.Rdata")

# Merge MOR and MOR_2nd at response level
# same info from "01_cleaning_data.R"
kline_rorschach_rsp <- read_excel("00 Raw Data/Jessa Coded Responses - Kline Dataset 04-23-2020.xlsx") %>%  
  mutate( ID = str_sub(CID, 2, 3) %>% as.numeric)

control_rorscahch_rsp <- read_excel("01 Processed data/Norm145 Responses - 70 Cases Matched to Kline Inpatients.xlsx") %>% mutate(across(FileName, ~str_replace_all(.x, " ", "")))

kline_rorschach_rsp2 <- kline_rorschach_rsp %>% 
  select(CID, ID, Card, Rn, MOR) %>% 
  left_join(df_complete %>% 
              select(RID, ID_Num, CID, id_random, id_merge)) %>% #RID
  select(RID, Card_Num = Card, R = Rn, MOR)

control_rorscahch_rsp2 <- control_rorscahch_rsp %>% 
  select(ID_Num, Card_Num, R = Resp_Num, MOR) %>% #ID_Num
  mutate(MOR = if_else(!is.na(MOR), 1,0 ))

## Response level of all MOR original
mor_rsp_original <- kline_rorschach_rsp2 %>% 
  bind_rows(control_rorscahch_rsp2) %>% 
  relocate(ID_Num) 

rm(kline_rorschach_rsp, control_rorscahch_rsp,
   kline_rorschach_rsp2, control_rorscahch_rsp2)

# From "10_MOR_30_protocols_for_reliability.R"
mor_rsp2 <- mor_rsp %>% rename(MOR_2nd = MOR, MOR_2nd_coder = coder)  %>% 
  left_join(mor_rsp_original) %>% 
  relocate(MOR, .before = MOR_2nd)

mor_disagreement <- mor_rsp2 %>% 
  mutate(MOR_disagreement = if_else(MOR == MOR_2nd, 0, 1)) %>% 
  filter(MOR_disagreement == 1)

# Number of disagreement by respondents 
mor_disagreement %>% 
  count(MOR_2nd_coder)

# Number of disagreement protocol level
mor_disagreement %>% 
  count(MOR_2nd_coder, id_merge) %>% 
  count(MOR_2nd_coder)

# writexl::write_xlsx(mor_disagreement, "00 Raw Data/MOR_disagreements.xlsx")

# id_merge, ID_Num, RID, id_random  
