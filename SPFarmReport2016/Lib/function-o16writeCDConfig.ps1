
function o16writeCDConfig() {
    try {
        $script:XMLWriter.WriteStartElement("Content_Deployment")
		
        #Writing General Information
        $script:XMLWriter.WriteStartElement("General_Information")
        $script:XMLWriter.WriteRaw($script:CDGI.Objects.Object.InnerXml)
        $script:XMLWriter.WriteEndElement()		
		
        #Writing Paths
        $script:CDPaths.GetEnumerator() | ForEach-Object {
            $PathId = ($_.key.Split('|'))[0]
            $PathName = ($_.key.Split('|'))[1]
            $PathName = $PathName.Trim()
            $tempstr = $_.value
		
		
            $script:XMLWriter.WriteStartElement("Path")
            $script:XMLWriter.WriteAttributeString("Name", $PathName)
            $script:XMLWriter.WriteStartElement("General_Information")
            $script:XMLWriter.WriteRaw($tempstr)
            $script:XMLWriter.WriteEndElement()		
		
            $script:CDJobs.GetEnumerator() | ForEach-Object {
                $PathId2 = ($_.key.Split('|'))[0]
                $JobName = ($_.key.Split('|'))[2]
                $JobName = $JobName.Trim()
		
                if ($PathId2 -eq $PathId) {
                    $script:XMLWriter.WriteStartElement("Job")
                    $script:XMLWriter.WriteAttributeString("Name", $JobName)
                    $script:XMLWriter.WriteRaw($_.value)
                    $script:XMLWriter.WriteEndElement()	
                }
		
            }
		
            $script:XMLWriter.WriteEndElement()		
        }	
        $script:XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        #global:HandleException("o16writeSPServiceApplicationPools", $_)
    }
}
