
function o14enumSPServiceApplicationProxies {
    [CmdletBinding()]
    param ()
    try {
        $script:serviceAppProxyCount = (Get-SPServiceApplicationProxy).Length
        $svcApps = Get-SPServiceApplicationProxy | Select Id | Out-String -Width 1000
        $delimitLines = $svcApps.Split("`n")

        ForEach ($ServiceAppProxyID in $delimitLines) {
            $ServiceAppProxyID = $ServiceAppProxyID.Trim()
            if (($ServiceAppProxyID -eq "") -or ($ServiceAppProxyID -eq "Id") -or ($ServiceAppProxyID -eq "--")) { continue }
            $script:XMLToParse = New-Object System.Xml.XmlDocument
            $script:XMLToParse = [xml](Get-SPServiceApplicationProxy | where {$_.Id -eq $ServiceAppProxyID} | ConvertTo-XML -NoTypeInformation)

            $typeName = $script:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" }
            if ($typeName -eq $null) {
                $tempstr = ($script:XMLToParse.Objects.Object.Property | where { $_.Name -eq "Name" }).InnerText
            }
            else {
                $tempstr = ($script:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" }).InnerText
            }

            $ServiceAppProxyID = $ServiceAppProxyID + "|" + $tempstr
            $tempstr2 = [System.String]$script:XMLToParse.Objects.Object.InnerXml
            $script:SPServiceAppProxies.Add($ServiceAppProxyID, $tempstr2)
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14enumSPServiceApplicationProxies", $_)
        return 0
    }
}

