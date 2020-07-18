
function o16writeHealthReport() {
    try {
	
        if (($script:HealthReport0.Count -eq 0) -and ($script:HealthReport1.Count -eq 0) -and ($script:HealthReport2.Count -eq 0) -and ($script:HealthReport3.Count -eq 0))
        { exit }
				
        $script:XMLWriter.WriteStartElement("Health_Analyzer_Reports")

        # We iterate through each Severity separately because the rules (their ids) are run and presented sporadic in CA.
        #Writing 0 - Rule Execution Failures
        if ($script:HealthReport0.Count -gt 0) {
            $script:XMLWriter.WriteStartElement("Type")
            $script:XMLWriter.WriteAttributeString("Name", "Rule_Execution_Failures")
            $script:HealthReport0.GetEnumerator() | ForEach-Object {
                $id = $_.key
                $title = $_.value.Split("||")[0]
                $failingServers = $_.value.Split("||")[2]
                $failingServices = $_.value.Split("||")[4]
                $Modified = $_.value.Split("||")[6]
			
                $script:XMLWriter.WriteStartElement("Item")
                $script:XMLWriter.WriteAttributeString("Id", $id)
                $script:XMLWriter.WriteAttributeString("Title", $title)
                $script:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
                $script:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
                $script:XMLWriter.WriteAttributeString("Modified", $Modified)
                $script:XMLWriter.WriteEndElement()		
            }		
            $script:XMLWriter.WriteEndElement()
        }
		
        #Writing 1 - Errors
        if ($script:HealthReport1.Count -gt 0) {
            $script:XMLWriter.WriteStartElement("Type")
            $script:XMLWriter.WriteAttributeString("Name", "Errors")
            $script:HealthReport1.GetEnumerator() | ForEach-Object {
                $id = $_.key
                $title = $_.value.Split("||")[0]
                $failingServers = $_.value.Split("||")[2]
                $failingServices = $_.value.Split("||")[4]
                $Modified = $_.value.Split("||")[6]
			
                $script:XMLWriter.WriteStartElement("Item")
                $script:XMLWriter.WriteAttributeString("Id", $id)
                $script:XMLWriter.WriteAttributeString("Title", $title)
                $script:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
                $script:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
                $script:XMLWriter.WriteAttributeString("Modified", $Modified)
                $script:XMLWriter.WriteEndElement()		
            }		
            $script:XMLWriter.WriteEndElement()
        }
		
        #Writing 2 - Warning
        if ($script:HealthReport2.Count -gt 0) {
            $script:XMLWriter.WriteStartElement("Type")
            $script:XMLWriter.WriteAttributeString("Name", "Warnings")
            $script:HealthReport2.GetEnumerator() | ForEach-Object {
                $id = $_.key
                $title = $_.value.Split("||")[0]
                $failingServers = $_.value.Split("||")[2]
                $failingServices = $_.value.Split("||")[4]
                $Modified = $_.value.Split("||")[6]
                $script:XMLWriter.WriteStartElement("Item")
                $script:XMLWriter.WriteAttributeString("Id", $id)
                $script:XMLWriter.WriteAttributeString("Title", $title)
                $script:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
                $script:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
                $script:XMLWriter.WriteAttributeString("Modified", $Modified)
                $script:XMLWriter.WriteEndElement()		
            }		
            $script:XMLWriter.WriteEndElement()		
        }
		
        #Writing 3 - Information
        if ($script:HealthReport3.Count -gt 0) {
            $script:XMLWriter.WriteStartElement("Type")
            $script:XMLWriter.WriteAttributeString("Name", "Information")
            $script:HealthReport3.GetEnumerator() | ForEach-Object {
                $id = $_.key
                $title = $_.value.Split("||")[0]
                $failingServers = $_.value.Split("||")[2]
                $failingServices = $_.value.Split("||")[4]
                $Modified = $_.value.Split("||")[6]
                $script:XMLWriter.WriteStartElement("Item")
                $script:XMLWriter.WriteAttributeString("Id", $id)
                $script:XMLWriter.WriteAttributeString("Title", $title)
                $script:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
                $script:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
                $script:XMLWriter.WriteAttributeString("Modified", $Modified)
                $script:XMLWriter.WriteEndElement()		
            }		
            $script:XMLWriter.WriteEndElement()		
        }
        $script:XMLWriter.WriteEndElement()		
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        #HandleException("o16writeSPServiceApplicationPools", $_)
    }
}
