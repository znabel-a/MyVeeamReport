function Get-MyVeeamReportConfig {
    [CmdletBinding()]
    param(
        [string]$Path = (Join-Path $PSScriptRoot 'MyVeeamReport_config.psd1')
    )

    if (-not (Test-Path -Path $Path)) {
        throw "Configuration file '$Path' not found."
    }

    $config = Import-PowerShellDataFile -Path $Path

    if (-not ($config -is [hashtable])) {
        throw 'Configuration data is not a hashtable.'
    }

    if ($config.reportMode -and ($config.reportMode -isnot [int]) -and \
        ($config.reportMode -notin 'Weekly','Monthly')) {
        throw 'reportMode must be numeric hours or ''Weekly''/''Monthly''.'
    }

    return $config
}
