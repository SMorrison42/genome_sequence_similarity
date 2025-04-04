process FASTANI {
    label 'process_medium'

    conda "${moduleDir}/environment.yml"
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/fastani:1.32--he1c1bb9_0' :
        'biocontainers/fastani:1.32--he1c1bb9_0' }"

    input:
    path(fastani_prepfile)

    output:
    path("ani.txt"), emit: ani
    path "versions.yml"               , emit: versions

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''

        """
        fastANI \\
            --ql $fastani_prepfile \\
            --rl $fastani_prepfile \\
            -o ani.txt

        cat <<-END_VERSIONS > versions.yml
        "${task.process}":
            fastani: \$(fastANI --version 2>&1 | sed 's/version//;')
        END_VERSIONS
        """
}
