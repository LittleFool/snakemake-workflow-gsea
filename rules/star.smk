def is_single_end(sample, unit):
    return pd.isnull(units.loc[(sample, unit), "fq2"])

def get_fq(wildcards):
    if config["trimming"]["skip"]:
        # no trimming, use raw reads
        return units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()
    else:
        # yes trimming, use trimmed data
        if not is_single_end(**wildcards):
            # paired-end sample
            return expand("data/trimmed/{sample}-{unit}.{group}.fastq.gz",
                          group=[1, 2], **wildcards)
        # single end sample
        return "data/trimmed/{sample}-{unit}.fastq.gz".format(**wildcards)

rule align:
	input:
		get_fq
	output:
		"data/mapped_reads/{sample}-{unit}.Aligned.out.bam"
	threads:
		12
	envmodules:
		"STAR/2.7.1a"
	conda:
		"../envs/star.yaml"
	log:
        	"logs/star/{sample}-{unit}.log"
	benchmark:
		"benchmarks/star/{sample}-{unit}.tsv"
	shell:
		"STAR --runThreadN {threads} --genomeDir {config[genomeDir]} --readFilesIn {input} --readFilesCommand zcat --outFileNamePrefix data/mapped_reads/{wildcards.sample}-{wildcards.unit}. --outReadsUnmapped Fastx --outSAMtype BAM Unsorted --outStd Log {log}"

