
function o14enumWebApps {
    [CmdletBinding()]
    param ()
    try {
        $script:totalContentDBCount = 0
        [Microsoft.SharePoint.Administration.SPFarm] $mySPFarm = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm
        [Microsoft.SharePoint.Administration.SPServerCollection] $mySPServerCollection = $mySPFarm.Servers
        [Microsoft.SharePoint.Administration.SPWebApplicationCollection] $mySPWebAppCollection = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.WebApplications
        $script:WebAppnum = $mySPWebAppCollection.Count;
        $script:WebAppDetails = New-Object 'System.String[,]' $script:WebAppnum, 10
        $script:WebAppExtended = New-Object 'System.String[,]' $script:WebAppnum, 6
        $script:WebAppInternalAAMURL = New-Object 'System.String[,]' $script:WebAppnum, 6
        $script:WebAppPublicAAM = New-Object 'System.String[,]' $script:WebAppnum, 6
        $script:WebAppAuthProviders = New-Object 'System.String[,]' $script:WebAppnum, 6
        $count = 0;
        $script:ContentDBs = New-Object 'System.String[,]' $script:WebAppnum, $script:_maxContentDBs
        $script:WebAppDbID = New-Object 'System.String[,]' $script:WebAppnum, $script:_maxContentDBs
        $script:ContentDBSitesNum = New-Object 'System.String[,]' $script:WebAppnum, $script:_maxContentDBs

        if ($mySPWebAppCollection -ne $null) {
            foreach ($mySPWebApp in $mySPWebAppCollection) {
                $mySiteCollectionNum = 0
                $script:WebAppDetails[$count, 0] = $count.ToString()
                $script:WebAppExtended[$count, 0] = $count.ToString()
                $script:WebAppInternalAAMURL[$count, 0] = $count.ToString()
                $script:WebAppPublicAAM[$count, 0] = $count.ToString()

                $script:WebAppDetails[$count, 2] = $mySPWebApp.Name
                $script:WebAppDetails[$count, 6] = $mySPWebApp.ApplicationPool.Name
                $script:WebAppDetails[$count, 7] = $mySPWebApp.ApplicationPool.Username
                $script:WebAppDetails[$count, 3] = $mySPWebApp.ContentDatabases.Count.ToString()
                if ($mySPWebApp.ServiceApplicationProxyGroup.Name -eq "")
                { $script:WebAppDetails[$count, 9] = "[default]" }
                else
                { $script:WebAppDetails[$count, 9] = $mySPWebApp.ServiceApplicationProxyGroup.Name }
                $script:ContentDBcount = $mySPWebApp.ContentDatabases.Count
                $script:totalContentDBCount = $script:totalContentDBCount + $mySPWebApp.ContentDatabases.Count

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
                        { $script:WebAppAuthProviders[$count, $count2] = "ADFS / WebSSO" }
                        else
                        { $script:WebAppAuthProviders[$count, $count2] = $authMode.ToString().Trim() }

                        if (($mySPWebApp.IisSettings[$CurrentZone].DisableKerberos) -and ($script:WebAppAuthProviders[$count, $count2] -eq "Windows") -and ($mySPWebApp.IisSettings[$CurrentZone ].UseWindowsIntegratedAuthentication) -and (-not $mySPWebApp.IisSettings[$CurrentZone ].UseBasicAuthentication))
                        { $script:WebAppAuthProviders[$count, $count2] = $WebAppAuthProviders[$count, $count2] + " (NTLM)" }

                        if (($mySPWebApp.IisSettings[$CurrentZone ].DisableKerberos) -and ($script:WebAppAuthProviders[$count, $count2] -eq "Windows") -and ($mySPWebApp.IisSettings[$CurrentZone ].UseWindowsIntegratedAuthentication) -and ($mySPWebApp.IisSettings[$CurrentZone ].UseBasicAuthentication))
                        { $script:WebAppAuthProviders[$count, $count2] = $script:WebAppAuthProviders[$count, $count2] + " (NTLM + Basic)" }

                        if ((-not $mySPWebApp.IisSettings[$CurrentZone ].DisableKerberos) -and ($script:WebAppAuthProviders[$count, $count2] -eq "Windows") -and ($mySPWebApp.IisSettings[$CurrentZone ].UseWindowsIntegratedAuthentication) -and (-not $mySPWebApp.IisSettings[$CurrentZone ].UseBasicAuthentication))
                        { $script:WebAppAuthProviders[$count, $count2] = $script:WebAppAuthProviders[$count, $count2] + " (Kerberos)" }

                        if ((-not $mySPWebApp.IisSettings[$CurrentZone ].DisableKerberos) -and ($script:WebAppAuthProviders[$count, $count2] -eq "Windows") -and ($mySPWebApp.IisSettings[$CurrentZone ].UseWindowsIntegratedAuthentication) -and ($mySPWebApp.IisSettings[$CurrentZone ].UseBasicAuthentication))
                        { $script:WebAppAuthProviders[$count, $count2] = $script:WebAppAuthProviders[$count, $count2] + " (Kerberos + Basic)" }

                        if (($script:WebAppAuthProviders[$count, $count2] -eq "Windows") -and (-not $mySPWebApp.IisSettings[$CurrentZone ].UseWindowsIntegratedAuthentication) -and ($mySPWebApp.IisSettings[$CurrentZone ].UseBasicAuthentication))
                        { $script:WebAppAuthProviders[$count, $count2] = $script:WebAppAuthProviders[$count, $count2] + " (Basic)" }

                        if ($mySPWebApp.IisSettings[$CurrentZone ].AllowAnonymous)
                        { $script:WebAppAuthProviders[$count, $count2] = $script:WebAppAuthProviders[$count, $count2] + " ] true" }
                        else
                        { $script:WebAppAuthProviders[$count, $count2] = $script:WebAppAuthProviders[$count, $count2] + " ] false" }

                        $script:WebAppAuthProviders[$count, $count2] = $script:WebAppAuthProviders[$count, $count2] + " ] " + $mySPWebApp.IisSettings[$CurrentZone].Path.FullName

                        $script:WebAppAuthProviders[$count, $count2] = $script:WebAppAuthProviders[$count, $count2] + " ] " + $mySPWebApp.IisSettings[$CurrentZone].UseClaimsAuthentication.ToString()
                    }
                }

                #finding out the content dbs for the web app
                [Microsoft.SharePoint.Administration.SPContentDatabaseCollection] $mySPContentDBCollection = $mySPWebApp.ContentDatabases
                foreach ($mySPContentDB in $mySPContentDBCollection) {
                    $script:ContentDBcount--;
                    $script:ContentDBs[$count, $script:ContentDBcount] = $mySPContentDB.Name
                    $mySiteCollectionNum = $mySiteCollectionNum + $mySPContentDB.Sites.Count
                    $ContentDBSitesNum[$count, $ContentDBcount] = $mySPContentDB.Sites.Count.ToString()
                }
                $script:WebAppDetails[$count, 4] = $mySiteCollectionNum.ToString()

                #enumerating alternateURLs
                foreach ($mySPAlternateUrl in $mySPWebApp.AlternateUrls) {
                    switch ($mySPAlternateUrl.UrlZone.ToString().Trim()) {
                        "Default" {
                            if ($script:WebAppPublicAAM[$count, 1] -eq $null)
                            { $script:WebAppPublicAAM[$count, 1] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                            { $script:WebAppInternalAAMURL[$count, 1] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                        "Intranet" {
                            if ($script:WebAppPublicAAM[$count, 2] -eq $null)
                            { $script:WebAppPublicAAM[$count, 2] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                            { $script:WebAppInternalAAMURL[$count, 2] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                        "Internet" {
                            if ($script:WebAppPublicAAM[$count, 3] -eq $null)
                            { $script:WebAppPublicAAM[$count, 3] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                            { $script:WebAppInternalAAMURL[$count, 3] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                        "Custom" {
                            if ($script:WebAppPublicAAM[$count, 4] -eq $null)
                            { $script:WebAppPublicAAM[$count, 4] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                            { $script:WebAppInternalAAMURL[$count, 4] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                        "Extranet" {
                            if ($script:WebAppPublicAAM[$count, 5] -eq $null)
                            { $script:WebAppPublicAAM[$count, 5] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                            { $script:WebAppInternalAAMURL[$count, 5] = $mySPAlternateUrl.IncomingUrl.ToString() }
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
        global:HandleException("o14enumWebApps", $_)
        return 0
    }
}
