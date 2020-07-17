
function o16writeContentDBs() {
    try {
        $script:XMLWriter.WriteStartElement("Content_Databases")
        for ($count = 0; $count -lt $script:totalContentDBCount; $count++) {
            $XMLWriter.WriteStartElement("Content_Database")
            $XMLWriter.WriteAttributeString("Name", ($ContentDBProps[$count, 0]))
            $XMLWriter.WriteAttributeString("Number", ($count + 1))
			
            $XMLWriter.WriteStartElement("Web_Application")
            $XMLWriter.WriteString(($script:ContentDBProps[$count, 1]))
            $XMLWriter.WriteEndElement()
			
            $XMLWriter.WriteStartElement("Id")
            $XMLWriter.WriteString(($script:ContentDBProps[$count, 2]))
            $XMLWriter.WriteEndElement()			
			
            $XMLWriter.WriteStartElement("Database_Service_Instance")
            $XMLWriter.WriteString(($script:ContentDBProps[$count, 3]))
            $XMLWriter.WriteEndElement()			
			
            $XMLWriter.WriteStartElement("Site_Collection_Count")
            $XMLWriter.WriteString(($script:ContentDBProps[$count, 4]))
            $XMLWriter.WriteEndElement()			
			
            $XMLWriter.WriteStartElement("Disk_Space_Required_for_Backup")
            $XMLWriter.WriteString(($script:ContentDBProps[$count, 5]))
            $XMLWriter.WriteEndElement()			
			
            for ($count2 = ($script:Servernum - 1); $count2 -ge 0; $count2--) {
                if ($script:ServersId[$count2] -eq $script:ContentDBProps[$count, 6]) { 
                    $XMLWriter.WriteStartElement("Timer_Locked_By")
                    $XMLWriter.WriteAttributeString("Server", ($script:Servers[$count2]))
                    $XMLWriter.WriteEndElement()
                }
            }
			
            $XMLWriter.WriteStartElement("NeedsUpgrade")
            $XMLWriter.WriteString(($script:ContentDBProps[$count, 7]))
            $XMLWriter.WriteEndElement()
			
            $XMLWriter.WriteEndElement()
        }		
        $XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16writeContentDBs", $_)
    }
}
