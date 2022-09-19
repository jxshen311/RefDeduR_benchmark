# criteria: treat preprints and conference proceedings as duplicates if a peer-reciewed version is availabe
# Preprints and conference proceedings are removed only when there is a paired peer-reviewed article available.

# set working directory
setwd("")


library(stringr)
library(dplyr)


uni_tr <- read.xlsx("data/manually_curated_benchmarking_dataset.xlsx", sheet = "unique")["label"]

# Check the special case
# p_all_s4[which(p_all_s4$label %in% c("RN8984", "RN12649", "RN1434","RN12657", "RN8637",  "RN393")), ]

p_all_s4_com_1 <- p_all_s4 %>%
  filter(retention_mark == "article") %>%
  group_by(connection) %>%
  summarise(label_keep = paste(label, collapse = ";")) %>%
  ungroup()

p_all_s4_com_2 <- p_all_s4 %>%
  filter(retention_mark != "article") %>%
  group_by(connection) %>%
  summarise(label_remove = paste(label, collapse = ";")) %>%
  ungroup()
              
p_all_s4_com <- full_join(p_all_s4_com_1, p_all_s4_com_2, by = "connection")



for (ii in 1:nrow(uni_tr)){
  if (any(str_detect(p_all_s4_com$label_keep, uni_tr$label[ii]))){
    uni_tr$label_keep[ii] <- p_all_s4_com$label_keep[str_which(p_all_s4_com$label_keep, uni_tr$label[ii])]
    uni_tr$label_remove[ii] <- p_all_s4_com$label_remove[str_which(p_all_s4_com$label_keep, uni_tr$label[ii])]
  } else {
    uni_tr$label_keep[ii] <- NA
    uni_tr$label_remove[ii] <- NA
  }
}

uni_tr <- uni_tr %>%
  mutate(label_keep = ifelse(is.na(label_keep), label, label_keep))

rownames(uni_tr) <- NULL
