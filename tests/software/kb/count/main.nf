#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { KB_COUNT } from '../../../../software/kb/count/main.nf' addParams( options: [:] )
include { KB_COUNT as KB_COUNT_LAMANNO } from '../../../../software/kb/count/main.nf' addParams(options: [args: '--workflow lamanno'] )
include { KB_COUNT as KB_COUNT_NUCLEUS } from '../../../../software/kb/count/main.nf' addParams(options: [args: '--workflow nucleus'] )

workflow test_kb_count {
    
    def input = []
    input = [ [ id:'test' ], // meta map
                file("${launchDir}/tests/data/fastq/heart_1k_v3_S1_L001_R1_001.1M_reads.fastq.gz", checkIfExists: true),
                file("${launchDir}/tests/data/fastq/heart_1k_v3_S1_L001_R2_001.1M_reads.fastq.gz", checkIfExists: true)]
                use_t1c   = false
                use_t2c   = false

    KB_COUNT (  input,
                file("${launchDir}/tests/data/kb/kb_ref_index.idx", checkIfExists: true),
                file("${launchDir}/tests/data/kb/t2g.txt", checkIfExists: true),
                use_t1c,use_t2c
                
     )
}

workflow test_kb_count_lamanno {
    
    def input = []
    input = [ [ id:'lamanno' ], // meta map
                file("${launchDir}/tests/data/fastq/heart_1k_v3_S1_L001_R1_001.1M_reads.fastq.gz", checkIfExists: true),
                file("${launchDir}/tests/data/fastq/heart_1k_v3_S1_L001_R2_001.1M_reads.fastq.gz", checkIfExists: true)]
                use_t1c = true
                use_t2c   = true

    KB_COUNT_LAMANNO (  input,
                file("${launchDir}/tests/lamanno/kb_ref_index.idx", checkIfExists: true),
                file("${launchDir}/tests/lamanno/t2g.txt", checkIfExists: true),
                file("${launchDir}/tests/lamanno/spliced_t2c.txt", checkIfExists: true),
                file("${launchDir}/tests/lamanno/unspliced_t2c.txt", checkIfExists: true),
                use_t1c,use_t2c
     )
}

workflow test_kb_count_nucleus {
    
    def input = []
    input = [ [ id:'nucleus' ], // meta map
                file("${launchDir}/tests/data/fastq/heart_1k_v3_S1_L001_R1_001.1M_reads.fastq.gz", checkIfExists: true),
                file("${launchDir}/tests/data/fastq/heart_1k_v3_S1_L001_R2_001.1M_reads.fastq.gz", checkIfExists: true)]
                use_t1c = true
                use_t2c   = true

    KB_COUNT_NUCLEUS (  input,
                file("${launchDir}/tests/lamanno/kb_ref_index.idx", checkIfExists: true),
                file("${launchDir}/tests/lamanno/t2g.txt", checkIfExists: true),
                file("${launchDir}/tests/lamanno/spliced_t2c.txt", checkIfExists: true),
                file("${launchDir}/tests/lamanno/unspliced_t2c.txt", checkIfExists: true),
                use_t1c,use_t2c
     )
}
