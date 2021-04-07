library(tidyverse)
library(stringr)

text <- file("metadata_german_departments.txt", open = "r")
lines <- readLines(text)
View(lines)

## Colapsar las líneas en una sola cadena para poder insertar un patrón = \n
lines <- paste(lines, collapse = "\n")
## Extraer el patrón todas las veces que encuentre en la cadena. 
## Me aseguré de capturar el primer titulo 
lines <- str_extract_all(string = lines, 
                         pattern = "(\n|^).*\nAuthor:.*\n", 
                         simplify = TRUE) %>% as.character()
## strcapture() de utils:: para capturar en columnas patrones en lineas de chr
## pide que antes especifiquemos el data.frame de destino
tibble <- data.frame(title = character(), author = character())
## Una vez especificado el data.frame de destino, ponemos entre paretesis lo que
## deseamos extraer y fuera de los parentesis lo que deseamos que ignore
tibble <- strcapture(pattern = "\\n?(.*?)\\nAuthor:(.*)\\n", 
                     x = lines, proto = tibble)
tibble <- tibble %>% select(author, title) %>% as_tibble(.)
tibble

## El resultado sería:

# A tibble: 100 x 2
#   author                    title                                              
#   <chr>                     <chr>                                              
# 1 " Seale, Joshua Alexande… Between Austria and Germany, Heimat and Zuhause: G…
# 2 " Quam, Justin Erle"      Helping Language Learners Align with Readers Throu…
# 3 " Rommelfanger, Tanja"    Wie Bauen? Eine Kritische Auseinandersetzung Mit D…
# 4 " Rothe, Lucian"          Imagined Social Spaces: Stereotypical Attributions…
# 5 " Hertel, Jeffrey Alden"  Liberating Laughter. Dramatic Satire and the Germa…
# 6 " Gill, John Thomas"      <em>Wild Politics</em>: Political Imagination in G…
# 7 " Reif, Margaret Suzanne… Disruptive Organizers: Wild Children in German Rea…
# 8 " Anderlé de Sylor, Juli… The <em>Heimatklänge</em> and the Danube Swabians …
# 9 " Nester, Adi"            Biblical Operas and the Discourse of German-Jewish…
#10 " Nowicki, Anna-Rebecca"  Die Poetik der Abweichung: Menschen mit Behinderun…
## … with 90 more rows
#> View(tibble)



#intento con lag:
#titles <- lag(str_subset(lines, "(^Author:.\\w+\\,\\s\\w+)"))
#View(titles)
#Nota: sólo regresa un string vacío antes del primer patrón detectado
#Ver: https://twitter.com/espejolento/status/1379633590481260548
#Nota 2: se requiere hacer slice(lag(str_detect..) para trabajar con los índices
#pero para esto tiene que ser un dataframe
#Ver: https://twitter.com/LuisDVerde/status/1379635446288949248


#intento para extraer títulos:
#titles <- str_subset(lines, "(\\n).*(\\nAuthor:\\s)")

#intento con positive lookbehind para obtener sólo el nombre del autor sin "Author:" 
# authors <- str_subset(lines, "(?<=^Author:\\s)\\w+,\\s\\w+\\s\\w+\\.*\\n")
