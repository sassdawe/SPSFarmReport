function o16enumSearchConfigContentSources() {
    try {
        if ($global:searchsvcAppsCount -eq 0)
        { 		return 		}

        for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++) {
            $cmdstr = Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $searchServiceAppIds[$tempCnt] | Select Id | ft -HideTableHeaders | Out-String -Width 1000
            $cmdstr = $cmdstr.Trim().Split("`n")
			
            for ($i = 0; $i -lt $cmdstr.Length ; $i++) {
                $cmdstr2 = $cmdstr[$i].Trim() 
                $searchServiceAppID = $searchServiceAppIds[$tempCnt]
                $tempXML = [xml] (Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $searchServiceAppIds[$tempCnt] | select Name, Type, DeleteCount, ErrorCount, SuccessCount, WarningCount, StartAddresses, Id, CrawlStatus, CrawlStarted, CrawlCompleted, CrawlState | where {$_.Id -eq $cmdstr2 } | ConvertTo-Xml -NoTypeInformation)
                $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
                $searchServiceAppID = $searchServiceAppID + "|" + $cmdstr2				 
                $global:SearchConfigContentSources.Add($searchServiceAppID, $tempstr)
            }			
        }		
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchConfigContentSources", $_)
    }
}
