process ETOKI_PREP {
    conda (params.enable_conda ? "conda-forge::python=3.8.3 conda-forge::pandas conda-forge::biopython" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/biopython:1.81' :
        'quay.io/biocontainers/biopython' }"

    input:
    //path(scaffolds, stageAs:"contigNames/*")
    path(etoki_fasta)
    output:
    path '*.txt'       , emit: etoki_prepfile
    path "versions.yml", emit:versions

    when: 
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args   ?: ''
    def ETOKIFASTADIR = "./etoki_mlst"
    """
    sDir=`dirname $ETOKIFASTADIR`
    
    prep_fastani_SM.py \\
	-assemblies \$sDir \\
	-output .
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """
}

