#Propuesta de @rivaquiroga para resolver problema
#Ver: https://github.com/silviaegt/dudas/issues/2

library(readr)
library(dplyr)
library(stringr)
library(tidyr)

metadata <- read_tsv("https://raw.githubusercontent.com/silviaegt/dudas/master/regex/metadata_german_departments", col_names = FALSE)
?lead
auti <- metadata %>%
  mutate(X1 = case_when(
    lead(str_detect(X1, "^Author:")) ~ str_c("Title: ", X1), #aquí se identifica el tíutulo y se le añade Title:
    TRUE ~ as.character(X1)
  )) %>% 
  filter(str_detect(X1, "^Author: |^Title: ")) %>% #acá se filtran las líneas con Author y Title
  separate(X1, into = c("variable", "data"), extra = "merge") %>% #se divide "Title:" y "Author:" (en variable) del contenido (en data)
  mutate(id = rep(1:83, each = 2), .before = variable) %>%  # se le da el mismo id a los pares de Title/Author
  pivot_wider(names_from = variable, values_from = data) 

#se obtienes 83 observaciones
