
function o14enumSPServiceApplicationProxies()
{
	try
	{
		$global:serviceAppProxyCount = (Get-SPServiceApplicationProxy).Length
		$svcApps = Get-SPServiceApplicationProxy | Select Id | Out-String -Width 1000
		$delimitLines =  $svcApps.Split("`n")
		
		ForEach($ServiceAppProxyID in $delimitLines)
        {
			$ServiceAppProxyID = $ServiceAppProxyID.Trim()
			if (($ServiceAppProxyID -eq "") -or ($ServiceAppProxyID -eq "Id") -or ($ServiceAppProxyID -eq "--")) { continue }
			$global:XMLToParse = New-Object System.Xml.XmlDocument
			$global:XMLToParse = [xml](Get-SPServiceApplicationProxy | where {$_.Id -eq $ServiceAppProxyID} | ConvertTo-XML -NoTypeInformation)
			
			$typeName = $global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" } 
			if($typeName -eq $null)
			{
				$tempstr = ($global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "Name" }).InnerText
			}
			else
			{
				$tempstr = ($global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" }).InnerText
			}
						
			$ServiceAppProxyID = $ServiceAppProxyID + "|" + $tempstr
			$tempstr2 = [System.String]$global:XMLToParse.Objects.Object.InnerXml 
			$global:SPServiceAppProxies.Add($ServiceAppProxyID, $tempstr2)
        }	
		return 1
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14enumSPServiceApplicationProxies", $_)
		return 0
    }
}

