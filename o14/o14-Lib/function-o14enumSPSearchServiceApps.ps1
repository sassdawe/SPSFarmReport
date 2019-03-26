function o14enumSPSearchServiceApps {
    [CmdletBinding()]
    param ()
    try {
        $searchsvcApps = Get-SPServiceApplication | where {$_.typename -eq "Search Service Application"} | where {$_.searchapplicationtype -eq "Regular"} | select Id | fl | Out-String -Width 1000
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
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14enumSPSearchServiceApps", $_)
        return 0
    }
}
