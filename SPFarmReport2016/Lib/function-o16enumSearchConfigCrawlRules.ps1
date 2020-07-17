function o16enumSearchConfigCrawlRules {
    [cmdletbinding()]
    param ()
    try {
        if ($script:searchsvcAppsCount -eq 0) { return }

        for ($tempCnt = 0; $tempCnt -lt $script:searchsvcAppsCount ; $tempCnt ++) {
            $CrawlRuleNames = Get-SPEnterpriseSearchCrawlRule -SearchApplication $script:searchServiceAppIds[$tempCnt] | Select-Object AccountName | Format-Table -HideTableHeaders | Out-String -Width 1000
            $CrawlRuleNames = $CrawlRuleNames.Trim().Split("`n")
            for ($i = 0; $i -lt $CrawlRuleNames.Length ; $i++) {
                $searchServiceAppID = $searchServiceAppIds[$tempCnt]
                $tempXML = [xml] (Get-SPEnterpriseSearchCrawlRule -SearchApplication $script:searchServiceAppIds[$tempCnt] | Where-Object {$_.AccountName -eq $CrawlRuleNames[$i]}| ConvertTo-Xml -NoTypeInformation)
                $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
                $searchServiceAppID = $searchServiceAppID + "|" + $CrawlRuleNames[$i]
                $script:SearchConfigCrawlRules.Add($searchServiceAppID, $tempstr)
            }
        }
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumSearchConfigCrawlRules", $_)
    }
}