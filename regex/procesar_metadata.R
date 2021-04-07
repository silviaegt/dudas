library(tidyverse)
library(stringr)

text <- file("metadata_german_departments.txt", open = "r")
lines <- readLines(text)
View(lines)

authors <- str_subset(lines, "(^Author:.\\w+\\,\\s\\w+)")
View(authors)
