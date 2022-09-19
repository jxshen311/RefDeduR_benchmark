# revtools

# set working directory
setwd("")


library(dplyr)
library(stringr)
library(revtools)
library(tictoc)  # to measure running time

# import
b <- read_bibliography("data/dataset_raw.bib")

# case 1 in tutorial: default (DOI) ----
matches_1 <- revtools::find_duplicates(b) 

b_uni_1 <- extract_unique_references(b, matches_1) 

write.csv(b_uni_1$label, file = "data/revtools_uni_1.csv", row.names = FALSE)



# case 2 in tutorial: match_variable = "title" ----
# Using title matching changes the defaults from exact matching to fuzzy matching using the ‘stringdist’ package. 
tic()
matches_2 <- find_duplicates(b, match_variable = "title")
toc()  # 1181.329 sec elapsed

b_uni_2 <- extract_unique_references(b, matches_2) 

write.csv(b_uni_2$label, file = "data/revtools_uni_2.csv", row.names = FALSE)

# * manual burden
# message displayed in shiny app: "Dataset with 6384 entries | Showing duplicate 1 of 1399"
test <- b
test$matches <- matches_2
screen_duplicates(test)


# case 3: default exact match (DOI) with to_lower and remove_punctuation ----
matches_3 <- find_duplicates(b, to_lower = TRUE, remove_punctuation = TRUE)

b_uni_3 <- extract_unique_references(b, matches_3) 

write.csv(b_uni_3$label, file = "data/revtools_uni_3.csv", row.names = FALSE)


# case 4 : match_variable = "title" ----
# Using title matching changes the defaults from exact matching to fuzzy matching using the ‘stringdist’ package. 
tic("match_4")
matches_4 <- find_duplicates(b, match_variable = "title", to_lower = TRUE, remove_punctuation = TRUE)
toc()  # match_4: 1056.228 sec elapsed

b_uni_4 <- extract_unique_references(b, matches_4) 

write.csv(b_uni_4$label, file = "data/revtools_uni_4.csv", row.names = FALSE)

# * manual burden
# message displayed in shiny app: "Dataset with 6384 entries | Showing duplicate 1 of 1460"
test <- b
test$matches <- matches_4
screen_duplicates(test)
