function o16WriteEndXML() {
    try {
        # Initial tag -> End
        #$script:XMLWriter.WriteEndElement()
        if ($script:exceptionDetails.Length -gt 0) {
            $XMLWriter.WriteComment($script:exceptionDetails)
        }
        $XMLWriter.WriteEndDocument()		
        $XMLWriter.Flush()
        $XMLWriter.Close()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16WriteEndXML", $_)
    }
}