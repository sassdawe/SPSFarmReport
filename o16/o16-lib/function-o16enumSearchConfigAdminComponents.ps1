function o16enumSearchConfigAdminComponents{
    [cmdletbinding()]
    param ()
    try {
        if ($global:searchsvcAppsCount -eq 0) { return }
        for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++) {
            $searchServiceAppID = $searchServiceAppIds[$tempCnt]
            $tempXML = [xml] (Get-SPEnterpriseSearchAdministrationComponent -SearchApplication $searchServiceAppID | ConvertTo-Xml -NoTypeInformation )
            $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
            $global:SearchConfigAdminComponents.Add($searchServiceAppID, $tempstr )
        }
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchConfigAdminComponents", $_)
    }
}