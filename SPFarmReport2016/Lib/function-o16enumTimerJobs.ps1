function o16enumTimerJobs() {
    try {
        $jobs = Get-SPTimerJob | Select-Object Id, Title, Server, WebApplication, Schedule, LastRunTime, IsDisabled, LockType 
        $script:timerJobCount = $jobs.Length

        ForEach ($Job in $jobs) {
            $timerJobId = ($Job | Select-Object Id | Format-Table -HideTableHeaders | Out-String).Trim()
            $title = ($Job | Select-Object Title | Format-Table -HideTableHeaders | Out-String).Trim()
            $server = ($Job | Select-Object Server | Format-Table -HideTableHeaders | Out-String).Trim()
            $webapplication = ($Job | Select-Object WebApplication | Format-Table -HideTableHeaders | Out-String).Trim()
            $schedule = ($Job | Select-Object Schedule | Format-Table -HideTableHeaders | Out-String).Trim()
            $lastruntime = ($Job | Select-Object LastRunTime | Format-Table -HideTableHeaders | Out-String).Trim()
            $isdisabled = ($Job | Select-Object IsDisabled | Format-Table -HideTableHeaders | Out-String).Trim()
            $locktype = ($Job | Select-Object LockType | Format-Table -HideTableHeaders | Out-String).Trim()

            $tempstr2 = $timerJobId + "||" + $title + "||" + $webapplication + "||" + $schedule + "||" + $lastruntime + "||" + $isdisabled + "||" + $locktype
            $script:timerJobs.Add($timerJobId, $tempstr2)
        }
        return 1
    }
    catch [System.Exception] {
        Write-Information " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16enumTimerJobs", $_)
        return 0
    }
}