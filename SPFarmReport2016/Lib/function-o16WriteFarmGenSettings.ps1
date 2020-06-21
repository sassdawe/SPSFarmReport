function o16WriteFarmGenSettings() {
    try {
        # Farm General Settings - Start
        $global:XMLWriter.WriteStartElement("Farm_General_Settings")
        $XMLWriter.WriteStartElement("Central_Admin_URL")
        $XMLWriter.WriteString($global:adminURL)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteStartElement("Farm_Build_Version")
        $XMLWriter.WriteString($global:BuildVersion)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteStartElement("System_Account")
        $XMLWriter.WriteString($global:systemAccount)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteStartElement("Configuration_Database_Name")
        $XMLWriter.WriteString($global:confgDbName)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteStartElement("Configuration_Database_Server")
        $XMLWriter.WriteString($global:confgDbServerName)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteStartElement("Admin_Content_Database_Name")
        $XMLWriter.WriteString($global:adminDbName)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteEndElement()
        # Farm General Settings - End		
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16WriteFarmGenSettings", $_)
    }
}