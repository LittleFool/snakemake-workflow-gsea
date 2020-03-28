log <- file(snakemake@log[[1]], open="wt")
sink(log)
sink(log, type="message")

library("DESeq2")
library("data.table")

parallel <- FALSE
if (snakemake@threads > 1) {
    library("BiocParallel")
    # setup parallelization
    register(MulticoreParam(snakemake@threads))
    parallel <- TRUE
}

countData <- read.table(snakemake@input[["counts"]], header=TRUE, row.names="GeneID", check.names=FALSE)
colData <- read.table(snakemake@config[["samples"]], header=TRUE, row.names="sample", check.names=FALSE)
dds <- DESeqDataSetFromMatrix(countData=countData, colData=colData, design=~ condition)

# remove uninformative columns
dds <- dds[ rowSums(counts(dds)) > 1, ]
# normalization and preprocessing
dds <- DESeq(dds, parallel=parallel)

res <- results(dds)
res.dds <- res[order(res$padj),]

RNK = data.table(Gene_Name = row.names(res.dds), padj = res.dds$padj)
RNK = subset(RNK, padj != "NA")
write.table(RNK, snakemake@output[[1]],quote=F,sep="\t", row.names = F)
