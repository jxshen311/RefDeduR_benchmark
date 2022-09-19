# set working directory ----
setwd("")


# benchmarking dataset information ---- 
n_total <- 6384
n_uniT <- nrow(uni_tr)
n_dupT <- n_total - n_uniT


# create benchmarking summary dataframe ----
bench_summary <- data.frame(matrix(ncol = 8, nrow = 3))
colnames(bench_summary) <- c("method", "unique_references_retained",	"duplicates_flagged", "FP",	"FN",	"accuracy",	"sensitivity",	"specificity")
bench_summary$method <- c("endnote", "zotero", "covidence")



# Function 1: calculate false positive ----
# uniT: dataframe of unique reference (true) (e.g., uni_tr)
# uniO: dataframe of unique reference (observed) (e.g., endnote_uni)
# FP: records in uniT but not in uniO
cal_FP <- function(uniT, uniO){
  in_uniO_str <- paste0("in_", deparse(substitute(uniO)))
  
  for (ii in 1:nrow(uniT)){
    # return TRUE if any label value in uniT$label_keep can be found in uniO$label
    uniT[[in_uniO_str]][ii] <- any(strsplit(uniT$label_keep[ii], ";")[[1]] %in% uniO$label)
  }
  
  FP = sum(!uniT[[in_uniO_str]])  
  
  return(FP)
}



# Function 2: calculate false negative ----
# uniT: dataframe of unique reference (true) (e.g., uni_tr)
# uniO: dataframe of unique reference (observed) (e.g., endnote_uni)
# FN: 
cal_FN <- function(uniT, uniO){
  in_uniT_str <- paste0("in_", deparse(substitute(uniT)))
  
  for (ii in 1:nrow(uniO)){
    uniO[[in_uniT_str]][ii] <-  ifelse(any(str_detect(uniT$label_keep, uniO$label[ii])), str_which(uniT$label_keep, uniO$label[ii]), "not detected")
  }
  
  
  df_temp <- filter(uniO, !!as.symbol(in_uniT_str) != "not detected")
  FN = sum(duplicated(df_temp[[in_uniT_str]]))
  
  FN = FN + sum(uniO[[in_uniT_str]] == "not detected")
  
  return(FN)
}




# import unique references (observed) and make calculations ----
# * endnote ----
endnote_uni <- read_table("data/endnote_uni_refNo.txt", col_names = FALSE)
colnames(endnote_uni) <- "label"

index_row <- which(bench_summary$method == "endnote")
bench_summary$unique_references_retained[index_row] <- nrow(endnote_uni)
bench_summary$duplicates_flagged[index_row] <- n_total - nrow(endnote_uni)
bench_summary$FP[index_row] <- cal_FP(uni_tr, endnote_uni)  # 0
bench_summary$FN[index_row] <- cal_FN(uni_tr, endnote_uni)  # 608



# * covidence ----
covidence_uni <- read.csv("data/review_198900_screen_csv_20220302091128.csv")["Ref"]
colnames(covidence_uni) <- "label"
covidence_uni$label <- paste0("RN", covidence_uni$label)

index_row <- which(bench_summary$method == "covidence")
bench_summary$unique_references_retained[index_row] <- nrow(covidence_uni)
bench_summary$duplicates_flagged[index_row] <- n_total - nrow(covidence_uni)
bench_summary$FP[index_row] <- cal_FP(uni_tr, covidence_uni)  
bench_summary$FN[index_row] <- cal_FN(uni_tr, covidence_uni)  



# * zotero ----
zotero_uni <- read_table("data/zotero_uni_refNo.txt", col_names = FALSE)
colnames(zotero_uni) <- "label"

index_row <- which(bench_summary$method == "zotero")
bench_summary$unique_references_retained[index_row] <- nrow(zotero_uni)
bench_summary$duplicates_flagged[index_row] <- n_total - nrow(zotero_uni)
bench_summary$FP[index_row] <- cal_FP(uni_tr, zotero_uni)  
bench_summary$FN[index_row] <- cal_FN(uni_tr, zotero_uni)  




# * revtools ----
# add rows to bench_summary
bench_summary <- bench_summary %>% add_row(method = paste0("revtools_uni_", seq(1:4)))

# revtools_uni_1 
revtools_uni_1 <- read.csv("data/revtools_uni_1.csv")
colnames(revtools_uni_1) <- "label"

index_row <- which(bench_summary$method == "revtools_uni_1")
bench_summary$unique_references_retained[index_row] <- nrow(revtools_uni_1)
bench_summary$duplicates_flagged[index_row] <- n_total - nrow(revtools_uni_1)
bench_summary$FP[index_row] <- cal_FP(uni_tr, revtools_uni_1)  
bench_summary$FN[index_row] <- cal_FN(uni_tr, revtools_uni_1)  

# revtools_uni_2 
revtools_uni_2 <- read.csv("data/revtools_uni_2.csv")
colnames(revtools_uni_2) <- "label"

index_row <- which(bench_summary$method == "revtools_uni_2")
bench_summary$unique_references_retained[index_row] <- nrow(revtools_uni_2)
bench_summary$duplicates_flagged[index_row] <- n_total - nrow(revtools_uni_2)
bench_summary$FP[index_row] <- cal_FP(uni_tr, revtools_uni_2)  
bench_summary$FN[index_row] <- cal_FN(uni_tr, revtools_uni_2)  

# revtools_uni_3 
revtools_uni_3 <- read.csv("data/revtools_uni_3.csv")
colnames(revtools_uni_3) <- "label"

index_row <- which(bench_summary$method == "revtools_uni_3")
bench_summary$unique_references_retained[index_row] <- nrow(revtools_uni_3)
bench_summary$duplicates_flagged[index_row] <- n_total - nrow(revtools_uni_3)
bench_summary$FP[index_row] <- cal_FP(uni_tr, revtools_uni_3)  
bench_summary$FN[index_row] <- cal_FN(uni_tr, revtools_uni_3)  

# revtools_uni_4 
revtools_uni_4 <- read.csv("data/revtools_uni_4.csv")
colnames(revtools_uni_4) <- "label"

index_row <- which(bench_summary$method == "revtools_uni_4")
bench_summary$unique_references_retained[index_row] <- nrow(revtools_uni_4)
bench_summary$duplicates_flagged[index_row] <- n_total - nrow(revtools_uni_4)
bench_summary$FP[index_row] <- cal_FP(uni_tr, revtools_uni_4)  
bench_summary$FN[index_row] <- cal_FN(uni_tr, revtools_uni_4)  




# * synthesisr ----
# add rows to bench_summary
bench_summary <- bench_summary %>% add_row(method = "synthesisr")

synthesisr_uni <- read.csv("data/synthesisr_uni.csv")
colnames(synthesisr_uni) <- "label"

index_row <- which(bench_summary$method == "synthesisr")
bench_summary$unique_references_retained[index_row] <- nrow(synthesisr_uni)
bench_summary$duplicates_flagged[index_row] <- n_total - nrow(synthesisr_uni)
bench_summary$FP[index_row] <- cal_FP(uni_tr, synthesisr_uni)  
bench_summary$FN[index_row] <- cal_FN(uni_tr, synthesisr_uni)  


# * RefDeduR ----
# add rows to bench_summary
bench_summary <- bench_summary %>% add_row(method = "RefDeduR")

RefDeduR_uni <- read.csv("data/RefDeduR_0.7_0.3_b4.csv")
colnames(RefDeduR_uni) <- "label"

index_row <- which(bench_summary$method == "RefDeduR")
bench_summary$unique_references_retained[index_row] <- nrow(RefDeduR_uni)
bench_summary$duplicates_flagged[index_row] <- n_total - nrow(RefDeduR_uni)
bench_summary$FP[index_row] <- cal_FP(uni_tr, RefDeduR_uni)  
bench_summary$FN[index_row] <- cal_FN(uni_tr, RefDeduR_uni)  




# summary: calculate sensitivity, specificity and accuracy ----
bench_summary <- bench_summary %>%
  mutate(sensitivity = round((duplicates_flagged - FP)/n_dupT*100, digits = 2),
         specificity = round((unique_references_retained - FN)/n_uniT*100, digits = 2),
         accuracy = round((n_total - FN - FP)/n_total*100, digits = 2))
