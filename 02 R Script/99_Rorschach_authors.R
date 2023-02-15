library(readr)
library(dplyr)
library(janitor)
library(tidyr)
library(openxlsx)

df <- read_csv("00 Raw Data/Psychological Assessment Journal - Rorschach articles.csv") %>% 
  clean_names() %>% 
  select(publication_year:title, doi, issue, volume) %>% 
  arrange(-publication_year, -volume, -issue);df

authors <- df %>% 
  separate_longer_delim(author, "; ") %>% 
  group_by(author) %>% 
  summarise(publication_years = paste0(publication_year, collapse = ","),
            n_of_publications = n()) %>% 
  arrange(desc(publication_years))

l <- list("Studies" = df,
     "Authors" = authors)

write.xlsx(l, "05 Manuscript/Psychological Assessment - Rorschach Authors.xlsx")
