
function Start-SPFarmReport {
	[cmdletbinding(SupportsShouldProcess = $true)]
	param ()
	try {
		#region initialize contect
		if ( $null -eq (Get-PSSnapin -Name Microsoft.Sharepoint.PowerShell -ErrorAction SilentlyContinue) ) {
			Add-PsSnapin Microsoft.Sharepoint.PowerShell -ErrorAction Stop
		}

		Write-Verbose "Loading functions"
		$scriptPath = [System.IO.Path]::GetDirectoryName($myInvocation.MyCommand.Definition)
		Get-ChildItem "$scriptPath\Lib" -Filter "function*" -Include "*.ps1" -Exclude "*.tests.ps1" -Recurse | ForEach-Object {
			Invoke-Expression ". $($_.FullName)"
		}
		Write-Verbose "Functions are loaded"

		[void][System.Reflection.Assembly]::Load("Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c")
		[void][System.Reflection.Assembly]::Load("System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
		[void][System.Reflection.Assembly]::Load("Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c")
		[void][System.Reflection.Assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")
		#endregion

		# Declaring bool variables
		$isFoundationOnlyInstalled = $false

		# Declaring all string variables
		$null = $DSN, $confgDbServerName, $confgDbName, $BuildVersion, $systemAccount = "","","","",""
		$null = $adminURL, $adminDbName, $adminDbServerName, $enterpriseSearchServiceStatus, $enterpriseSearchServiceJobDefs  = "","","","",""
		$null = $exceptionDetails = ""
		$null = $exceptionDetails

		# Declaing all integer variables
		$null = $Servernum, $totalContentDBCount, $WebAppnum, $serviceAppPoolCount, $FeatureCount = 0,0,0,0,0,0,0
		$null = $wFeatureCount, $solutionCount, $sFeatureCount, $timerJobCount = 0,0,0,0
		$null = $serviceAppProxyCount, $serviceAppProxyGroupCount, $searchsvcAppsCount  = 0, 0, 0
		$null = $SvcAppCount = 0
		$null = $SvcAppCount

		# Declaring all string[] arrays
		$null = [System.string[]] $Servers, $ServersId
		$null = [System.string[]] $searchServiceAppIds
		# remove this line man [System.string[]] $delimiterChars, $delimiterChars2, $delimiterChars3, $delimiterChars4 | Out-Null

		# Declaring all string[,] arrays
		$null = [System.string[,]] $ServicesOnServers, $WebAppDetails
		$null = [System.string[,]] $WebAppExtended, $WebAppInternalAAMURL, $WebAppPublicAAM, $WebAppAuthProviders
		$null = [System.string[,]] $ContentDBs, $ContentDBSitesNum, $solutionProps, $ContentDBProps
		$null = [System.string[,]] $FarmFeatures, $SiteFeatures, $WebFeatures

		# Declaring three dimensional arrays
		$null = [System.string[,,]] $serverProducts

		# Declaring PowerShell environment settings
		$null = $FormatEnumerationLimit = 25
		$null = $FormatEnumerationLimit

		# Declaring XML data variables
		$null = [System.Xml.XmlDocument]$XMLToParse
		$null = [System.Xml.XmlDocument]$script:CDGI
		$null = [System.Xml.XmlNode]$XmlNode

		# Declaring all Hash Tables
		$script:ServerRoles = @{}
		$script:ServiceApps = @{}
		$script:SearchHostControllers = @{}
		$script:SearchActiveTopologyComponents = @{}
		$script:SearchActiveTopologyComponentsStatus = @{}
		$script:SearchConfigAdminComponents = @{}
		$script:SearchConfigLinkStores = @{}
		$script:SearchConfigCrawlDatabases = @{}
		$script:SearchConfigCrawlRules = @{}
		$script:SearchConfigQuerySiteSettings = @{}
		$script:SearchConfigContentSources = @{}
		$script:SPServiceApplicationPools = @{}
		$script:SPServiceAppProxies = @{}
		$script:SPServiceAppProxyGroups = @{}
		$script:CDPaths = @{}
		$script:CDJobs = @{}
		$script:HealthReport0 = @{}
		$script:HealthReport1 = @{}
		$script:HealthReport2 = @{}
		$script:HealthReport3 = @{}
		$script:timerJobs = @{}
		$script:projectInstances = @{}
		$script:projectPCSSettings = @{}
		$script:projectQueueSettings = @{}
		$script:projectsvcApps= @{}
		$script:_DCacheContainers= @{}
		$script:_DCacheHosts= @{}

		# Declaring all Hard-Coded values
		$script:_maxServicesOnServers = 75 # This value indicates the maximum number of services that run on each server.
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
		$script:_logpath = [Environment]::CurrentDirectory + "\2016SPSFarmReport{0}{1:d2}{2:d2}-{3:d2}{4:d2}" -f (Get-Date).Day,(Get-Date).Month,(Get-Date).Year,(Get-Date).Second,(Get-Date).Millisecond + ".LOG"
		$script:_DCacheContainerNames = @("DistributedAccessCache", "DistributedActivityFeedCache", "DistributedActivityFeedLMTCache", "DistributedBouncerCache", "DistributedDefaultCache", "DistributedFileLockThrottlerCache", "DistributedHealthScoreCache", "DistributedLogonTokenCache", "DistributedResourceTallyCache", "DistributedSecurityTrimmingCache", "DistributedServerToAppServerAccessTokenCache", "DistributedSharedWithUserCache", "DistributedUnifiedGroupsCache", "DistributedSearchCache" )

		#region init
		$dtime = " Starting run of SPSFarmReport at " + (Get-Date).ToString()
		Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $script:_logpath -Append
		Write-Output  $dtime | Out-File -FilePath $script:_logpath -Append
		Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $script:_logpath -Append

		o16WriteInitialXML
		$dtime = " Completed running o16WriteInitialXML at " + (Get-Date).ToString()
		Write-Information o16WriteInitialXML
		Write-Output  $dtime | Out-File -FilePath $script:_logpath -Append
		#endregion init

		#region farm config
		$status = o16farmConfig
		$dtime = " Completed running o16farmConfig at " + (Get-Date).ToString()
		Write-Information o16farmConfig
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			o16WriteFarmGenSettings
			$dtime = " Completed running o16WriteFarmGenSettings at " + (Get-Date).ToString()
			Write-Information o16WriteFarmGenSettings
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}
		#endregion farm config

		#region servers
		$status = o16enumServers
		$dtime = " Completed running o16enumServers at " + (Get-Date).ToString()
		Write-Output o16enumServers
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			o16writeServers
			$dtime = " Completed running o16writeServers at " + (Get-Date).ToString()
			Write-Information o16writeServers
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}
		#endregion servers

		#region distributed cache
		$status = o16enumSPDcacheConfig
		$dtime = " Completed running o16enumSPDcacheConfig at " + (Get-Date).ToString()
		Write-Output o16enumSPDcacheConfig
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			o16writeDCacheConfig
			$dtime = " Completed running o16writeDCacheConfig at " + (Get-Date).ToString()
			Write-Information o16writeDCacheConfig
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}
		#endregion distributed cache

		$status = o16enumProdVersions
		$dtime = " Completed running o16enumProdVersions at " + (Get-Date).ToString()
		Write-Information o16enumProdVersions
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			o16writeProdVersions2
			$dtime = " Completed running o16writeProdVersions2 at " + (Get-Date).ToString()
			Write-Information o16writeProdVersions2
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}

		$status = o16enumFeatures
		$dtime = " Completed running o16enumFeatures at " + (Get-Date).ToString()
		Write-Information o16enumFeatures
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			o16writeFeatures
			$dtime = " Completed running o16writeFeatures at " + (Get-Date).ToString()
			Write-Information o16writeFeatures
			Write-Output $dtime	| Out-File -FilePath $script:_logpath -Append
		}

		$status = o16enumSolutions
		$dtime = " Completed running o16enumSolutions at " + (Get-Date).ToString()
		Write-Information o16enumSolutions
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			o16writeSolutions
			$dtime = " Completed running o16writeSolutions at " + (Get-Date).ToString()
			Write-Information o16writeSolutions
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}


		$status = o16enumSvcApps
		$dtime = " Completed running o16enumSvcApps at " + (Get-Date).ToString()
		Write-Information  o16enumSvcApps
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append

		if($status -eq 1) { o16enumSPSearchServiceApps }
		Write-Information o16enumSPSearchServiceApps
		if($status -eq 1) { o16enumSPSearchService }
		Write-Information o16enumSPSearchService
		if($status -eq 1) { o16enumHostControllers }
		Write-Information o16enumHostControllers
		if($status -eq 1) { o16enumSearchActiveTopologies }
		Write-Information o16enumSearchActiveTopologies
		if($status -eq 1) { o16enumSearchConfigAdminComponents }
		Write-Information o16enumSearchConfigAdminComponents
		if($status -eq 1) { o16enumSearchConfigLinkStores }
		Write-Information o16enumSearchConfigLinkStores
		if($status -eq 1) { o16enumSearchConfigCrawlDatabases }
		Write-Information o16enumSearchConfigCrawlDatabases
		if($status -eq 1) { o16enumSearchConfigCrawlRules }
		Write-Information o16enumSearchConfigCrawlRules
		if($status -eq 1) { o16enumSearchConfigQuerySiteSettings }
		Write-Information o16enumSearchConfigQuerySiteSettings
		if($status -eq 1) { o16enumSearchConfigContentSources }
		Write-Information o16enumSearchConfigContentSources
		if($status -eq 1) { o16enumProjectServiceApps }
		Write-Information o16enumProjectServiceApps

		if($status -eq 1) {
			o16writeServiceApps
			$dtime = " Completed running o16writeServiceApps at " + (Get-Date).ToString()
			Write-Information o16writeServiceApps
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}

		$status = o16enumSPServiceApplicationPools
		$dtime = " Completed running o16enumSPServiceApplicationPools at " + (Get-Date).ToString()
		Write-Information o16enumSPServiceApplicationPools
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			o16writeSPServiceApplicationPools
			$dtime = " Completed running o16writeSPServiceApplicationPools at " + (Get-Date).ToString()
			Write-Information o16writeSPServiceApplicationPools
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}

		$status = o16enumSPServiceApplicationProxies
		$dtime = " Completed running o16enumSPServiceApplicationProxies at " + (Get-Date).ToString()
		Write-Information o16enumSPServiceApplicationProxies
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			o16writeSPServiceApplicationProxies
			$dtime = " Completed running o16writeSPServiceApplicationProxies at " + (Get-Date).ToString()
			Write-Information o16writeSPServiceApplicationProxies
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}

		$status = o16enumSPServiceApplicationProxyGroups
		$dtime = " Completed running o16enumSPServiceApplicationProxyGroups at " + (Get-Date).ToString()
		Write-Information o16enumSPServiceApplicationProxyGroups
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			o16writeSPServiceApplicationProxyGroups
			$dtime = " Completed running o16writeSPServiceApplicationProxyGroups at " + (Get-Date).ToString()
			Write-Information o16writeSPServiceApplicationProxyGroups
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}

		$status = o16enumWebApps
		$dtime = " Completed running o16enumWebApps at " + (Get-Date).ToString()
		Write-Information o16enumWebApps
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			Write-SPSRWebApp
			$dtime = " Completed running Write-SPSRWebApp at " + (Get-Date).ToString()
			Write-Information "Write-SPSRWebApp"
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append

			o16writeAAMsnAPs
			$dtime = " Completed running o16writeAAMsnAPs at " + (Get-Date).ToString()
			Write-Information o16writeAAMsnAPs
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}

		$status = o16enumContentDBs
		$dtime = " Completed running o16enumContentDBs at " + (Get-Date).ToString()
		Write-Information o16enumContentDBs
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			o16writeContentDBs
			$dtime = " Completed running o16writeContentDBs at " + (Get-Date).ToString()
			Write-Information o16writeContentDBs
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}

		if($isFoundationOnlyInstalled -eq $false)
		{
			$status = o16enumCDConfig
			$dtime = " Completed running o16enumCDConfig at " + (Get-Date).ToString()
			Write-Information o16enumCDConfig
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
			if($status -eq 1) {
				o16writeCDConfig
				$dtime = " Completed running o16writeCDConfig at " + (Get-Date).ToString()
				Write-Information o16writeCDConfig
				Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
			}
		}

		$status = o16enumHealthReport
		$dtime = " Completed running o16enumHealthReport at " + (Get-Date).ToString()
		Write-Information o16enumHealthReport
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			o16writeHealthReport
			$dtime = " Completed running o16writeHealthReport at " + (Get-Date).ToString()
			Write-Information o16writeHealthReport
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}

		$status = o16enumTimerJobs
		$dtime = " Completed running o16enumTimerJobs at " + (Get-Date).ToString()
		Write-Information o16enumTimerJobs
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		if($status -eq 1) {
			Write-SPSRTimerJob
			$dtime = " Completed running Write-SPSRTimerJob at " + (Get-Date).ToString()
			Write-Information "Write-SPSRTimerJob"
			Write-Output $dtime | Out-File -FilePath $script:_logpath -Append
		}

		o16WriteEndXML
		Write-Information o16WriteEndXML
		$dtime = " Completed running o16WriteEndXML at " + (Get-Date).ToString()
		Write-Output $dtime | Out-File -FilePath $script:_logpath -Append

		$dtime = " Ending run of SPSFarmReport at " + (Get-Date).ToString()
		Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $script:_logpath -Append
		Write-Output  $dtime | Out-File -FilePath $script:_logpath -Append
		Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $script:_logpath  -Append
	}
	catch {
		Write-Error $_
	}

}
