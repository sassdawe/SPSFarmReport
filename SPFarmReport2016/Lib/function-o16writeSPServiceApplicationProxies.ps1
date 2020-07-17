function o16writeSPServiceApplicationProxies {
    try {
        if ($script:serviceAppProxyCount -eq 0)
        { 		return 		}
        $script:XMLWriter.WriteStartElement("Service_Application_Proxies")
        try {
            $script:SPServiceAppProxies.GetEnumerator() | ForEach-Object {
                $searchServiceAppProxyID = ($_.key.Split('|'))[0]
                $TypeName = ($_.key.Split('|'))[1]	
                $proxy = $_.value				
                $script:XMLWriter.WriteStartElement("Proxy")
                $script:XMLWriter.WriteAttributeString("Id", $searchServiceAppProxyID)
                $script:XMLWriter.WriteAttributeString("TypeName", $TypeName)
                $script:XMLWriter.WriteRaw($proxy)
                $script:XMLWriter.WriteEndElement()
            }
        }
        catch [System.Exception] {
            Write-Host " ******** Exception caught. Check the log file for more details. ******** "
            Write-Output $_ | Out-File -FilePath $script:_logpath -Append
        }		
        $XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16writeSPServiceApplicationProxies", $_)
    }
}
