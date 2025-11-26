#!/usr/bin/env nextflow

process INDEX {

    tag "${genome_fa.simpleName}"
    label 'index'

    publishDir "${params.outdir}/index",
        mode: 'copy',
        overwrite: true

    input:
    path genome_fa

    output:
    path "genome_index.*.ht2"

    script:
    """
    hisat2-build ${genome_fa} genome_index
    """
}