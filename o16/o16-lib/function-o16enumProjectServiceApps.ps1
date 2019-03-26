function o16enumProjectServiceApps() {
    try {
        $global:projectsvcApps = Get-SPServiceApplication | where {$_.typename -eq "Project Application Services"} 
        $instcount = (Get-SPProjectWebInstance).Length
        $prjInst = Get-SPProjectWebInstance | Select Id | Out-String -Width 1000
        $delimitLines = $prjInst.Split("`n")
        $global:projectPCSSettings = Get-SPProjectPCSSettings
        $global:projectQueueSettings = Get-SPProjectQueueSettings
        ForEach ($instID in $delimitLines) {
            $instID = $instID.Trim()
            if (($instID -eq "") -or ($instID -eq "Id") -or ($instID -eq "--")) { continue }
            $global:XMLToParse = New-Object System.Xml.XmlDocument
            $global:XMLToParse = [xml](Get-SPProjectWebInstance | where {$_.Id -eq $instID} | ConvertTo-XML -NoTypeInformation)
			
            $typeName = $global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" } 
            if ($typeName -eq $null) {
                $tempstr = ($global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "Name" }).InnerText
            }
            else {
                $tempstr = ($global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" }).InnerText
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