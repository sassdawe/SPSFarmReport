
function o14writeSolutions {
    [CmdletBinding()]
    param ()
    try {
        $script:XMLWriter.WriteStartElement("Custom_Solutions")

        if ($script:solutionCount -eq 0) {
            $XMLWriter.WriteComment("There were no custom solutions found to be deployed on this farm.")
            $XMLWriter.WriteEndElement()
            return
        }

        for ($count = 0; $count -le ($script:solutionCount - 1); $count++) {
            $XMLWriter.WriteStartElement("Solution")
            $XMLWriter.WriteAttributeString("No.", ($count + 1).ToString() )

            $XMLWriter.WriteStartElement("Id")
            $XMLWriter.WriteString(($script:solutionProps[$count, 5]))
            $XMLWriter.WriteEndElement()

            $XMLWriter.WriteStartElement("Name")
            $XMLWriter.WriteString(($script:solutionProps[$count, 0]))
            $XMLWriter.WriteEndElement()

            $XMLWriter.WriteStartElement("Deployed_On_Web_Apps")
            $XMLWriter.WriteString(($script:solutionProps[$count, 1]))
            $XMLWriter.WriteEndElement()

            $XMLWriter.WriteStartElement("LastOperationDetails")
            $XMLWriter.WriteString(($script:solutionProps[$count, 2]))
            $XMLWriter.WriteEndElement()

            $XMLWriter.WriteStartElement("Deployed_On_Servers")
            $XMLWriter.WriteString(($script:solutionProps[$count, 3]))
            $XMLWriter.WriteEndElement()

            $XMLWriter.WriteEndElement()
        }

        $XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14writeSolutions", $_)
    }
}
