function o16enumSearchConfigContentSources {
    [cmdletbinding()]
    param ()
    try {
        if ($script:searchsvcAppsCount -eq 0) { return }

        for ($tempCnt = 0; $tempCnt -lt $script:searchsvcAppsCount ; $tempCnt ++) {
            $cmdstr = Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $searchServiceAppIds[$tempCnt] | Select-Object Id | ft -HideTableHeaders | Out-String -Width 1000
            $cmdstr = $cmdstr.Trim().Split("`n")

            for ($i = 0; $i -lt $cmdstr.Length ; $i++) {
                $cmdstr2 = $cmdstr[$i].Trim()
                $searchServiceAppID = $searchServiceAppIds[$tempCnt]
                $tempXML = [xml] (Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $searchServiceAppIds[$tempCnt] | Select-Object Name, Type, DeleteCount, ErrorCount, SuccessCount, WarningCount, StartAddresses, Id, CrawlStatus, CrawlStarted, CrawlCompleted, CrawlState | Where-Object {$_.Id -eq $cmdstr2 } | ConvertTo-Xml -NoTypeInformation)
                $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
                $searchServiceAppID = $searchServiceAppID + "|" + $cmdstr2
                $script:SearchConfigContentSources.Add($searchServiceAppID, $tempstr)
            }
        }
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16enumSearchConfigContentSources", $_)
    }
}
