def get_fastq(wildcards):
	return units.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]].dropna()

def getReverseAdapter():
	return config["trimming"]["adapter"][::-1]

rule cutadapt_pe:
	input:
		get_fastq
	output:
		fastq1="data/trimmed/{sample}-{unit}.1.fastq.gz",
		fastq2="data/trimmed/{sample}-{unit}.2.fastq.gz"
	threads:
		workflow.cores - 4
	params:
		reverseAdapter=getReverseAdapter()
	conda:
		"../envs/trim.yaml"
	log:
		"logs/cutadapt/{sample}-{unit}.log"
	benchmark:
		"benchmarks/cutadapt_pe/{sample}-{unit}.tsv"
	shell:
		"cutadapt -j {threads} -a {config[trimming][adapter]} -A {params.reverseAdapter} -o {output.fastq1} -p {output.fastq2} {input} > {log}"

rule cutadapt_se:
	input:
		get_fastq
	output:
		"data/trimmed/{sample}-{unit}.fastq.gz"
	threads:
		workflow.cores - 4
	conda:
		"../envs/trim.yaml"
	log:
		"logs/cutadapt/{sample}-{unit}.log"
	benchmark:
		"benchmarks/cutadapt_se/{sample}-{unit}.tsv"
	shell:
		"cutadapt -j {threads} -a {config[trimming][adapter]} -o {output} {input} > {log}"
