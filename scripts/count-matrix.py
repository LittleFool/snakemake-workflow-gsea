import pandas as pd
matrix = pd.read_table(snakemake.input[0], index_col=0, header=0, skiprows=0)
matrix = matrix.groupby(matrix.index, axis=0).sum()
matrix.to_csv(snakemake.output[0], sep="\t")
