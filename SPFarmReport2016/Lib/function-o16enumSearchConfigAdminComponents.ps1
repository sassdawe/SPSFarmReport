function o16enumSearchConfigAdminComponents{
    [cmdletbinding()]
    param ()
    try {
        if ($script:searchsvcAppsCount -eq 0) { return }
        for ($tempCnt = 0; $tempCnt -lt $script:searchsvcAppsCount ; $tempCnt ++) {
            $searchServiceAppID = $searchServiceAppIds[$tempCnt]
            $tempXML = [xml] (Get-SPEnterpriseSearchAdministrationComponent -SearchApplication $searchServiceAppID | ConvertTo-Xml -NoTypeInformation )
            $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
            $script:SearchConfigAdminComponents.Add($searchServiceAppID, $tempstr )
        }
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumSearchConfigAdminComponents", $_)
    }
}