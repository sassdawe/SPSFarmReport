function o16writeSPServiceApplicationPools {
    try {
        if ($global:serviceAppPoolCount -eq 0 ) { return }
		
        $global:XMLWriter.WriteStartElement("Service_Application_Pools")
        $global:SPServiceApplicationPools.GetEnumerator() | ForEach-Object {
            $serviceAppPoolID = $_.key
            $serviceAppPoolstr = $_.value
		
            $global:XMLWriter.WriteStartElement("Application_Pool")
            $global:XMLWriter.WriteAttributeString("Id", $serviceAppPoolID)
            $global:XMLWriter.WriteRaw($serviceAppPoolstr)
            $global:XMLWriter.WriteEndElement()		
        }
        $global:XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeSPServiceApplicationPools", $_)
    }
}