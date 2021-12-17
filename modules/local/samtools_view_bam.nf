process SAMTOOLS_VIEW_BAM {
    tag "$meta.id"
    label 'process_medium'

    conda     (params.enable_conda ? "bioconda::samtools=1.10" : null)
    container "${ workflow.containerEngine == 'singularity' && !task.ext.singularity_pull_docker_container ?
        'https://depot.galaxyproject.org/singularity/samtools:1.14--hb421002_0' :
        'quay.io/biocontainers/samtools:1.14--hb421002_0' }"

    input:
    tuple val(meta), path(sizes), val(is_transcripts), path(sam)

    output:
    tuple val(meta), path("*.bam") ,emit: bam
    path "versions.yml"        , emit: versions

    script:
    """
    samtools view -b -h -O BAM -@ $task.cpus -o ${meta.id}.bam $sam

    cat <<-END_VERSIONS > versions.yml
    "${task.process}":
        samtools: \$(echo \$(samtools --version 2>&1) | sed 's/^.*samtools //; s/Using.*\$//')
    END_VERSIONS
    """
}
