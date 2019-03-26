function o14WriteInitialXML {
    [CmdletBinding()]
    param ()
    try {
        [System.Xml.XmlWriterSettings] $script:XMLWriterSettings = New-Object System.Xml.XmlWriterSettings
        $script:XMLWriterSettings.Indent = [System.Boolean] "true"
        $script:XMLWriterSettings.IndentChars = ("    ")
        $path = [Environment]::CurrentDirectory + "\SPSFarmReportNew{0}{1:d2}{2:d2}-{3:d2}{4:d2}" -f (Get-Date).Day, (Get-Date).Month, (Get-Date).Year, (Get-Date).Second, (Get-Date).Millisecond + ".XML"
        $script:XMLWriter = [System.Xml.XmlWriter]::Create($path, $XMLWriterSettings)
        $script:XMLWriter.WriteStartDocument()
        $xsl = "type='text/xsl' href='SPSFarmReport.xslt'"
        $commentStr = " This report was generated at " + (Get-Date).ToString() + " on server " + $env:COMPUTERNAME + " by user " + $Env:USERDOMAIN + "\" + $Env:USERNAME + ". "
        $XMLWriter.WriteProcessingInstruction("xml-stylesheet", $xsl)
        $XMLWriter.WriteComment($commentStr)

        # Initial tag -> Start
        $XMLWriter.WriteStartElement("Farm_Information")
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14WriteInitialXML", $_)
    }
}
