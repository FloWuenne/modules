#!/usr/bin/env nextflow

nextflow.enable.dsl = 2

include { KB_COUNT } from '../../../../software/kb/count/main.nf' addParams( options: [:] )

workflow test_kb_count {
    
    def input = []
    input = [ [ id:'test', single_end:false ], // meta map
              file("${launchDir}/tests/data/genomics/sarscov2/bam/test_paired_end.bam", checkIfExists: true) ]

    KB_COUNT ( input )
}
