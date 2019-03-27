function o16enumHealthReport{
    [cmdletbinding()]
    param ()
    try {
        $site = Get-SPSite $global:adminURL
        $web = $site.RootWeb

        $list = $web.Lists["Review problems and solutions"]
        foreach ($item in $list.Items) {
            $id = $item["ID"]
            $tempstr = $item["Title"] + "||" + $item["Failing Servers"] + "||" + $item["Failing Services"] + "||" + $item["Modified"]
            switch ($item["Severity"]) {
                "0 - Rule Execution Failure"
                { $global:HealthReport0.Add($id, $tempstr) }
                "1 - Error"
                { $global:HealthReport1.Add($id, $tempstr) }
                "2 - Warning"
                { $global:HealthReport2.Add($id, $tempstr) }
                "3 - Information"
                { $global:HealthReport3.Add($id, $tempstr) }
                default { }
            }
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumHealthReport", $_)
        return 0
    }
}