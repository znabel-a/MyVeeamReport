function Get-TapeSummarySection {
    [CmdletBinding()]
    param()

    $bodySummaryTp = $null
    if ($script:showSummaryTp) {
        $vbrMasterHash = @{
            'Sessions'    = if ($script:sessListTp) { @($script:sessListTp).Count } else { 0 }
            'Read'        = $script:totalReadTp
            'Transferred' = $script:totalXferTp
            'Successful'  = @($script:successSessionsTp).Count
            'Warning'     = @($script:warningSessionsTp).Count
            'Fails'       = @($script:failsSessionsTp).Count
            'Working'     = @($script:workingSessionsTp).Count
            'Idle'        = @($script:idleSessionsTp).Count
            'Waiting'     = @($script:waitingSessionsTp).Count
        }
        $vbrMasterObj = New-Object -TypeName PSObject -Property $vbrMasterHash
        if ($script:onlyLastTp) { $total = 'Jobs Run' } else { $total = 'Total Sessions' }
        $arrSummaryTp = $vbrMasterObj | Select-Object \
            @{Name=$total;Expression={ $_.Sessions }},
            @{Name='Read (GB)';Expression={ $_.Read }},
            @{Name='Transferred (GB)';Expression={ $_.Transferred }},
            @{Name='Idle';Expression={ $_.Idle }},
            @{Name='Waiting';Expression={ $_.Waiting }},
            @{Name='Working';Expression={ $_.Working }},
            @{Name='Successful';Expression={ $_.Successful }},
            @{Name='Warnings';Expression={ $_.Warning }},
            @{Name='Failures';Expression={ $_.Fails }}
        $bodySummaryTp = $arrSummaryTp | ConvertTo-HTML -Fragment
        if ($arrSummaryTp.Failures -gt 0) { $summaryTpHead = $script:subHead01err }
        elseif ($arrSummaryTp.Warnings -gt 0 -or $arrSummaryTp.Waiting -gt 0) { $summaryTpHead = $script:subHead01war }
        elseif ($arrSummaryTp.Successful -gt 0) { $summaryTpHead = $script:subHead01suc }
        else { $summaryTpHead = $script:subHead01 }
        $bodySummaryTp = $summaryTpHead + 'Tape Backup Results Summary' + $script:subHead02 + $bodySummaryTp
    }
    return $bodySummaryTp
}
