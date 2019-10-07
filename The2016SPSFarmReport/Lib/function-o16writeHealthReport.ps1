
function o16writeHealthReport() {
    try {
	
        if (($global:HealthReport0.Count -eq 0) -and ($global:HealthReport1.Count -eq 0) -and ($global:HealthReport2.Count -eq 0) -and ($global:HealthReport3.Count -eq 0))
        { exit }
				
        $global:XMLWriter.WriteStartElement("Health_Analyzer_Reports")

        # We iterate through each Severity separately because the rules (their ids) are run and presented sporadic in CA.
        #Writing 0 - Rule Execution Failures
        if ($global:HealthReport0.Count -gt 0) {
            $global:XMLWriter.WriteStartElement("Type")
            $global:XMLWriter.WriteAttributeString("Name", "Rule_Execution_Failures")
            $global:HealthReport0.GetEnumerator() | ForEach-Object {
                $id = $_.key
                $title = $_.value.Split("||")[0]
                $failingServers = $_.value.Split("||")[2]
                $failingServices = $_.value.Split("||")[4]
                $Modified = $_.value.Split("||")[6]
			
                $global:XMLWriter.WriteStartElement("Item")
                $global:XMLWriter.WriteAttributeString("Id", $id)
                $global:XMLWriter.WriteAttributeString("Title", $title)
                $global:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
                $global:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
                $global:XMLWriter.WriteAttributeString("Modified", $Modified)
                $global:XMLWriter.WriteEndElement()		
            }		
            $global:XMLWriter.WriteEndElement()
        }
		
        #Writing 1 - Errors
        if ($global:HealthReport1.Count -gt 0) {
            $global:XMLWriter.WriteStartElement("Type")
            $global:XMLWriter.WriteAttributeString("Name", "Errors")
            $global:HealthReport1.GetEnumerator() | ForEach-Object {
                $id = $_.key
                $title = $_.value.Split("||")[0]
                $failingServers = $_.value.Split("||")[2]
                $failingServices = $_.value.Split("||")[4]
                $Modified = $_.value.Split("||")[6]
			
                $global:XMLWriter.WriteStartElement("Item")
                $global:XMLWriter.WriteAttributeString("Id", $id)
                $global:XMLWriter.WriteAttributeString("Title", $title)
                $global:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
                $global:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
                $global:XMLWriter.WriteAttributeString("Modified", $Modified)
                $global:XMLWriter.WriteEndElement()		
            }		
            $global:XMLWriter.WriteEndElement()
        }
		
        #Writing 2 - Warning
        if ($global:HealthReport2.Count -gt 0) {
            $global:XMLWriter.WriteStartElement("Type")
            $global:XMLWriter.WriteAttributeString("Name", "Warnings")
            $global:HealthReport2.GetEnumerator() | ForEach-Object {
                $id = $_.key
                $title = $_.value.Split("||")[0]
                $failingServers = $_.value.Split("||")[2]
                $failingServices = $_.value.Split("||")[4]
                $Modified = $_.value.Split("||")[6]
                $global:XMLWriter.WriteStartElement("Item")
                $global:XMLWriter.WriteAttributeString("Id", $id)
                $global:XMLWriter.WriteAttributeString("Title", $title)
                $global:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
                $global:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
                $global:XMLWriter.WriteAttributeString("Modified", $Modified)
                $global:XMLWriter.WriteEndElement()		
            }		
            $global:XMLWriter.WriteEndElement()		
        }
		
        #Writing 3 - Information
        if ($global:HealthReport3.Count -gt 0) {
            $global:XMLWriter.WriteStartElement("Type")
            $global:XMLWriter.WriteAttributeString("Name", "Information")
            $global:HealthReport3.GetEnumerator() | ForEach-Object {
                $id = $_.key
                $title = $_.value.Split("||")[0]
                $failingServers = $_.value.Split("||")[2]
                $failingServices = $_.value.Split("||")[4]
                $Modified = $_.value.Split("||")[6]
                $global:XMLWriter.WriteStartElement("Item")
                $global:XMLWriter.WriteAttributeString("Id", $id)
                $global:XMLWriter.WriteAttributeString("Title", $title)
                $global:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
                $global:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
                $global:XMLWriter.WriteAttributeString("Modified", $Modified)
                $global:XMLWriter.WriteEndElement()		
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
