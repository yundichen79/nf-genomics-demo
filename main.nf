#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

/*
 * Simple WGS pipeline:
 *  1. Build genome index (hisat2-build)
 *  2. FastQC on raw reads
 *  3. Trim reads with fastp
 *  4. Align trimmed reads with hisat2
 */

params.reads  = 'data/*_{1,2}.fastq'
params.genome = 'ref/genome.fa'       
params.outdir = 'results'           

include { FASTQC } from './modules/fastqc'
include { TRIM } from './modules/trim'
include { INDEX } from './modules/index'
include { ALIGN } from './modules/align'

workflow {

    // input reads
    reads_ch = Channel
        .fromFilePairs( params.reads )
        .map { id, reads -> tuple(id, reads[0], reads[1]) }

    // reference genome
    genome_ch = Channel.fromPath( params.genome, checkIfExists: true )

    // workflow steps
    index_files = INDEX( genome_ch )
    raw_qc = FASTQC( reads_ch )
    trimmed_ch = TRIM( reads_ch )
    aligned_bam = ALIGN( trimmed_ch, index_files )
    
}
