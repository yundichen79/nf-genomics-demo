#!/usr/bin/env nextflow


process FASTQC {

    tag "$sample_id"
    label 'fastqc'

    publishDir "${params.outdir}/fastqc",
        mode: 'copy',
        overwrite: true

    input:
    tuple val(sample_id), path(read1), path(read2)

    output:
    path "*_fastqc.html"
    path "*_fastqc.zip"

    script:
    """
    fastqc --outdir . ${read1} ${read2}
    """
}