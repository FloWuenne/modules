// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options = [:]
options        = initOptions(params.options)

process KB_COUNT {
    tag "$meta.id"
    label 'process_medium'
    publishDir "${params.outdir}",
        mode: params.publish_dir_mode,
        saveAs: { filename -> saveFiles(filename:filename, options:params.options, publish_dir:getSoftwareName(task.process), publish_id:meta.id) }

    conda (params.enable_conda ? "bioconda::kb-python==0.25.1--py_0" : null)
    if (workflow.containerEngine == 'singularity' && !params.singularity_pull_docker_container) {
        container "https://depot.galaxyproject.org/singularity/kb-python:0.25.1--py_0"
    } else {
        container "quay.io/biocontainers/kb-python:0.25.1--py_0"
    }

    input:
    tuple val(meta), path(fastq1), path(fastq2)
    path index
    path t2g
    path t1c
    path t2c
    val use_t1c
    val use_t2c

    output:
    tuple val(meta)
    path "output"       ,   emit: output
    path "*.version.txt",   emit: version

    script:
    def software = getSoftwareName(task.process)
    def prefix   = options.suffix ? "${meta.id}${options.suffix}" : "${meta.id}"
    def cdna  = use_t1c ? "-c1 $t1c" : ''
    def introns  = use_t2c ? "-c2 $t2c" : ''

    """
    kb \\
    count \\
    $options.args \\
    --threads $task.cpus \\
    -m  \\ 
    -i $index \\
    -g $t2g \\
    $cdna \\
    $introns \\ 
    -x 10xv3 \\
    -o output \\
    $fastq1 \\
    $fastq2

    echo \$(kb 2>&1) | sed 's/^kb_python //; s/Usage.*\$//' > ${software}.version.txt
    """
}
