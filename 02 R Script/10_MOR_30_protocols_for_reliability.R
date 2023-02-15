# Merge Responses to code MOR -----------
library(tidyr)

control_rsp_to_merge <- control_rorscahch_rsp %>% 
  mutate(id_merge = paste0(ID_Num, "_c")) %>% 
  select(id_merge,
         Card_Num, 
         R = Resp_Num, 
         Or = Angle,
         RP = Response, 
         CP = Clarification) 

{set.seed(44)
random_15_ids_control <- control_rsp_to_merge %>% 
  count(id_merge) %>% 
  sample_n(15) %>% 
  .$id_merge}

kline_rsp_to_merge <- kline_rorschach_rsp_new_codes %>% 
  mutate(Card_Num = as.numeric(as.roman(Cd)),
         id_merge = paste0(RID, "_k")) %>% 
  select(id_merge,
         Card_Num,
         R,
         Or, 
         RP = Response, 
         CP = Inquiry
         ) 
  
{set.seed(44)
random_15_ids_kline <- kline_rsp_to_merge %>% 
  count(id_merge) %>% 
  sample_n(15) %>% 
  .$id_merge}

random_30_ids <- c(random_15_ids_control, random_15_ids_kline)

{set.seed(44)
random_30_ids_and_coders <- tibble(id_merge = random_30_ids,
       id_random =  sample(100, size = 30),
       coder = sample(rep(c("GM", "RP", "GP"),10 ), 30),
       ) }

# random_30_ids_and_coders %>% xlsx::write.xlsx("04 output/id_key_MOR_reliability.xlsx")

rorschach_rsp_complete <- control_rsp_to_merge %>% 
  full_join(kline_rsp_to_merge) %>% 
  filter(id_merge %in% random_30_ids) %>% 
  full_join(random_30_ids_and_coders) %>% 
  select(id_random, everything()) %>% 
  mutate(MOR = NA) 

rorschach_rsp_complete %>% 
  count(id_random)

rorschach_rsp_complete <- rorschach_rsp_complete %>% 
  select(-id_merge) %>% 
  arrange(coder, id_random, Card_Num, R) 


rm( control_rsp_to_merge, random_15_ids_control, kline_rsp_to_merge,
    random_15_ids_kline, random_30_ids, random_30_ids_and_coders)

rorschach_rsp_complete %>% 
  count(coder)

# rorschach_rsp_complete %>% 
#   xlsx::write.xlsx("04 output/MOR_responses_for_reliability.xlsx",
#                    showNA = F)

browseURL("04 Output")

#double checking
rorschach_rsp_complete %>% count(id_merge) %>% 
  separate(id_merge, 
           into = c("num", "text")) %>% 
  count(text)
  
