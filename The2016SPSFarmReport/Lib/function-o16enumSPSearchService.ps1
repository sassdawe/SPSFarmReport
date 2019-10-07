function o16enumSPSearchService {
    [cmdletbinding()]
    param ()
    try {
        $searchsvc = Get-SPEnterpriseSearchService
        $_ato = ($searchsvc.AcknowledgementTimeout).ToString()
        $_cto = ($searchsvc.ConnectionTimeout).ToString()
        $_wproxy = ($searchsvc.WebProxy).ToString()
        $_ucpf = ($searchsvc.UseCrawlProxyForFederation).ToString()
        $_pl = ($searchsvc.PerformanceLevel).ToString()
        $_pi = ($searchsvc.ProcessIdentity).ToString()

        foreach ($jd in $searchsvc.JobDefinitions) {
            #$jdx = ($jd | Select-Object NAme, Schedule, LastRunTime, Server | ConvertTo-Xml -NoTypeInformation)
            $jd_Name = $jd | Select-Object Name | Format-Table -HideTableHeaders | Out-String
            $jd_Schedule = $jd | Select-Object Schedule | Format-Table -HideTableHeaders | Out-String
            $jd_LastRunTime = $jd | Select-Object LastRunTime | Format-Table -HideTableHeaders | Out-String
            $jd_Server = $jd | Select-Object Server | Format-Table -HideTableHeaders | Out-String
            $jd_Name = $jd_Name.Trim()
            $jd_Schedule = $jd_Schedule.Trim()
            $jd_LastRunTime = $jd_LastRunTime.Trim()
            $jd_Server = $jd_Server.Trim()
            $ejob = $ejob + "<job Name=`"" + $jd_Name + "`" Schedule=`"" + $jd_Schedule + "`" LastRunTime=`"" + $jd_LastRunTime + "`" Server=`"" + $jd_Server + "`" />"
        }
        $tempXML = "<Property Name = `"AcknowledgementTimeout`">" + $_ato + "</Property>" + "<Property Name =`"ConnectionTimeout`">" + $_cto + "</Property>" + "<Property Name =`"WebProxy`">" + $_wproxy + "</Property>" + "<Property Name =`"UseCrawlProxyForFederation`">" + $_ucpf + "</Property>" + "<Property Name =`"PerformanceLevel`">" + $_pl + "</Property>" + "<Property Name =`"ProcessIdentity`">" + $_pi + "</Property>"

        $global:enterpriseSearchServiceStatus = $tempXML
        $global:enterpriseSearchServiceJobDefs = $ejob
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSPSearchServiceApps", $_)
        return 0
    }
}