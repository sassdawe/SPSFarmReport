function o16enumSvcApps() {
    try {
        $script:SvcAppCount = (Get-SPServiceApplication).Length

        $svcApps = Get-SPServiceApplication | Select-Object Id | Out-String -Width 1000
        $delimitLines = $svcApps.Split("`n")

        ForEach ($ServiceAppID in $delimitLines) {
            $ServiceAppID = $ServiceAppID.Trim()
            if (($ServiceAppID -eq "") -or ($ServiceAppID -eq "Id") -or ($ServiceAppID -eq "--")) { continue }
            $script:XMLToParse = New-Object System.Xml.XmlDocument
            $script:XMLToParse = [xml](Get-SPServiceApplication | Where-Object { $_.Id -eq $ServiceAppID } | ConvertTo-XML -NoTypeInformation)

            $typeName = $script:XMLToParse.Objects.Object.Property | Where-Object { $_.Name -eq "TypeName" }
            if ($null -eq $typeName) {
                $tempstr = ($script:XMLToParse.Objects.Object.Property | Where-Object { $_.Name -eq "Name" }).InnerText
            }
            else {
                $tempstr = ($script:XMLToParse.Objects.Object.Property | Where-Object { $_.Name -eq "TypeName" }).InnerText
            }

            $ServiceAppID = $ServiceAppID + "|" + $tempstr
            $tempstr2 = [System.String]$script:XMLToParse.Objects.Object.InnerXml
            $script:ServiceApps.Add($ServiceAppID, $tempstr2)
        }
        return 1
    }
    catch [System.Exception] {
        Write-Information " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16enumSvcApps", $_)
        return 0
    }
}