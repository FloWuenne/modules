#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { KB_COUNT } from '../../../../software/kb/count/main.nf' addParams( options: [:] )

workflow test_kb_count {
    
    def input = []
    input = [ [ id:'test', single_end:false ], // meta map
                file("${launchDir}/output/fastq/heart_1k_v3_S1_L001_R1_001.1M_reads.fastq.gz", checkIfExists: true),
                file("${launchDir}/output/fastq/heart_1k_v3_S1_L001_R2_001.1M_reads.fastq.gz", checkIfExists: true)]

    KB_COUNT (  input,
                file("${launchDir}/output/kb/kb_ref_index.idx", checkIfExists: true),
                file("${launchDir}/output/kb/t2g.txt", checkIfExists: true)
     )
}
