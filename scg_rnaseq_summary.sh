#!/bin/bash
# Replace MY_PI_SUNetID_or_Project_ID with the PI/project to be charged.
#SBATCH --account=congle
# Set job time to six hours, typically good for quick runs with Salmon/Kallisto
#SBATCH --time=6:00:00
## SCG partitions are batch, interactive and nih_s10
#SBATCH --partition=nih_s10

# Set a name for the job, visible in `squeue`
#SBATCH --job-name="PRT_Nextseq20190215"

# The following settings are optimal for *most* software, we want one task to have one or more cores available for that task to fork or use threads.-N also works
#SBATCH --nodes=1
# Number of tasks, -n also works. For single-cell RNA-seq you have multiple cells so request 8 tasks to be allowed
#SBATCH --ntasks=1
# One CPU/core per task, -c also works.
#SBATCH --cpus-per-task=4

# There are to ways to specify memory, --mem= and --mem-per-cpu= # --mem is usually enough since total job memory is easy to specify this way.
# 32GB of RAM for the job could be reasonable for Salmon and Kallisto as they both are memory efficient.
#SBATCH --mem=32G

# These are optional, if you want to receive mail about the job. Who to send mail to.
#SBATCH --mail-user=congle@stanford.edu
# What type of mail to send
#SBATCH --mail-type=BEGIN,END,FAIL,TIME_LIMIT_80

# What variables does SLURM set?
module load anaconda
module load python/2.7
module load samtools/1.9

## Activating python virtual environment
## source activate python_2.7

python2.7 /labs/congle/PRT/Nextseq_20190207/aggregate_kallisto_output.py \
--rnaseqdir ./ \
--tool Kallisto \
--tool_file abundance.tsv

python2.7 /labs/congle/PRT/Nextseq_20190207/merge_KALLISTO_ouptut_to_matrix.py \
--kallistodir ./Kallisto \
--mode count \
--outputfile ./kallisto.count.matrix

env | grep SLURM | sort -V

## deactivating python virtual environment
# source deactivate
