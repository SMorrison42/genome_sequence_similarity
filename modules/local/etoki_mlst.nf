process ETOKI_MLST {
    tag "$meta.id"
    label 'process_medium'



    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/etoki%3A1.2.3--hdfd78af_0' :
        'biocontainers/fastani:etoki%3A1.2.3--hdfd78af_0' }"


    input:
    tuple val(meta), path(contigs)
    path(reference_alleles)
    path(etoki_csv)

    output:
    tuple val(meta), path('*.etoki.fasta')    , emit: etoki_alleles_fasta
    path 'versions.yml'                 , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    def prefix = task.ext.prefix ?: "${meta.id}"

    """
    #singularity exec ${projectDir}/bin/etoki_latest.sif 
        EToKi.py MLSType \\
        -i ${contigs} \\
        -r $reference_alleles \\
        -k Cparvum \\
        -d $etoki_csv \\
        -o ${prefix}.etoki.fasta \\
        $args \\
    &> etoki_mlst_main.log
    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        etoki_mlst_main: \$(etoki_mlst_main.sh | grep -v "Duplicate cpuset")
    END_VERSIONS
    """
}

