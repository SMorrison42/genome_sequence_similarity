process MLST_JACCARD {
    conda (params.enable_conda ? "conda-forge::python=3.8.3 conda-forge::pandas conda-forge::biopython" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/biopython:1.81' :
        'quay.io/biocontainers/biopython' }"

    input:
    path(etoki_prepfile)


    output:
    path '*.tab'       , emit: mlst_jaccard_distance
    path '*.tab'       , emit: mlst_jaccard_combined
    path "versions.yml", emit:versions

    when: 
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
     

    
    """
    mapfile -t genomes < "$etoki_prepfile"
    while IFS= read -r i; do
        PREFIX=\$(basename "\$i" .etoki.fasta)
        for genome in "\${genomes[@]}"; do
            mlst_jaccard.py \\
                -f1 "\$i" \\
                -f2 "\$genome" \\
                $args \\
                > "\${PREFIX}.mlst.tab"
        done 
    done < "${etoki_prepfile}"
    
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        python: \$(python --version | sed 's/Python //g')
    END_VERSIONS
    """
}
	


