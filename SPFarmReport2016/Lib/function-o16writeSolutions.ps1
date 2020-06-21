function o16writeSolutions {
    try {
        $global:XMLWriter.WriteStartElement("Custom_Solutions")
		
        if ($global:solutionCount -eq 0) {
            $XMLWriter.WriteComment("There were no custom solutions found to be deployed on this farm.")
            $XMLWriter.WriteEndElement()
            return
        }
		
        for ($count = 0; $count -le ($global:solutionCount - 1); $count++) {
            $XMLWriter.WriteStartElement("Solution")
            $XMLWriter.WriteAttributeString("No.", ($count + 1).ToString() )
			
            $XMLWriter.WriteStartElement("Id")
            $XMLWriter.WriteString(($global:solutionProps[$count, 5]))
            $XMLWriter.WriteEndElement()

            $XMLWriter.WriteStartElement("Name")
            $XMLWriter.WriteString(($global:solutionProps[$count, 0]))
            $XMLWriter.WriteEndElement()
	
            $XMLWriter.WriteStartElement("Deployed_On_Web_Apps")
            $XMLWriter.WriteString(($global:solutionProps[$count, 1]))
            $XMLWriter.WriteEndElement()

            $XMLWriter.WriteStartElement("LastOperationDetails")
            $XMLWriter.WriteString(($global:solutionProps[$count, 2]))
            $XMLWriter.WriteEndElement()

            $XMLWriter.WriteStartElement("Deployed_On_Servers")
            $XMLWriter.WriteString(($global:solutionProps[$count, 3]))
            $XMLWriter.WriteEndElement()

            $XMLWriter.WriteEndElement()			
        }
		
        $XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16writeSolutions", $_)
    }	
}