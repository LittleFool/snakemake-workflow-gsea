# Snakemake workflow for GSEA
This workflow performs Gene Set Enrichment Analysis with STAR and DESeq2

## Installation

**Step 1: Clone the repository**
Clone the repository into your working folder

    git clone https://github.com/LittleFool/snakemake-workflow-gsea.git

**Step 2: install miniconda**
Download and install miniconda from https://docs.conda.io/en/latest/miniconda.html

**Step 3: download GSEA**
[Download](https://www.gsea-msigdb.org/gsea/downloads.jsp) the CLI Version of GSEA from the Broad Institute and unpack it.  You do not need to install java, this will be done automatically with conda.

**Step 4: configure the workflow**
Change the settings in the file `config.yaml` as needed. Make sure the path to `gsea-cli.sh` is set correctly.

## Usage
Keep in mind, that STAR requires about 32GB RAM for human and mouse genomes, if you are working with larger genomes or start more than one STAR job at the same time you will need more RAM. For example 24 Cores will run 2 STAR jobs which need about 64GB RAM.

Test your configuration by starting a dry-run with

    snakemake --use-conda -n

Execute the workflow locally via

    snakemake --use-conda --cores $N

using `$N` cores. 

The GSEA report gets saved to `report/workflow.GseaPreranked` open the `index.html` file and check the results.

## Credits
Original workflow can be found at https://github.com/snakemake-workflows/rna-seq-star-deseq2
GSEA Software by Broad Institute, Inc., Massachusetts Institute of Technology, and Regents of the University of California https://www.gsea-msigdb.org/gsea/index.jsp
