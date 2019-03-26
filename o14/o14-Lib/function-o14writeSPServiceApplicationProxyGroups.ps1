
function o14writeSPServiceApplicationProxyGroups {
    [CmdletBinding()]
    param ()
    try {
        if ($script:SvcAppProxyGroupCount -eq 0) { 		return 		}

        $XMLWriter.WriteStartElement("Service_Application_Proxy_Groups")
        try {
            $script:SPServiceAppProxyGroups.GetEnumerator() | ForEach-Object {
                $GroupID = ($_.key.Split("|"))[0]
                $FriendlyName = ($_.key.Split("|"))[1]
                $GroupXML = $_.value
                $script:XMLWriter.WriteStartElement("Proxy_Group")
                $script:XMLWriter.WriteAttributeString("Id", $GroupID)
                $script:XMLWriter.WriteAttributeString("FriendlyName", $FriendlyName)
                $script:XMLWriter.WriteRaw($GroupXML)
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
        global:HandleException("o14writeSPServiceApplicationProxyGroups", $_)
    }
}
