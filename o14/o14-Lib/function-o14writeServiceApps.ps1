
function o14writeServiceApps
{
	try
	{ 
		$xrs = New-Object -TypeName System.Xml.XmlReaderSettings
		$xrs.ConformanceLevel = [System.Xml.ConformanceLevel]::Fragment
		
		$global:XMLWriter.WriteStartElement("Service_Applications")		
		$global:ServiceApps.GetEnumerator() | ForEach-Object {
		
		$isSearchSvcApp = 0	
		$ServiceAppID = ($_.key.Split('|'))[0]
		$typeName = ($_.key.Split('|'))[1]		
	
		ForEach($searchAppId in $searchServiceAppIds)
		{
			if($searchAppId -eq $ServiceAppID) { $isSearchSvcApp = 1 }
		}
		
		$global:XMLWriter.WriteStartElement("Service_Application")
		$global:XMLWriter.WriteAttributeString("Type", $typeName)
		
		if($isSearchSvcApp -eq 1)		
		{			
			$global:XMLWriter.WriteStartElement("General_Information")
			$global:XMLWriter.WriteRaw($_.value)
			$global:XMLWriter.WriteEndElement()
			
			#Writing the Admin Component
			$global:XMLWriter.WriteStartElement("Admin_Component")
			try
			{
				$global:SearchConfigAdminComponents.GetEnumerator() | ForEach-Object {
				if($ServiceAppID -eq ($_.key)) { $adminComponent = $_.value}
				}
				$global:XMLWriter.WriteRaw($adminComponent)
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()			
			
			#Writing the Crawl Components
			$global:XMLWriter.WriteStartElement("Crawl_Components")
			try
			{
				$global:SearchConfigCrawlComponents.GetEnumerator() | ForEach-Object {
					$crawlComponent = ""
					$searchServiceAppID = ($_.key.Split('|'))[0]
					$crawlComponentID = ($_.key.Split('|'))[1]	
					if($ServiceAppID -eq $searchServiceAppID) 
					{ 
						$crawlComponent = $_.value				
						$global:XMLWriter.WriteStartElement("Crawl_Component")
						$global:XMLWriter.WriteAttributeString("Id", $crawlComponentID)
						$global:XMLWriter.WriteRaw($crawlComponent)
						$global:XMLWriter.WriteEndElement()
					}
				}
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()			
			
			#Writing the Query Components
			$global:XMLWriter.WriteStartElement("Query_Components")
			try
			{
				$global:SearchConfigQueryComponents.GetEnumerator() | ForEach-Object {
					$queryComponent = ""
					$searchServiceAppID = ($_.key.Split('|'))[0]
					$queryComponentID = ($_.key.Split('|'))[1]	
					if($ServiceAppID -eq $searchServiceAppID) 
					{ 
						$queryComponent = $_.value
						$global:XMLWriter.WriteStartElement("Query_Component")
						$global:XMLWriter.WriteAttributeString("Id", $queryComponentID)
						$global:XMLWriter.WriteRaw($queryComponent)
						$global:XMLWriter.WriteEndElement()
					}
				}
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()
			
			#Writing the Content Sources
			$global:XMLWriter.WriteStartElement("Content_Sources")
			try
			{
				$global:SearchConfigContentSources.GetEnumerator() | ForEach-Object {
					$contentSource = ""
					$searchServiceAppID = ($_.key.Split('|'))[0]
					$contentSourceID = ($_.key.Split('|'))[1]	
					if($ServiceAppID -eq $searchServiceAppID) 
					{ 
						$contentSource = $_.value
						$global:XMLWriter.WriteStartElement("Content_Source")
						$global:XMLWriter.WriteAttributeString("Id", $contentSourceID)
						$global:XMLWriter.WriteRaw($contentSource)
						$global:XMLWriter.WriteEndElement()
					}
				}
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()			
		}		
		elseif($isSearchSvcApp -eq 0)
		{
			$global:XMLWriter.WriteRaw($_.value)
		}
		
		$global:XMLWriter.WriteEndElement()
		
		}		
		$global:XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14writeServiceApps", $_)
    }
}

