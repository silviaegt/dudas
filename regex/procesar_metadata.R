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


#intento para extraer títulos:
#titles <- str_subset(lines, "(\\n).*(\\nAuthor:\\s)")

#intento con positive lookbehind para obtener sólo el nombre del autor sin "Author:" 
# authors <- str_subset(lines, "(?<=^Author:\\s)\\w+,\\s\\w+\\s\\w+\\.*\\n")
