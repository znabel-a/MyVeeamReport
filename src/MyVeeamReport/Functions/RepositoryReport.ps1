function Get-RepositoryInfoSection {
    [CmdletBinding()]
    param()

    $bodyRepo = $null
    $bodySORepo = $null
    $bodyRepoPerms = $null
    if ($script:showRepo) {
        if ($script:repoList.count -gt 0) {
            $arrRepo = $script:repoList | Get-VBRRepoInfo | Select-Object \
                @{Name='Repository Name';Expression={$_.Target}},
                @{Name='Type';Expression={$_.rType}},
                @{Name='Max Tasks';Expression={$_.MaxTasks}},
                @{Name='Host';Expression={$_.RepoHost}},
                @{Name='Path';Expression={$_.Storepath}},
                @{Name='Backups (TB)';Expression={[Math]::Round($_.StorageBackup/1024,0)}},
                @{Name='Other data (TB)';Expression={[Math]::Round($_.StorageOther/1024,0)}},
                @{Name='Free (TB)';Expression={[Math]::Round($_.StorageFree/1024,0)}},
                @{Name='Total (TB)';Expression={[Math]::Round($_.StorageTotal/1024,0)}},
                @{Name='Free (%)';Expression={$_.FreePercentage}},
                @{Name='Status';Expression={
                    if ($_.FreePercentage -lt $script:repoCritical) { 'Critical' }
                    elseif ($_.StorageTotal -eq 0 -and $_.rtype -ne 'SAN Snapshot') { 'Warning' }
                    elseif ($_.StorageTotal -eq 0) { 'NoData' }
                    elseif ($_.FreePercentage -lt $script:repoWarn) { 'Warning' }
                    elseif ($_.FreePercentage -eq 'Unknown') { 'Unknown' }
                    else { 'OK' }
                }}
            $bodyRepo = $arrRepo | Sort-Object 'Repository Name' | ConvertTo-HTML -Fragment
            if ($arrRepo.status -match 'Critical') { $repoHead = $script:subHead01err }
            elseif ($arrRepo.status -match 'Warning|Unknown') { $repoHead = $script:subHead01war }
            elseif ($arrRepo.status -match 'OK|NoData') { $repoHead = $script:subHead01suc }
            else { $repoHead = $script:subHead01 }
            $bodyRepo = $repoHead + 'Repository Details' + $script:subHead02 + $bodyRepo
        }
        if ($script:repoListSo.count -gt 0) {
            $arrSORepo = $script:repoListSo | Get-VBRSORepoInfo | Select-Object \
                @{Name='Scale Out Repository Name';Expression={$_.SOTarget}},
                @{Name='Member Name';Expression={$_.Target}},
                @{Name='Type';Expression={$_.rType}},
                @{Name='Max Tasks';Expression={$_.MaxTasks}},
                @{Name='Host';Expression={$_.RepoHost}},
                @{Name='Path';Expression={$_.Storepath}},
                @{Name='Backups (GB)';Expression={$_.StorageBackup}},
                @{Name='Other data (GB)';Expression={$_.StorageOther}},
                @{Name='Free (GB)';Expression={$_.StorageFree}},
                @{Name='Total (GB)';Expression={$_.StorageTotal}},
                @{Name='Free (%)';Expression={$_.FreePercentage}},
                @{Name='Status';Expression={
                    if ($_.FreePercentage -lt $script:repoCritical) { 'Critical' }
                    elseif ($_.StorageTotal -eq 0) { 'Warning' }
                    elseif ($_.FreePercentage -lt $script:repoWarn) { 'Warning' }
                    elseif ($_.FreePercentage -eq 'Unknown') { 'Unknown' }
                    else { 'OK' }
                }}
            $bodySORepo = $arrSORepo | Sort-Object 'Scale Out Repository Name','Member Repository Name' | ConvertTo-HTML -Fragment
            if ($arrSORepo.status -match 'Critical') { $sorepoHead = $script:subHead01err }
            elseif ($arrSORepo.status -match 'Warning|Unknown') { $sorepoHead = $script:subHead01war }
            elseif ($arrSORepo.status -match 'OK') { $sorepoHead = $script:subHead01suc }
            else { $sorepoHead = $script:subHead01 }
            $bodySORepo = $sorepoHead + 'Scale Out Repository Details' + $script:subHead02 + $bodySORepo
        }
        if ($script:showRepoPerms -and ($script:repoList.count -gt 0 -or $script:repoListSo.count -gt 0)) {
            $bodyRepoPerms = Get-RepoPermission | Select-Object Name,'Encryption Enabled','Permission Type',Users | Sort-Object Name | ConvertTo-HTML -Fragment
            $bodyRepoPerms = $script:subHead01 + 'Repository Permissions for Agent Jobs' + $script:subHead02 + $bodyRepoPerms
        }
    }
    return $bodyRepo, $bodySORepo, $bodyRepoPerms
}
