#Propuesta de @sicabi (Sicabí Cruz) para resolver problema
#Ver: https://github.com/silviaegt/dudas/pull/1

library(tidyverse)
library(stringr)
text <- file("metadata_german_departments.txt", open = "r")
lines <- readLines(text, encoding = "UTF-8")
View(lines)

## Colapsar las líneas en una sola cadena para poder insertar un patrón = \n
lines <- paste(lines, collapse = "\n")
## Extraer el patrón todas las veces que encuentre en la cadena. 
## Me aseguré de capturar el primer titulo 
lines <- str_extract_all(string = lines, 
                         pattern = "(\n|^).*\nAuthor:.*\n", 
                         simplify = TRUE) %>% as.character()
lines
## strcapture() de utils:: para capturar en columnas patrones en lineas de chr
## pide que antes especifiquemos el data.frame de destino
tibble <- data.frame(title = character(), author = character())
## Una vez especificado el data.frame de destino, ponemos entre paretesis lo que
## deseamos extraer y fuera de los parentesis lo que deseamos que ignore
tibble <- strcapture(pattern = "\\n?(.*?)\\nAuthor:(.*)\\n", 
                     x = lines, proto = tibble)
tibble <- tibble %>% select(author, title) %>% as_tibble(.)
