
function o14enumSearchConfigCrawlComponents {
    [CmdletBinding()]
    param ()
    try {
        if ($script:searchsvcAppsCount -eq 0) {
            return
        }

        for ($tempCnt = 0; $tempCnt -lt $script:searchsvcAppsCount ; $tempCnt ++) {
            $crawlComponentsPerSearchApp = Get-SPEnterpriseSearchCrawlTopology -SearchApplication $script:searchServiceAppIds[$tempCnt] | Get-SPEnterpriseSearchCrawlComponent | Select Id | ft -HideTableHeaders | Out-String -Width 1000
            $crawlComponentsPerSearchApp = $crawlComponentsPerSearchApp.Trim().Split("`n")
            for ($i = 0; $i -lt $crawlComponentsPerSearchApp.Length ; $i++) {
                $searchServiceAppID = $searchServiceAppIds[$tempCnt]
                $tempXML = [xml] (Get-SPEnterpriseSearchCrawlTopology -SearchApplication $script:searchServiceAppIds[$tempCnt] | Get-SPEnterpriseSearchCrawlComponent | where {$_.Id -eq $crawlComponentsPerSearchApp[$i] } | ConvertTo-Xml -NoTypeInformation)
                $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
                $searchServiceAppID = $searchServiceAppID + "|" + $crawlComponentsPerSearchApp[$i]
                $script:SearchConfigCrawlComponents.Add($searchServiceAppID, $tempstr)
            }
        }
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14enumSearchConfigCrawlComponents", $_)
    }
}
