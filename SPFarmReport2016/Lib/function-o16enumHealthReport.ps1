function o16enumHealthReport{
    [cmdletbinding()]
    param ()
    try {
        $site = Get-SPSite $script:adminURL
        $web = $site.RootWeb

        $list = $web.Lists["Review problems and solutions"]
        foreach ($item in $list.Items) {
            $id = $item["ID"]
            $tempstr = $item["Title"] + "||" + $item["Failing Servers"] + "||" + $item["Failing Services"] + "||" + $item["Modified"]
            switch ($item["Severity"]) {
                "0 - Rule Execution Failure"
                { $script:HealthReport0.Add($id, $tempstr) }
                "1 - Error"
                { $script:HealthReport1.Add($id, $tempstr) }
                "2 - Warning"
                { $script:HealthReport2.Add($id, $tempstr) }
                "3 - Information"
                { $script:HealthReport3.Add($id, $tempstr) }
                default { }
            }
        }
        return 1
    }
    catch [System.Exception] {
        Write-Information " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16enumHealthReport", $_)
        return 0
    }
}