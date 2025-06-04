function Get-ProxyInfoSection {
    [CmdletBinding()]
    param()

    $bodyProxy = $null
    if ($script:showProxy) {
        if ($script:proxyList.count -gt 0) {
            $arrProxy = $script:proxyList | Get-VBRProxyInfo | Select-Object \
                @{Name="Proxy Name"; Expression = { $_.ProxyName }},
                @{Name="Transport Mode"; Expression = { $_.tMode }},
                @{Name="Max Tasks"; Expression = { $_.MaxTasks }},
                @{Name="Proxy Host"; Expression = { $_.RealName }},
                @{Name="Host Type"; Expression = { $_.pType }},
                Enabled,
                @{Name="IP Address"; Expression = { $_.IP }},
                @{Name="RT (ms)"; Expression = { $_.Response }},
                Status
            $bodyProxy = $arrProxy | Sort-Object 'Proxy Host' | ConvertTo-HTML -Fragment
            if ($arrProxy.Status -match 'Dead') {
                $proxyHead = $script:subHead01err
            } elseif ($arrProxy -match 'Alive') {
                $proxyHead = $script:subHead01suc
            } else {
                $proxyHead = $script:subHead01
            }
            $bodyProxy = $proxyHead + 'Proxy Details' + $script:subHead02 + $bodyProxy
        }
    }
    return $bodyProxy
}
