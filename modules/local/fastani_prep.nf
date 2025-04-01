process FASTANI_PREP {
    conda (params.enable_conda ? "conda-forge::python=3.8.3 conda-forge::pandas conda-forge::biopython" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/pandas:2.2.1' :
        'quay.io/biocontainers/pandas' }"
 

    input:
    path(contigs)
    output:
    path '*.txt'       , emit: fastani_prepfile
    path "versions.yml", emit:versions

    when: 
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args   ?: ''
    """

    
    prep_fastani.py \\
	-assemblies $contigs \\
	-output .
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """
}
	
