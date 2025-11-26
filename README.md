# NF-Genomics-Demo: RNA-seq Preprocessing Pipeline (Nextflow + AWS Batch)

This repository contains a simple RNA-seq preprocessing pipeline built with **Nextflow DSL2**, designed to run both locally (via Docker) and on the cloud (AWS Batch + S3).

---

## Pipeline Overview

The workflow performs the following steps:

1. Build genome index (hisat2-build)  
2. FastQC on raw FASTQ reads  
3. Trim reads for adapters/quality with fastp  
4. Align trimmed reads to the genome with hisat2 → output sorted BAM  

---

## Repository Structure

nf-genomics-demo/
├── data/                # paired-end FASTQ input files
├── ref/                 # reference genome FASTA (and related files)
├── modules/             # Nextflow sub-modules:
│     ├── fastqc.nf
│     ├── trim.nf
│     ├── index.nf
│     └── align.nf
├── main.nf              # top-level workflow
├── nextflow.config      # configuration for local and AWS execution
├── Dockerfile           # container image definition with required tools
└── README.md            # (this file)

---

## Tools (inside Docker container)

- `fastqc`  
- `fastp`  
- `hisat2`  
- `samtools`  

The Docker image installs all required tools using conda** for portability and reproducibility.

---

## Usage

### Local run (with Docker)

Make sure Docker is running, then:

```bash
nextflow run main.nf \
   -profile docker \
   --reads 'data/*_{1,2}.fastq' \
   --genome 'ref/genome.fa' \
   --outdir 'results'
```

### Run on AWS (Batch + S3)
	
1.	Push data and reference genome to an S3 bucket
	
2.	Update nextflow.config AWS profile parameters (workDir, reads, genome, outdir)
	
3.	Ensure AWS Batch compute environment, job queue, and IAM permissions are correctly configured
	
4.	run: 
    ```bash
    nextflow run main.nf -profile aws
    ```