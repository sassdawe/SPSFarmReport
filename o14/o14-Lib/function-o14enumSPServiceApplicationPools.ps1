

function o14enumSPServiceApplicationPools {
    [CmdletBinding()]
    param ()
    try {
        $svcAppPoolIDs = Get-SPServiceApplicationPool | select Id | Out-String -Width 1000
        $delimitLines = $svcAppPoolIDs.Split("`n")
        $script:serviceAppPoolCount = (Get-SPServiceApplicationPool).Length

        ForEach ($svcAppPoolID in $delimitLines) {
            $svcAppPoolID = $svcAppPoolID.Trim()
            if (($svcAppPoolID -eq "") -or ($svcAppPoolID -eq "Id") -or ($svcAppPoolID -eq "--")) { continue }

            $script:XMLToParse = New-Object System.Xml.XmlDocument
            $script:XMLToParse = [xml](Get-SPServiceApplicationPool | select Id, Name, ProcessAccountName | where {$_.Id -eq $svcAppPoolID} | select Name, ProcessAccountName | ConvertTo-XML -NoTypeInformation)
            $tempstr = [System.String]$script:XMLToParse.Objects.Object.InnerXml
            $script:SPServiceApplicationPools.Add($svcAppPoolID, $tempstr)
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14enumSPServiceApplicationPools", $_)
        return 0
    }
}

