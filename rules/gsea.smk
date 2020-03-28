checkpoint gsea:
	input:
		"counts/deseq.rnk"
	output:
		directory("report/gsea")
	conda:
		"../envs/gsea.yaml"
	envmodules:
		"Java/11.0.2"
	benchmark:
		"benchmarks/gsea.tsv"
	log:
        	"logs/gsea.log"
	shell:
		"{config[gsea][scriptFile]} GSEAPreranked -gmx {config[gsea][geneSetDatabases]} -chip {config[gsea][chip]} -rnk {input} -out {output} {config[gsea][params]} 2> {log}"

def gsea_get_folder(wildcards):
	checkpoint_output = checkpoints.gsea.get(**wildcards).output[0]
	return expand("report/gsea/workflow.GseaPreranked.{timestamp}",timestamp=glob_wildcards("report/gsea/workflow.GseaPreranked.{timestamp}").timestamp[0])

rule gsea_cleanup:
	input: gsea_get_folder
	output: directory("report/workflow.GseaPreranked")
	shell:
		"mv {input} {output}; "
		"rm -rf report/gsea; "
		"rm -rf $(echo $(date +\"%b%d\") | tr '[:upper:]' '[:lower:]'); "

