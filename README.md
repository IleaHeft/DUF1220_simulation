
Simulation of copy number changes within the DUF1220 domains and testing several alignment and summarization strategies. The details will be published in the
forthcoming paper:

> Astling, DP, Heft IE, Jones, KL, Sikela, JM. "High resolution measurement of
> DUF1220 domain copy number from whole genome sequence data"

# Prerequisites
- bowtie2
- bedtools
- Perl module, Parallel:ForkManager

# Running simulations
There are two types of simulations:  
1. baseline: For user-defined read lengths, simulates reads from all regions (of the genome or just NBPF relevant regions) at a user-specified diploid coverage level and aligns them to the reference genome. The user can specify how many replicates of this analysis they could like.

2. spikein: For user-defined read lengths, simulates reads from each DUF1220 domain (one at a time) at various copy numbers (currently set to simulate from 1 to 10 copies of each domain) and aligns them to the reference genome.

# Running baseline simulations
1. Simulate reads   
  a.  specify the desired read lengths and replictes in *code/simulation_baseline/1_simulate_replicates.sh*.
  b. Adjust the number of jobs to reflect the number of different read lengths multipled by the number of replicates (e.g. 2 different read lengths at 10 replicates each would be 20 jobs).
  c. Run the code to generate the FASTQ files: ```bsub < code/simulation_baseline/1_simulate_replicates.sh```   

2. Align the FASTQ files  
  a. Ensure that the bowtie 2 parameters (e.g. maxins) are set as desired within _code/bowtie2.sh_  
  b. Run the code to align the FASTQ files to the reference genome: ```bsub < code/simulation_baseline/bowtie2_replicates.sh```  
 
4. Generate the read depth data  
  a. Ensure the reference BED file being used is the desired file
  b. Run the code: ```bsub < code/simulation_baseline/make_bed_replicates.sh```  

5. Analyze the results
  a. Run the code: ```Rscript < code/analysis/replicate_analysis.R```

6. Generate plots of the results

# Running spikein simulations
1. Simulate reads  
  a.  specify the desired read lengths and replictes in *code/simulation_spikein/1_simulate_readlengths.sh*.  
  b.  Adjust the number of jobs to reflect the number of different read lengths multipled by the number of replicates (e.g. 2 different read lengths at 10 replicates each would be 20 jobs).    
  c.  Run the code: ```bsub < code/simulation_spikein/1_simulate_readlengths.sh```  
2. Align the FASTQ files  
  a. Ensure that the bowtie 2 parameters (e.g. maxins) are set as desired within _code/bowtie2.sh_    
  b. Run the code to align the FASTQ files to the reference genome: ```bsub < code/simulation_spikein/bowtie2_spikein.sh```    
3. Generate the read depth data  
  a. Set the number of jobs to the total number of domains for which FASTQ data was generated  
  b. Ensure the reference BED file being used is the desired file  
  c. Run the code: ```bsub < code/simulation_spikein/make_bed_spikein.sh```  
4. Analyze the results  
  a. Run the code: ```Rscript < code/analysis/spikein_analysis.R```  
5. Generate plots of the results  
  

  
