#First, please set your working directory

#You'll need an Excel file with your a sheet that contains your hits for all 
# your genomes and the corresponding UniProt number for each file. 
# An other sheet should contain the gene info for all the UniProt files.

# You can now merge both sheets.

# --- Load the Excel file ---
read_ods("Code.ods", sheet = "Hits",  col_names = TRUE) ->
  Hits

read_ods("Code.ods", sheet = "Code",  col_names = TRUE) ->
  Code

# Merge and sum
Code_Transport_Beta_oxidation_Phenylacetate_Naphthalene_genes_hits <- Code %>%
  right_join(Hits, by = "UniProt", multiple = "all", relationship = "many-to-many")


# Save in Tables
write.csv(Code_Transport_Beta_oxidation_Phenylacetate_Naphthalene_genes_hits, "Code_Transport_Beta_oxidation_Phenylacetate_Naphthalene_genes_hits.csv")
```

# Here, we are using only part of the previous data. We're looking only to use certain genes
library(dplyr)

Code_Transport_Beta_oxidation_Phenylacetate_Naphthalene_genes_hits %>%
  group_by(Category, Gene.x, Genome) %>%
  summarise(sum_hit = n(), .groups = "drop") %>%
  mutate(Gene.x = factor(Gene.x, levels = c("fadL", "ompW", "pcaK", "mlaB", "mlaD", "mlaE", "mlaF", "pqiA", "pqiB", "pqiC", "yebS", "yebT", "opdK", "aliA", "aliB", "badH", "badI", "GMET_RS16560", "fadD", "fadK", "acsA", "fadE", "acdA", "acdB", "fadJ", "fadB", "fadB2", "echA", "crt", "echA1", "fadA", "atoB", "paaK", "paaA", "paaB", "paaC", "paaD", "paaE", "paaG", "paaZ", "paaF", "paaJ", "paaH", "paaI", "paaY", "paaX", "nagAa", "nagAb", "nagAc", "nagAd", "nagB", "nagC", "nagD", "nagE", "nagF", "nagG", "nagH", "nahG", "nagR"))) %>%
  filter(sum_hit > 0) %>%
  write.csv("iTOL_Transport_Beta_oxidation_Phenylacetate_and_Naphthalene_genes_hits.csv")
```



#To have the right iTOL format to be able to fill the dataset txt file
library(tidyr)
library(dplyr)

df <- read.csv("iTOL_Transport_Beta_oxidation_Phenylacetate_and_Naphthalene_genes_hits.csv")

pivot <- df %>%
  select(-Category) %>%                          # Ignores the Category column
  group_by(Genome, Gene.x) %>%
  summarise(sum_hit = sum(sum_hit), .groups = "drop") %>%   # Adds if multiple identical
  pivot_wider(names_from = Gene.x, values_from = sum_hit, values_fill = 0)

# Replaces 0 with "X" (appart from the Genome column)
pivot <- pivot %>%
  mutate(across(-Genome, ~ ifelse(. == 0, "X", .)))


write.csv(pivot, "pivot_iTOL.csv", row.names = FALSE)

# You should be able to use the resulting csv file to create your dataset for iTOL!