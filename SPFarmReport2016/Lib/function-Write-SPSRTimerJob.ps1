function Write-SPSRTimerJob {
    [Alias("o16writeTimerJobs")]
    [CmdletBinding()]
    param (
    )
    try {
        if ($script:timerJobs.Count -eq 0) {
            exit
        }

        $script:XMLWriter.WriteStartElement("Timer_Jobs")

        #Writing them
        $script:timerJobs.GetEnumerator() | ForEach-Object {

            $id = $_.value.Split("||")[0]
            $title = $_.value.Split("||")[2]
            $webapplication = $_.value.Split("||")[4]
            $schedule = $_.value.Split("||")[6]
            $lastruntime = $_.value.Split("||")[8]
            $isdisabled = $_.value.Split("||")[10]
            $locktype = $_.value.Split("||")[12]
            $null = $id
            $script:XMLWriter.WriteStartElement("Job")
            $script:XMLWriter.WriteAttributeString("Id", $_.key)
            $script:XMLWriter.WriteAttributeString("Title", $title.replace( '"', " ") )
            $script:XMLWriter.WriteAttributeString("WebApplication", $webapplication)
            $script:XMLWriter.WriteAttributeString("Schedule", $schedule)
            $script:XMLWriter.WriteAttributeString("LastRunTime", $lastruntime)
            $script:XMLWriter.WriteAttributeString("IsDisabled", $isdisabled)
            $script:XMLWriter.WriteAttributeString("LockType", $locktype)
            $script:XMLWriter.WriteEndElement()
        }

        $script:XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        #global:HandleException("o16writeSPServiceApplicationPools", $_)
    }
}
