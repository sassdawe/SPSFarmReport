function o16enumSvcApps() {
    try {                
        $script:SvcAppCount = (Get-SPServiceApplication).Length

        $svcApps = Get-SPServiceApplication | Select Id | Out-String -Width 1000
        $delimitLines = $svcApps.Split("`n")
	
        ForEach ($ServiceAppID in $delimitLines) {
            $ServiceAppID = $ServiceAppID.Trim()
            if (($ServiceAppID -eq "") -or ($ServiceAppID -eq "Id") -or ($ServiceAppID -eq "--")) { continue }
            $script:XMLToParse = New-Object System.Xml.XmlDocument
            $script:XMLToParse = [xml](Get-SPServiceApplication | where {$_.Id -eq $ServiceAppID} | ConvertTo-XML -NoTypeInformation)
			
            $typeName = $script:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" } 
            if ($typeName -eq $null) {
                $tempstr = ($script:XMLToParse.Objects.Object.Property | where { $_.Name -eq "Name" }).InnerText
            }
            else {
                $tempstr = ($script:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" }).InnerText
            }
						
            $ServiceAppID = $ServiceAppID + "|" + $tempstr
            $tempstr2 = [System.String]$script:XMLToParse.Objects.Object.InnerXml
            $script:ServiceApps.Add($ServiceAppID, $tempstr2)
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumSvcApps", $_)
        return 0
    }
}