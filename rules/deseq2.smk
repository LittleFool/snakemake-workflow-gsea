rule deseq2:
	input:
		counts="counts/cts.tsv"
	output:
		"counts/deseq.rnk"
	threads:
		8
	conda:
		"../envs/r.yaml"
	log:
        	"logs/deseq2.log"
	benchmark:
		"benchmarks/deseq2.tsv"
	script:
		"../scripts/deseq2.R"

