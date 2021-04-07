#Propuesta de @rivaquiroga (https://github.com/silviaegt/dudas/issues/2)
#Modificada gracias a los resultados de @svrvhi (https://github.com/silviaegt/dudas/blob/master/regex/propuesta_sarahi-aguilar.R)
#Adaptación y notas @espejolento


# Cargar paquetes ---------------------------------------------------------
library(readr)
library(dplyr)
library(stringr)
library(tidyr)

# Leer archivo ------------------------------------------------------------
text <- file("metadata_german_departments.txt", open = "r")
lines <- readLines(text, encoding = "UTF-8") #conviene usar este método para que no se salte las files que empiezan con caracteres especiales
metadata <- as_tibble(lines)


# Transformar de filas a columnas usando expresiones regulares y pivot_wider------------
metadata <- metadata %>%
  mutate(value = case_when(
    lead(str_detect(value, "^Author:")) ~ str_c("Title: ", value),
    #Si fila X tiene debajo algo que coincide con str_detect(X1, "^Author:"), le agrega "Title: " a esa fila X.
    TRUE ~ as.character(value)
  )) %>% 
  filter(str_detect(value, "^Author: |^Title: |^Publication info: |^Subject: ")) %>% #acá se filtran las líneas con el patrón deseado
  separate(value, into = c("variable", "data"), sep = ": ", extra = "merge") %>% #se dividen las variables del contenido usando ": " como separador
  mutate(id = rep(1:100, each = 4), .before = variable) %>% # se le da el mismo id a los grupos de metadatos
  pivot_wider(names_from = variable, values_from = data) %>% #usar variable como nombre de columna y rellenar con el contenido (data)
  rename(Publication_info = 'Publication info') %>% #renombrar columna para evitar nombres con espacios
  select(., -id) #eliminar columna de "ids"


# Crear csv con resultado -------------------------------------------------
write_csv(metadata, "metadata.csv")
