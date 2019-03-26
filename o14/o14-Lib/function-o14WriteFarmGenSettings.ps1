

function o14WriteFarmGenSettings {
    [CmdletBinding()]
    param ()
    try {
        # Farm General Settings - Start
        $script:XMLWriter.WriteStartElement("Farm_General_Settings")
        $XMLWriter.WriteStartElement("Central_Admin_URL")
        $XMLWriter.WriteString($script:adminURL)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteStartElement("Farm_Build_Version")
        $XMLWriter.WriteString($script:BuildVersion)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteStartElement("System_Account")
        $XMLWriter.WriteString($script:systemAccount)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteStartElement("Configuration_Database_Name")
        $XMLWriter.WriteString($script:confgDbName)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteStartElement("Configuration_Database_Server")
        $XMLWriter.WriteString($script:confgDbServerName)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteStartElement("Admin_Content_Database_Name")
        $XMLWriter.WriteString($script:adminDbName)
        $XMLWriter.WriteEndElement()
        $XMLWriter.WriteEndElement()
        # Farm General Settings - End
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14WriteFarmGenSettings", $_)
    }
}