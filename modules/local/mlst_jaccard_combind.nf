process MLST_JACCARD_COMBIND {


    input:
    path(mlst_jaccard_distance)


    output:
    path '*.tab'       , emit: mlst_jaccard_combined

    when: 
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
     
    """
    cat ${mlst_jaccard_distance} > combined_results.tab

    """
}
	


