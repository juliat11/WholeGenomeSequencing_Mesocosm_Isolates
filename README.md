These scripts were used for bioinformatic analyses of Whole Genome Sequencing data obtained by Oxford Nanopore Sequencing. This was used to identify genes of interest in the sequenced genomes that may not have been identified using automatic annotations.

1. You'll first need to create a folder containing all your sequencing data, preferably .faa files which can be obtained after automatic annotations using programs such as Prokka.

2. Create a folder inside the previous folder and call it "Genes". Download UniProt files for you proteins of interest. Here, we'll focus on proteins which could play a role in naphthenic acid degradation.

3. In the Code.ods file, you'll see the Code sheet which you can use as a template to fill with information for all your downloaded proteins from UniProt. The important columns to fill are "Gene" and "UniProt".

4. Run the first bash file in your command line. For MAC/UNIX users, it should look like this (and make sure miniconda is deactivated) : bash 1_append_file_name_to_proteins.sh

5. Then, activate MiniConda if you are using it (conda activate), and run the second file to run the Blast search : sh 2_blastp.sh

6. Deactivate MiniConda for the next script and run the third script : bash 3_append_merge.sh

7. Now, open the txt file in Excel and copy paste the Merged_hits file you juste created in the “Hits” sheet of Code.ods file. The genome and gene columns will be blank for the moment. For the Gene column, copy and paste the Nom column, then search for each individual isolate name (Ex. 68A.faa_) and replace by nothing. For the Genome column, use this function in excel “ =GAUCHE(A2; TROUVE("."; A2) - 1) “.
The R script will help you merge both sheets from the Code.ods file so each hit will be linked to the Gene. This will be useful to calculate the sum hits for each gene present in each genome. 

8. You'll also be able to manipulate the data in R to fit the iTOL dataset txt files to create a heatmap. Use the fifth file, and make sur to modify the gene names if necessary (FIELD_LABELS). You can also modify the colors and such settings directly in the text file before uploading it to iTOL.
