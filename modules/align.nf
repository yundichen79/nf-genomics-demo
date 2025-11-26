#!/usr/bin/env nextflow

process ALIGN {

    tag "$sample_id"
    label 'align'

    publishDir "${params.outdir}/align",
        mode: 'copy',
        overwrite: true

    input:
    tuple val(sample_id), path(read1), path(read2)
    path index_files

    output:
    tuple val(sample_id), path("${sample_id}.sorted.bam")
    path "${sample_id}.sorted.bam.bai"

    script:
    """
    # hisat2 expects the basename (here: genome_index) of the index files
    hisat2 -x genome_index \
           -1 ${read1} \
           -2 ${read2} \
           -p 4 \
      | samtools view -bS - \
      | samtools sort -o ${sample_id}.sorted.bam -

    samtools index ${sample_id}.sorted.bam
    """
}
