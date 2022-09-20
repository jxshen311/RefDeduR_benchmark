## Order to run the scripts
1. generate_benchmark_dup_pairs.R
2. generate_benchmark_true_datasets.R
3. benchmark_calculation.R

<br/>
<br/>

## Details of running reference deduplication for each method
### Rayyan 
**Version:** unknown  
**Setting:** default   
**Deduplication criteria:**  
- https://help.rayyan.ai/hc/en-us/articles/4406426988177-How-does-Rayyan-handle-duplicates-  

**Date of operation:** 20220225  
**Result:**  
- 3369 duplicates detected out of 6384 (3369 unresolved) 

**High-throughput?**
	No.  
**Additional comments:**
- pros: Ranked by confidence percentages
- cons: Not customizable, not transparent

<br/>

###  Covidence 
**Version:** unknown  
**Setting:** default   
**Deduplication criteria:** 
- https://support.covidence.org/help/how-does-covidence-detect-duplicates

**Date of operation:** 20220301  
**Result:**  
- 3928 unique records, 2456 total duplicates removed

<br/>

### Endnote X20 
**Version:** 20.2  
**Setting:** default     
**Deduplication criteria:**
- Compare reference based on the following terms: author, year, title, reference type

**Date of operation:** 20220407
**Result:**
- 1947 duplicates removed; 4437 records remained

**High-throughput?** Yes

<br/>

### Zotero 
**Version:** 6.0.9  
**Setting:** default    
**Deduplication criteria:**
- "Zotero currently uses the title, DOI, and ISBN fields to determine duplicates. If these fields match (or are absent), Zotero also compares the years of publication (if they are within a year of each other) and author/creator lists (if at least one author last name plus first initial matches) to determine duplicates. The algorithm will be improved in the future to incorporate other fields. At this time, it is not possible to mark false positive matches as non-duplicates. This functionality will be added in the future."

**Date of operation:** 20220718-20220719  
**Result:**
- 3854 items in the unique dataset (among which 5 sets cannot be resolved by merging due to type differences; error message 'Merged items must be of the same type')
- Cannot automatically resolve duplicates. Has to be manual. Hackable but even with the hacking option, it is time consuming. Constantly stop working and need to click run. It took me more than a day to resolve all duplicates.
High-throughput? No. Hackable but still time-consuming.

**Additionally comments:**
- Not able to mark false positives as non-duplicates
- Deduplication can only be performed at the library scale. This means users cannot select a collection or folder and deduplicate only within the selected one.
- Cannot resolve near-duplicates with item type differences. (See [Zotero forum discussion threads](https://forums.zotero.org/discussion/69444/two-simple-improvements-for-duplicate-items-papercut))

<br/>

### Mendeley desktop
**Version:** 1.19.8  
**Setting:** default   
**Deduplication criteria:** 
- https://blog.mendeley.com/tag/deduplication/

**Date of operation:** 20220718  
**Result:**
- 1457 sets of duplicates found.

**High-throughput?** No  
**Additionally comments:**
- Can deduplicate within a selected collection or folder.
- Provide confidence levels for identified duplicates.
- According to [the official announcement](https://blog.mendeley.com/category/new-release-2/#:~:text=As%20part%20of%20the%20continued,and%20sync%20their%20Mendeley%20Desktop.), Mendeley desktop has been discontinued and will be gradually replaced by the web-centric version, Mendeley Reference Manager, which does not support reference deduplication yet. 

<br/>

### revtools
**Version:** 0.4.1  
**Setting:** 
- Follow [this provided tutorial](https://revtools.net/deduplication.html); tried 4 scenarios (see `bench_revtools.R` for source codes)

**Date of operation:** 20220720  
**Result:**
- Removed duplicates without checking
- The authors recommended manual checking. Quoted from the tutorial "Although this works, it relies very heavily on the user to check the results. The settings that you choose in `find_duplicates` strongly affect the accuracy of the result, so it is risky to simply rely on `extract_unique_references` to do the work for you. A safer choice is to use `screen_duplicates` to investigate different string matching algorithms, and to interrogate the results via `screen_duplicates`."

**High-throughput?** To some extent

<br/>

### synthesisr
**Version:** 0.3.0  
**Setting:** 
- Follow [this provided tutorial](https://cran.r-project.org/web/packages/synthesisr/vignettes/synthesisr_vignette.html)
- Added data cleaning

**Deduplication criteria:**
- Multi-step (1. exact matching by title; 2. fuzzy matching by title)

**Date of operation:** 20220721  
**Result:** 
- 3846 records remained (removed duplicates without manual checking)
- The authors recommended manual checking (need to check 556 duplicate sets)

**High-throughput?** To some extent

