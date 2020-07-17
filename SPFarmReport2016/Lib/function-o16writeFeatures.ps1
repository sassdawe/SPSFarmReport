function o16writeFeatures {
    try {
        $script:XMLWriter.WriteStartElement("Features")	
		
        # where scope is farm
        $XMLWriter.WriteStartElement("Scope")
        $XMLWriter.WriteAttributeString("Level", "Farm")
        for ($i = 0; $i -lt $script:FeatureCount; $i++) {
            $XMLWriter.WriteStartElement("Feature")
            $XMLWriter.WriteAttributeString("Id", ($script:FarmFeatures[$i, 0]))
            $XMLWriter.WriteAttributeString("Name", ($script:FarmFeatures[$i, 1]))
            $XMLWriter.WriteAttributeString("SolutionId", ($script:FarmFeatures[$i, 2]))
            $XMLWriter.WriteAttributeString("IsActive", ($script:FarmFeatures[$i, 3]))
            $XMLWriter.WriteEndElement()
        }
        $XMLWriter.WriteEndElement()
		
        # where scope is site
        $XMLWriter.WriteStartElement("Scope")
        $XMLWriter.WriteAttributeString("Level", "Site")
        for ($i = 0; $i -lt $script:sFeatureCount; $i++) {
            $XMLWriter.WriteStartElement("Feature")
            $XMLWriter.WriteAttributeString("Id", ($script:SiteFeatures[$i, 0]))
            $XMLWriter.WriteAttributeString("Name", ($script:SiteFeatures[$i, 1]))
            $XMLWriter.WriteAttributeString("SolutionId", ($script:SiteFeatures[$i, 2]))
            $XMLWriter.WriteAttributeString("IsActive", ($script:SiteFeatures[$i, 3]))
            $XMLWriter.WriteEndElement()
        }
        $XMLWriter.WriteEndElement()
		
        # where scope is web
        $XMLWriter.WriteStartElement("Scope")
        $XMLWriter.WriteAttributeString("Level", "Web")
        for ($i = 0; $i -lt $script:wFeatureCount; $i++) {
            $XMLWriter.WriteStartElement("Feature")
            $XMLWriter.WriteAttributeString("Id", ($script:WebFeatures[$i, 0]))
            $XMLWriter.WriteAttributeString("Name", ($script:WebFeatures[$i, 1]))
            $XMLWriter.WriteAttributeString("SolutionId", ($script:WebFeatures[$i, 2]))
            $XMLWriter.WriteAttributeString("IsActive", ($script:WebFeatures[$i, 3]))
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