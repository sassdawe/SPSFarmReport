function o16enumSearchConfigQuerySiteSettings {
    [cmdletbinding()]
    param ()
    try {
        if ($script:searchsvcAppsCount -eq 0) { return }

        for ($tempCnt = 0; $tempCnt -lt $script:searchsvcAppsCount ; $tempCnt ++) {
            $querySiteSettingsId = Get-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance | Where-Object {$_.status -ne "Disabled"} | Select-Object Id | Format-Table -HideTableHeaders | Out-String -Width 1000
            $querySiteSettingsId = $querySiteSettingsId.Trim().Split("`n")
            for ($i = 0; $i -lt $querySiteSettingsId.Length ; $i++) {
                $searchServiceAppID = $searchServiceAppIds[$tempCnt]
                $tempXML = [xml] (Get-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance | Where-Object {$_.status -ne "Disabled"} | Where-Object {$_.Id -eq $querySiteSettingsId[$i] } | ConvertTo-Xml -NoTypeInformation)
                $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
                $searchServiceAppID = $searchServiceAppID + "|" + $querySiteSettingsId[$i]
                $script:SearchConfigQuerySiteSettings.Add($searchServiceAppID, $tempstr)
            }
        }
    }
    catch [System.Exception] {
        Write-Information " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16enumSearchConfigQuerySiteSettings", $_)
    }
}