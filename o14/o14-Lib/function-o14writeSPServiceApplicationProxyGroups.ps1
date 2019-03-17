
function o14writeSPServiceApplicationProxyGroups
{
	try
	{
		if($global:SvcAppProxyGroupCount -eq 0)		{ 		return 		}
		
		$XMLWriter.WriteStartElement("Service_Application_Proxy_Groups")
		try
		{
			$global:SPServiceAppProxyGroups.GetEnumerator() | ForEach-Object {
			$GroupID = ($_.key.Split("|"))[0]
			$FriendlyName = ($_.key.Split("|"))[1]
			$GroupXML = $_.value				
			$global:XMLWriter.WriteStartElement("Proxy_Group")
			$global:XMLWriter.WriteAttributeString("Id", $GroupID)
			$global:XMLWriter.WriteAttributeString("FriendlyName", $FriendlyName)
			$global:XMLWriter.WriteRaw($GroupXML)
			$global:XMLWriter.WriteEndElement()
			}
		}
		catch [System.Exception] 
	    {
			Write-Host " ******** Exception caught. Check the log file for more details. ******** "
	        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
	    }
		
		
		$XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14writeSPServiceApplicationProxyGroups", $_)
    }
}
