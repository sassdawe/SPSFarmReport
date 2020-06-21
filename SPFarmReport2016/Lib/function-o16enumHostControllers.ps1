function o16enumHostControllers{
    [cmdletbinding()]
    param ()
    try {
        if ($global:searchsvcAppsCount -eq 0) { return }

        for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++) {
            $cmdstr = Get-SPEnterpriseSearchHostController | Select Server | ft -HideTableHeaders | Out-String -Width 1000
            $cmdstr = $cmdstr.Trim().Split("`n")

            for ($i = 0; $i -lt $cmdstr.Length ; $i++) {
                $cmdstr2 = $cmdstr[$i].Trim() 
                $searchServiceAppID = $searchServiceAppIds[$tempCnt]
                $tempXML = [xml] ( Get-SPEnterpriseSearchHostController | where {$_.Server -match $cmdstr2 } | ConvertTo-Xml -NoTypeInformation)
                $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
                $searchServiceAppID = $searchServiceAppID + "|" + $cmdstr2
                $global:SearchHostControllers.Add($searchServiceAppID, $tempstr)
            }
        }
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumHostControllers", $_)
        return 0
    }
}