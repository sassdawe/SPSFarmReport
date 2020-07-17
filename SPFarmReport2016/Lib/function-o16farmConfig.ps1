function o16farmConfig() {
    try {
            
        $script:DSN = Get-ItemProperty "hklm:SOFTWARE\Microsoft\Shared Tools\Web Server Extensions\16.0\Secure\configdb" | select dsn | Format-Table -HideTableHeaders | Out-String -Width 1024
        if (-not $?) {
            Write-Host You will need to run this program on a server where SharePoint is installed.
            exit
        }
        $script:DSN = out-string -InputObject $script:DSN
        $confgDbServerNameTemp = $script:DSN -split '[=;]' 
        $script:confgDbServerName = $confgDbServerNameTemp[1]
        $script:confgDbName = $confgDbServerNameTemp[3]

        [Microsoft.SharePoint.Administration.SPFarm] $mySPFarm = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm
        $script:BuildVersion = [string] $mySPFarm.BuildVersion
        $script:systemAccount = $mySPFarm.TimerService.ProcessIdentity.Username.ToString()
        [Microsoft.SharePoint.Administration.SPServerCollection] $mySPServerCollection = $mySPFarm.Servers
        [Microsoft.SharePoint.Administration.SPWebApplicationCollection] $mySPAdminWebAppCollection = [Microsoft.SharePoint.Administration.SPWebService]::AdministrationService.WebApplications
        [Microsoft.SharePoint.Administration.SPTimerService] $spts = $mySPFarm.TimerService   
                
        if ($mySPAdminWebAppCollection -ne $null) {
            $mySPAdminWebApp = new-object Microsoft.SharePoint.Administration.SPAdministrationWebApplication
            foreach ($mySPAdminWebApp in $mySPAdminWebAppCollection) {
                if ($mySPAdminWebApp.IsAdministrationWebApplication) {
                    $mySPAlternateUrl = new-object Microsoft.SharePoint.Administration.SPAlternateUrl
                    foreach ($mySPAlternateUrl in $mySPAdminWebApp.AlternateUrls) {
                        switch ($mySPAlternateUrl.UrlZone.ToString().Trim()) {
                            default {
                                $script:adminURL = $mySPAlternateUrl.IncomingUrl.ToString()
                            }
                        }
                    }
                    [Microsoft.SharePoint.Administration.SPContentDatabaseCollection] $mySPContentDBCollection = $mySPAdminWebApp.ContentDatabases;
                    $mySPContentDB = new-object Microsoft.SharePoint.Administration.SPContentDatabase
                    foreach ( $mySPContentDB in $mySPContentDBCollection) {
                        $script:adminDbName = $mySPContentDB.Name.ToString()
                        $script:adminDbServerName = $mySPContentDB.Server.ToString()
                    }
                }
            }
        }
				
        $productsNum = ((($mySPFarm.Products | ft -HideTableHeaders | Out-String).Trim()).Split("`n")).Count
        if ($productsNum -eq 1)
        { $script:isFoundationOnlyInstalled = $true }
        return 1
    } 
    
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16farmConfig", $_)
        return 0
    } 
}