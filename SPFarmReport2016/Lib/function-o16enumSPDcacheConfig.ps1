function o16enumSPDcacheConfig {
    [cmdletbinding()]
    param ()
    try {
        $count = 0
        Use-CacheCluster
        $hostdetails = Get-CacheHost
        if ($hostdetails.Length -lt 2) {
            $script:XMLToParse = New-Object System.Xml.XmlDocument
            $script:XMLToParse = [xml] ($hostdetails[$count]  | ConvertTo-Xml -notypeinformation)
            $tempstr = [System.String]$script:XMLToParse.Objects.Object.InnerXml
            $script:_DCacheHosts.Add($hostdetails.Hostname, $tempstr)
        }
        else {
            $hostdetails.GetEnumerator() | ForEach-Object {
                $script:XMLToParse = New-Object System.Xml.XmlDocument
                $script:XMLToParse = [xml] ($hostdetails[$count]  | ConvertTo-Xml -notypeinformation)
                $tempstr = [System.String]$script:XMLToParse.Objects.Object.InnerXml
                $script:_DCacheHosts.Add($_.Hostname, $tempstr)
                $count++
            }
        }

        ForEach ($container in $script:_DCacheContainerNames) {
            $script:XMLToParse = New-Object System.Xml.XmlDocument
            $script:XMLToParse = [xml] (Get-SPDistributedCacheClientSetting $container  | ConvertTo-Xml -notypeinformation)
            $tempstr = [System.String]$script:XMLToParse.Objects.Object.InnerXml
            $script:_DCacheContainers.Add($container, $tempstr)
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16enumSPDcacheConfig", $_)
        return 0
    }
}