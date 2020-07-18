function o16writeServiceApps {
    try { 
        $xrs = New-Object -TypeName System.Xml.XmlReaderSettings
        $xrs.ConformanceLevel = [System.Xml.ConformanceLevel]::Fragment
		
        $script:XMLWriter.WriteStartElement("Service_Applications")		
        $script:ServiceApps.GetEnumerator() | ForEach-Object {
		
            $isSearchSvcApp = 0	
            $isProjectSvcApp = 0          
            $prjApp = $_.Value
            $ServiceAppID = ($_.key.Split('|'))[0]
            $typeName = ($_.key.Split('|'))[1]		
            if ($script:projectsvcApps.Id -eq $ServiceAppID) { $isProjectSvcApp = 1}  	
	
            ForEach ($searchAppId in $searchServiceAppIds) {
                if ($searchAppId -eq $ServiceAppID) { $isSearchSvcApp = 1 }
            }
		
            $script:XMLWriter.WriteStartElement("Service_Application")
            $script:XMLWriter.WriteAttributeString("Type", $typeName)
		
            if ($isSearchSvcApp -eq 1) {			
                $script:XMLWriter.WriteStartElement("General_Information")
                $script:XMLWriter.WriteRaw($_.value)
                $script:XMLWriter.WriteEndElement()
			
                #Writing the Search Service Status
                $script:XMLWriter.WriteStartElement("Enterprise_Search_Service_Status")
                try {
                    $script:XMLWriter.WriteStartElement("General_Information")
                    $script:XMLWriter.WriteRaw($script:enterpriseSearchServiceStatus)
                    $script:XMLWriter.WriteEndElement()
					
                    $script:XMLWriter.WriteStartElement("Job_Definitions")
                    $script:XMLWriter.WriteRaw($script:enterpriseSearchServiceJobDefs)
                    $script:XMLWriter.WriteEndElement()
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
                }
                $script:XMLWriter.WriteEndElement()	
			
                #Writing the Active Topology
                $script:XMLWriter.WriteStartElement("Active_Topology")
                try {
                    $script:SearchActiveTopologyComponents.GetEnumerator() | ForEach-Object {
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        if ($ServiceAppID -eq ($searchServiceAppID)) { 
                            $props = $_.value
                            $compName = ($_.key.Split('|'))[1]
                            $script:XMLWriter.WriteStartElement("Component")
                            $script:XMLWriter.WriteAttributeString("Name", $compName.Trim())
                            $script:XMLWriter.WriteRaw($props)
                            $script:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
                }
                $script:XMLWriter.WriteEndElement()		
			
                #Writing the Host Controllers
                $script:XMLWriter.WriteStartElement("Host_Controllers")
                try {
                    $script:SearchHostControllers.GetEnumerator() | ForEach-Object {
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        if ($ServiceAppID -eq ($searchServiceAppID)) { 
                            $props = $_.value
                            $serverName = ($_.key.Split('|'))[1]
                            $script:XMLWriter.WriteStartElement("Server")
                            $script:XMLWriter.WriteAttributeString("Name", $serverName.Trim())
                            $script:XMLWriter.WriteRaw($props)
                            $script:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
                }
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
			
                # Writing Link Stores
                $script:XMLWriter.WriteStartElement("Link_Stores")
                try {
                    $script:SearchConfigLinkStores.GetEnumerator() | ForEach-Object {
                        if ($ServiceAppID -eq ($_.key)) { $storeValue = $_.value}
                    }
                    $script:XMLWriter.WriteRaw($storeValue)
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
                }
                $script:XMLWriter.WriteEndElement()
			
                #Writing the Crawl Databases
                $script:XMLWriter.WriteStartElement("Crawl_Databases")
                try {
                    $script:SearchConfigCrawlDatabases.GetEnumerator() | ForEach-Object {
                        $crawlComponent = ""
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        $crawlDatabaseID = ($_.key.Split('|'))[1]	
                        if ($ServiceAppID -eq $searchServiceAppID) { 
                            $crawlComponent = $_.value				
                            $script:XMLWriter.WriteStartElement("Database")
                            $script:XMLWriter.WriteAttributeString("Id", $crawlDatabaseID)
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
			
                #Writing crawl rules
                $script:XMLWriter.WriteStartElement("Crawl_Rules")
                try {
                    $script:SearchConfigCrawlRules.GetEnumerator() | ForEach-Object {
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        $crawlRuleName = ($_.key.Split('|'))[1]	
                        if ($ServiceAppID -eq $searchServiceAppID) { 
                            $crawlRule = $_.value				
                            $script:XMLWriter.WriteStartElement("Rule")
                            $script:XMLWriter.WriteAttributeString("Name", $crawlRuleName)
                            $script:XMLWriter.WriteRaw($crawlRule)
                            $script:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
                }
                $script:XMLWriter.WriteEndElement()	
			
                #Writing the Query Site Settings
                $script:XMLWriter.WriteStartElement("Query_and_Site_Settings")
                try {
                    $script:SearchConfigQuerySiteSettings.GetEnumerator() | ForEach-Object {
                        $queryComponent = ""
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        $queryComponentID = ($_.key.Split('|'))[1]	
                        if ($ServiceAppID -eq $searchServiceAppID) { 
                            $queryComponent = $_.value
                            $script:XMLWriter.WriteStartElement("Instance")
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
            elseif ($isProjectSvcApp -eq 1) {			        
                $script:XMLWriter.WriteStartElement("ProjectServer_General_Information")
                $script:XMLWriter.WriteRaw($prjApp)
                $script:XMLWriter.WriteEndElement()        
                $cnt = 0 
           
                #Writing Project Server Instance Information                   
                $script:XMLWriter.WriteStartElement("ProjectServer_Instances")
                $script:XMLWriter.WriteAttributeString("Type", "Project Server Instances")			
                try {                                        
                    $script:projectInstances.GetEnumerator() | ForEach-Object {
                        $prjAppID = ($_.key.Split('|'))[0]
                        $prjName = ($_.key.Split('|'))[1]						
                        $prjInst = $_.value				
                        $script:XMLWriter.WriteStartElement("ProjectServer_Instance")
                        $script:XMLWriter.WriteAttributeString("Number", $cnt)
                        $script:XMLWriter.WriteRaw($prjInst)
                        $script:XMLWriter.WriteEndElement()
                        $cnt++					
                    }                                  	                                          
                                
                         										
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
                }
                $script:XMLWriter.WriteEndElement()

                #Writing Project Server PCS Settings
                $script:XMLWriter.WriteStartElement("ProjectServer_PCSSettings")
                $script:XMLWriter.WriteAttributeString("Type", "Project PCS Settings")			
                try {    
                    $script:XMLWriter.WriteStartElement("General_Information")
                    $script:XMLWriter.WriteAttributeString("TimeOut", $script:projectPCSSettings.EditingSessionTimeout)
                    $script:XMLWriter.WriteAttributeString("WorkerCount", $script:projectPCSSettings.MaximumWorkersCount)
                    $script:XMLWriter.WriteAttributeString("RequestTimeLimits", $script:projectPCSSettings.RequestTimeLimits)
                    $script:XMLWriter.WriteAttributeString("MaximumProjectSize", $script:projectPCSSettings.MaximumProjectSize)                               
                    $script:XMLWriter.WriteEndElement()                             
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
                }
                $script:XMLWriter.WriteEndElement()
            
            }
            elseif ($isSearchSvcApp -eq 0 -and $isProjectSvcApp -eq 0) {
                $script:XMLWriter.WriteRaw($_.value)
            }
		
            $script:XMLWriter.WriteEndElement()
		
        }		
        $script:XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16writeServiceApps", $_)
    }
}