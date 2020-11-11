fs <- list(
panreactive_genes = c("LCN2", "STEAP4", "S1PR3", "TIMP1", "HSBP1", "CXCL10", 
                      "CD44", "OSMR", "CP", "SERPINA3", "ASPG", "VIM", "GFAP", 
                      "CCL5", "CXCL8"),
A1 = c("C3", "HLA-E", "SERPING1", "HLA-A", "GGTA1P", "IRGM", "GBP2", "FBLN5", 
       "UGT1A1", "FKBP5", "PSMB8", "SRGN", "AMIGO2"),
A2 = c("CLCF1", "TGM1", "PTX3", "S100A10", "SPHK1", "CD109", "PTGS2", "EMP1", 
       "SLC10A6", "TM4SF1", "B3GNT5", "CD14", "STAT3"),
senescence_down = c("GFAP", "S100B", "ALDH1L1", "FGFR3", "SYNDIG1"),
senescence_up = c("CDKN1A", "GADD45A", "CXCL8", "IL12A", "CCND1", "ICAM1", 
                  "IGFBP5", "CXCL12")
)

## issues with A2:
# "GGTA1" should be GGTA1P in the human genome, but we don't have it in our data

## most of the senescence markers are also the wrong names
# senescence_up = c("p21", "GADD45", "IL-8", "IL-12", "Cyclin D1", "ICAM-1", "IGFBP-5", "CXCL12")

