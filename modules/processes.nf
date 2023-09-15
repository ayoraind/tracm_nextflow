process TRACM_ALIGN {
    tag "$meta"
    publishDir "${params.output_dir}", mode:'copy'

    input:
    tuple val(meta), path(reads)
    path db

    output:
    tuple val(meta), path("*")                , emit: output_ch
    path("${meta}/${meta}.log")
    path  "versions.yml"                      , emit: versions_ch

    when:
    task.ext.when == null || task.ext.when

    script:
    def args = task.ext.args ?: ''
    """
    mkdir ${meta}
    
    tracm align -i $reads -o ${meta} --prefix ${meta} --keep-all -t 20 --database $db > ${meta}/${meta}.log


    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        tracm: \$(echo \$(tracm --version 2>&1) | sed 's/^.*tracm //; s/ .*\$//')
    END_VERSIONS
    """
}
