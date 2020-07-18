function o16enumSPServiceApplicationPools {
    [cmdletbinding()]
    param ()
    try {
        $svcAppPoolIDs = Get-SPServiceApplicationPool | Select-Object Id | Out-String -Width 1000
        $delimitLines = $svcAppPoolIDs.Split("`n")
        $script:serviceAppPoolCount = (Get-SPServiceApplicationPool).Length

        ForEach ($svcAppPoolID in $delimitLines) {
            $svcAppPoolID = $svcAppPoolID.Trim()
            if (($svcAppPoolID -eq "") -or ($svcAppPoolID -eq "Id") -or ($svcAppPoolID -eq "--")) { continue }

            $script:XMLToParse = New-Object System.Xml.XmlDocument
            $script:XMLToParse = [xml](Get-SPServiceApplicationPool | Select-Object Id, Name, ProcessAccountName | Where-Object {$_.Id -eq $svcAppPoolID} | Select-Object Name, ProcessAccountName | ConvertTo-XML -NoTypeInformation)
            $tempstr = [System.String]$script:XMLToParse.Objects.Object.InnerXml
            $script:SPServiceApplicationPools.Add($svcAppPoolID, $tempstr)
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16enumSPServiceApplicationPools", $_)
        return 0
    }
}