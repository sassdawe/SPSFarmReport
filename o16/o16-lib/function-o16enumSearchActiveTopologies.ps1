function o16enumSearchActiveTopologies() {
    try {
        if ($global:searchsvcAppsCount -eq 0)
        { 		return 		}
		
        for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++) {
            $esa = Get-SPEnterpriseSearchServiceApplication -Identity $global:searchServiceAppIds[$tempCnt]			
            $searchServiceAppID = $searchServiceAppIds[$tempCnt]
            $searchSatus = Get-SPEnterpriseSearchStatus -SearchApplication $searchServiceAppID -ErrorAction SilentlyContinue			
            $ATComponentNames = $esa.ActiveTopology.GetComponents() | Select Name | ft -HideTableHeaders | Out-String -Width 1000
            $ATComponentNames = $ATComponentNames.Trim().Split("`n")			
            for ($i = 0; $i -lt $ATComponentNames.Length ; $i++) {
                $tempXML = [xml] ($esa.ActiveTopology.GetComponents() | where {$_.Name -eq $ATComponentNames[$i].Trim() } | ConvertTo-Xml -NoTypeInformation)
                if ($searchSatus -ne $null) {
                    $tempXML2 = [xml] (Get-SPEnterpriseSearchStatus -SearchApplication $searchServiceAppID | ? {$_.Name -eq $ATComponentNames[$i].Trim()} | select State | ConvertTo-Xml -NoTypeInformation)
                    $tempXML3 = [xml] (Get-SPEnterpriseSearchStatus -SearchApplication $searchServiceAppID | ? {$_.Name -eq $ATComponentNames[$i].Trim()} | select Details | ConvertTo-Xml -NoTypeInformation)
                }
				
                $tempstr = [System.String] $tempXML.Objects.Object.InnerXML
                $tempstr2 = [System.String] $tempXML2.Objects.Object.InnerXML
                $tempstr3 = [System.String] $tempXML3.Objects.Object.InnerXML
                $tempstr4 = $searchServiceAppID + "|" + $ATComponentNames[$i]	
                $tempstr = $tempstr + $tempstr2 + $tempstr3
                $global:SearchActiveTopologyComponents.Add($tempstr4, $tempstr)
            }
        }		
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchActiveTopologies", $_)
    }
}
