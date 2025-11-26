# NF-Genomics-Demo: Minimal WGS Processing Pipeline (Nextflow + AWS Batch)

This repository contains a small demonstration pipeline built with Nextflow DSL2, showing how to automate a simple whole-genome sequencing (WGS) preprocessing and alignment workflow.  
It is designed to run locally (using Docker) or on AWS Batch (using S3 for storage).

The sample used in this demo is:
Illumina WGS paired-end reads of *Escherichia coli*
Accession: SRR34066748



## Pipeline Overview

The workflow performs four basic steps:

1. Build genome index using `hisat2-build`  
2. Run FastQC on raw FASTQ files using `fastqc`
3. Trim adapters / low-quality bases with `fastp`  
4. Align reads to the reference genome using `hisat2` → output: sorted BAM file  

Although `hisat2` is commonly used for RNA-seq, it works fine for short-read bacterial WGS alignment in this demo.



## Repository Structure

    nf-genomics-demo/
    ├── data/                # paired-end FASTQ input files of SRR34066748
    ├── ref/                 # reference genome FASTA (E. coil assembled genome ASM584v2)
    ├── modules/             # Nextflow sub-modules:
    │     ├── fastqc.nf
    │     ├── trim.nf
    │     ├── index.nf
    │     └── align.nf
    ├── main.nf              # top-level workflow
    ├── nextflow.config      # configuration for local and AWS execution
    ├── Dockerfile           # container image definition with required tools
    └── README.md            # (this file)



## Tools (inside Docker container)

- **FastQC** — quality control  
- **fastp** — adapter trimming + quality trimming  
- **hisat2** — short-read alignment  
- **samtools** — sort BAM output  

The Docker image installs all required tools using conda for portability and reproducibility.


## Usage

### Local run (with Docker)

Make sure Docker is running, then:

```bash
nextflow run main.nf
```

### Run on AWS (Batch + S3)
	
1.	Push data and reference genome to an S3 bucket
2.	Update nextflow.config AWS profile parameters (workDir, reads, genome, outdir)
3.	Ensure AWS Batch compute environment, job queue, and IAM permissions are correctly configured
4.  ```bash
    nextflow run main.nf -profile aws
    ```