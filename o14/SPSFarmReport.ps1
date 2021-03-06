
try {
    #region initialize contect
    if ( $null -eq (Get-PSSnapin -Name Microsoft.Sharepoint.PowerShell -ErrorAction SilentlyContinue)  )
    {
        Add-PsSnapin Microsoft.Sharepoint.PowerShell -ErrorAction Stop
    }
    $scriptPath = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
    Get-ChildItem $scriptPath -Filter "function*" -Include "*.ps1" -Exclude "*.tests.ps1" -Recurse | ForEach-Object {
        Invoke-Expression ". $($_.FullName)"
    }

    [void][System.Reflection.Assembly]::Load("Microsoft.SharePoint, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c")
    [void][System.Reflection.Assembly]::Load("System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
    [void][System.Reflection.Assembly]::Load("Microsoft.SharePoint.Publishing, Version=14.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c")
    [void][System.Reflection.Assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
    #endregion

    # Declaring all string variables
    $DSN, $confgDbServerName, $confgDbName, $BuildVersion, $systemAccount = "","","","","" | Out-Null
    $adminURL, $adminDbName, $adminDbServerName  = "","","" | Out-Null
    $exceptionDetails = "" | Out-Null

    # Declaing all integer variables
    $Servernum, $totalContentDBCount, $WebAppnum, $serviceAppPoolCount, $FeatureCount = 0,0,0,0,0,0,0 | Out-Null
    $wFeatureCount, $solutionCount, $sFeatureCount = 0,0,0 | Out-Null
    $serviceAppProxyCount, $serviceAppProxyGroupCount, $searchsvcAppsCount  = 0, 0, 0 | Out-Null
    $SvcAppCount = 0 | Out-Null

    # Declaring all string[] arrays
    [System.string[]] $Servers, $ServersId | Out-Null
    [System.string[]] $searchServiceAppIds | Out-Null
    # remove this line man [System.string[]] $delimiterChars, $delimiterChars2, $delimiterChars3, $delimiterChars4 | Out-Null

    # Declaring all string[,] arrays
    [System.string[,]] $ServicesOnServers, $WebAppDetails | Out-Null
    [System.string[,]] $WebAppExtended, $WebAppInternalAAMURL, $WebAppPublicAAM, $WebAppAuthProviders | Out-Null
    [System.string[,]] $ContentDBs, $ContentDBSitesNum, $solutionProps, $ContentDBProps | Out-Null
    [System.string[,]] $FarmFeatures, $SiteFeatures, $WebFeatures | Out-Null

    # Declaring three dimensional arrays
    [System.string[,,]] $serverProducts | Out-Null

    # Declaring PowerShell environment settings
    $FormatEnumerationLimit = 25

    # Declaring XML data variables
    [System.Xml.XmlDocument]$XMLToParse | Out-Null
    [System.Xml.XmlDocument]$script:CDGI | Out-Null
    [System.Xml.XmlNode]$XmlNode | Out-Null

    # Declaring all Hash Tables
    $script:ServiceApps = @{}
    $script:SearchConfigAdminComponents = @{}
    $script:SearchConfigCrawlComponents = @{}
    $script:SearchConfigQueryComponents = @{}
    $script:SearchConfigContentSources = @{}
    $script:SPServiceApplicationPools = @{}
    $script:SPServiceAppProxies = @{}
    $script:SPServiceAppProxyGroups = @{}
    $script:CDPaths = @{}
    $script:CDJobs = @{}

    # Declaring all Hard-Coded values
    $script:_maxServicesOnServers = 50 # This value indicates the maximum number of services that run on each server.
    $script:_maxProductsonServer = 15 # This value indicates the maximum number of Products installed on each server.
    $script:_maxItemsonServer = 200 # This value indicates the maximum number of Items installed per Product on each server.
    $script:_maxContentDBs = 141 # This is the maximum number of content databases we enumerate per web application.
    $script:_serviceTypeswithNames = @{"Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsService" = "Search Query and Site Settings Service" ; "Microsoft.Office.Server.ApplicationRegistry.SharedService.ApplicationRegistryService" = "Application Registry Service"} # This varialble is used to translate service names to friendly names.
    $script:_farmFeatureDefinitions = @{"AccSrvApplication" = "Access Services Farm Feature"; # This varialble is used to feature definition names to friendly names.
    "GlobalWebParts" = "Global Web Parts";
    "VisioServer" = "Visio Web Access";
    "SpellChecking" = "Spell Checking";
    "SocialRibbonControl" = "Social Tags and Note Board Ribbon Controls";
    "VisioProcessRepositoryFeatureStapling" = "Visio Process Repository";
    "DownloadFromOfficeDotCom" = "Office.com Entry Points from SharePoint";
    "ExcelServerWebPartStapler" = "Excel Services Application Web Part Farm Feature";
    "DataConnectionLibraryStapling" = "Data Connection Library";
    "FastFarmFeatureActivation" = "FAST Search Server 2010 for SharePoint Master Job Provisioning";
    "ExcelServer" = "Excel Services Application View Farm Feature";
    "ObaStaple" = "`"Connect to Office`" Ribbon Controls";
    "TemplateDiscovery" = "Offline Synchronization for External Lists" }
    $script:_logpath = [Environment]::CurrentDirectory + "\SPSFarmReportNew{0}{1:d2}{2:d2}-{3:d2}{4:d2}" -f (Get-Date).Day,(Get-Date).Month,(Get-Date).Year,(Get-Date).Second,(Get-Date).Millisecond + ".LOG"


    $dtime = " Starting run of SPSFarmReport at " + (Get-Date).ToString()
    Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $script:_logpath -Append
    Write-Output  $dtime | Out-File -FilePath $script:_logpath -Append
    Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $script:_logpath -Append

    o14WriteInitialXML
    # Write-Host o14WriteInitialXML
    Write-Output  o14WriteInitialXML | Out-File -FilePath $script:_logpath -Append

    $status = o14farmConfig
    # Write-Host o14farmConfig
    if($status -eq 1) { o14WriteFarmGenSettings }
    # Write-Host o14WriteFarmGenSettings
    Write-Output o14farmConfig | Out-File -FilePath $script:_logpath -Append
    Write-Output o14WriteFarmGenSettings | Out-File -FilePath $script:_logpath -Append

    $status = o14enumServers
    # Write-Host o14enumServers
    if($status -eq 1) { o14writeServers }
    # Write-Host o14writeServers
    Write-Output o14enumServers | Out-File -FilePath $script:_logpath -Append
    Write-Output o14writeServers | Out-File -FilePath $script:_logpath -Append

    $status = o14enumProdVersions
    # Write-Host o14enumProdVersions
    if($status -eq 1) { o14writeProdVersions2 }
    # Write-Host o14writeProdVersions2
    Write-Output o14enumProdVersions | Out-File -FilePath $script:_logpath -Append
    Write-Output o14writeProdVersions2 | Out-File -FilePath $script:_logpath -Append

    $status = o14enumFeatures
    # Write-Host o14enumFeatures
    if($status -eq 1) { o14writeFeatures }
    # Write-Host o14writeFeatures
    Write-Output o14enumFeatures | Out-File -FilePath $script:_logpath -Append
    Write-Output o14writeFeatures | Out-File -FilePath $script:_logpath -Append

    $status = o14enumSolutions
    # Write-Host o14enumSolutions
    if($status -eq 1) { o14writeSolutions }
    # Write-Host o14writeSolutions
    Write-Output o14enumSolutions | Out-File -FilePath $script:_logpath -Append
    Write-Output o14writeSolutions | Out-File -FilePath $script:_logpath -Append

    $status = o14enumSvcApps
    # Write-Host  o14enumSvcApps
    if($status -eq 1) { o14enumSPSearchServiceApps }
    # Write-Host o14enumSPSearchServiceApps
    if($status -eq 1) { o14enumSearchConfigAdminComponents }
    # Write-Host o14enumSearchConfigAdminComponents
    if($status -eq 1) { o14enumSearchConfigCrawlComponents }
    # Write-Host o14enumSearchConfigCrawlComponents
    if($status -eq 1) { o14enumSearchConfigQueryComponents }
    # Write-Host o14enumSearchConfigQueryComponents
    if($status -eq 1) { o14enumSearchConfigContentSources }
    # Write-Host o14enumSearchConfigContentSources

    if($status -eq 1) { o14writeServiceApps }
    # Write-Host o14writeServiceApps

    $status = o14enumSPServiceApplicationPools
    # Write-Host o14enumSPServiceApplicationPools
    if($status -eq 1) { o14writeSPServiceApplicationPools }
    # Write-Host o14writeSPServiceApplicationPools
    Write-Output o14enumSPServiceApplicationPools | Out-File -FilePath $script:_logpath -Append
    Write-Output o14writeSPServiceApplicationPools | Out-File -FilePath $script:_logpath -Append

    $status = o14enumSPServiceApplicationProxies
    # Write-Host o14enumSPServiceApplicationProxies
    if($status -eq 1) { o14writeSPServiceApplicationProxies }
    # Write-Host o14writeSPServiceApplicationProxies
    Write-Output o14enumSPServiceApplicationProxies | Out-File -FilePath $script:_logpath -Append
    Write-Output o14writeSPServiceApplicationProxies | Out-File -FilePath $script:_logpath -Append

    $status = o14enumSPServiceApplicationProxyGroups
    # Write-Host o14enumSPServiceApplicationProxyGroups
    if($status -eq 1) { o14writeSPServiceApplicationProxyGroups }
    # Write-Host o14writeSPServiceApplicationProxyGroups
    Write-Output o14enumSPServiceApplicationProxyGroups | Out-File -FilePath $script:_logpath -Append
    Write-Output o14writeSPServiceApplicationProxyGroups | Out-File -FilePath $script:_logpath -Append

    $status = o14enumWebApps
    # Write-Host o14enumWebApps
    if($status -eq 1) { o14writeWebApps }
    # Write-Host o14writeWebApps
    if($status -eq 1) { o14writeAAMsnAPs }
    # Write-Host o14writeAAMsnAPs
    Write-Output o14enumWebApps | Out-File -FilePath $script:_logpath -Append
    Write-Output o14writeWebApps | Out-File -FilePath $script:_logpath -Append
    Write-Output o14writeAAMsnAPs | Out-File -FilePath $script:_logpath -Append

    $status = o14enumContentDBs
    # Write-Host o14enumContentDBs
    if($status -eq 1) { o14writeContentDBs }
    # Write-Host o14writeContentDBs
    Write-Output o14enumContentDBs | Out-File -FilePath $script:_logpath -Append
    Write-Output o14writeContentDBs | Out-File -FilePath $script:_logpath -Append

    $status = o14enumCDConfig
    # Write-Host o14enumCDConfig
    if($status -eq 1) { o14writeCDConfig }
    # Write-Host o14writeCDConfig
    Write-Output o14enumCDConfig | Out-File -FilePath $script:_logpath -Append
    Write-Output o14writeCDConfig | Out-File -FilePath $script:_logpath -Append

    o14WriteEndXML
    # Write-Host o14WriteEndXML
    Write-Output o14WriteEndXML | Out-File -FilePath $script:_logpath -Append

    $dtime = " Ending run of SPSFarmReport at " + (Get-Date).ToString()
    Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $script:_logpath -Append
    Write-Output  $dtime | Out-File -FilePath $script:_logpath -Append
    Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $script:_logpath  -Append
}
catch {
    Write-Warning "OOps: $_"
}