function o16enumProjectServiceApps{
    [cmdletbinding()]
    param ()
    try {
        $global:projectsvcApps = Get-SPServiceApplication | Where-Object {$_.typename -eq "Project Application Services"}
        $instcount = (Get-SPProjectWebInstance).Length
        $prjInst = Get-SPProjectWebInstance | Select-Object Id | Out-String -Width 1000
        $delimitLines = $prjInst.Split("`n")
        $global:projectPCSSettings = Get-SPProjectPCSSettings
        $global:projectQueueSettings = Get-SPProjectQueueSettings
        ForEach ($instID in $delimitLines) {
            $instID = $instID.Trim()
            if (($instID -eq "") -or ($instID -eq "Id") -or ($instID -eq "--")) { continue }
            $global:XMLToParse = New-Object System.Xml.XmlDocument
            $global:XMLToParse = [xml](Get-SPProjectWebInstance | Where-Object {$_.Id -eq $instID} | ConvertTo-XML -NoTypeInformation)

            $typeName = $global:XMLToParse.Objects.Object.Property | Where-Object { $_.Name -eq "TypeName" }
            if ($null -eq $typeName) {
                $tempstr = ($global:XMLToParse.Objects.Object.Property | Where-Object { $_.Name -eq "Name" }).InnerText
            }
            else {
                $tempstr = ($global:XMLToParse.Objects.Object.Property | Where-Object { $_.Name -eq "TypeName" }).InnerText
            }

            $instID = $instID + "|" + $tempstr
            $tempstr2 = [System.String]$global:XMLToParse.Objects.Object.InnerXml
            $global:projectInstances.Add($instID, $tempstr2)
        }
        return 1 | Out-Null

    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumProjectServiceApps", $_)
        return 0
    }
}