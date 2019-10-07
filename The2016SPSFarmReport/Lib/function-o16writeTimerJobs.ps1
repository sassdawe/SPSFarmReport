function o16writeTimerJobs() {
    try {
        if ($global:timerJobs.Count -eq 0)
        { exit }
				
        $global:XMLWriter.WriteStartElement("Timer_Jobs")

        #Writing them
        $global:timerJobs.GetEnumerator() | ForEach-Object {
		
            $id = $_.value.Split("||")[0]
            $title = $_.value.Split("||")[2]
            $webapplication = $_.value.Split("||")[4]
            $schedule = $_.value.Split("||")[6]
            $lastruntime = $_.value.Split("||")[8]
            $isdisabled = $_.value.Split("||")[10]
            $locktype = $_.value.Split("||")[12]
			
            $global:XMLWriter.WriteStartElement("Job")
            $global:XMLWriter.WriteAttributeString("Id", $_.key)
            $global:XMLWriter.WriteAttributeString("Title", $title.replace('"', " "))
            $global:XMLWriter.WriteAttributeString("WebApplication", $webapplication)
            $global:XMLWriter.WriteAttributeString("Schedule", $schedule)
            $global:XMLWriter.WriteAttributeString("LastRunTime", $lastruntime)
            $global:XMLWriter.WriteAttributeString("IsDisabled", $isdisabled)
            $global:XMLWriter.WriteAttributeString("LockType", $locktype)
            $global:XMLWriter.WriteEndElement()
        }
			
        $global:XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        #global:HandleException("o16writeSPServiceApplicationPools", $_)
    }
}
