process GENERATE_SIF {


    input:
    path(ani)
    val percentage
    

    output:
    path '*.sif'       , emit: ani_sif

    when: 
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
     
    """
    awk '{ if (\$3 >= ${percentage}) print \$1"\\t"\$3"\\t"\$2; else print \$1 }' ${ani} > ani.sif

    """
}
	


