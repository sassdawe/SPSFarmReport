function o16enumSearchConfigCrawlDatabases {
    [cmdletbinding()]
    param ()
    try {
        if ($global:searchsvcAppsCount -eq 0) { return }

        for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++) {
            $crawlDatabasesPerSearchApp = Get-SPEnterpriseSearchCrawlDatabase -SearchApplication $global:searchServiceAppIds[$tempCnt] | Select-Object Id | Format-Table -HideTableHeaders | Out-String -Width 1000
            $crawlDatabasesPerSearchApp = $crawlDatabasesPerSearchApp.Trim().Split("`n")
            for ($i = 0; $i -lt $crawlDatabasesPerSearchApp.Length ; $i++) {
                $searchServiceAppID = $searchServiceAppIds[$tempCnt]
                $tempXML = [xml] (Get-SPEnterpriseSearchCrawlDatabase -SearchApplication $global:searchServiceAppIds[$tempCnt] | Where-Object {$_.Id -eq $crawlDatabasesPerSearchApp[$i] } | ConvertTo-Xml -NoTypeInformation)
                $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
                $searchServiceAppID = $searchServiceAppID + "|" + $crawlDatabasesPerSearchApp[$i]
                $global:SearchConfigCrawlDatabases.Add($searchServiceAppID, $tempstr)
            }
        }
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumSearchConfigCrawlDatabases", $_)
    }
}