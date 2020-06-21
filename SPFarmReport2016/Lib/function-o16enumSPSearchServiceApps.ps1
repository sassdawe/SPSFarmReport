function o16enumSPSearchServiceApps {
    [cmdletbinding()]
    param ()
    try {
        $searchsvcApps = Get-SPServiceApplication | Where-Object {$_.typename -eq "Search Service Application"} | Select-Object Id | Format-List | Out-String -Width 1000
        $global:searchsvcAppsCount = 0
        $delimitLines = $searchsvcApps.Trim().Split("`n")
        ForEach ($Liner in $delimitLines) {
            if ($liner.Trim().Length -eq 0) { continue }
            $global:searchsvcAppsCount++
        }
        $global:searchServiceAppIds = new-object 'System.String[]' $global:searchsvcAppsCount
        $x = $global:searchsvcAppsCount - 1
        ForEach ($Liner in $delimitLines) {
            $Liner = $Liner.Trim()
            if ($Liner.Length -eq 0)
            { continue }
            if ($Liner.Contains("Id")) {
                $tempstr = $Liner -split " : "
                $global:searchServiceAppIds[$x] = $tempstr[1]
                $x--
                if ($x -lt 0)
                { break }
            }
        }
        return 1 | Out-Null
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumSPSearchServiceApps", $_)
        return 0
    }
}