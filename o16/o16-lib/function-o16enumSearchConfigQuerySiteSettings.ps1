function o16enumSearchConfigQuerySiteSettings() {
    try {
        if ($global:searchsvcAppsCount -eq 0)
        { 		return 		}
		
        for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++) {
            $querySiteSettingsId = Get-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance | ? {$_.status -ne "Disabled"} | Select Id | ft -HideTableHeaders | Out-String -Width 1000
            $querySiteSettingsId = $querySiteSettingsId.Trim().Split("`n")
            for ($i = 0; $i -lt $querySiteSettingsId.Length ; $i++) {
                $searchServiceAppID = $searchServiceAppIds[$tempCnt]
                $tempXML = [xml] (Get-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance | ? {$_.status -ne "Disabled"} | where {$_.Id -eq $querySiteSettingsId[$i] } | ConvertTo-Xml -NoTypeInformation)
                $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
                $searchServiceAppID = $searchServiceAppID + "|" + $querySiteSettingsId[$i]				 
                $global:SearchConfigQuerySiteSettings.Add($searchServiceAppID, $tempstr)
            }
        }		
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchConfigQuerySiteSettings", $_)
    }
}