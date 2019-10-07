function o16writeServers() {
    try {
        $global:XMLWriter.WriteStartElement("Services_On_Servers")		
        for ($i = $global:Servernum; $i -gt 0; $i--) {
            if ([System.Convert]::ToInt32(($global:ServicesOnServers[($i - 1), ($global:_maxServicesOnServers - 1)])) -gt 0 ) {
                $XMLWriter.WriteStartElement("Server")
                $XMLWriter.WriteAttributeString("Name", $Servers[$i - 1])	
                $global:ServerRoles.GetEnumerator() | ForEach-Object {		
                    if ($_.key -eq $Servers[$i - 1]) {                
                        $Role = ($_.value.Split(','))[0]
                        $Compliance = ($_.value.Split(','))[1]	    
                    }
                }			
                $XMLWriter.WriteAttributeString("Role", $Role)
                $XMLWriter.WriteAttributeString("Compliance", $Compliance)
				
                for ($j = [System.Int16]::Parse(($ServicesOnServers[($i - 1), ($global:_maxServicesOnServers - 1)])); $j -ge 0 ; $j--) {
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
        global:HandleException("o16writeServers", $_)
    }
}