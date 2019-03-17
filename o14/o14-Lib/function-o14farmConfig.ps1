function o14farmConfig()
{
    try
    {
            
            $global:DSN = Get-ItemProperty "hklm:SOFTWARE\Microsoft\Shared Tools\Web Server Extensions\14.0\Secure\configdb" | select dsn | Format-Table -HideTableHeaders | Out-String -Width 1024
            if (-not $?)
            {
                Write-Host You will need to run this program on a server where SharePoint is installed.
                exit
            }
            $global:DSN = out-string -InputObject $global:DSN
            $confgDbServerNameTemp = $global:DSN -split '[=;]' 
            $global:confgDbServerName = $confgDbServerNameTemp[1]
            $global:confgDbName = $confgDbServerNameTemp[3]

            [Microsoft.SharePoint.Administration.SPFarm] $mySPFarm = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm
            $global:BuildVersion = [string] $mySPFarm.BuildVersion
            $global:systemAccount = $mySPFarm.TimerService.ProcessIdentity.Username.ToString()
            [Microsoft.SharePoint.Administration.SPServerCollection] $mySPServerCollection = $mySPFarm.Servers
            [Microsoft.SharePoint.Administration.SPWebApplicationCollection] $mySPAdminWebAppCollection = [Microsoft.SharePoint.Administration.SPWebService]::AdministrationService.WebApplications
            [Microsoft.SharePoint.Administration.SPTimerService] $spts = $mySPFarm.TimerService   
                
                if ($mySPAdminWebAppCollection -ne $null)
                {
                    $mySPAdminWebApp = new-object Microsoft.SharePoint.Administration.SPAdministrationWebApplication
                    foreach($mySPAdminWebApp in $mySPAdminWebAppCollection)
                    {
                        if ($mySPAdminWebApp.IsAdministrationWebApplication)
                        {
                            $mySPAlternateUrl = new-object Microsoft.SharePoint.Administration.SPAlternateUrl
                            foreach ($mySPAlternateUrl in $mySPAdminWebApp.AlternateUrls)
                            {
                                switch ($mySPAlternateUrl.UrlZone.ToString().Trim())
                                {
                                    default
                                    {
                                        $global:adminURL = $mySPAlternateUrl.IncomingUrl.ToString()
                                    }
                                }
                            }
                            [Microsoft.SharePoint.Administration.SPContentDatabaseCollection] $mySPContentDBCollection = $mySPAdminWebApp.ContentDatabases;
                            $mySPContentDB = new-object Microsoft.SharePoint.Administration.SPContentDatabase
                            foreach ( $mySPContentDB in $mySPContentDBCollection)
                            {
                                $global:adminDbName = $mySPContentDB.Name.ToString()
                                $global:adminDbServerName = $mySPContentDB.Server.ToString()
                            }
                        }
                    }
                }
				return 1
    } 
    
    catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		global:HandleException("o14farmConfig", $_)
		return 0
    } 
}