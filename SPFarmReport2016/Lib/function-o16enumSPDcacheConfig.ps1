function o16enumSPDcacheConfig {
    [cmdletbinding()]
    param ()
    try {
        $count = 0
        Use-CacheCluster
        $hostdetails = Get-CacheHost
        if ($hostdetails.Length -lt 2) {
            $global:XMLToParse = New-Object System.Xml.XmlDocument
            $global:XMLToParse = [xml] ($hostdetails[$count]  | ConvertTo-Xml -notypeinformation)
            $tempstr = [System.String]$global:XMLToParse.Objects.Object.InnerXml
            $global:_DCacheHosts.Add($hostdetails.Hostname, $tempstr)
        }
        else {
            $hostdetails.GetEnumerator() | ForEach-Object {
                $global:XMLToParse = New-Object System.Xml.XmlDocument
                $global:XMLToParse = [xml] ($hostdetails[$count]  | ConvertTo-Xml -notypeinformation)
                $tempstr = [System.String]$global:XMLToParse.Objects.Object.InnerXml
                $global:_DCacheHosts.Add($_.Hostname, $tempstr)
                $count++
            }
        }

        ForEach ($container in $global:_DCacheContainerNames) {
            $global:XMLToParse = New-Object System.Xml.XmlDocument
            $global:XMLToParse = [xml] (Get-SPDistributedCacheClientSetting $container  | ConvertTo-Xml -notypeinformation)
            $tempstr = [System.String]$global:XMLToParse.Objects.Object.InnerXml
            $global:_DCacheContainers.Add($container, $tempstr)
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumSPDcacheConfig", $_)
        return 0
    }
}