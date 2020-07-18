function o16enumProjectServiceApps{
    [cmdletbinding()]
    param ()
    try {
        $script:projectsvcApps = Get-SPServiceApplication | Where-Object {$_.typename -eq "Project Application Services"}
        $instcount = (Get-SPProjectWebInstance).Length
        $prjInst = Get-SPProjectWebInstance | Select-Object Id | Out-String -Width 1000
        $delimitLines = $prjInst.Split("`n")
        $script:projectPCSSettings = Get-SPProjectPCSSettings
        $script:projectQueueSettings = Get-SPProjectQueueSettings
        ForEach ($instID in $delimitLines) {
            $instID = $instID.Trim()
            if (($instID -eq "") -or ($instID -eq "Id") -or ($instID -eq "--")) { continue }
            $script:XMLToParse = New-Object System.Xml.XmlDocument
            $script:XMLToParse = [xml](Get-SPProjectWebInstance | Where-Object {$_.Id -eq $instID} | ConvertTo-XML -NoTypeInformation)

            $typeName = $script:XMLToParse.Objects.Object.Property | Where-Object { $_.Name -eq "TypeName" }
            if ($null -eq $typeName) {
                $tempstr = ($script:XMLToParse.Objects.Object.Property | Where-Object { $_.Name -eq "Name" }).InnerText
            }
            else {
                $tempstr = ($script:XMLToParse.Objects.Object.Property | Where-Object { $_.Name -eq "TypeName" }).InnerText
            }

            $instID = $instID + "|" + $tempstr
            $tempstr2 = [System.String]$script:XMLToParse.Objects.Object.InnerXml
            $script:projectInstances.Add($instID, $tempstr2)
        }
        return 1 | Out-Null

    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16enumProjectServiceApps", $_)
        return 0
    }
}