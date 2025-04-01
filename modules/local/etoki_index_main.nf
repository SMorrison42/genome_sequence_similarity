process ETOKI_DB {
    // tag "$fasta"
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/etoki%3A1.2.3--hdfd78af_0' :
        'biocontainers/fastani:etoki%3A1.2.3--hdfd78af_0' }"


    input:
    path(fasta)
    path(reference_fastas)
    
    output:
    path "*.csv"            , emit: etoki_csv 
    path "versions.yml"     , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
       
       #singularity exec ${projectDir}/bin/etoki_05142024.sif 

    EToKi.py MLSTdb -i $fasta -r $reference_fastas -d etoki_index_md5hash.csv \\
        $args \\
        &> etoki_index.log
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        etoki_index: \$(etoki_index_indexversion.sh | grep -v "Duplicate cpuset")
    END_VERSIONS
    """
}

