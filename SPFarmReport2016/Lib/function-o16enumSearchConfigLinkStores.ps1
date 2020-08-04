function o16enumSearchConfigLinkStores {
    [cmdletbinding()]
    param ()
    try {
        if ($script:searchsvcAppsCount -eq 0) { return }
        for ($tempCnt = 0; $tempCnt -lt $script:searchsvcAppsCount ; $tempCnt ++) {
            $searchServiceAppID = $searchServiceAppIds[$tempCnt]
            $ssa = Get-SPEnterpriseSearchServiceApplication -Identity $searchServiceAppID
            $tempXML = [xml] ($ssa.LinksStores | ConvertTo-Xml -NoTypeInformation )
            $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
            $script:SearchConfigLinkStores.Add($searchServiceAppID, $tempstr )
        }
    }
    catch [System.Exception] {
        Write-Information " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16enumSearchConfigLinkStores", $_)
    }
}