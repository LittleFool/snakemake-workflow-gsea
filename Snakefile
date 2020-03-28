from snakemake.utils import validate, min_version
import pandas as pd

# require at least snakemake 5.4 for "Data-dependent conditional execution" (checkpoints)
min_version("5.4")

configfile: "config.yaml"
validate(config, schema="schemas/config.schema.yaml")

samples = pd.read_table(config["samples"]).set_index("sample", drop=False)
validate(samples, "schemas/samples.schema.yaml")

units = pd.read_table(config["units"], dtype=str).set_index(["sample", "unit"], drop=False)
# enforce str in index
units.index = units.index.set_levels([i.astype(str) for i in units.index.levels])
validate(units, schema="schemas/units.schema.yaml")

rule all:
	input: "report/workflow.GseaPreranked"

# include rules
include: "rules/trim.smk"
include: "rules/star.smk"
include: "rules/count.smk"
include: "rules/deseq2.smk"
include: "rules/gsea.smk"
