#Propuesta de @rivaquiroga para resolver problema
#Ver: https://github.com/silviaegt/dudas/issues/2

library(readr)
library(dplyr)
library(stringr)
library(tidyr)

text <- file("metadata_german_department.txt", open = "r")
lines <- readLines(text, encoding = "UTF-8")
metadata <- as_tibble(lines)

metadata %>%
  mutate(value = case_when(
    lead(str_detect(value, "^Author:")) ~ str_c("Title: ", value),
    TRUE ~ as.character(value)
  )) %>% 
  filter(str_detect(value, "^Author: |^Title: ")) %>% 
  separate(value, into = c("variable", "data"), extra = "merge") %>% 
  mutate(id = rep(1:100, each = 2), .before = variable) %>% 
  pivot_wider(names_from = variable, values_from = data)
