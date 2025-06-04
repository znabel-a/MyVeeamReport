function Get-BackupSummarySection {
    [CmdletBinding()]
    param()

    $bodySummaryBk = $null
    if ($script:showSummaryBk) {
        $vbrMasterHash = @{
            'Failed'      = @($script:failedSessionsBk).Count
            'Sessions'    = if ($script:sessListBk) { @($script:sessListBk).Count } else { 0 }
            'Read'        = $script:totalReadBk
            'Transferred' = $script:totalXferBk
            'Successful'  = @($script:successSessionsBk).Count
            'Warning'     = @($script:warningSessionsBk).Count
            'Fails'       = @($script:failsSessionsBk).Count
            'Running'     = @($script:runningSessionsBk).Count
        }
        $vbrMasterObj = New-Object -TypeName PSObject -Property $vbrMasterHash
        if ($script:onlyLastBk) { $total = 'Jobs Run' } else { $total = 'Total Sessions' }
        $arrSummaryBk = $vbrMasterObj | Select-Object \
            @{Name=$total;Expression={ $_.Sessions }},
            @{Name='Read (GB)';Expression={ $_.Read }},
            @{Name='Transferred (GB)';Expression={ $_.Transferred }},
            @{Name='Running';Expression={ $_.Running }},
            @{Name='Successful';Expression={ $_.Successful }},
            @{Name='Warnings';Expression={ $_.Warning }},
            @{Name='Failures';Expression={ $_.Fails }},
            @{Name='Failed';Expression={ $_.Failed }}
        $bodySummaryBk = $arrSummaryBk | ConvertTo-HTML -Fragment
        if ($arrSummaryBk.Failed -gt 0) { $summaryBkHead = $script:subHead01err }
        elseif ($arrSummaryBk.Warnings -gt 0) { $summaryBkHead = $script:subHead01war }
        elseif ($arrSummaryBk.Successful -gt 0) { $summaryBkHead = $script:subHead01suc }
        else { $summaryBkHead = $script:subHead01 }
        $bodySummaryBk = $summaryBkHead + 'Backup Results Summary' + $script:subHead02 + $bodySummaryBk
    }
    return $bodySummaryBk
}
