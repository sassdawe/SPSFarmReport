function o16enumCDConfig {
    [cmdletbinding()]
    param ()
    try {
        $CDInstance = [Microsoft.SharePoint.Publishing.Administration.ContentDeploymentConfiguration]::GetInstance()
        #Obtaining General Information about the CDInstance
        $global:CDGI = [xml] ($CDInstance | ConvertTo-Xml)

        #Obtaining information about deployment paths
        $global:Paths = [Microsoft.SharePoint.Publishing.Administration.ContentDeploymentPath]::GetAllPaths()
        foreach ($CDPath in $global:Paths) {
            $PathName = $CDPath.Name | Out-String
            $global:XMLToParse = [xml] ($CDPath | ConvertTo-Xml)
            $PathGI = [System.String]$global:XMLToParse.Objects.Object.InnerXml
            $PathId = $CDPath.Id | Format-List | Out-String
            $PathId = ($PathId.Split(':'))[1]
            $PathId = $PathId.Trim()
            $tempstr = $PathId + "|" + $PathName
            $global:CDPaths.Add($tempstr, $PathGI)

            foreach ($Job in $CDPath.Jobs) {
                $JobId = $Job.Id | Out-String
                $JobName = $Job.Name | Out-String
                $XMLToParse2 = [xml] ($Job | ConvertTo-Xml)
                $tempstr2 = $PathId + "|" + $JobId + "|" + $JobName
                $tempstr3 = [System.String]$XMLToParse2.Objects.Object.InnerXml
                $global:CDJobs.Add($tempstr2, $tempstr3)
            }
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15CDConfig", $_)
        return 0
    }
}