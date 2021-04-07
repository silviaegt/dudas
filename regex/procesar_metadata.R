#Propuesta de @rivaquiroga (https://github.com/silviaegt/dudas/issues/2)
#Modificada gracias a los resultados de @svrvhi (https://github.com/silviaegt/dudas/blob/master/regex/propuesta_sarahi-aguilar.R)
#Adaptación y notas @espejolento


# Cargar paquetes ---------------------------------------------------------
library(readr)
library(dplyr)
library(stringr)
library(tidyr)
library(janitor)

# Leer archivo ------------------------------------------------------------
text <- file("metadata_german_departments.txt", open = "r") #ver archivo: https://github.com/silviaegt/dudas/blob/master/regex/metadata_german_departments
lines <- readLines(text, encoding = "UTF-8") #conviene usar este método para que no se salte las files que empiezan con caracteres especiales
metadata <- as_tibble(lines)


# Transformar de filas a columnas usando expresiones regulares y pivot_wider------------
metadata_tb <- metadata %>%
  mutate(value = case_when(
    lead(stringr::str_detect(value, "^Author:")) ~ str_c("Title: ", value),
    #Si fila X tiene debajo algo que coincide con str_detect(X1, "^Author:"), le agrega "Title: " a esa fila X.
    TRUE ~ as.character(value)
  )) %>% 
  dplyr::filter(stringr::str_detect(value, "^Author: |^Title: |^University/institution: |^Subject: |^Abstract: ")) %>% #acá se filtran las líneas con el patrón deseado
  tidyr::separate(value, into = c("variable", "data"), sep = ": ", extra = "merge") %>% #se dividen las variables del contenido usando ": " como separador
  dplyr::group_by(variable) %>% #se crean grupos según los nombres en las variables
  dplyr::mutate(row = row_number()) %>% #se agregan números para hacer el pivot_wider (pondrá el mismo id por "paquetes" de las n variables)
  tidyr::pivot_wider(names_from = variable, values_from = data) %>% 
  janitor::clean_names() %>% #para que los nombres sean uniformes (sin signos de puntuación, mayúsculas, etc) 
  dplyr::select(-row)
 
# Crear csv con resultado -------------------------------------------------
write_csv(metadata_tb, "metadata.csv")
