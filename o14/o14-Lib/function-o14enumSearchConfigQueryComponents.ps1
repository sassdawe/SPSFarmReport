
function o14enumSearchConfigQueryComponents {
    [CmdletBinding()]
    param ()
    try {
        if ($script:searchsvcAppsCount -eq 0) {
            return
        }

        for ($tempCnt = 0; $tempCnt -lt $script:searchsvcAppsCount ; $tempCnt ++) {
            $queryComponentsPerSearchApp = Get-SPEnterpriseSearchQueryTopology -SearchApplication $script:searchServiceAppIds[$tempCnt] | Get-SPEnterpriseSearchQueryComponent | Select Id | ft -HideTableHeaders | Out-String -Width 1000
            $queryComponentsPerSearchApp = $queryComponentsPerSearchApp.Trim().Split("`n")
            for ($i = 0; $i -lt $queryComponentsPerSearchApp.Length ; $i++) {
                $searchServiceAppID = $searchServiceAppIds[$tempCnt]
                $tempXML = [xml] (Get-SPEnterpriseSearchQueryTopology -SearchApplication $script:searchServiceAppIds[$tempCnt] | Get-SPEnterpriseSearchQueryComponent | where {$_.Id -eq $queryComponentsPerSearchApp[$i] } | ConvertTo-Xml -NoTypeInformation)
                $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
                $searchServiceAppID = $searchServiceAppID + "|" + $queryComponentsPerSearchApp[$i]
                $script:SearchConfigQueryComponents.Add($searchServiceAppID, $tempstr)
            }
        }
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14enumSearchConfigQueryComponents", $_)
    }
}
