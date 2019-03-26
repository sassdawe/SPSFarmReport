function o16enumSearchConfigLinkStores() {
    try {
        if ($global:searchsvcAppsCount -eq 0)
        { 		return 		}
        for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++) {
            $searchServiceAppID = $searchServiceAppIds[$tempCnt]			
            $ssa = Get-SPEnterpriseSearchServiceApplication -Identity $searchServiceAppID
            $tempXML = [xml] ($ssa.LinksStores | ConvertTo-Xml -NoTypeInformation )
            $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
            $global:SearchConfigLinkStores.Add($searchServiceAppID, $tempstr )
        }		
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchConfigLinkStores", $_)
    }
}