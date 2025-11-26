#!/usr/bin/env nextflow

process TRIM {

    tag "$sample_id"
    label 'trim'

    publishDir "${params.outdir}/trimmed",
        mode: 'copy',
        overwrite: true

    input:
    tuple val(sample_id), path(read1), path(read2)

    output:
    tuple val(sample_id),
          path("${sample_id}_1.trim.fastq.gz"),
          path("${sample_id}_2.trim.fastq.gz")

    script:
    """
    fastp \
        -i ${read1} \
        -I ${read2} \
        -o ${sample_id}_1.trim.fastq.gz \
        -O ${sample_id}_2.trim.fastq.gz \
        --thread 4 \
        --detect_adapter_for_pe \
        --html ${sample_id}_fastp.html \
        --json ${sample_id}_fastp.json
    """
}