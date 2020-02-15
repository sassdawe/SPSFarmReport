
function Write-SPSRWebApp {
    [Alias("o16writeWebApps")]
    [CmdletBinding()]
    param (
    )
    try {
        $contentDBs = ""
        $global:XMLWriter.WriteStartElement("Web_Applications")

        for ($wcount = 0; $wcount -lt $global:WebAppnum; $wcount++ ) {
            $XMLWriter.WriteStartElement("Web_Application")
            $XMLWriter.WriteAttributeString("Name", ($global:WebAppDetails[$wcount, 2]))

            $XMLWriter.WriteStartElement("Associated_Applicaion_Pool")
            $XMLWriter.WriteAttributeString("Name", ($global:WebAppDetails[$wcount, 6]))
            $XMLWriter.WriteAttributeString("Identity", ($global:WebAppDetails[$wcount, 7]))
            $XMLWriter.WriteEndElement()

            $XMLWriter.WriteStartElement("Associated_Service_Application_Proxy_Group")
            $XMLWriter.WriteAttributeString("Name", ($global:WebAppDetails[$wcount, 9]))
            $XMLWriter.WriteEndElement()

            $XMLWriter.WriteStartElement("Content_Databases")
            for ($dbcount = 0; $dbcount -le [System.Convert]::ToInt32(($global:WebAppDetails[$wcount, 3])); $dbcount++) {
                if (($contentDBs -eq "") -and (($dbcount + 1) -eq [System.Convert]::ToInt32(($global:WebAppDetails[$wcount, 3])))) {
                    $contentDB = $global:ContentDBs[$wcount, $dbcount]
                    $XMLWriter.WriteStartElement("Content_Database")
                    $XMLWriter.WriteAttributeString("Name", $contentDB)
                    $XMLWriter.WriteEndElement()
                }
            }
            $XMLWriter.WriteEndElement()
            $XMLWriter.WriteEndElement()
        }

        $global:XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("Write-SPSRWebApp", $_)
    }
}