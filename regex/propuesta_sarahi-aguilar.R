#Propuesta de @svrvhi (Sarahí Aguilar) para resolver problema

#Si se abre "file" con encoding se obtienen 36 observaciones al final
#text <- file("metadata_german_department.txt", encoding= "UTF-8", open = "r")
text <- file("metadata_german_department.txt", open = "r")
lines <- readLines(text, encoding = "UTF-8")
title_indexes <- which(str_detect(lines, "^Author: ")) - 1 #para encontrar los títulos

titles <- vector()
authors <- vector()
pinfos <- vector() 

for (first_book_line in title_indexes) {
  last_book_line <-  title_indexes[which(first_book_line == title_indexes) + 1] - 1
  last_book_line <- ifelse(is.na(last_book_line), yes = length(lines), no = last_book_line) # Para el caso del último libro
  
  # Seleccionar solo las lineas que corresponden al registro de un solo libro
  this_book_lines <- lines[first_book_line:last_book_line]
  
  # Title
  title <- this_book_lines[1]
  
  # Author
  author <- this_book_lines[which(str_detect(this_book_lines, "^Author: "))]
  author <- str_replace(author, "Author: ", "")
  
  # Publication info
  pinfo <- this_book_lines[which(str_detect(this_book_lines, "^Publication info: "))]
  pinfo <- ifelse(identical(character(0), pinfo), yes = NA, no = pinfo) # Poner NA si ese campo no estaba en el registro libro
  pinfo <- str_replace(pinfo, "Publication info: ", "")
  
  # Concatenar
  titles <- c(titles, title)
  authors <- c(authors, author)
  pinfos <- c(pinfos, pinfo)
}

bookst <- tibble(title = titles,
                 author = authors,
                 publication_info = pinfos)
