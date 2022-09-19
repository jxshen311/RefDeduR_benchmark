# set working directory
setwd("")

library(tidyr)
library(openxlsx)

# load dup_pair_b_has_doi, dup_pair_b1, and dup_pair_b2
load(file = "data/input_for_generate_dup_pair.RData")

p1 <- dup_pair_b_has_doi
p2 <- dup_pair_b1
p3 <- dup_pair_b2

# reset rownames
rownames(p1) <- NULL
rownames(p2) <- NULL
rownames(p3) <- NULL


# remove unique rows according to column "match" ----
p1 <- subset(p1,duplicated(match) | duplicated(match, fromLast=TRUE))
p2 <- subset(p2,duplicated(match) | duplicated(match, fromLast=TRUE))
p3 <- subset(p3,duplicated(match) | duplicated(match, fromLast=TRUE))


# p_all <- p1 after reset ----
# reset match number so that it starts from 1 and is continuous
p1$match <- as.numeric(factor(p1$match, ))

# reset rownames
rownames(p1) <- NULL

p1$connection <- p1$match

p_all <- p1

# Function 1: assign continuous values (max + 1...) to all(is.na(connection)) groups ----
# x: max
value_forNA <- function(df, x){
  df_sub_na <- filter(df, is.na(connection))
  df_sub_rest <- filter(df, !is.na(connection))
  
  df_sub_na <- df_sub_na %>%
    group_by(match) %>%
    mutate(connection = x + cur_group_id()) %>%
    ungroup()
  
  df_final <- rbind(df_sub_rest, df_sub_na)
  df_final <- df_final[with(df_final, order(match)), ]
  
  return(df_final)
}


# Function 2: attach_df_to_df_all(df, df_all) ----
attach_df_to_df_all <- function(df, df_all){
  df$match <- as.numeric(factor(df$match, ))
  
  # reset rownames
  rownames(df) <- NULL
  
  # attach df to df_all -> df_all
  df$connection <- df_all$connection[match(df$label, df_all$label)]
  
  df <- df %>%
    group_by(match) %>%
    mutate(connection = ifelse(all(is.na(connection)), NA, unique(connection[!is.na(connection)])))
  
  df <- value_forNA(df, max(df_all$connection))
  
  df_all <- rbind(df_all, df)
  
  return(df_all)
}

# attach p2 and p3 to p_all -> p_all ----
p_all <- attach_df_to_df_all(p2, p_all)
p_all <- attach_df_to_df_all(p3, p_all)


# deduplicate p_all + add category and retention_mark ----
p_all <- select(p_all, -match)
p_all <- p_all[!duplicated(p_all), ]

p_all$category <- "duplicate"
p_all$retention_mark <- "article"




# import duplicate records that were manually found at the downstream steps ----
p4 <- read.xlsx("data/duplicate_pairs_found_downstream.xlsx", sheet = "combined")

p_all_s4 <- p_all

# attach p4 to p_all -> p_all_s4
p4$connection <- p_all_s4$connection[match(p4$label, p_all_s4$label)]

# Noticed a special article-conference pair
# RN8637  conference  article  393
# RN12649  conference  conference  1434
# modify the original p_all as well
p_all_s4$connection[which(p_all_s4$connection == 1434)] <- 393

p4$connection[which(p4$connection == 1434)] <- 393

# modify the rest as normal
p4 <- p4 %>%
  group_by(match) %>%
  mutate(connection = ifelse(all(is.na(connection)), NA, unique(connection[!is.na(connection)]))) %>%
  ungroup()

p4 <- value_forNA(p4, max(p_all_s4$connection))


p4 <- select(p4, -match)

p_all_s4 <- rbind(p_all_s4, p4)

# deduplicate p_all_s4 according to label, remove category == "duplicate" if for the same label, category of the pair has both "duplicate" and "conference"
p_all_s4 <- p_all_s4[with(p_all_s4, order(category)), ]
p_all_s4 <- p_all_s4[!duplicated(p_all_s4$label), ]
