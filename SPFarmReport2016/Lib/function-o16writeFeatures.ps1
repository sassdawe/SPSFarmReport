function o16writeFeatures {
    try {
        $global:XMLWriter.WriteStartElement("Features")	
		
        # where scope is farm
        $XMLWriter.WriteStartElement("Scope")
        $XMLWriter.WriteAttributeString("Level", "Farm")
        for ($i = 0; $i -lt $global:FeatureCount; $i++) {
            $XMLWriter.WriteStartElement("Feature")
            $XMLWriter.WriteAttributeString("Id", ($global:FarmFeatures[$i, 0]))
            $XMLWriter.WriteAttributeString("Name", ($global:FarmFeatures[$i, 1]))
            $XMLWriter.WriteAttributeString("SolutionId", ($global:FarmFeatures[$i, 2]))
            $XMLWriter.WriteAttributeString("IsActive", ($global:FarmFeatures[$i, 3]))
            $XMLWriter.WriteEndElement()
        }
        $XMLWriter.WriteEndElement()
		
        # where scope is site
        $XMLWriter.WriteStartElement("Scope")
        $XMLWriter.WriteAttributeString("Level", "Site")
        for ($i = 0; $i -lt $global:sFeatureCount; $i++) {
            $XMLWriter.WriteStartElement("Feature")
            $XMLWriter.WriteAttributeString("Id", ($global:SiteFeatures[$i, 0]))
            $XMLWriter.WriteAttributeString("Name", ($global:SiteFeatures[$i, 1]))
            $XMLWriter.WriteAttributeString("SolutionId", ($global:SiteFeatures[$i, 2]))
            $XMLWriter.WriteAttributeString("IsActive", ($global:SiteFeatures[$i, 3]))
            $XMLWriter.WriteEndElement()
        }
        $XMLWriter.WriteEndElement()
		
        # where scope is web
        $XMLWriter.WriteStartElement("Scope")
        $XMLWriter.WriteAttributeString("Level", "Web")
        for ($i = 0; $i -lt $global:wFeatureCount; $i++) {
            $XMLWriter.WriteStartElement("Feature")
            $XMLWriter.WriteAttributeString("Id", ($global:WebFeatures[$i, 0]))
            $XMLWriter.WriteAttributeString("Name", ($global:WebFeatures[$i, 1]))
            $XMLWriter.WriteAttributeString("SolutionId", ($global:WebFeatures[$i, 2]))
            $XMLWriter.WriteAttributeString("IsActive", ($global:WebFeatures[$i, 3]))
            $XMLWriter.WriteEndElement()
        }
        $XMLWriter.WriteEndElement()
		
        $XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16writeFeatures", $_)
    }
}