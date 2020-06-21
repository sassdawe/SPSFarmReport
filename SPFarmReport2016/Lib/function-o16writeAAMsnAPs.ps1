function o16writeAAMsnAPs() {
    try {
        $AllZones = [Microsoft.SharePoint.Administration.SPUrlZone]::Default, 
        [Microsoft.SharePoint.Administration.SPUrlZone]::Intranet, 
        [Microsoft.SharePoint.Administration.SPUrlZone]::Internet, 
        [Microsoft.SharePoint.Administration.SPUrlZone]::Custom, 
        [Microsoft.SharePoint.Administration.SPUrlZone]::Extranet
        $global:XMLWriter.WriteStartElement("Alternate_Access_Mappings")
        for ($wcount = 0; $wcount -lt $global:WebAppnum; $wcount++) {
            $XMLWriter.WriteStartElement("Web_Application")
            $XMLWriter.WriteAttributeString("Name", ($WebAppDetails[$wcount, 2]))
			
            for ($zones = 1; $zones -le 5; $zones++) {				
                $XMLWriter.WriteStartElement(($AllZones[$zones - 1]))	
                $tempstr = $WebAppPublicAAM[$wcount, $zones]
                if ($tempstr -ne $null) { 
                    $tempstr = $tempstr.Trim()
                    if ($tempstr -ne "") {
                        $XMLWriter.WriteStartElement("PublicURL")
                        $XMLWriter.WriteString(($WebAppPublicAAM[$wcount, $zones]))
                        $XMLWriter.WriteEndElement()
                    }
                }
				
                $tempstr = $WebAppInternalAAMURL[$wcount, $zones]
                if ($tempstr -ne $null) {
                    $tempstr = $tempstr.Trim()
                    if ($tempstr -ne "") {
                        $XMLWriter.WriteStartElement("InternalURL")
                        $XMLWriter.WriteString(($WebAppInternalAAMURL[$wcount, $zones]))
                        $XMLWriter.WriteEndElement()
                    }
                }
				
                $tempstr = $WebAppAuthProviders[$wcount, $zones]
                if ($tempstr -ne $null) {
                    $tempstr = $tempstr -split ']'
					
                    $XMLWriter.WriteStartElement("UseClaimsAuthentication")
                    $XMLWriter.WriteString(($tempstr[3].Trim()))
                    $XMLWriter.WriteEndElement()
					
                    $XMLWriter.WriteStartElement("AuthenticationMode")
                    $XMLWriter.WriteString(($tempstr[0].Trim()))
                    $XMLWriter.WriteEndElement()				
					
                    $XMLWriter.WriteStartElement("AllowAnonymous")
                    $XMLWriter.WriteString(($tempstr[1].Trim()))
                    $XMLWriter.WriteEndElement()								

                    $XMLWriter.WriteStartElement("Path")
                    $XMLWriter.WriteString(($tempstr[2].Trim()))
                    $XMLWriter.WriteEndElement()				
                }
                $XMLWriter.WriteEndElement()
            }		
            $XMLWriter.WriteEndElement()
        }
        $XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16writeAAMsnAPs", $_)
    }
}
