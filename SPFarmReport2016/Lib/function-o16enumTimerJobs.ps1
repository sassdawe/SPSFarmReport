function o16enumTimerJobs() {
    try {
        $jobs = Get-SPTimerJob | Select Id, Title, Server, WebApplication, Schedule, LastRunTime, IsDisabled, LockType 
        $script:timerJobCount = $jobs.Length
            
        ForEach ($Job in $jobs) {
            $timerJobId = ($Job | Select Id | ft -HideTableHeaders | Out-String).Trim()
            $title = ($Job | Select Title | ft -HideTableHeaders | Out-String).Trim()
            $server = ($Job | Select Server | ft -HideTableHeaders | Out-String).Trim()
            $webapplication = ($Job | Select WebApplication | ft -HideTableHeaders | Out-String).Trim()
            $schedule = ($Job | Select Schedule | ft -HideTableHeaders | Out-String).Trim()
            $lastruntime = ($Job | Select LastRunTime | ft -HideTableHeaders | Out-String).Trim()
            $isdisabled = ($Job | Select IsDisabled | ft -HideTableHeaders | Out-String).Trim()
            $locktype = ($Job | Select LockType | ft -HideTableHeaders | Out-String).Trim()
                  
            $tempstr2 = $timerJobId + "||" + $title + "||" + $webapplication + "||" + $schedule + "||" + $lastruntime + "||" + $isdisabled + "||" + $locktype
            $script:timerJobs.Add($timerJobId, $tempstr2)
        }           
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16enumTimerJobs", $_)
        return 0
    }
}