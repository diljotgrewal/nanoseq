// Import generic module functions
include { initOptions; saveFiles; getSoftwareName } from './functions'

params.options       = [:]
def options          = initOptions(params.options)

process GET_TEST_DATA {
    output:    
    path "test-datasets/fast5/$barcoded"  , emit: ch_input_path

    script:
    barcoded = workflow.profile.contains('test_bc_nodx') ? "nonbarcoded" : "barcoded"
    """
    git clone https://github.com/nf-core/test-datasets.git --branch nanoseq --single-branch
    """
}