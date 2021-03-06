

function o14writeServers {
    [CmdletBinding()]
    param ()
    try {
        $script:XMLWriter.WriteStartElement("Services_On_Servers")
        for ($i = $script:Servernum; $i -gt 0; $i--) {
            if ([System.Convert]::ToInt32(($script:ServicesOnServers[($i - 1), ($script:_maxServicesOnServers - 1)])) -gt 0 ) {
                $XMLWriter.WriteStartElement("Server")
                $XMLWriter.WriteAttributeString("Name", $Servers[$i - 1])

                for ($j = [System.Int16]::Parse(($ServicesOnServers[($i - 1), ($script:_maxServicesOnServers - 1)])); $j -ge 0 ; $j--) {
                    if ($ServicesOnServers[($i - 1), $j] -ne $null) {
                        if ($j -eq 0) {
                            $XMLWriter.WriteStartElement("Service")
                            $XMLWriter.WriteAttributeString("Name", ($ServicesOnServers[($i - 1), $j]))
                            $XMLWriter.WriteEndElement()
                        }
                        else {
                            $XMLWriter.WriteStartElement("Service")
                            $XMLWriter.WriteAttributeString("Name", ($ServicesOnServers[($i - 1), $j]))
                            $XMLWriter.WriteEndElement()
                        }
                    }
                }
                $XMLWriter.WriteEndElement()
            }
        }
        $XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14writeServers", $_)
    }
}
