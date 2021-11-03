
name: test-action

on:
  workflow_dispatch:
    inputs:
      skip_check_run: 
        description: |
          false
        required: false
  #push:
  #release:
  #  types: published

jobs:

  run-code-coverage:
    strategy:
      matrix:
        os:
          - 'ubuntu-latest'
    runs-on: ${{ matrix.os }}
    steps:

      - name: checkout
        uses: actions/checkout@v1
      
      - name: code coverage
        if: ${{ !cancelled() }}  
        id: codecoverage
        uses: ./
        with:
          code_coverage_path: coverage/jacoco.xml
          report_name:  code_coverage-${{ matrix.os }}
          report_title: Sample Code Coverage (${{ matrix.os }})
          github_token: ${{ secrets.GITHUB_TOKEN }}
      
      - name: dump code coverage results
        shell: pwsh
        run: |
          Write-ActionInfo 'Code Coverage Results: ${{ matrix.os }}'
          Write-ActionInfo '  Code Coverage Jacoco/Corbetura/ICov/Istanbul:'
          Write-ActionInfo '    * result_value    = ${{ steps.codecoverage.outputs.coverage_value }}'
          Write-ActionInfo '    * total_count     = ${{ steps.codecoverage.outputs.total_lines }}'
          Write-ActionInfo '    * passed_count    = ${{ steps.codecoverage.outputs.covered_lines }}'
          Write-ActionInfo '    * failed_count    = ${{ steps.codecoverage.outputs.notcovered_lines }}'
