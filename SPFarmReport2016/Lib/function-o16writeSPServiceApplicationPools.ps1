function o16writeSPServiceApplicationPools {
    try {
        if ($script:serviceAppPoolCount -eq 0 ) { return }
		
        $script:XMLWriter.WriteStartElement("Service_Application_Pools")
        $script:SPServiceApplicationPools.GetEnumerator() | ForEach-Object {
            $serviceAppPoolID = $_.key
            $serviceAppPoolstr = $_.value
		
            $script:XMLWriter.WriteStartElement("Application_Pool")
            $script:XMLWriter.WriteAttributeString("Id", $serviceAppPoolID)
            $script:XMLWriter.WriteRaw($serviceAppPoolstr)
            $script:XMLWriter.WriteEndElement()		
        }
        $script:XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16writeSPServiceApplicationPools", $_)
    }
}