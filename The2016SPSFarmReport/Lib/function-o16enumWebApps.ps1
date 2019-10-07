function o16enumWebApps() {
    try {
        $global:totalContentDBCount = 0
        [Microsoft.SharePoint.Administration.SPFarm] $mySPFarm = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm
        [Microsoft.SharePoint.Administration.SPServerCollection] $mySPServerCollection = $mySPFarm.Servers
        [Microsoft.SharePoint.Administration.SPWebApplicationCollection] $mySPWebAppCollection = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.WebApplications
        $global:WebAppnum = $mySPWebAppCollection.Count;
        $global:WebAppDetails = New-Object 'System.String[,]' $global:WebAppnum, 10
        $global:WebAppExtended = New-Object 'System.String[,]' $global:WebAppnum, 6
        $global:WebAppInternalAAMURL = New-Object 'System.String[,]' $global:WebAppnum, 6
        $global:WebAppPublicAAM = New-Object 'System.String[,]' $global:WebAppnum, 6
        $global:WebAppAuthProviders = New-Object 'System.String[,]' $global:WebAppnum, 6
        $count = 0;
        $global:ContentDBs = New-Object 'System.String[,]' $global:WebAppnum, $global:_maxContentDBs
        $global:WebAppDbID = New-Object 'System.String[,]' $global:WebAppnum, $global:_maxContentDBs
        $global:ContentDBSitesNum = New-Object 'System.String[,]' $global:WebAppnum, $global:_maxContentDBs
		
        if ($mySPWebAppCollection -ne $null) {
            foreach ($mySPWebApp in $mySPWebAppCollection) {
                $mySiteCollectionNum = 0
                $global:WebAppDetails[$count, 0] = $count.ToString()
                $global:WebAppExtended[$count, 0] = $count.ToString()
                $global:WebAppInternalAAMURL[$count, 0] = $count.ToString()
                $global:WebAppPublicAAM[$count, 0] = $count.ToString()

                $global:WebAppDetails[$count, 2] = $mySPWebApp.Name
                $global:WebAppDetails[$count, 6] = $mySPWebApp.ApplicationPool.Name
                $global:WebAppDetails[$count, 7] = $mySPWebApp.ApplicationPool.Username
                $global:WebAppDetails[$count, 3] = $mySPWebApp.ContentDatabases.Count.ToString()
                if ($mySPWebApp.ServiceApplicationProxyGroup.Name -eq "")
                { $global:WebAppDetails[$count, 9] = "[default]" }
                else
                { $global:WebAppDetails[$count, 9] = $mySPWebApp.ServiceApplicationProxyGroup.Name }
                $global:ContentDBcount = $mySPWebApp.ContentDatabases.Count
                $global:totalContentDBCount = $global:totalContentDBCount + $mySPWebApp.ContentDatabases.Count				
				
                $AllZones = [Microsoft.SharePoint.Administration.SPUrlZone]::Default, 
                [Microsoft.SharePoint.Administration.SPUrlZone]::Intranet, 
                [Microsoft.SharePoint.Administration.SPUrlZone]::Internet, 
                [Microsoft.SharePoint.Administration.SPUrlZone]::Custom, 
                [Microsoft.SharePoint.Administration.SPUrlZone]::Extranet
                foreach ($CurrentZone in $AllZones) {
                    switch ($CurrentZone) {
                        [Microsoft.SharePoint.Administration.SPUrlZone]::Default { $count2 = 1 }
                        [Microsoft.SharePoint.Administration.SPUrlZone]::Intranet { $count2 = 2 }
                        [Microsoft.SharePoint.Administration.SPUrlZone]::Internet { $count2 = 3 }
                        [Microsoft.SharePoint.Administration.SPUrlZone]::Custom { $count2 = 4 }
                        [Microsoft.SharePoint.Administration.SPUrlZone]::Extranet { $count2 = 5 }
                        default { $count2 = 1 }
                    }
                    if ($mySPWebApp.IisSettings.ContainsKey($CurrentZone)) {
                        $authMode = $mySPWebApp.IisSettings[$CurrentZone].AuthenticationMode
                        if ($authMode.ToString().ToLower().Trim() -eq "none")
                        { $global:WebAppAuthProviders[$count, $count2] = "ADFS / WebSSO" }
                        else
                        { $global:WebAppAuthProviders[$count, $count2] = $authMode.ToString().Trim() }

                        if (($mySPWebApp.IisSettings[$CurrentZone].DisableKerberos) -and ($global:WebAppAuthProviders[$count, $count2] -eq "Windows") -and ($mySPWebApp.IisSettings[$CurrentZone ].UseWindowsIntegratedAuthentication) -and (-not $mySPWebApp.IisSettings[$CurrentZone ].UseBasicAuthentication))
                        { $global:WebAppAuthProviders[$count, $count2] = $WebAppAuthProviders[$count, $count2] + " (NTLM)" }

                        if (($mySPWebApp.IisSettings[$CurrentZone ].DisableKerberos) -and ($global:WebAppAuthProviders[$count, $count2] -eq "Windows") -and ($mySPWebApp.IisSettings[$CurrentZone ].UseWindowsIntegratedAuthentication) -and ($mySPWebApp.IisSettings[$CurrentZone ].UseBasicAuthentication))
                        { $global:WebAppAuthProviders[$count, $count2] = $global:WebAppAuthProviders[$count, $count2] + " (NTLM + Basic)" }

                        if ((-not $mySPWebApp.IisSettings[$CurrentZone ].DisableKerberos) -and ($global:WebAppAuthProviders[$count, $count2] -eq "Windows") -and ($mySPWebApp.IisSettings[$CurrentZone ].UseWindowsIntegratedAuthentication) -and (-not $mySPWebApp.IisSettings[$CurrentZone ].UseBasicAuthentication))
                        { $global:WebAppAuthProviders[$count, $count2] = $global:WebAppAuthProviders[$count, $count2] + " (Kerberos)" }

                        if ((-not $mySPWebApp.IisSettings[$CurrentZone ].DisableKerberos) -and ($global:WebAppAuthProviders[$count, $count2] -eq "Windows") -and ($mySPWebApp.IisSettings[$CurrentZone ].UseWindowsIntegratedAuthentication) -and ($mySPWebApp.IisSettings[$CurrentZone ].UseBasicAuthentication))
                        { $global:WebAppAuthProviders[$count, $count2] = $global:WebAppAuthProviders[$count, $count2] + " (Kerberos + Basic)" }

                        if (($global:WebAppAuthProviders[$count, $count2] -eq "Windows") -and (-not $mySPWebApp.IisSettings[$CurrentZone ].UseWindowsIntegratedAuthentication) -and ($mySPWebApp.IisSettings[$CurrentZone ].UseBasicAuthentication))
                        { $global:WebAppAuthProviders[$count, $count2] = $global:WebAppAuthProviders[$count, $count2] + " (Basic)" }

                        if ($mySPWebApp.IisSettings[$CurrentZone ].AllowAnonymous)
                        { $global:WebAppAuthProviders[$count, $count2] = $global:WebAppAuthProviders[$count, $count2] + " ] true" }
                        else
                        { $global:WebAppAuthProviders[$count, $count2] = $global:WebAppAuthProviders[$count, $count2] + " ] false" }

                        $global:WebAppAuthProviders[$count, $count2] = $global:WebAppAuthProviders[$count, $count2] + " ] " + $mySPWebApp.IisSettings[$CurrentZone].Path.FullName

                        $global:WebAppAuthProviders[$count, $count2] = $global:WebAppAuthProviders[$count, $count2] + " ] " + $mySPWebApp.IisSettings[$CurrentZone].UseClaimsAuthentication.ToString()
                    }		
                }
				
                #finding out the content dbs for the web app
                [Microsoft.SharePoint.Administration.SPContentDatabaseCollection] $mySPContentDBCollection = $mySPWebApp.ContentDatabases
                foreach ($mySPContentDB in $mySPContentDBCollection) {
                    $global:ContentDBcount--;
                    $global:ContentDBs[$count, $global:ContentDBcount] = $mySPContentDB.Name
                    $mySiteCollectionNum = $mySiteCollectionNum + $mySPContentDB.Sites.Count
                    $ContentDBSitesNum[$count, $ContentDBcount] = $mySPContentDB.Sites.Count.ToString()					
                }
                $global:WebAppDetails[$count, 4] = $mySiteCollectionNum.ToString()
				
                #enumerating alternateURLs
                foreach ($mySPAlternateUrl in $mySPWebApp.AlternateUrls) {
                    switch ($mySPAlternateUrl.UrlZone.ToString().Trim()) {
                        "Default" {
                            if ($global:WebAppPublicAAM[$count, 1] -eq $null)
                            { $global:WebAppPublicAAM[$count, 1] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                            { $global:WebAppInternalAAMURL[$count, 1] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                        "Intranet" {
                            if ($global:WebAppPublicAAM[$count, 2] -eq $null)
                            { $global:WebAppPublicAAM[$count, 2] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                            { $global:WebAppInternalAAMURL[$count, 2] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                        "Internet" {
                            if ($global:WebAppPublicAAM[$count, 3] -eq $null)
                            { $global:WebAppPublicAAM[$count, 3] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                            { $global:WebAppInternalAAMURL[$count, 3] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                        "Custom" {
                            if ($global:WebAppPublicAAM[$count, 4] -eq $null)
                            { $global:WebAppPublicAAM[$count, 4] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                            { $global:WebAppInternalAAMURL[$count, 4] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                        "Extranet" {
                            if ($global:WebAppPublicAAM[$count, 5] -eq $null)
                            { $global:WebAppPublicAAM[$count, 5] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                            { $global:WebAppInternalAAMURL[$count, 5] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                    }
                }					
                $count++
            }
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumWebApps", $_)
        return 0
    }
}
