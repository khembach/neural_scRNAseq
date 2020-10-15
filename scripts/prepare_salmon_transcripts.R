## We extract the transcript sequence from the plasmid sequence and save a fasta file for index creation with salmon.

library(Biostrings)
library(stringr)

seq <- readDNAStringSet(file.path("data", "reference",
                                  "pLVX-TRE-TDP43-HA-IRES-T7-rtTA.fa"))
# Theoretically, the transcript should be 2505 (2525 is ATG) - ~5818
seq[[1]] <- seq[[1]][2505:5818]
names(seq) <- "TDP43-HA_transcript"
writeXStringSet(seq, file.path("data", "reference", "TDP43-HA_transcript.fa"),
                format = "fasta")

## We also quantify the endogenous TDP-43
## endogenous TDP-43 transcripts
## We remove the empty sequences from the fasta file
seq1 <- readDNAStringSet(file.path("data", "reference",
                                   "TDP43_transcripts1.fa"))
seq1 <- seq1[lengths(seq1)>0]
writeXStringSet(seq1, file.path("data", "reference", "TDP43_transcripts.fa"),
                format = "fasta")

## generate transcript to gene mapping
tr_ids <- str_split(names(seq1), " ", simplify = TRUE)[,1]
df <- data.frame(transcript_id = tr_ids, gene_id = "ENSG00000120948.17")
df <- rbind(df, c("TDP43-HA_transcript", "TDP43-HA"))
write.table(df, file.path("data", "reference", "t2g.txt"), sep = "\t",
                          row.names = FALSE, col.names = FALSE,
            quote = FALSE)

names(seq1) <- tr_ids

writeXStringSet(c(seq1, seq), file.path("data", "reference",
                                        "TDP43_transcripts_all.fa"),
                format = "fasta")
