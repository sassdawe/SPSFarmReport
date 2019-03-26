function o16enumFeatures() {
    try {
        $bindingFlags = [System.Reflection.BindingFlags] “NonPublic,Instance”
        [Microsoft.SharePoint.Administration.SPFarm] $mySPFarm = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm
        $global:FeatureCount = 0
        $FeatureCount2 = 0
        #PropertyInfo pi;

        #to retrieve the number of features deployed in farm
        foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions) {
            if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Farm")) {
                $global:FeatureCount++
            }
        }
        $global:FarmFeatures = new-object 'System.String[,]' $global:FeatureCount, 4;

        #to retrieve the properties
        foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions) {
            if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Farm")) {
                if ($global:_farmFeatureDefinitions.ContainsKey($FeatureDefinition.DisplayName))
                { $global:FarmFeatures[$FeatureCount2, 1] = $global:_farmFeatureDefinitions.Get_Item($FeatureDefinition.DisplayName)	}
                else {	$FarmFeatures[$FeatureCount2, 1] = $FeatureDefinition.DisplayName }
					
                $FarmFeatures[$FeatureCount2, 0] = $FeatureDefinition.Id.ToString()
                $FarmFeatures[$FeatureCount2, 2] = $FeatureDefinition.SolutionId.ToString()
                $pi = $FeatureDefinition.GetType().GetProperty("HasActivations", $bindingFlags)
                $FarmFeatures[$FeatureCount2, 3] = $pi.GetValue($FeatureDefinition, $null).ToString()				
                $FeatureCount2++
            }
        }

        $global:sFeatureCount = 0
        $FeatureCount2 = 0
        foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions) {
            if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Site")) {
                $global:sFeatureCount++
            }
        }
        $global:SiteFeatures = new-object 'System.String[,]' $global:sFeatureCount, 4
        foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions) {
            if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Site")) {
                $global:SiteFeatures[$FeatureCount2, 0] = $FeatureDefinition.Id.ToString()
                $SiteFeatures[$FeatureCount2, 1] = $FeatureDefinition.DisplayName
                $SiteFeatures[$FeatureCount2, 2] = $FeatureDefinition.SolutionId.ToString()
                $pi = $FeatureDefinition.GetType().GetProperty("HasActivations", $bindingFlags)
                $SiteFeatures[$FeatureCount2, 3] = $pi.GetValue($FeatureDefinition, $null).ToString()
                $FeatureCount2++
            }
        }

        $global:wFeatureCount = 0
        $FeatureCount2 = 0
        foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions) {
            if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Web")) {
                $global:wFeatureCount++
            }
        }
        $global:WebFeatures = new-object 'System.String[,]' $global:wFeatureCount, 4
        foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions) {
            if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Web")) {
                $WebFeatures[$FeatureCount2, 0] = $FeatureDefinition.Id.ToString()
                $WebFeatures[$FeatureCount2, 1] = $FeatureDefinition.DisplayName
                $WebFeatures[$FeatureCount2, 2] = $FeatureDefinition.SolutionId.ToString()
                $pi = $FeatureDefinition.GetType().GetProperty("HasActivations", $bindingFlags)
                $WebFeatures[$FeatureCount2, 3] = $pi.GetValue($FeatureDefinition, $null).ToString()
                $FeatureCount2++;
            }
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumFeatures", $_)
        return 0
    }
}