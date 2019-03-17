
function o14writeContentDBs()
{
	try
	{
		$global:XMLWriter.WriteStartElement("Content_Databases")
		for($count = 0; $count -lt $global:totalContentDBCount; $count++)
		{
			$XMLWriter.WriteStartElement("Content_Database")
			$XMLWriter.WriteAttributeString("Name", ($ContentDBProps[$count, 0]))
			$XMLWriter.WriteAttributeString("Number", ($count + 1))
			
			$XMLWriter.WriteStartElement("Web_Application")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 1]))
			$XMLWriter.WriteEndElement()
			
			$XMLWriter.WriteStartElement("Id")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 2]))
			$XMLWriter.WriteEndElement()			
			
			$XMLWriter.WriteStartElement("Database_Service_Instance")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 3]))
			$XMLWriter.WriteEndElement()			
			
			$XMLWriter.WriteStartElement("Site_Collection_Count")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 4]))
			$XMLWriter.WriteEndElement()			
			
			$XMLWriter.WriteStartElement("Disk_Space_Required_for_Backup")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 5]))
			$XMLWriter.WriteEndElement()			
			
			for ($count2 = ($global:Servernum - 1); $count2 -ge 0; $count2--)
			{
				if ($global:ServersId[$count2] -eq $global:ContentDBProps[$count, 6]) 
				{ 
					$XMLWriter.WriteStartElement("Timer_Locked_By")
					$XMLWriter.WriteAttributeString("Server", ($global:Servers[$count2]))
					$XMLWriter.WriteEndElement()
				}
			}
			
			$XMLWriter.WriteStartElement("NeedsUpgrade")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 7]))
			$XMLWriter.WriteEndElement()
			
			$XMLWriter.WriteEndElement()
		}		
		$XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14writeContentDBs", $_)
    }
}
