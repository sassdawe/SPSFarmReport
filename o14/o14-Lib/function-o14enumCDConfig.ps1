function o14enumCDConfig {
    [CmdletBinding()]
    [OutputType('System.Int32')]
    param ()
    try {
        $CDInstance = [Microsoft.SharePoint.Publishing.Administration.ContentDeploymentConfiguration]::GetInstance()
        #Obtaining General Information about the CDInstance
        $script:CDGI = [xml] ($CDInstance | ConvertTo-Xml)

        #Obtaining information about deployment paths
        $script:Paths = [Microsoft.SharePoint.Publishing.Administration.ContentDeploymentPath]::GetAllPaths()
        foreach ($CDPath in $script:Paths) {
            $PathName = $CDPath.Name | Out-String
            $script:XMLToParse = [xml] ($CDPath | ConvertTo-Xml)
            $PathGI = [System.String]$script:XMLToParse.Objects.Object.InnerXml
            $PathId = $CDPath.Id | Format-List | Out-String
            $PathId = ($PathId.Split(':'))[1]
            $PathId = $PathId.Trim()
            $tempstr = $PathId + "|" + $PathName
            $script:CDPaths.Add($tempstr, $PathGI)

            foreach ($Job in $CDPath.Jobs) {
                $JobId = $Job.Id | Out-String
                $JobName = $Job.Name | Out-String
                $XMLToParse2 = [xml] ($Job | ConvertTo-Xml)
                $tempstr2 = $PathId + "|" + $JobId + "|" + $JobName
                $tempstr3 = [System.String]$XMLToParse2.Objects.Object.InnerXml
                $script:CDJobs.Add($tempstr2, $tempstr3)
            }
        }
        return 1
    }
    catch [System.Exception] {
        #Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14enumCDConfig", $_)
        return 0
    }
}