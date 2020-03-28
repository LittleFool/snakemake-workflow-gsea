rule count:
	input:
		expand("data/mapped_reads/{unit.sample}-{unit.unit}.Aligned.out.bam", unit=units.itertuples())
	output:
		"counts/all.tsv"
	threads:
		8
	log:
        	"logs/count.log"
	benchmark:
		"benchmarks/count.tsv"
	conda:
		"../envs/r.yaml"
	script:
		"../scripts/count.R"

rule count_matrix:
	input:
		"counts/all.tsv"
	output:
		"counts/cts.tsv"
	envmodules:
		"Python/3.6.5"
	conda:
		"../envs/python3.yaml"
	benchmark:
		"benchmarks/count_matrix.tsv"
	script:
		"../scripts/count-matrix.py"

