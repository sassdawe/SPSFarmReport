function o16writeSPServiceApplicationProxies {
    try {
        if ($global:serviceAppProxyCount -eq 0)
        { 		return 		}
        $global:XMLWriter.WriteStartElement("Service_Application_Proxies")
        try {
            $global:SPServiceAppProxies.GetEnumerator() | ForEach-Object {
                $searchServiceAppProxyID = ($_.key.Split('|'))[0]
                $TypeName = ($_.key.Split('|'))[1]	
                $proxy = $_.value				
                $global:XMLWriter.WriteStartElement("Proxy")
                $global:XMLWriter.WriteAttributeString("Id", $searchServiceAppProxyID)
                $global:XMLWriter.WriteAttributeString("TypeName", $TypeName)
                $global:XMLWriter.WriteRaw($proxy)
                $global:XMLWriter.WriteEndElement()
            }
        }
        catch [System.Exception] {
            Write-Host " ******** Exception caught. Check the log file for more details. ******** "
            Write-Output $_ | Out-File -FilePath $global:_logpath -Append
        }		
        $XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeSPServiceApplicationProxies", $_)
    }
}
