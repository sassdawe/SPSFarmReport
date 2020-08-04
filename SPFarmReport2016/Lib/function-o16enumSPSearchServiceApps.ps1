function o16enumSPSearchServiceApps {
    [cmdletbinding()]
    param ()
    try {
        $searchsvcApps = Get-SPServiceApplication | Where-Object {$_.typename -eq "Search Service Application"} | Select-Object Id | Format-List | Out-String -Width 1000
        $script:searchsvcAppsCount = 0
        $delimitLines = $searchsvcApps.Trim().Split("`n")
        ForEach ($Liner in $delimitLines) {
            if ($liner.Trim().Length -eq 0) { continue }
            $script:searchsvcAppsCount++
        }
        $script:searchServiceAppIds = new-object 'System.String[]' $script:searchsvcAppsCount
        $x = $script:searchsvcAppsCount - 1
        ForEach ($Liner in $delimitLines) {
            $Liner = $Liner.Trim()
            if ($Liner.Length -eq 0)
            { continue }
            if ($Liner.Contains("Id")) {
                $tempstr = $Liner -split " : "
                $script:searchServiceAppIds[$x] = $tempstr[1]
                $x--
                if ($x -lt 0)
                { break }
            }
        }
        return 1 | Out-Null
    }
    catch [System.Exception] {
        Write-Information " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16enumSPSearchServiceApps", $_)
        return 0
    }
}