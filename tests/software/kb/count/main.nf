#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { KB_COUNT } from '../../../../software/kb/count/main.nf' addParams( options: [:] )

workflow test_kb_count {
    
    def input = []
    input = [ [ id:'test' ], // meta map
                file("${launchDir}/tests/data/fastq/heart_1k_v3_S1_L001_R1_001.1M_reads.fastq.gz", checkIfExists: true),
                file("${launchDir}/tests/data/fastq/heart_1k_v3_S1_L001_R2_001.1M_reads.fastq.gz", checkIfExists: true)]

    KB_COUNT (  input,
                file("${launchDir}/tests/data/kb/kb_ref_index.idx", checkIfExists: true),
                file("${launchDir}/tests/data/kb/t2g.txt", checkIfExists: true)
     )
}
