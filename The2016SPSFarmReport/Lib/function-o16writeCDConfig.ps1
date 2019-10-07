
function o16writeCDConfig() {
    try {
        $global:XMLWriter.WriteStartElement("Content_Deployment")
		
        #Writing General Information
        $global:XMLWriter.WriteStartElement("General_Information")
        $global:XMLWriter.WriteRaw($global:CDGI.Objects.Object.InnerXml)
        $global:XMLWriter.WriteEndElement()		
		
        #Writing Paths
        $global:CDPaths.GetEnumerator() | ForEach-Object {
            $PathId = ($_.key.Split('|'))[0]
            $PathName = ($_.key.Split('|'))[1]
            $PathName = $PathName.Trim()
            $tempstr = $_.value
		
		
            $global:XMLWriter.WriteStartElement("Path")
            $global:XMLWriter.WriteAttributeString("Name", $PathName)
            $global:XMLWriter.WriteStartElement("General_Information")
            $global:XMLWriter.WriteRaw($tempstr)
            $global:XMLWriter.WriteEndElement()		
		
            $global:CDJobs.GetEnumerator() | ForEach-Object {
                $PathId2 = ($_.key.Split('|'))[0]
                $JobName = ($_.key.Split('|'))[2]
                $JobName = $JobName.Trim()
		
                if ($PathId2 -eq $PathId) {
                    $global:XMLWriter.WriteStartElement("Job")
                    $global:XMLWriter.WriteAttributeString("Name", $JobName)
                    $global:XMLWriter.WriteRaw($_.value)
                    $global:XMLWriter.WriteEndElement()	
                }
		
            }
		
            $global:XMLWriter.WriteEndElement()		
        }	
        $global:XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        #global:HandleException("o16writeSPServiceApplicationPools", $_)
    }
}
