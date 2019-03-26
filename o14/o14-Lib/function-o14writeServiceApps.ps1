
function o14writeServiceApps {
    [CmdletBinding()]
    param ()
    try {
        $xrs = New-Object -TypeName System.Xml.XmlReaderSettings
        $xrs.ConformanceLevel = [System.Xml.ConformanceLevel]::Fragment

        $script:XMLWriter.WriteStartElement("Service_Applications")
        $script:ServiceApps.GetEnumerator() | ForEach-Object {

            $isSearchSvcApp = 0
            $ServiceAppID = ($_.key.Split('|'))[0]
            $typeName = ($_.key.Split('|'))[1]

            ForEach ($searchAppId in $searchServiceAppIds) {
                if ($searchAppId -eq $ServiceAppID) { $isSearchSvcApp = 1 }
            }

            $script:XMLWriter.WriteStartElement("Service_Application")
            $script:XMLWriter.WriteAttributeString("Type", $typeName)

            if ($isSearchSvcApp -eq 1) {
                $script:XMLWriter.WriteStartElement("General_Information")
                $script:XMLWriter.WriteRaw($_.value)
                $script:XMLWriter.WriteEndElement()

                #Writing the Admin Component
                $script:XMLWriter.WriteStartElement("Admin_Component")
                try {
                    $script:SearchConfigAdminComponents.GetEnumerator() | ForEach-Object {
                        if ($ServiceAppID -eq ($_.key)) { $adminComponent = $_.value}
                    }
                    $script:XMLWriter.WriteRaw($adminComponent)
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
                }
                $script:XMLWriter.WriteEndElement()

                #Writing the Crawl Components
                $script:XMLWriter.WriteStartElement("Crawl_Components")
                try {
                    $script:SearchConfigCrawlComponents.GetEnumerator() | ForEach-Object {
                        $crawlComponent = ""
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        $crawlComponentID = ($_.key.Split('|'))[1]
                        if ($ServiceAppID -eq $searchServiceAppID) {
                            $crawlComponent = $_.value
                            $script:XMLWriter.WriteStartElement("Crawl_Component")
                            $script:XMLWriter.WriteAttributeString("Id", $crawlComponentID)
                            $script:XMLWriter.WriteRaw($crawlComponent)
                            $script:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
                }
                $script:XMLWriter.WriteEndElement()

                #Writing the Query Components
                $script:XMLWriter.WriteStartElement("Query_Components")
                try {
                    $script:SearchConfigQueryComponents.GetEnumerator() | ForEach-Object {
                        $queryComponent = ""
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        $queryComponentID = ($_.key.Split('|'))[1]
                        if ($ServiceAppID -eq $searchServiceAppID) {
                            $queryComponent = $_.value
                            $script:XMLWriter.WriteStartElement("Query_Component")
                            $script:XMLWriter.WriteAttributeString("Id", $queryComponentID)
                            $script:XMLWriter.WriteRaw($queryComponent)
                            $script:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
                }
                $script:XMLWriter.WriteEndElement()

                #Writing the Content Sources
                $script:XMLWriter.WriteStartElement("Content_Sources")
                try {
                    $script:SearchConfigContentSources.GetEnumerator() | ForEach-Object {
                        $contentSource = ""
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        $contentSourceID = ($_.key.Split('|'))[1]
                        if ($ServiceAppID -eq $searchServiceAppID) {
                            $contentSource = $_.value
                            $script:XMLWriter.WriteStartElement("Content_Source")
                            $script:XMLWriter.WriteAttributeString("Id", $contentSourceID)
                            $script:XMLWriter.WriteRaw($contentSource)
                            $script:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
                }
                $script:XMLWriter.WriteEndElement()
            }
            elseif ($isSearchSvcApp -eq 0) {
                $script:XMLWriter.WriteRaw($_.value)
            }

            $script:XMLWriter.WriteEndElement()

        }
        $script:XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14writeServiceApps", $_)
    }
}

