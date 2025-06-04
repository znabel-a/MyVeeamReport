Get-ChildItem -Path $PSScriptRoot/Functions -Filter '*.ps1' | ForEach-Object {
    . $_.FullName
}

Export-ModuleMember -Function \
    Get-ProxyInfoSection, \
    Get-RepositoryInfoSection, \
    Get-BackupSummarySection, \
    Get-TapeSummarySection
