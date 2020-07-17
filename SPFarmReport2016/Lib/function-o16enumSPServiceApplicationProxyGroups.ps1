function o16enumSPServiceApplicationProxyGroups() {
    try {
        $script:SvcAppProxyGroupCount = 0
        $groupstr = Get-SPServiceApplicationProxyGroup | select Id | fl | Out-String
        $delimitLines = $groupstr.Split("`n")
		
        ForEach ($GroupID in $delimitLines) {
            $GroupID = $GroupID.Trim()
            if (($GroupID -eq "") -or ($GroupID -eq "Id") -or ($GroupID -eq "--")) { continue }
            $script:SvcAppProxyGroupCount ++
            $GroupID = ($GroupID.Split(":"))[1]
            $GroupID = $GroupID.Trim()
            $script:XMLToParse = New-Object System.Xml.XmlDocument
            $script:XMLToParse = [xml](Get-SPServiceApplicationProxyGroup | Select-Object * -Exclude Proxies, DefaultProxies | where {$_.Id -eq $GroupID} | Out-String -Width 2000 | ConvertTo-XML )			
            $ProxyGroups = Get-SPServiceApplicationProxyGroup | where {$_.Id -eq $GroupID} | select Proxies
            $ProxiesXML = [xml]($ProxyGroups.Proxies | select DisplayName | ConvertTo-Xml -NoTypeInformation)
            $FriendlyName = Get-SPServiceApplicationProxyGroup | where {$_.Id -eq $GroupID} | select FriendlyName | fl | Out-String
            $FriendlyName = ($FriendlyName.Split(":"))[1]
            $FriendlyName = $FriendlyName.Trim()
            $ProxiesStr = [System.String]$ProxiesXML.Objects.OuterXML
            $tempstr1 = $GroupID + "|" + $FriendlyName 
            $tempstr2 = [System.String]$script:XMLToParse.Objects.Object.InnerXml 
            $tempstr2 = $tempstr2.Trim() + $ProxiesStr 
            $script:SPServiceAppProxyGroups.Add($tempstr1, $tempstr2)
        }
        return 1
    }	
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumSPServiceApplicationProxyGroups", $_)
        return 0
    }
}