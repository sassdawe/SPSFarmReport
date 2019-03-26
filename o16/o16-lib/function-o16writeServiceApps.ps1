function o16writeServiceApps {
    try { 
        $xrs = New-Object -TypeName System.Xml.XmlReaderSettings
        $xrs.ConformanceLevel = [System.Xml.ConformanceLevel]::Fragment
		
        $global:XMLWriter.WriteStartElement("Service_Applications")		
        $global:ServiceApps.GetEnumerator() | ForEach-Object {
		
            $isSearchSvcApp = 0	
            $isProjectSvcApp = 0          
            $prjApp = $_.Value
            $ServiceAppID = ($_.key.Split('|'))[0]
            $typeName = ($_.key.Split('|'))[1]		
            if ($global:projectsvcApps.Id -eq $ServiceAppID) { $isProjectSvcApp = 1}  	
	
            ForEach ($searchAppId in $searchServiceAppIds) {
                if ($searchAppId -eq $ServiceAppID) { $isSearchSvcApp = 1 }
            }
		
            $global:XMLWriter.WriteStartElement("Service_Application")
            $global:XMLWriter.WriteAttributeString("Type", $typeName)
		
            if ($isSearchSvcApp -eq 1) {			
                $global:XMLWriter.WriteStartElement("General_Information")
                $global:XMLWriter.WriteRaw($_.value)
                $global:XMLWriter.WriteEndElement()
			
                #Writing the Search Service Status
                $global:XMLWriter.WriteStartElement("Enterprise_Search_Service_Status")
                try {
                    $global:XMLWriter.WriteStartElement("General_Information")
                    $global:XMLWriter.WriteRaw($global:enterpriseSearchServiceStatus)
                    $global:XMLWriter.WriteEndElement()
					
                    $global:XMLWriter.WriteStartElement("Job_Definitions")
                    $global:XMLWriter.WriteRaw($global:enterpriseSearchServiceJobDefs)
                    $global:XMLWriter.WriteEndElement()
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $global:_logpath -Append
                }
                $global:XMLWriter.WriteEndElement()	
			
                #Writing the Active Topology
                $global:XMLWriter.WriteStartElement("Active_Topology")
                try {
                    $global:SearchActiveTopologyComponents.GetEnumerator() | ForEach-Object {
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        if ($ServiceAppID -eq ($searchServiceAppID)) { 
                            $props = $_.value
                            $compName = ($_.key.Split('|'))[1]
                            $global:XMLWriter.WriteStartElement("Component")
                            $global:XMLWriter.WriteAttributeString("Name", $compName.Trim())
                            $global:XMLWriter.WriteRaw($props)
                            $global:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $global:_logpath -Append
                }
                $global:XMLWriter.WriteEndElement()		
			
                #Writing the Host Controllers
                $global:XMLWriter.WriteStartElement("Host_Controllers")
                try {
                    $global:SearchHostControllers.GetEnumerator() | ForEach-Object {
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        if ($ServiceAppID -eq ($searchServiceAppID)) { 
                            $props = $_.value
                            $serverName = ($_.key.Split('|'))[1]
                            $global:XMLWriter.WriteStartElement("Server")
                            $global:XMLWriter.WriteAttributeString("Name", $serverName.Trim())
                            $global:XMLWriter.WriteRaw($props)
                            $global:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $global:_logpath -Append
                }
                $global:XMLWriter.WriteEndElement()		
			
                #Writing the Admin Component
                $global:XMLWriter.WriteStartElement("Admin_Component")
                try {
                    $global:SearchConfigAdminComponents.GetEnumerator() | ForEach-Object {
                        if ($ServiceAppID -eq ($_.key)) { $adminComponent = $_.value}
                    }
                    $global:XMLWriter.WriteRaw($adminComponent)
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $global:_logpath -Append
                }
                $global:XMLWriter.WriteEndElement()			
			
                # Writing Link Stores
                $global:XMLWriter.WriteStartElement("Link_Stores")
                try {
                    $global:SearchConfigLinkStores.GetEnumerator() | ForEach-Object {
                        if ($ServiceAppID -eq ($_.key)) { $storeValue = $_.value}
                    }
                    $global:XMLWriter.WriteRaw($storeValue)
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $global:_logpath -Append
                }
                $global:XMLWriter.WriteEndElement()
			
                #Writing the Crawl Databases
                $global:XMLWriter.WriteStartElement("Crawl_Databases")
                try {
                    $global:SearchConfigCrawlDatabases.GetEnumerator() | ForEach-Object {
                        $crawlComponent = ""
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        $crawlDatabaseID = ($_.key.Split('|'))[1]	
                        if ($ServiceAppID -eq $searchServiceAppID) { 
                            $crawlComponent = $_.value				
                            $global:XMLWriter.WriteStartElement("Database")
                            $global:XMLWriter.WriteAttributeString("Id", $crawlDatabaseID)
                            $global:XMLWriter.WriteRaw($crawlComponent)
                            $global:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $global:_logpath -Append
                }
                $global:XMLWriter.WriteEndElement()			
			
                #Writing crawl rules
                $global:XMLWriter.WriteStartElement("Crawl_Rules")
                try {
                    $global:SearchConfigCrawlRules.GetEnumerator() | ForEach-Object {
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        $crawlRuleName = ($_.key.Split('|'))[1]	
                        if ($ServiceAppID -eq $searchServiceAppID) { 
                            $crawlRule = $_.value				
                            $global:XMLWriter.WriteStartElement("Rule")
                            $global:XMLWriter.WriteAttributeString("Name", $crawlRuleName)
                            $global:XMLWriter.WriteRaw($crawlRule)
                            $global:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $global:_logpath -Append
                }
                $global:XMLWriter.WriteEndElement()	
			
                #Writing the Query Site Settings
                $global:XMLWriter.WriteStartElement("Query_and_Site_Settings")
                try {
                    $global:SearchConfigQuerySiteSettings.GetEnumerator() | ForEach-Object {
                        $queryComponent = ""
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        $queryComponentID = ($_.key.Split('|'))[1]	
                        if ($ServiceAppID -eq $searchServiceAppID) { 
                            $queryComponent = $_.value
                            $global:XMLWriter.WriteStartElement("Instance")
                            $global:XMLWriter.WriteAttributeString("Id", $queryComponentID)
                            $global:XMLWriter.WriteRaw($queryComponent)
                            $global:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $global:_logpath -Append
                }
                $global:XMLWriter.WriteEndElement()
			
                #Writing the Content Sources
                $global:XMLWriter.WriteStartElement("Content_Sources")
                try {
                    $global:SearchConfigContentSources.GetEnumerator() | ForEach-Object {
                        $contentSource = ""
                        $searchServiceAppID = ($_.key.Split('|'))[0]
                        $contentSourceID = ($_.key.Split('|'))[1]	
                        if ($ServiceAppID -eq $searchServiceAppID) { 
                            $contentSource = $_.value
                            $global:XMLWriter.WriteStartElement("Content_Source")
                            $global:XMLWriter.WriteAttributeString("Id", $contentSourceID)
                            $global:XMLWriter.WriteRaw($contentSource)
                            $global:XMLWriter.WriteEndElement()
                        }
                    }
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $global:_logpath -Append
                }
                $global:XMLWriter.WriteEndElement()			
            }		
            elseif ($isProjectSvcApp -eq 1) {			        
                $global:XMLWriter.WriteStartElement("ProjectServer_General_Information")
                $global:XMLWriter.WriteRaw($prjApp)
                $global:XMLWriter.WriteEndElement()        
                $cnt = 0 
           
                #Writing Project Server Instance Information                   
                $global:XMLWriter.WriteStartElement("ProjectServer_Instances")
                $global:XMLWriter.WriteAttributeString("Type", "Project Server Instances")			
                try {                                        
                    $global:projectInstances.GetEnumerator() | ForEach-Object {
                        $prjAppID = ($_.key.Split('|'))[0]
                        $prjName = ($_.key.Split('|'))[1]						
                        $prjInst = $_.value				
                        $global:XMLWriter.WriteStartElement("ProjectServer_Instance")
                        $global:XMLWriter.WriteAttributeString("Number", $cnt)
                        $global:XMLWriter.WriteRaw($prjInst)
                        $global:XMLWriter.WriteEndElement()
                        $cnt++					
                    }                                  	                                          
                                
                         										
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $global:_logpath -Append
                }
                $global:XMLWriter.WriteEndElement()

                #Writing Project Server PCS Settings
                $global:XMLWriter.WriteStartElement("ProjectServer_PCSSettings")
                $global:XMLWriter.WriteAttributeString("Type", "Project PCS Settings")			
                try {    
                    $global:XMLWriter.WriteStartElement("General_Information")
                    $global:XMLWriter.WriteAttributeString("TimeOut", $global:projectPCSSettings.EditingSessionTimeout)
                    $global:XMLWriter.WriteAttributeString("WorkerCount", $global:projectPCSSettings.MaximumWorkersCount)
                    $global:XMLWriter.WriteAttributeString("RequestTimeLimits", $global:projectPCSSettings.RequestTimeLimits)
                    $global:XMLWriter.WriteAttributeString("MaximumProjectSize", $global:projectPCSSettings.MaximumProjectSize)                               
                    $global:XMLWriter.WriteEndElement()                             
                }
                catch [System.Exception] {
                    Write-Host " ******** Exception caught. Check the log file for more details. ******** "
                    Write-Output $_ | Out-File -FilePath $global:_logpath -Append
                }
                $global:XMLWriter.WriteEndElement()
            
            }
            elseif ($isSearchSvcApp -eq 0 -and $isProjectSvcApp -eq 0) {
                $global:XMLWriter.WriteRaw($_.value)
            }
		
            $global:XMLWriter.WriteEndElement()
		
        }		
        $global:XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeServiceApps", $_)
    }
}