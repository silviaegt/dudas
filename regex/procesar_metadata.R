library(tidyverse)
library(stringr)

text <- file("metadata_german_departments.txt", open = "r")
lines <- readLines(text)
View(lines)

authors <- str_subset(lines, "(^Author:.\\w+\\,\\s\\w+)")

#intento con lag:
#titles <- lag(str_subset(lines, "(^Author:.\\w+\\,\\s\\w+)"))
#View(titles)
#Nota: sólo regresa un string vacío antes del primer patrón detectado
#Ver: https://twitter.com/espejolento/status/1379633590481260548
#Nota 2: se requiere hacer slice(lag(str_detect..) para trabajar con los índices
#pero para esto tiene que ser un dataframe
#Ver: https://twitter.com/LuisDVerde/status/1379635446288949248



library(readr)
library(dplyr)
library(stringr)
library(tidyr)

metadata <- read_tsv("https://raw.githubusercontent.com/silviaegt/dudas/master/regex/metadata_german_departments", col_names = FALSE)

metadata %>%
  mutate(X1 = case_when(
    lead(str_detect(X1, "^Author:")) ~ str_c("Title: ", X1),
    TRUE ~ as.character(X1)
  )) %>% 
  filter(str_detect(X1, "^Author: |^Title: ")) %>% 
  separate(X1, into = c("variable", "data"), extra = "merge") %>% 
  mutate(id = rep(1:83, each = 2), .before = variable) %>% 
  pivot_wider(names_from = variable, values_from = data) 


#intento para extraer títulos:
#titles <- str_subset(lines, "(\\n).*(\\nAuthor:\\s)")

#intento con positive lookbehind para obtener sólo el nombre del autor sin "Author:" 
# authors <- str_subset(lines, "(?<=^Author:\\s)\\w+,\\s\\w+\\s\\w+\\.*\\n")
