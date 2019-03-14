if ( (Get-PSSnapin -Name Microsoft.Sharepoint.PowerShell -ErrorAction SilentlyContinue) -eq $null )
{
    Add-PsSnapin Microsoft.Sharepoint.PowerShell
}

[void][System.Reflection.Assembly]::Load("Microsoft.SharePoint, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c")
[void][System.Reflection.Assembly]::Load("System.Web, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b03f5f7f11d50a3a")
[void][System.Reflection.Assembly]::Load("Microsoft.SharePoint.Publishing, Version=16.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c")
[void][System.Reflection.Assembly]::Load("System.Data, Version=2.0.0.0, Culture=neutral, PublicKeyToken=b77a5c561934e089")

# Declaring bool variables
$isFoundationOnlyInstalled = $false

# Declaring all string variables
$DSN, $confgDbServerName, $confgDbName, $BuildVersion, $systemAccount = "","","","","" | Out-Null
$adminURL, $adminDbName, $adminDbServerName, $enterpriseSearchServiceStatus, $enterpriseSearchServiceJobDefs  = "","","","","" | Out-Null
$exceptionDetails = "" | Out-Null

# Declaing all integer variables
$Servernum, $totalContentDBCount, $WebAppnum, $serviceAppPoolCount, $FeatureCount = 0,0,0,0,0,0,0 | Out-Null
$wFeatureCount, $solutionCount, $sFeatureCount, $timerJobCount = 0,0,0,0 | Out-Null
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
[System.Xml.XmlDocument]$global:CDGI | Out-Null
[System.Xml.XmlNode]$XmlNode | Out-Null

# Declaring all Hash Tables
$global:ServerRoles = @{}
$global:ServiceApps = @{}
$global:SearchHostControllers = @{}
$global:SearchActiveTopologyComponents = @{}
$global:SearchActiveTopologyComponentsStatus = @{}
$global:SearchConfigAdminComponents = @{}
$global:SearchConfigLinkStores = @{}
$global:SearchConfigCrawlDatabases = @{}
$global:SearchConfigCrawlRules = @{}
$global:SearchConfigQuerySiteSettings = @{}
$global:SearchConfigContentSources = @{}
$global:SPServiceApplicationPools = @{}
$global:SPServiceAppProxies = @{}
$global:SPServiceAppProxyGroups = @{}
$global:CDPaths = @{}
$global:CDJobs = @{}
$global:HealthReport0 = @{}
$global:HealthReport1 = @{}
$global:HealthReport2 = @{}
$global:HealthReport3 = @{}
$global:timerJobs = @{} 
$global:projectInstances = @{} 
$global:projectPCSSettings = @{} 
$global:projectQueueSettings = @{} 
$global:projectsvcApps= @{} 
$global:_DCacheContainers= @{}
$global:_DCacheHosts= @{}

# Declaring all Hard-Coded values
$global:_maxServicesOnServers = 75 # This value indicates the maximum number of services that run on each server.
$global:_maxProductsonServer = 15 # This value indicates the maximum number of Products installed on each server.
$global:_maxItemsonServer = 200 # This value indicates the maximum number of Items installed per Product on each server.
$global:_maxContentDBs = 141 # This is the maximum number of content databases we enumerate per web application.
$global:_serviceTypeswithNames = @{"Microsoft.Office.Server.Search.Administration.SearchQueryAndSiteSettingsService" = "Search Query and Site Settings Service" ; "Microsoft.Office.Server.ApplicationRegistry.SharedService.ApplicationRegistryService" = "Application Registry Service"} # This varialble is used to translate service names to friendly names.
$global:_farmFeatureDefinitions = @{"AccSrvApplication" = "Access Services Farm Feature"; # This varialble is used to feature definition names to friendly names.
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
$global:_logpath = [Environment]::CurrentDirectory + "\2016SPSFarmReport{0}{1:d2}{2:d2}-{3:d2}{4:d2}" -f (Get-Date).Day,(Get-Date).Month,(Get-Date).Year,(Get-Date).Second,(Get-Date).Millisecond + ".LOG"
$global:_DCacheContainerNames = @("DistributedAccessCache", "DistributedActivityFeedCache", "DistributedActivityFeedLMTCache", "DistributedBouncerCache", "DistributedDefaultCache", "DistributedFileLockThrottlerCache", "DistributedHealthScoreCache", "DistributedLogonTokenCache", "DistributedResourceTallyCache", "DistributedSecurityTrimmingCache", "DistributedServerToAppServerAccessTokenCache", "DistributedSharedWithUserCache", "DistributedUnifiedGroupsCache", "DistributedSearchCache" )

function global:PSUsing 
{    param 
    (        
        [System.IDisposable] $inputObject = $(throw "The parameter -inputObject is required."),        
        [ScriptBlock] $scriptBlock = $(throw "The parameter -scriptBlock is required.")    
     )     
     Try 
     {        
        &$scriptBlock    
     } 
     Finally 
     {        
        if ($inputObject -ne $null) 
        {            
            if ($inputObject.psbase -eq $null) {                $inputObject.Dispose()            } 
            else {                $inputObject.psbase.Dispose()            }        
        }    
    }
}

function o16farmConfig()
{
    try
    {
            
            $global:DSN = Get-ItemProperty "hklm:SOFTWARE\Microsoft\Shared Tools\Web Server Extensions\16.0\Secure\configdb" | select dsn | Format-Table -HideTableHeaders | Out-String -Width 1024
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
				
				$productsNum = ((($mySPFarm.Products | ft -HideTableHeaders | Out-String).Trim()).Split("`n")).Count
				if($productsNum -eq 1)
				{ $global:isFoundationOnlyInstalled = $true }
				return 1
    } 
    
    catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		global:HandleException("o15farmConfig", $_)
		return 0
    } 
}

function o16enumServers()
{
    try
    {
        [Microsoft.SharePoint.Administration.SPFarm] $mySPFarm = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm
        [Microsoft.SharePoint.Administration.SPServerCollection] $mySPServerCollection = $mySPFarm.Servers
        
        #To get the number of servers in farm
        $global:Servernum = $mySPServerCollection.Count
        $global:ServicesOnServers = new-object 'System.String[,]' $global:Servernum, $global:_maxServicesOnServers 
        $global:Servers = new-object 'System.String[]' $global:Servernum
        $global:ServersId = new-object 'System.String[]' $global:Servernum
        $local:count, $ServicesCount, $count2 = 0,0,0
        [Microsoft.SharePoint.Administration.SPServer] $ServerInstance  
        foreach ($ServerInstance in $mySPServerCollection)
        {
            $tempstr = ""
            $count2 = 0
            $Servers[$count] = $ServerInstance.Address
            $ServersId[$count] = $ServerInstance.Id.ToString()
            $ServicesCount = $ServerInstance.ServiceInstances.Count
            $global:ServicesOnServers[$local:count, ($global:_maxServicesOnServers - 1)] = $ServerInstance.ServiceInstances.Count.ToString()
            foreach ($serviceInstance in $ServerInstance.ServiceInstances)
            {
                if(($serviceInstance.Hidden -eq $FALSE) -and ($serviceInstance.Status.ToString().Trim().ToLower() -eq "online"))    
                {
					if($global:_serviceTypeswithNames.ContainsKey($serviceInstance.Service.TypeName))
					{
						$ServicesOnServers[$count, $count2] = $global:_serviceTypeswithNames.Get_Item($serviceInstance.Service.TypeName)
					}
					else
					{
						$ServicesOnServers[$count, $count2] = $serviceInstance.Service.TypeName
					}
					$count2++
				}                    
             }
             $tempstr = $ServerInstance.Role.ToString()
             $tempstr += ","
             if ($ServerInstance.CompliantWithMinRole -eq $null ) { $tempstr += "Unknown - Check in Central Admin" }
             else { $tempstr += $ServerInstance.CompliantWithMinRole }
             $global:ServerRoles.Add($ServerInstance.Name, $tempstr)
			 $count = $count + 1             
        }                   
        return 1
    }
    catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		global:HandleException("o15enumServers", $_)
		return 0
    }    
}

function o16enumSPDcacheConfig()
{
	try
	{
        $count = 0
        Use-CacheCluster 
        $hostdetails = Get-CacheHost            
        if($hostdetails.Length -lt 2)
        {
                $global:XMLToParse = New-Object System.Xml.XmlDocument
                $global:XMLToParse = [xml] ($hostdetails[$count]  | ConvertTo-Xml -notypeinformation)
                $tempstr = [System.String]$global:XMLToParse.Objects.Object.InnerXml
                $global:_DCacheHosts.Add($hostdetails.Hostname, $tempstr)
        }
        else
        {     
                $hostdetails.GetEnumerator() | ForEach-Object {        
                $global:XMLToParse = New-Object System.Xml.XmlDocument
                $global:XMLToParse = [xml] ($hostdetails[$count]  | ConvertTo-Xml -notypeinformation)
                $tempstr = [System.String]$global:XMLToParse.Objects.Object.InnerXml
                $global:_DCacheHosts.Add($_.Hostname, $tempstr)
                $count++
                } 
        }

        ForEach($container in $global:_DCacheContainerNames)
        {
			$global:XMLToParse = New-Object System.Xml.XmlDocument
			$global:XMLToParse = [xml] (get-SPDistributedCacheClientSetting $container  | ConvertTo-Xml -notypeinformation)
			$tempstr = [System.String]$global:XMLToParse.Objects.Object.InnerXml
			$global:_DCacheContainers.Add($container, $tempstr)
		}	
		return 1
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSPServiceApplicationPools", $_)
		return 0
    }
}

function o16enumProdVersions()
{
    try
    {
        $global:serverProducts = new-object 'System.String[,,]' $global:Servernum, $global:_maxProductsonServer, $global:_maxItemsonServer
        $count = $global:Servernum - 1
        $count2, $count3 = 0,0

        [Microsoft.SharePoint.Administration.SPProductVersions] $versions = [Microsoft.SharePoint.Administration.SPProductVersions]::GetProductVersions()
        $infos = New-Object 'System.Collections.Generic.List[Microsoft.SharePoint.Administration.SPServerProductInfo]' (,$versions.ServerInformation)
        
        foreach ($prodInfo in $infos)
        {
            $count2 = 0;
            $count3 = 0;
            $products = New-Object 'System.Collections.Generic.List[System.String]' (,$prodInfo.Products)
            $products.Sort()
            $global:serverProducts[$count, $count2, $count3] = $prodInfo.ServerName
            foreach ($str in $products)
            {
                $count2++
                $serverProducts[$count, $count2, $count3] = $str
                $singleProductInfo = $prodInfo.GetSingleProductInfo($str)
                $patchableUnitDisplayNames = New-Object 'System.Collections.Generic.List[System.String]' (,$singleProductInfo.PatchableUnitDisplayNames)
                $patchableUnitDisplayNames.Sort()
                foreach ($str2 in $patchableUnitDisplayNames)
                {
                    $patchableUnitInfoByDisplayName = New-Object 'System.Collections.Generic.List[Microsoft.SharePoint.Administration.SPPatchableUnitInfo]' (,$singleProductInfo.GetPatchableUnitInfoByDisplayName($str2))
                    foreach ($info in $patchableUnitInfoByDisplayName)
                    {
                        $count3++;
                        $version = [Microsoft.SharePoint.Utilities.SPHttpUtility]::HtmlEncode($info.BaseVersionOnServer($prodInfo.ServerId).ToString())
                        $serverProducts[$count, $count2, $count3] = $info.DisplayName + " : " + $info.LatestPatchOnServer($prodInfo.ServerId).Version.ToString() 
                     }
                     $serverProducts[$count, $count2, ($global:_maxItemsonServer - 1)] = $count3.ToString()
                }
                $serverProducts[$count, ($global:_maxProductsonServer - 1), ($_maxItemsonServer - 1)] = $count2.ToString()
                $count3 = 0
            }
            $count--
        }
        return 1
    }
    catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumProdVersions", $_)
		return 0
    }
}

function o16enumFeatures()
{
            try
            {
                $bindingFlags = [System.Reflection.BindingFlags] “NonPublic,Instance”
                [Microsoft.SharePoint.Administration.SPFarm] $mySPFarm = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm
                $global:FeatureCount = 0
                $FeatureCount2 = 0
                #PropertyInfo pi;

                #to retrieve the number of features deployed in farm
                foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions)
                {
                    if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Farm"))
                    {
                        $global:FeatureCount++
                    }
                }
                $global:FarmFeatures = new-object 'System.String[,]' $global:FeatureCount, 4;

                #to retrieve the properties
                foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions)
                {
                    if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Farm"))
                    {
						if($global:_farmFeatureDefinitions.ContainsKey($FeatureDefinition.DisplayName))
						{ $global:FarmFeatures[$FeatureCount2, 1] = $global:_farmFeatureDefinitions.Get_Item($FeatureDefinition.DisplayName)	}
						else {	$FarmFeatures[$FeatureCount2, 1] = $FeatureDefinition.DisplayName }
					
						$FarmFeatures[$FeatureCount2, 0] = $FeatureDefinition.Id.ToString()
						$FarmFeatures[$FeatureCount2, 2] = $FeatureDefinition.SolutionId.ToString()
						$pi = $FeatureDefinition.GetType().GetProperty("HasActivations", $bindingFlags)
						$FarmFeatures[$FeatureCount2, 3] = $pi.GetValue($FeatureDefinition, $null).ToString()				
                        $FeatureCount2++
                    }
                }

                $global:sFeatureCount = 0
                $FeatureCount2 = 0
                foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions)
                {
                    if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Site"))
                    {
                        $global:sFeatureCount++
                    }
                }
                $global:SiteFeatures = new-object 'System.String[,]' $global:sFeatureCount, 4
                foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions)
                {
                    if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Site"))
                    {
                        $global:SiteFeatures[$FeatureCount2, 0] = $FeatureDefinition.Id.ToString()
                        $SiteFeatures[$FeatureCount2, 1] = $FeatureDefinition.DisplayName
                        $SiteFeatures[$FeatureCount2, 2] = $FeatureDefinition.SolutionId.ToString()
                        $pi = $FeatureDefinition.GetType().GetProperty("HasActivations", $bindingFlags)
                        $SiteFeatures[$FeatureCount2, 3] = $pi.GetValue($FeatureDefinition, $null).ToString()
                        $FeatureCount2++
                    }
                }

                $global:wFeatureCount = 0
                $FeatureCount2 = 0
                foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions)
                {
                    if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Web"))
                    {
                        $global:wFeatureCount++
                    }
                }
                $global:WebFeatures = new-object 'System.String[,]' $global:wFeatureCount, 4
                foreach ($FeatureDefinition in $mySPFarm.FeatureDefinitions)
                {
                    if (($FeatureDefinition.Hidden.ToString() -ne "true") -and ($FeatureDefinition.Scope.ToString() -eq "Web"))
                    {
                        $WebFeatures[$FeatureCount2, 0] = $FeatureDefinition.Id.ToString()
                        $WebFeatures[$FeatureCount2, 1] = $FeatureDefinition.DisplayName
                        $WebFeatures[$FeatureCount2, 2] = $FeatureDefinition.SolutionId.ToString()
                        $pi = $FeatureDefinition.GetType().GetProperty("HasActivations", $bindingFlags)
                        $WebFeatures[$FeatureCount2, 3] = $pi.GetValue($FeatureDefinition, $null).ToString()
                        $FeatureCount2++;
                    }
                }
        return 1
    }
    catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumFeatures", $_)
		return 0
    }
}

function o16enumSolutions()
{
	try
	{
		$global:solutionCount = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm.Solutions.Count
        $global:solutionProps = New-Object 'System.String[,]' $global:solutionCount, 6
        $count = 0
        foreach ($solution in [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm.Solutions)
        {
            $global:solutionProps[$count, 0] = $solution.DisplayName
            $global:solutionProps[$count, 1] = $solution.Deployed.ToString()
            $global:solutionProps[$count, 2] = $solution.LastOperationDetails
            $global:solutionProps[$count, 5] = $solution.Id.ToString()

            foreach ($deployedServer in $solution.DeployedServers)
            {
                if ($global:solutionProps[$count, 3] -eq $null)
                {
                    if ($deployedServer.Address -eq $null)
					{ $global:solutionProps[$count, 3] = "" }
                    else
                        { $global:solutionProps[$count, 3] = $deployedServer.Address }
                }
                else
                    { $global:solutionProps[$count, 3] = $global:solutionProps[$count, 3] + "<br>" + $deployedServer.Address }
            }
            $count = $count + 1
        }
		return 1
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSolutions", $_)
		return 0
    }
}

function o16enumSvcApps() 
{
    try
    {                
		$global:SvcAppCount = (Get-SPServiceApplication).Length

		$svcApps = Get-SPServiceApplication | Select Id | Out-String -Width 1000
		$delimitLines =  $svcApps.Split("`n")
	
        ForEach($ServiceAppID in $delimitLines)
        {
			$ServiceAppID = $ServiceAppID.Trim()
			if (($ServiceAppID -eq "") -or ($ServiceAppID -eq "Id") -or ($ServiceAppID -eq "--")) { continue }
			$global:XMLToParse = New-Object System.Xml.XmlDocument
			$global:XMLToParse = [xml](Get-SPServiceApplication | where {$_.Id -eq $ServiceAppID} | ConvertTo-XML -NoTypeInformation)
			
			$typeName = $global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" } 
			if($typeName -eq $null)
			{
				$tempstr = ($global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "Name" }).InnerText
			}
			else
			{
				$tempstr = ($global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" }).InnerText
			}
						
			$ServiceAppID = $ServiceAppID + "|" + $tempstr
			$tempstr2 = [System.String]$global:XMLToParse.Objects.Object.InnerXml
			$global:ServiceApps.Add($ServiceAppID, $tempstr2)
        }
		return 1
    }
    catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSvcApps", $_)
		return 0
    }
}

function o16enumSPSearchServiceApps()
{
	try
	{
		$searchsvcApps = Get-SPServiceApplication | where {$_.typename -eq "Search Service Application"} | select Id | fl | Out-String -Width 1000
		$global:searchsvcAppsCount = 0
		$delimitLines = $searchsvcApps.Trim().Split("`n")
		ForEach($Liner in $delimitLines) 
		{	
			if($liner.Trim().Length -eq 0) { continue } 
			$global:searchsvcAppsCount++	
		}
		$global:searchServiceAppIds = new-object 'System.String[]' $global:searchsvcAppsCount
		$x = $global:searchsvcAppsCount - 1 
        ForEach($Liner in $delimitLines)
        {
            $Liner = $Liner.Trim()
            if($Liner.Length -eq 0)
            { continue }
            if($Liner.Contains("Id"))
            {
				$tempstr = $Liner -split " : "
                $global:searchServiceAppIds[$x] = $tempstr[1]   
				$x--
				if($x -lt 0)
				{ break }
            }
        }
		return 1 | Out-Null
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSPSearchServiceApps", $_)
		return 0
    }		
}

function o16enumProjectServiceApps()
{
	try
	{
        $global:projectsvcApps = Get-SPServiceApplication | where {$_.typename -eq "Project Application Services"} 
        $instcount=(Get-SPProjectWebInstance).Length
		$prjInst = Get-SPProjectWebInstance | Select Id | Out-String -Width 1000
		$delimitLines =  $prjInst.Split("`n")
	    $global:projectPCSSettings = Get-SPProjectPCSSettings
        $global:projectQueueSettings=Get-SPProjectQueueSettings
        ForEach($instID in $delimitLines)
        {
			$instID = $instID.Trim()
			if (($instID -eq "") -or ($instID -eq "Id") -or ($instID -eq "--")) { continue }
			$global:XMLToParse = New-Object System.Xml.XmlDocument
			$global:XMLToParse = [xml](Get-SPProjectWebInstance | where {$_.Id -eq $instID} | ConvertTo-XML -NoTypeInformation)
			
			$typeName = $global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" } 
			if($typeName -eq $null)
			{
				$tempstr = ($global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "Name" }).InnerText
			}
			else
			{
				$tempstr = ($global:XMLToParse.Objects.Object.Property | where { $_.Name -eq "TypeName" }).InnerText
			}
						
			$instID = $instID + "|" + $tempstr
			$tempstr2 = [System.String]$global:XMLToParse.Objects.Object.InnerXml
			$global:projectInstances.Add($instID, $tempstr2)
        }
		return 1 | Out-Null
		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumProjectServiceApps", $_)
		return 0
    }		
}

function o16enumSPSearchService()
{
	try
	{
		$searchsvc = Get-SPEnterpriseSearchService 
		$_ato = ($searchsvc.AcknowledgementTimeout).ToString()
		$_cto = ($searchsvc.ConnectionTimeout).ToString()
		$_wproxy = ($searchsvc.WebProxy).ToString()
		$_ucpf = ($searchsvc.UseCrawlProxyForFederation).ToString()
		$_pl = ($searchsvc.PerformanceLevel).ToString()
		$_pi = ($searchsvc.ProcessIdentity).ToString()

		foreach($jd in $searchsvc.JobDefinitions)
		{
			#$jdx = ($jd | Select NAme, Schedule, LastRunTime, Server | ConvertTo-Xml -NoTypeInformation)
			$jd_Name = $jd | Select Name | ft -HideTableHeaders | Out-String
			$jd_Schedule = $jd | Select Schedule | ft -HideTableHeaders | Out-String
			$jd_LastRunTime = $jd | Select LastRunTime | ft -HideTableHeaders | Out-String
			$jd_Server = $jd | Select Server | ft -HideTableHeaders | Out-String
			
			$jd_Name = $jd_Name.Trim()
			$jd_Schedule = $jd_Schedule.Trim()
			$jd_LastRunTime = $jd_LastRunTime.Trim()
			$jd_Server = $jd_Server.Trim()
			
			$ejob = $ejob + "<job Name=`"" + $jd_Name + "`" Schedule=`"" + $jd_Schedule + "`" LastRunTime=`"" + $jd_LastRunTime +  "`" Server=`""  + $jd_Server + "`" />"
		}
		$tempXML = "<Property Name = `"AcknowledgementTimeout`">" + $_ato + "</Property>" + "<Property Name =`"ConnectionTimeout`">" + $_cto + "</Property>" + "<Property Name =`"WebProxy`">" + $_wproxy + "</Property>" + "<Property Name =`"UseCrawlProxyForFederation`">" + $_ucpf + "</Property>" + "<Property Name =`"PerformanceLevel`">" + $_pl + "</Property>" + "<Property Name =`"ProcessIdentity`">" + $_pi + "</Property>"
		
		$global:enterpriseSearchServiceStatus = $tempXML 
		$global:enterpriseSearchServiceJobDefs = $ejob 
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSPSearchServiceApps", $_)
		return 0
    }		
}

function o16enumSearchActiveTopologies()
{
	try
	{
		if($global:searchsvcAppsCount -eq 0)
		{ 		return 		}
		
		for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++)	
		{
			$esa = Get-SPEnterpriseSearchServiceApplication -Identity $global:searchServiceAppIds[$tempCnt]			
			$searchServiceAppID = $searchServiceAppIds[$tempCnt]
			$searchSatus = Get-SPEnterpriseSearchStatus -SearchApplication $searchServiceAppID -ErrorAction SilentlyContinue			
				$ATComponentNames = $esa.ActiveTopology.GetComponents() | Select Name | ft -HideTableHeaders | Out-String -Width 1000
				$ATComponentNames = $ATComponentNames.Trim().Split("`n")			
			for($i = 0; $i -lt $ATComponentNames.Length ; $i++)
			{
				$tempXML = [xml] ($esa.ActiveTopology.GetComponents() | where {$_.Name -eq $ATComponentNames[$i].Trim() } | ConvertTo-Xml -NoTypeInformation)
				if($searchSatus -ne $null)
				{
					$tempXML2 = [xml] (Get-SPEnterpriseSearchStatus -SearchApplication $searchServiceAppID | ? {$_.Name -eq $ATComponentNames[$i].Trim()} | select State | ConvertTo-Xml -NoTypeInformation)
					$tempXML3 = [xml] (Get-SPEnterpriseSearchStatus -SearchApplication $searchServiceAppID | ? {$_.Name -eq $ATComponentNames[$i].Trim()} | select Details | ConvertTo-Xml -NoTypeInformation)
				}
				
				$tempstr = [System.String] $tempXML.Objects.Object.InnerXML
				$tempstr2 = [System.String] $tempXML2.Objects.Object.InnerXML
				$tempstr3 = [System.String] $tempXML3.Objects.Object.InnerXML
				$tempstr4 = $searchServiceAppID + "|" + $ATComponentNames[$i]	
				$tempstr = $tempstr + $tempstr2 + $tempstr3
				$global:SearchActiveTopologyComponents.Add($tempstr4, $tempstr)
			}
		}		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchActiveTopologies", $_)
    }
}

function o16enumHostControllers()
{
	try
	{
		if($global:searchsvcAppsCount -eq 0)
		{ 		return 		}

		for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++)	
		{
			$cmdstr = Get-SPEnterpriseSearchHostController | Select Server | ft -HideTableHeaders | Out-String -Width 1000
			$cmdstr = $cmdstr.Trim().Split("`n")
			
			for($i = 0; $i -lt $cmdstr.Length ; $i++)
			{
				$cmdstr2 = $cmdstr[$i].Trim() 
				$searchServiceAppID = $searchServiceAppIds[$tempCnt]
				$tempXML = [xml] ( Get-SPEnterpriseSearchHostController | where {$_.Server -match $cmdstr2 } | ConvertTo-Xml -NoTypeInformation)
				$tempstr = [System.String] $tempXML.Objects.Object.InnerXML
				$searchServiceAppID = $searchServiceAppID + "|" + $cmdstr2				 
				$global:SearchHostControllers.Add($searchServiceAppID, $tempstr)
			}			
		}		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		global:HandleException("o15enumHostControllers", $_)
		return 0
    } 
}

function o16enumSearchConfigAdminComponents()
{
	try
	{
		if($global:searchsvcAppsCount -eq 0)
		{ 		return 		}
		for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++)	
		{
			$searchServiceAppID = $searchServiceAppIds[$tempCnt]			
			$tempXML = [xml] (Get-SPEnterpriseSearchAdministrationComponent -SearchApplication $searchServiceAppID | ConvertTo-Xml -NoTypeInformation )
			$tempstr = [System.String] $tempXML.Objects.Object.InnerXML
			$global:SearchConfigAdminComponents.Add($searchServiceAppID, $tempstr )
		}		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchConfigAdminComponents", $_)
    }
}

function o16enumSearchConfigLinkStores()
{
	try
	{
		if($global:searchsvcAppsCount -eq 0)
		{ 		return 		}
		for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++)	
		{
			$searchServiceAppID = $searchServiceAppIds[$tempCnt]			
			$ssa = Get-SPEnterpriseSearchServiceApplication -Identity $searchServiceAppID
			$tempXML = [xml] ($ssa.LinksStores | ConvertTo-Xml -NoTypeInformation )
			$tempstr = [System.String] $tempXML.Objects.Object.InnerXML
			$global:SearchConfigLinkStores.Add($searchServiceAppID, $tempstr )
		}		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchConfigLinkStores", $_)
    }
}

function o16enumSearchConfigCrawlDatabases() 
{
	try
	{
		if($global:searchsvcAppsCount -eq 0)
		{ 		return 		}

		for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++)	
		{
			$crawlDatabasesPerSearchApp = Get-SPEnterpriseSearchCrawlDatabase -SearchApplication $global:searchServiceAppIds[$tempCnt] | Select Id | ft -HideTableHeaders | Out-String -Width 1000
			$crawlDatabasesPerSearchApp = $crawlDatabasesPerSearchApp.Trim().Split("`n")
			for($i = 0; $i -lt $crawlDatabasesPerSearchApp.Length ; $i++)
			{
				$searchServiceAppID = $searchServiceAppIds[$tempCnt]
				$tempXML = [xml] (Get-SPEnterpriseSearchCrawlDatabase -SearchApplication $global:searchServiceAppIds[$tempCnt] | where {$_.Id -eq $crawlDatabasesPerSearchApp[$i] } | ConvertTo-Xml -NoTypeInformation)
				$tempstr = [System.String] $tempXML.Objects.Object.InnerXML
				$searchServiceAppID = $searchServiceAppID + "|" + $crawlDatabasesPerSearchApp[$i]				 
				$global:SearchConfigCrawlDatabases.Add($searchServiceAppID, $tempstr)
			}			
		}		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchConfigCrawlDatabases", $_)
    }
}

function o16enumSearchConfigCrawlRules() 
{
	try
	{
		if($global:searchsvcAppsCount -eq 0)
		{ 		return 		}
		
		for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++)	
		{
			$CrawlRuleNames = Get-SPEnterpriseSearchCrawlRule -SearchApplication $global:searchServiceAppIds[$tempCnt] | Select AccountName | ft -HideTableHeaders | Out-String -Width 1000
			$CrawlRuleNames = $CrawlRuleNames.Trim().Split("`n")
			for($i = 0; $i -lt $CrawlRuleNames.Length ; $i++)
			{
				$searchServiceAppID = $searchServiceAppIds[$tempCnt]
				$tempXML = [xml] (Get-SPEnterpriseSearchCrawlRule -SearchApplication $global:searchServiceAppIds[$tempCnt] | ? {$_.AccountName -eq $CrawlRuleNames[$i]}| ConvertTo-Xml -NoTypeInformation)
				$tempstr = [System.String] $tempXML.Objects.Object.InnerXML
				$searchServiceAppID = $searchServiceAppID + "|" + $CrawlRuleNames[$i]					
				$global:SearchConfigCrawlRules.Add($searchServiceAppID, $tempstr)
			}
		}		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchConfigCrawlRules", $_)
    }
}

function o16enumSearchConfigQuerySiteSettings() 
{
	try
	{
		if($global:searchsvcAppsCount -eq 0)
		{ 		return 		}
		
		for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++)	
		{
			$querySiteSettingsId = Get-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance | ? {$_.status -ne "Disabled"} | Select Id | ft -HideTableHeaders | Out-String -Width 1000
			$querySiteSettingsId = $querySiteSettingsId.Trim().Split("`n")
			for($i = 0; $i -lt $querySiteSettingsId.Length ; $i++)
			{
				$searchServiceAppID = $searchServiceAppIds[$tempCnt]
				$tempXML = [xml] (Get-SPEnterpriseSearchQueryAndSiteSettingsServiceInstance | ? {$_.status -ne "Disabled"} | where {$_.Id -eq $querySiteSettingsId[$i] } | ConvertTo-Xml -NoTypeInformation)
				$tempstr = [System.String] $tempXML.Objects.Object.InnerXML
				$searchServiceAppID = $searchServiceAppID + "|" + $querySiteSettingsId[$i]				 
				$global:SearchConfigQuerySiteSettings.Add($searchServiceAppID, $tempstr)
			}
		}		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchConfigQuerySiteSettings", $_)
    }
}

function o16enumSearchConfigContentSources()
{
	try
	{
		if($global:searchsvcAppsCount -eq 0)
		{ 		return 		}

		for ($tempCnt = 0; $tempCnt -lt $global:searchsvcAppsCount ; $tempCnt ++)	
		{
			$cmdstr = Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $searchServiceAppIds[$tempCnt] | Select Id | ft -HideTableHeaders | Out-String -Width 1000
			$cmdstr = $cmdstr.Trim().Split("`n")
			
			for($i = 0; $i -lt $cmdstr.Length ; $i++)
			{
				$cmdstr2 = $cmdstr[$i].Trim() 
				$searchServiceAppID = $searchServiceAppIds[$tempCnt]
				$tempXML = [xml] (Get-SPEnterpriseSearchCrawlContentSource -SearchApplication $searchServiceAppIds[$tempCnt] | select Name, Type, DeleteCount, ErrorCount, SuccessCount, WarningCount, StartAddresses, Id, CrawlStatus, CrawlStarted, CrawlCompleted, CrawlState | where {$_.Id -eq $cmdstr2 } | ConvertTo-Xml -NoTypeInformation)
				$tempstr = [System.String] $tempXML.Objects.Object.InnerXML
				$searchServiceAppID = $searchServiceAppID + "|" + $cmdstr2				 
				$global:SearchConfigContentSources.Add($searchServiceAppID, $tempstr)
			}			
		}		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSearchConfigContentSources", $_)
    }
}

function o16enumSPServiceApplicationPools()
{
	try
	{
		$svcAppPoolIDs = Get-SPServiceApplicationPool | select Id | Out-String -Width 1000
		$delimitLines =  $svcAppPoolIDs.Split("`n")
		$global:serviceAppPoolCount = (Get-SPServiceApplicationPool).Length		
		
        ForEach($svcAppPoolID in $delimitLines)
        {
			$svcAppPoolID = $svcAppPoolID.Trim()
			if (($svcAppPoolID -eq "") -or ($svcAppPoolID -eq "Id") -or ($svcAppPoolID -eq "--")) { continue }
			
			$global:XMLToParse = New-Object System.Xml.XmlDocument
			$global:XMLToParse = [xml](Get-SPServiceApplicationPool | select Id, Name, ProcessAccountName | where {$_.Id -eq $svcAppPoolID} | select Name, ProcessAccountName | ConvertTo-XML -NoTypeInformation)
			$tempstr = [System.String]$global:XMLToParse.Objects.Object.InnerXml
			$global:SPServiceApplicationPools.Add($svcAppPoolID, $tempstr)
		}	
		return 1
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSPServiceApplicationPools", $_)
		return 0
    }
}

function o16enumSPServiceApplicationProxies()
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
        global:HandleException("o15enumSPServiceApplicationProxies", $_)
		return 0
    }
}

function o16enumSPServiceApplicationProxyGroups()
{
	try
	{
		$global:SvcAppProxyGroupCount = 0
		$groupstr = Get-SPServiceApplicationProxyGroup | select Id | fl | Out-String
		$delimitLines =  $groupstr.Split("`n")
		
		ForEach($GroupID in $delimitLines)
        {
			$GroupID = $GroupID.Trim()
			if (($GroupID -eq "") -or ($GroupID -eq "Id") -or ($GroupID -eq "--")) { continue }
			$global:SvcAppProxyGroupCount ++
			$GroupID =  ($GroupID.Split(":"))[1]
			$GroupID = $GroupID.Trim()
			$global:XMLToParse = New-Object System.Xml.XmlDocument
			$global:XMLToParse = [xml](Get-SPServiceApplicationProxyGroup | Select-Object * -Exclude Proxies, DefaultProxies | where {$_.Id -eq $GroupID} | Out-String -Width 2000 | ConvertTo-XML )			
			$ProxyGroups = Get-SPServiceApplicationProxyGroup | where {$_.Id -eq $GroupID} | select Proxies
			$ProxiesXML = [xml]($ProxyGroups.Proxies | select DisplayName | ConvertTo-Xml -NoTypeInformation)
			$FriendlyName = Get-SPServiceApplicationProxyGroup | where {$_.Id -eq $GroupID} | select FriendlyName | fl | Out-String
			$FriendlyName =  ($FriendlyName.Split(":"))[1]
			$FriendlyName = $FriendlyName.Trim()
			$ProxiesStr = [System.String]$ProxiesXML.Objects.OuterXML
			$tempstr1 = $GroupID + "|" + $FriendlyName 
			$tempstr2 = [System.String]$global:XMLToParse.Objects.Object.InnerXml 
			$tempstr2 = $tempstr2.Trim() + $ProxiesStr 
			$global:SPServiceAppProxyGroups.Add($tempstr1, $tempstr2)
        }
		return 1
	}	
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSPServiceApplicationProxyGroups", $_)
		return 0
    }
}

function o16enumWebApps()
{
	try
	{
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
		
		if ($mySPWebAppCollection -ne $null)
        {
            foreach ($mySPWebApp in $mySPWebAppCollection)
            {
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
				foreach($CurrentZone in $AllZones)
				{
					switch($CurrentZone)
					{
						[Microsoft.SharePoint.Administration.SPUrlZone]::Default  { $count2 = 1 }
						[Microsoft.SharePoint.Administration.SPUrlZone]::Intranet { $count2 = 2 }
						[Microsoft.SharePoint.Administration.SPUrlZone]::Internet { $count2 = 3 }
						[Microsoft.SharePoint.Administration.SPUrlZone]::Custom   { $count2 = 4 }
						[Microsoft.SharePoint.Administration.SPUrlZone]::Extranet { $count2 = 5 }
						default { $count2 = 1 }
					}
					if ($mySPWebApp.IisSettings.ContainsKey($CurrentZone))
	                {
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
                foreach ($mySPContentDB in $mySPContentDBCollection)
                {
					$global:ContentDBcount--;
                    $global:ContentDBs[$count, $global:ContentDBcount] = $mySPContentDB.Name
                    $mySiteCollectionNum = $mySiteCollectionNum + $mySPContentDB.Sites.Count
                    $ContentDBSitesNum[$count, $ContentDBcount] = $mySPContentDB.Sites.Count.ToString()					
                }
                $global:WebAppDetails[$count, 4] = $mySiteCollectionNum.ToString()
				
				#enumerating alternateURLs
                foreach ($mySPAlternateUrl in $mySPWebApp.AlternateUrls)
                {
                    switch ($mySPAlternateUrl.UrlZone.ToString().Trim())
                    {
                        "Default" 
						{
                            if ($global:WebAppPublicAAM[$count, 1] -eq $null)
                                { $global:WebAppPublicAAM[$count, 1] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                                { $global:WebAppInternalAAMURL[$count, 1] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                        "Intranet"
						{
                            if ($global:WebAppPublicAAM[$count, 2] -eq $null)
                                { $global:WebAppPublicAAM[$count, 2] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                                { $global:WebAppInternalAAMURL[$count, 2] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                        "Internet"
						{
                            if ($global:WebAppPublicAAM[$count, 3] -eq $null)
                                { $global:WebAppPublicAAM[$count, 3] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                                { $global:WebAppInternalAAMURL[$count, 3] = $mySPAlternateUrl.IncomingUrl.ToString() }
						}
                        "Custom"
						{
                            if ($global:WebAppPublicAAM[$count, 4] -eq $null)
                                { $global:WebAppPublicAAM[$count, 4] = $mySPAlternateUrl.IncomingUrl.ToString() }
                            else
                                { $global:WebAppInternalAAMURL[$count, 4] = $mySPAlternateUrl.IncomingUrl.ToString() }
                        }
                        "Extranet"
                        {
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
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumWebApps", $_)
		return 0
    }
}

function o16enumContentDBs()
{
	try
	{
	    $DiskSpaceReq = 0.000
	    $global:ContentDBProps = new-object 'System.String[,]' $global:totalContentDBCount, 8
	    $count = 0
	    $queryString = ""
		foreach ($webApplication in [Microsoft.SharePoint.Administration.SPWebService]::ContentService.WebApplications)
	    {
	        $contentDBs = $webApplication.ContentDatabases

	        foreach ($contentDB in $contentDBs)
	        {
	            $global:ContentDBProps[$count, 0] = $contentDB.Name
	            $global:ContentDBProps[$count, 1] = $webApplication.Name
	            $global:ContentDBProps[$count, 2] = $contentDB.Id.ToString()
	            $global:ContentDBProps[$count, 3] = $contentDB.ServiceInstance.DisplayName
	            $global:ContentDBProps[$count, 4] = $contentDB.Sites.Count.ToString()
	            $DiskSpaceReq = [double] $contentDB.DiskSizeRequired / 1048576
	            $global:ContentDBProps[$count, 5] = $DiskSpaceReq.ToString() + " MB"
				$DBConnectionString = $contentDB.DatabaseConnectionString
		    	PSUsing ($sqlConnection = New-Object System.Data.SqlClient.SqlConnection $DBConnectionString)  {   
			        try 
			        {      
						$queryString = "select LockedBy from timerlock with (nolock)"
			            $sqlCommand = $sqlConnection.CreateCommand()      
			            $sqlCommand.CommandText = $queryString       
			            $sqlConnection.Open() | Out-Null      
			            $reader = $sqlcommand.ExecuteReader() 
			            while ($reader.Read())
			            {
			                $global:ContentDBProps[$count, 6] = $reader[0].ToString()
			            }
			            $reader.Close()
			        }    
			        catch [Exception] 
			        {      
			            Write-Host "Exception while running SQL query." -ForegroundColor Cyan      
			            Write-Host "$($_.exception)" -ForegroundColor Black      return -1    
			        }
					
					$global:ContentDBProps[$count, 7] = $contentDB.NeedsUpgrade.ToString()
    			}            

	            $count = $count + 1
	        }
	    }
	    return 1
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumContentDBs", $_)
		return 0
    }
}

function o16enumCDConfig()
{
	try
	{
		$CDInstance = [Microsoft.SharePoint.Publishing.Administration.ContentDeploymentConfiguration]::GetInstance()
		#Obtaining General Information about the CDInstance
		$global:CDGI = [xml] ($CDInstance | ConvertTo-Xml)
		
		#Obtaining information about deployment paths
		$global:Paths = [Microsoft.SharePoint.Publishing.Administration.ContentDeploymentPath]::GetAllPaths()
		foreach($CDPath in $global:Paths)
		{
			$PathName = $CDPath.Name | Out-String
			$global:XMLToParse = [xml] ($CDPath | ConvertTo-Xml)
			$PathGI = [System.String]$global:XMLToParse.Objects.Object.InnerXml 
			$PathId = $CDPath.Id | fl | Out-String
			$PathId = ($PathId.Split(':'))[1]
			$PathId = $PathId.Trim()
			$tempstr = $PathId + "|" + $PathName
			$global:CDPaths.Add($tempstr, $PathGI)
			
			foreach($Job in $CDPath.Jobs)
			{
				$JobId = $Job.Id | Out-String
				$JobName = $Job.Name | Out-String
				$XMLToParse2 = [xml] ($Job | ConvertTo-Xml)
				$tempstr2 = $PathId + "|" + $JobId + "|" + $JobName
				$tempstr3 = [System.String]$XMLToParse2.Objects.Object.InnerXml 
				$global:CDJobs.Add($tempstr2, $tempstr3)
			}			
		}
		return 1
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		global:HandleException("o15CDConfig", $_)
		return 0
    } 
}

function o16enumHealthReport()
{
	try
	{
		$site = Get-SPSite $global:adminURL
		$web = $site.RootWeb

		$list = $web.Lists["Review problems and solutions"]
		foreach($item in $list.Items)
		{
			$id = $item["ID"]
			$tempstr = $item["Title"] + "||" + $item["Failing Servers"] + "||" + $item["Failing Services"] + "||" + $item["Modified"]
			switch($item["Severity"])
			{
				"0 - Rule Execution Failure"  
				{ $global:HealthReport0.Add($id, $tempstr) }
				"1 - Error" 
				{ $global:HealthReport1.Add($id, $tempstr) }
				"2 - Warning" 
				{ $global:HealthReport2.Add($id, $tempstr) }
				"3 - Information" 
				{ $global:HealthReport3.Add($id, $tempstr) }
				default { }
			}
		}
		return 1
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		global:HandleException("o15enumHealthReport", $_)
		return 0
    } 
}

function o16enumTimerJobs()
{
      try
      {
            $jobs = Get-SPTimerJob | Select Id, Title, Server, WebApplication, Schedule, LastRunTime, IsDisabled, LockType 
            $global:timerJobCount = $jobs.Length
            
            ForEach($Job in $jobs)
            {
                  $timerJobId = ($Job | Select Id | ft -HideTableHeaders | Out-String).Trim()
                  $title = ($Job | Select Title | ft -HideTableHeaders | Out-String).Trim()
                  $server = ($Job | Select Server | ft -HideTableHeaders | Out-String).Trim()
                  $webapplication = ($Job | Select WebApplication | ft -HideTableHeaders | Out-String).Trim()
                  $schedule = ($Job | Select Schedule | ft -HideTableHeaders | Out-String).Trim()
                  $lastruntime = ($Job | Select LastRunTime | ft -HideTableHeaders | Out-String).Trim()
                  $isdisabled = ($Job | Select IsDisabled | ft -HideTableHeaders | Out-String).Trim()
                  $locktype = ($Job | Select LockType | ft -HideTableHeaders | Out-String).Trim()
                  
                  $tempstr2 = $timerJobId + "||" + $title + "||" + $webapplication + "||" + $schedule + "||" + $lastruntime + "||" + $isdisabled + "||" + $locktype
                  $global:timerJobs.Add($timerJobId, $tempstr2)
            }           
            return 1
            }
      catch [System.Exception] 
    {
            Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumTimerJobs", $_)
            return 0
    }
}

function o16WriteInitialXML()
{
	try	
	{	
		[System.Xml.XmlWriterSettings] $global:XMLWriterSettings = New-Object System.Xml.XmlWriterSettings 
		$global:XMLWriterSettings.Indent = [System.Boolean] "true" 
		$global:XMLWriterSettings.IndentChars = ("    ") 
		$path = [Environment]::CurrentDirectory + "\2016SPSFarmReport{0}{1:d2}{2:d2}-{3:d2}{4:d2}" -f (Get-Date).Day,(Get-Date).Month,(Get-Date).Year,(Get-Date).Second,(Get-Date).Millisecond + ".XML"
		$global:XMLWriter = [System.Xml.XmlWriter]::Create($path, $XMLWriterSettings) 
		$global:XMLWriter.WriteStartDocument()
		$xsl = "type='text/xsl' href='o16SPSFarmReport.xslt'" 
		$commentStr = " This report was generated at " + (Get-Date).ToString() + " on server " + $env:COMPUTERNAME + " by user " + $Env:USERDOMAIN + "\" + $Env:USERNAME + ". " + "Post your feedback about this tool on http://spsfarmreport.codeplex.com/."
		$XMLWriter.WriteProcessingInstruction("xml-stylesheet", $xsl)
		$XMLWriter.WriteComment($commentStr)
		
		# Initial tag -> Start
		$XMLWriter.WriteStartElement("Farm_Information")
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15WriteInitialXML", $_)
    }
}

function o16WriteFarmGenSettings()
{
	try
	{
		# Farm General Settings - Start
		$global:XMLWriter.WriteStartElement("Farm_General_Settings")
        $XMLWriter.WriteStartElement("Central_Admin_URL")
		$XMLWriter.WriteString($global:adminURL)
		$XMLWriter.WriteEndElement()
		$XMLWriter.WriteStartElement("Farm_Build_Version")
		$XMLWriter.WriteString($global:BuildVersion)
		$XMLWriter.WriteEndElement()
		$XMLWriter.WriteStartElement("System_Account")
		$XMLWriter.WriteString($global:systemAccount)
		$XMLWriter.WriteEndElement()
		$XMLWriter.WriteStartElement("Configuration_Database_Name")
		$XMLWriter.WriteString($global:confgDbName)
		$XMLWriter.WriteEndElement()
		$XMLWriter.WriteStartElement("Configuration_Database_Server")
		$XMLWriter.WriteString($global:confgDbServerName)
		$XMLWriter.WriteEndElement()
		$XMLWriter.WriteStartElement("Admin_Content_Database_Name")
		$XMLWriter.WriteString($global:adminDbName)
		$XMLWriter.WriteEndElement()
		$XMLWriter.WriteEndElement()
		# Farm General Settings - End		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15WriteFarmGenSettings", $_)
    }
}

function o16writeServers()
{
	try
	{
		$global:XMLWriter.WriteStartElement("Services_On_Servers")		
		for($i = $global:Servernum; $i -gt 0; $i--)
		{
			if([System.Convert]::ToInt32(($global:ServicesOnServers[($i - 1), ($global:_maxServicesOnServers - 1)])) -gt 0 )
			{
				$XMLWriter.WriteStartElement("Server")
				$XMLWriter.WriteAttributeString("Name", $Servers[$i - 1])	
                $global:ServerRoles.GetEnumerator() | ForEach-Object {		
                if($_.key -eq $Servers[$i - 1]) {                
		                $Role = ($_.value.Split(','))[0]
		                $Compliance = ($_.value.Split(','))[1]	    }
                        }			
                $XMLWriter.WriteAttributeString("Role", $Role)
                $XMLWriter.WriteAttributeString("Compliance", $Compliance)
				
				for($j = [System.Int16]::Parse(($ServicesOnServers[($i - 1), ($global:_maxServicesOnServers - 1)])); $j -ge 0 ; $j--)
				{
		            if ($ServicesOnServers[($i - 1), $j] -ne $null)
                    {
						if ($j -eq 0)
						{
							$XMLWriter.WriteStartElement("Service")
							$XMLWriter.WriteAttributeString("Name", ($ServicesOnServers[($i - 1), $j]))
							$XMLWriter.WriteEndElement()
						}
                        else
						{ 
							$XMLWriter.WriteStartElement("Service")
							$XMLWriter.WriteAttributeString("Name", ($ServicesOnServers[($i - 1), $j]))
							$XMLWriter.WriteEndElement()
						}
                    }
				}
				$XMLWriter.WriteEndElement()
			}
		}
		$XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeServers", $_)
    }
}

function o16writeDCacheConfig
{
	try
	{
		$global:XMLWriter.WriteStartElement("Distributed_Cache")	

        $global:XMLWriter.WriteStartElement("Containers")	
        $global:_DCacheContainers.GetEnumerator() | ForEach-Object {
		$keystr = $_.key
		$valuexml = $_.value | ConvertTo-Xml
		$global:XMLWriter.WriteStartElement($keystr)
        $global:XMLWriter.WriteRaw($valuexml.Objects.Object.InnerText)
	    $XMLWriter.WriteEndElement()
            }
        $XMLWriter.WriteEndElement()

        $global:XMLWriter.WriteStartElement("Hosts")	
        if($global:_DCacheHosts.Length -lt 2)
        {
            $keystr = [string]$_DCacheHosts.keys
            if ($keystr.ToString() -match "^[0-9]") {$keystr = $keystr.ToString().Insert(0,"_") }
		    $valuexml = $_DCacheHosts.values | ConvertTo-Xml
		    $global:XMLWriter.WriteStartElement($keystr)
            $global:XMLWriter.WriteRaw($valuexml.Objects.Object.InnerText)
	        $XMLWriter.WriteEndElement()
        }
        else
        {
            $global:_DCacheHosts.GetEnumerator() | ForEach-Object {
		    $keystr = $_.key
		    $valuexml = $_.value | ConvertTo-Xml
		    $global:XMLWriter.WriteStartElement($keystr)
            $global:XMLWriter.WriteRaw($valuexml.Objects.Object.InnerText)
	        $XMLWriter.WriteEndElement()
            }
        }
                
        $XMLWriter.WriteEndElement()

		$XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeFeatures", $_)
    }
}

function o16writeProdVersions2()
{ 
	$thCount = $global:_maxItemsonServer - 1
	$writtenItem, $itemVal2Found, $allProductsConsistent = [Boolean] "false", [Boolean] "false", [Boolean] "false"
	$totalProducts = 0
	try
	{
        for ($count = ($global:Servernum - 1); $count -ge 0; $count--)
        {
            if ($global:serverProducts[$count, 0, 0] -eq $null)
                { continue }
				
				
            if ( [System.Convert]::ToInt32(($global:serverProducts[$count, ($global:_maxProductsonServer - 1), ($global:_maxItemsonServer - 1)])) -gt $totalProducts)
                { $totalProducts = [System.Convert]::ToInt32(($global:serverProducts[$count, ($global:_maxProductsonServer - 1), ($global:_maxItemsonServer - 1) ])) }
		}
		
		# get names of the installed products 
        $productsInstalled = New-Object System.Collections.ArrayList
        $itemsInstalled = New-Object System.Collections.ArrayList
        $itemsWriter = New-Object System.Collections.ArrayList
		
        for ($count = ($global:Servernum - 1); $count -ge 0; $count--)
        {
            for ($count2 = ($global:_maxProductsonServer - 1); $count2 -ge 1; $count2--)
            {
                if (!$productsInstalled.Contains(($global:serverProducts[$count, $count2, 0])) -and ($serverProducts[$count, $count2, 0] -ne $null))
                    { $productsInstalled.Add(($serverProducts[$count, $count2, 0])) | Out-Null }

                for ($count3 = 1; $count3 -le ($global:_maxItemsonServer - 2); $count3++)
                {
                    $itemVal2Found = [boolean] "false"
                    if ($serverProducts[$count, $count2, $count3] -ne $null)
                    {
						
                        $itemVal = $serverProducts[$count, $count2, 0] + " : " + $serverProducts[$count, $count2, $count3].Split(':')[0].Trim() 
                        foreach($itemVal2 in $itemsInstalled)
                        {
                            if ($itemVal.Trim() -eq $itemVal2.Trim())
                                { $itemVal2Found = [boolean] "true" }
                        }
                        if ($itemVal2Found -eq [boolean] "false")
                        {
                            $itemsInstalled.Add(($serverProducts[$count, $count2, 0]) + " : " + ($serverProducts[$count, $count2, $count3].Split(':')[0])) | Out-Null
                        }
                    }
                }
            }
        }
		
        # let us get the max number of items per product 
        $count = $Servernum - 1
        $temptotalProducts = $totalProducts | Out-Null
        while ($count -ge 0)
        {
            while ($temptotalProducts -ge 0)
            {
                while ($thCount -ge 0)
                {
                    if ($serverProducts[$count, $temptotalProducts, $thCount] -ne $null)
                        { $itemCount = $itemCount + 1 }
                    $thCount--
                }
                if ($maxitemCount -lt $itemCount)
                    { $maxitemCount = $itemCount | Out-Null }
                $itemCount = 0
                $temptotalProducts = $temptotalProducts - 1
            }
            $count = $count - 1
        }
		
		# Now, the writing part $Write-Host 
		$global:XMLWriter.WriteStartElement("Installed_Products_on_Servers")
		
		foreach ($tcp in $productsInstalled)
        {
            $star = [boolean] "false"
            # writing the Products
            $XMLWriter.WriteStartElement("Product")
			$XMLWriter.WriteAttributeString("Name", $tcp)
			
            foreach ($tcp0 in $itemsInstalled)
            {
				$XMLWriter.WriteStartElement("Item")	
				$XMLWriter.WriteAttributeString("Name", $tcp0.Split(':')[1].Trim())
				
                for ($count = ($global:Servernum - 1); $count -ge 0; $count--)
                {
                    for ($count2 = ($global:_maxProductsonServer - 1); $count2 -ge 1; $count2--)
                    {
                        for ($count3 = ($global:_maxItemsonServer - 2); $count3 -ge 1; $count3--)
                        {
                            if ($global:serverProducts[$count, $count2, $count3] -ne $null)
							{
                                if ($tcp0.Split(':')[1].ToLower().Trim() -eq $serverProducts[$count, $count2, $count3].Split(':')[0].Trim().ToLower())
                                {
									$XMLWriter.WriteStartElement("Server")	
									$XMLWriter.WriteAttributeString("Name", ($global:serverProducts[$count,0,0]))
									$XMLWriter.WriteString(($serverProducts[$count, $count2, $count3].Split(':')[1]))
									$XMLWriter.WriteEndElement()
                                }
							}
                        }
                    }
                }
				$XMLWriter.WriteEndElement()
            }
			$XMLWriter.WriteEndElement()
        }
		$XMLWriter.WriteEndElement() # Install_Products_on_Servers		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeProdVersions2", $_)
    }
}

function o16writeFeatures
{
	try
	{
		$global:XMLWriter.WriteStartElement("Features")	
		
		# where scope is farm
		$XMLWriter.WriteStartElement("Scope")
		$XMLWriter.WriteAttributeString("Level", "Farm")
        for ($i = 0; $i -lt $global:FeatureCount; $i++)
        {
			$XMLWriter.WriteStartElement("Feature")
			$XMLWriter.WriteAttributeString("Id", ($global:FarmFeatures[$i, 0]))
			$XMLWriter.WriteAttributeString("Name", ($global:FarmFeatures[$i, 1]))
			$XMLWriter.WriteAttributeString("SolutionId", ($global:FarmFeatures[$i, 2]))
			$XMLWriter.WriteAttributeString("IsActive", ($global:FarmFeatures[$i, 3]))
			$XMLWriter.WriteEndElement()
        }
		$XMLWriter.WriteEndElement()
		
		# where scope is site
		$XMLWriter.WriteStartElement("Scope")
		$XMLWriter.WriteAttributeString("Level", "Site")
        for ($i = 0; $i -lt $global:sFeatureCount; $i++)
        {
			$XMLWriter.WriteStartElement("Feature")
			$XMLWriter.WriteAttributeString("Id", ($global:SiteFeatures[$i, 0]))
			$XMLWriter.WriteAttributeString("Name", ($global:SiteFeatures[$i, 1]))
			$XMLWriter.WriteAttributeString("SolutionId", ($global:SiteFeatures[$i, 2]))
			$XMLWriter.WriteAttributeString("IsActive", ($global:SiteFeatures[$i, 3]))
			$XMLWriter.WriteEndElement()
        }
		$XMLWriter.WriteEndElement()
		
		# where scope is web
		$XMLWriter.WriteStartElement("Scope")
		$XMLWriter.WriteAttributeString("Level", "Web")
        for ($i = 0; $i -lt $global:wFeatureCount; $i++)
        {
			$XMLWriter.WriteStartElement("Feature")
			$XMLWriter.WriteAttributeString("Id", ($global:WebFeatures[$i, 0]))
			$XMLWriter.WriteAttributeString("Name", ($global:WebFeatures[$i, 1]))
			$XMLWriter.WriteAttributeString("SolutionId", ($global:WebFeatures[$i, 2]))
			$XMLWriter.WriteAttributeString("IsActive", ($global:WebFeatures[$i, 3]))
			$XMLWriter.WriteEndElement()
        }
		$XMLWriter.WriteEndElement()
		
		$XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeFeatures", $_)
    }
}

function o16writeSolutions
{
	try
	{
		$global:XMLWriter.WriteStartElement("Custom_Solutions")
		
        if ($global:solutionCount -eq 0)
        {
			$XMLWriter.WriteComment("There were no custom solutions found to be deployed on this farm.")
			$XMLWriter.WriteEndElement()
			return
        }
		
        for ($count = 0; $count -le ($global:solutionCount - 1); $count++)
        {
			$XMLWriter.WriteStartElement("Solution")
			$XMLWriter.WriteAttributeString("No.", ($count + 1).ToString() )
			
			$XMLWriter.WriteStartElement("Id")
			$XMLWriter.WriteString(($global:solutionProps[$count, 5]))
			$XMLWriter.WriteEndElement()

			$XMLWriter.WriteStartElement("Name")
			$XMLWriter.WriteString(($global:solutionProps[$count, 0]))
			$XMLWriter.WriteEndElement()
	
			$XMLWriter.WriteStartElement("Deployed_On_Web_Apps")
			$XMLWriter.WriteString(($global:solutionProps[$count, 1]))
			$XMLWriter.WriteEndElement()

			$XMLWriter.WriteStartElement("LastOperationDetails")
			$XMLWriter.WriteString(($global:solutionProps[$count, 2]))
			$XMLWriter.WriteEndElement()

			$XMLWriter.WriteStartElement("Deployed_On_Servers")
			$XMLWriter.WriteString(($global:solutionProps[$count, 3]))
			$XMLWriter.WriteEndElement()

			$XMLWriter.WriteEndElement()			
        }
		
		$XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeSolutions", $_)
    }	
}

function o16writeServiceApps
{
	try
	{ 
		$xrs = New-Object -TypeName System.Xml.XmlReaderSettings
		$xrs.ConformanceLevel = [System.Xml.ConformanceLevel]::Fragment
		
		$global:XMLWriter.WriteStartElement("Service_Applications")		
		$global:ServiceApps.GetEnumerator() | ForEach-Object {
		
		$isSearchSvcApp = 0	
        $isProjectSvcApp = 0          
        $prjApp=$_.Value
		$ServiceAppID = ($_.key.Split('|'))[0]
		$typeName = ($_.key.Split('|'))[1]		
        if($global:projectsvcApps.Id -eq $ServiceAppID) { $isProjectSvcApp=1}  	
	
		ForEach($searchAppId in $searchServiceAppIds)
		{
			if($searchAppId -eq $ServiceAppID) { $isSearchSvcApp = 1 }
		}
		
		$global:XMLWriter.WriteStartElement("Service_Application")
		$global:XMLWriter.WriteAttributeString("Type", $typeName)
		
		if($isSearchSvcApp -eq 1)		
		{			
			$global:XMLWriter.WriteStartElement("General_Information")
			$global:XMLWriter.WriteRaw($_.value)
			$global:XMLWriter.WriteEndElement()
			
			#Writing the Search Service Status
			$global:XMLWriter.WriteStartElement("Enterprise_Search_Service_Status")
			try
			{
					$global:XMLWriter.WriteStartElement("General_Information")
					$global:XMLWriter.WriteRaw($global:enterpriseSearchServiceStatus)
					$global:XMLWriter.WriteEndElement()
					
					$global:XMLWriter.WriteStartElement("Job_Definitions")
					$global:XMLWriter.WriteRaw($global:enterpriseSearchServiceJobDefs)
					$global:XMLWriter.WriteEndElement()
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()	
			
			#Writing the Active Topology
			$global:XMLWriter.WriteStartElement("Active_Topology")
			try
			{
				$global:SearchActiveTopologyComponents.GetEnumerator() | ForEach-Object {
				$searchServiceAppID = ($_.key.Split('|'))[0]
				if($ServiceAppID -eq ($searchServiceAppID)) 
				{ 
					$props = $_.value
					$compName = ($_.key.Split('|'))[1]
					$global:XMLWriter.WriteStartElement("Component")
					$global:XMLWriter.WriteAttributeString("Name", $compName.Trim())
					$global:XMLWriter.WriteRaw($props)
					$global:XMLWriter.WriteEndElement()
				}
				}
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()		
			
			#Writing the Host Controllers
			$global:XMLWriter.WriteStartElement("Host_Controllers")
			try
			{
				$global:SearchHostControllers.GetEnumerator() | ForEach-Object {
				$searchServiceAppID = ($_.key.Split('|'))[0]
				if($ServiceAppID -eq ($searchServiceAppID)) 
				{ 
					$props = $_.value
					$serverName = ($_.key.Split('|'))[1]
					$global:XMLWriter.WriteStartElement("Server")
					$global:XMLWriter.WriteAttributeString("Name", $serverName.Trim())
					$global:XMLWriter.WriteRaw($props)
					$global:XMLWriter.WriteEndElement()
				}
				}
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()		
			
			#Writing the Admin Component
			$global:XMLWriter.WriteStartElement("Admin_Component")
			try
			{
				$global:SearchConfigAdminComponents.GetEnumerator() | ForEach-Object {
				if($ServiceAppID -eq ($_.key)) { $adminComponent = $_.value}
				}
				$global:XMLWriter.WriteRaw($adminComponent)
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()			
			
			# Writing Link Stores
			$global:XMLWriter.WriteStartElement("Link_Stores")
			try
			{
				$global:SearchConfigLinkStores.GetEnumerator() | ForEach-Object {
				if($ServiceAppID -eq ($_.key)) { $storeValue = $_.value}
				}
				$global:XMLWriter.WriteRaw($storeValue)
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()
			
			#Writing the Crawl Databases
			$global:XMLWriter.WriteStartElement("Crawl_Databases")
			try
			{
				$global:SearchConfigCrawlDatabases.GetEnumerator() | ForEach-Object {
					$crawlComponent = ""
					$searchServiceAppID = ($_.key.Split('|'))[0]
					$crawlDatabaseID = ($_.key.Split('|'))[1]	
					if($ServiceAppID -eq $searchServiceAppID) 
					{ 
						$crawlComponent = $_.value				
						$global:XMLWriter.WriteStartElement("Database")
						$global:XMLWriter.WriteAttributeString("Id", $crawlDatabaseID)
						$global:XMLWriter.WriteRaw($crawlComponent)
						$global:XMLWriter.WriteEndElement()
					}
				}
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()			
			
			#Writing crawl rules
			$global:XMLWriter.WriteStartElement("Crawl_Rules")
			try
			{
				$global:SearchConfigCrawlRules.GetEnumerator() | ForEach-Object {
					$searchServiceAppID = ($_.key.Split('|'))[0]
					$crawlRuleName = ($_.key.Split('|'))[1]	
					if($ServiceAppID -eq $searchServiceAppID) 
					{ 
						$crawlRule = $_.value				
						$global:XMLWriter.WriteStartElement("Rule")
						$global:XMLWriter.WriteAttributeString("Name", $crawlRuleName)
						$global:XMLWriter.WriteRaw($crawlRule)
						$global:XMLWriter.WriteEndElement()
					}
				}
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()	
			
			#Writing the Query Site Settings
			$global:XMLWriter.WriteStartElement("Query_and_Site_Settings")
			try
			{
				$global:SearchConfigQuerySiteSettings.GetEnumerator() | ForEach-Object {
					$queryComponent = ""
					$searchServiceAppID = ($_.key.Split('|'))[0]
					$queryComponentID = ($_.key.Split('|'))[1]	
					if($ServiceAppID -eq $searchServiceAppID) 
					{ 
						$queryComponent = $_.value
						$global:XMLWriter.WriteStartElement("Instance")
						$global:XMLWriter.WriteAttributeString("Id", $queryComponentID)
						$global:XMLWriter.WriteRaw($queryComponent)
						$global:XMLWriter.WriteEndElement()
					}
				}
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()
			
			#Writing the Content Sources
			$global:XMLWriter.WriteStartElement("Content_Sources")
			try
			{
				$global:SearchConfigContentSources.GetEnumerator() | ForEach-Object {
					$contentSource = ""
					$searchServiceAppID = ($_.key.Split('|'))[0]
					$contentSourceID = ($_.key.Split('|'))[1]	
					if($ServiceAppID -eq $searchServiceAppID) 
					{ 
						$contentSource = $_.value
						$global:XMLWriter.WriteStartElement("Content_Source")
						$global:XMLWriter.WriteAttributeString("Id", $contentSourceID)
						$global:XMLWriter.WriteRaw($contentSource)
						$global:XMLWriter.WriteEndElement()
					}
				}
			}
			catch [System.Exception] 
		    {
				Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
		    }
			$global:XMLWriter.WriteEndElement()			
		}		
        elseif($isProjectSvcApp -eq 1)		
        {			        
            $global:XMLWriter.WriteStartElement("ProjectServer_General_Information")
		    $global:XMLWriter.WriteRaw($prjApp)
		    $global:XMLWriter.WriteEndElement()        
            $cnt=0 
           
           #Writing Project Server Instance Information                   
	        $global:XMLWriter.WriteStartElement("ProjectServer_Instances")
     	    $global:XMLWriter.WriteAttributeString("Type", "Project Server Instances")			
            try
            {                                        
                        $global:projectInstances.GetEnumerator() | ForEach-Object {
					    $prjAppID = ($_.key.Split('|'))[0]
					    $prjName = ($_.key.Split('|'))[1]						
						$prjInst = $_.value				
						$global:XMLWriter.WriteStartElement("ProjectServer_Instance")
						$global:XMLWriter.WriteAttributeString("Number", $cnt)
						$global:XMLWriter.WriteRaw($prjInst)
						$global:XMLWriter.WriteEndElement()
                        $cnt++					
            }                                  	                                          
                                
                         										
        }
        catch [System.Exception] 
        {
		                Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		                Write-Output $_ | Out-File -FilePath $global:_logpath -Append
   		}
            $global:XMLWriter.WriteEndElement()

            #Writing Project Server PCS Settings
	        $global:XMLWriter.WriteStartElement("ProjectServer_PCSSettings")
     	    $global:XMLWriter.WriteAttributeString("Type", "Project PCS Settings")			
            try
            {    
                               $global:XMLWriter.WriteStartElement("General_Information")
                               $global:XMLWriter.WriteAttributeString("TimeOut", $global:projectPCSSettings.EditingSessionTimeout)
			                   $global:XMLWriter.WriteAttributeString("WorkerCount", $global:projectPCSSettings.MaximumWorkersCount)
                               $global:XMLWriter.WriteAttributeString("RequestTimeLimits", $global:projectPCSSettings.RequestTimeLimits)
                               $global:XMLWriter.WriteAttributeString("MaximumProjectSize", $global:projectPCSSettings.MaximumProjectSize)                               
                               $global:XMLWriter.WriteEndElement()                             
            }
            catch [System.Exception] 
            {
		                Write-Host " ******** Exception caught. Check the log file for more details. ******** "
		                Write-Output $_ | Out-File -FilePath $global:_logpath -Append
       		}
            $global:XMLWriter.WriteEndElement()
            
        }
		elseif($isSearchSvcApp -eq 0 -and $isProjectSvcApp -eq 0)
		{
			$global:XMLWriter.WriteRaw($_.value)
		}
		
		$global:XMLWriter.WriteEndElement()
		
		}		
		$global:XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeServiceApps", $_)
    }
}

function o16writeSPServiceApplicationPools
{
	try
	{
		if($global:serviceAppPoolCount -eq 0 ) { return }
		
		$global:XMLWriter.WriteStartElement("Service_Application_Pools")
		$global:SPServiceApplicationPools.GetEnumerator() | ForEach-Object {
		$serviceAppPoolID = $_.key
		$serviceAppPoolstr = $_.value
		
		$global:XMLWriter.WriteStartElement("Application_Pool")
		$global:XMLWriter.WriteAttributeString("Id", $serviceAppPoolID)
		$global:XMLWriter.WriteRaw($serviceAppPoolstr)
		$global:XMLWriter.WriteEndElement()		
		}
		$global:XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeSPServiceApplicationPools", $_)
    }
}

function o16writeSPServiceApplicationProxies
{
	try
	{
		if($global:serviceAppProxyCount -eq 0)
		{ 		return 		}
		$global:XMLWriter.WriteStartElement("Service_Application_Proxies")
		try
		{
			$global:SPServiceAppProxies.GetEnumerator() | ForEach-Object {
			$searchServiceAppProxyID = ($_.key.Split('|'))[0]
			$TypeName = ($_.key.Split('|'))[1]	
			$proxy = $_.value				
			$global:XMLWriter.WriteStartElement("Proxy")
			$global:XMLWriter.WriteAttributeString("Id", $searchServiceAppProxyID)
			$global:XMLWriter.WriteAttributeString("TypeName", $TypeName)
			$global:XMLWriter.WriteRaw($proxy)
			$global:XMLWriter.WriteEndElement()
			}
		}
		catch [System.Exception] 
	    {
			Write-Host " ******** Exception caught. Check the log file for more details. ******** "
	        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
	    }		
		$XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeSPServiceApplicationProxies", $_)
    }
}

function o16writeSPServiceApplicationProxyGroups
{
	try
	{
		if($global:SvcAppProxyGroupCount -eq 0)		{ 		return 		}
		
		$XMLWriter.WriteStartElement("Service_Application_Proxy_Groups")
		try
		{
			$global:SPServiceAppProxyGroups.GetEnumerator() | ForEach-Object {
			$GroupID = ($_.key.Split("|"))[0]
			$FriendlyName = ($_.key.Split("|"))[1]
			$GroupXML = $_.value				
			$global:XMLWriter.WriteStartElement("Proxy_Group")
			$global:XMLWriter.WriteAttributeString("Id", $GroupID)
			$global:XMLWriter.WriteAttributeString("FriendlyName", $FriendlyName)
			$global:XMLWriter.WriteRaw($GroupXML)
			$global:XMLWriter.WriteEndElement()
			}
		}
		catch [System.Exception] 
	    {
			Write-Host " ******** Exception caught. Check the log file for more details. ******** "
	        Write-Output $_ | Out-File -FilePath $global:_logpath -Append
	    }
		
		
		$XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeSPServiceApplicationProxyGroups", $_)
    }
}

function o16writeWebApps()
{
	try
	{
			$contentDBs = ""
			$global:XMLWriter.WriteStartElement("Web_Applications")
			
			for($wcount = 0; $wcount -lt $global:WebAppnum; $wcount++ )
			{
				$XMLWriter.WriteStartElement("Web_Application")
				$XMLWriter.WriteAttributeString("Name", ($global:WebAppDetails[$wcount, 2]))
				
				$XMLWriter.WriteStartElement("Associated_Applicaion_Pool")
				$XMLWriter.WriteAttributeString("Name", ($global:WebAppDetails[$wcount, 6]))
				$XMLWriter.WriteAttributeString("Identity", ($global:WebAppDetails[$wcount, 7]))
				$XMLWriter.WriteEndElement()
				
				$XMLWriter.WriteStartElement("Associated_Service_Application_Proxy_Group")
				$XMLWriter.WriteAttributeString("Name", ($global:WebAppDetails[$wcount, 9]))
				$XMLWriter.WriteEndElement()

				$XMLWriter.WriteStartElement("Content_Databases")
                        for ($dbcount = 0; $dbcount -le [System.Convert]::ToInt32(($global:WebAppDetails[$wcount, 3])); $dbcount++)
                        {
                            if (($contentDBs -eq "") -and (($dbcount + 1) -eq [System.Convert]::ToInt32(($global:WebAppDetails[$wcount, 3]))))
                            {    
								$contentDB = $global:ContentDBs[$wcount, $dbcount] 
								$XMLWriter.WriteStartElement("Content_Database")
								$XMLWriter.WriteAttributeString("Name", $contentDB)
								$XMLWriter.WriteEndElement()
							}								
                        }
				$XMLWriter.WriteEndElement()
				$XMLWriter.WriteEndElement()
			}	
			
			$global:XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeWebApps", $_)
    }
}

function o16writeAAMsnAPs()
{
	try
	{
		$AllZones = [Microsoft.SharePoint.Administration.SPUrlZone]::Default, 
							[Microsoft.SharePoint.Administration.SPUrlZone]::Intranet, 
							[Microsoft.SharePoint.Administration.SPUrlZone]::Internet, 
							[Microsoft.SharePoint.Administration.SPUrlZone]::Custom, 
							[Microsoft.SharePoint.Administration.SPUrlZone]::Extranet
		$global:XMLWriter.WriteStartElement("Alternate_Access_Mappings")
		for($wcount = 0; $wcount -lt $global:WebAppnum; $wcount++)
		{
			$XMLWriter.WriteStartElement("Web_Application")
			$XMLWriter.WriteAttributeString("Name", ($WebAppDetails[$wcount, 2]))
			
			for ($zones = 1; $zones -le 5; $zones++)
			{				
				$XMLWriter.WriteStartElement(($AllZones[$zones -1]))	
				$tempstr = $WebAppPublicAAM[$wcount, $zones]
				if($tempstr -ne $null) 
				{ 
					$tempstr = $tempstr.Trim()
					if($tempstr -ne "")
					{
						$XMLWriter.WriteStartElement("PublicURL")
						$XMLWriter.WriteString(($WebAppPublicAAM[$wcount, $zones]))
						$XMLWriter.WriteEndElement()
					}
				}
				
				$tempstr = $WebAppInternalAAMURL[$wcount, $zones]
				if($tempstr -ne $null)
				{
					$tempstr = $tempstr.Trim()
					if($tempstr -ne "")
					{
						$XMLWriter.WriteStartElement("InternalURL")
						$XMLWriter.WriteString(($WebAppInternalAAMURL[$wcount, $zones]))
						$XMLWriter.WriteEndElement()
					}
				}
				
				$tempstr = $WebAppAuthProviders[$wcount, $zones]
				if($tempstr -ne $null)
				{
					$tempstr = $tempstr -split ']'
					
					$XMLWriter.WriteStartElement("UseClaimsAuthentication")
					$XMLWriter.WriteString(($tempstr[3].Trim()))
					$XMLWriter.WriteEndElement()
					
					$XMLWriter.WriteStartElement("AuthenticationMode")
					$XMLWriter.WriteString(($tempstr[0].Trim()))
					$XMLWriter.WriteEndElement()				
					
					$XMLWriter.WriteStartElement("AllowAnonymous")
					$XMLWriter.WriteString(($tempstr[1].Trim()))
					$XMLWriter.WriteEndElement()								

					$XMLWriter.WriteStartElement("Path")
					$XMLWriter.WriteString(($tempstr[2].Trim()))
					$XMLWriter.WriteEndElement()				
				}
				$XMLWriter.WriteEndElement()
			}		
			$XMLWriter.WriteEndElement()
		}
		$XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeAAMsnAPs", $_)
    }
}

function o16writeContentDBs()
{
	try
	{
		$global:XMLWriter.WriteStartElement("Content_Databases")
		for($count = 0; $count -lt $global:totalContentDBCount; $count++)
		{
			$XMLWriter.WriteStartElement("Content_Database")
			$XMLWriter.WriteAttributeString("Name", ($ContentDBProps[$count, 0]))
			$XMLWriter.WriteAttributeString("Number", ($count + 1))
			
			$XMLWriter.WriteStartElement("Web_Application")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 1]))
			$XMLWriter.WriteEndElement()
			
			$XMLWriter.WriteStartElement("Id")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 2]))
			$XMLWriter.WriteEndElement()			
			
			$XMLWriter.WriteStartElement("Database_Service_Instance")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 3]))
			$XMLWriter.WriteEndElement()			
			
			$XMLWriter.WriteStartElement("Site_Collection_Count")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 4]))
			$XMLWriter.WriteEndElement()			
			
			$XMLWriter.WriteStartElement("Disk_Space_Required_for_Backup")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 5]))
			$XMLWriter.WriteEndElement()			
			
			for ($count2 = ($global:Servernum - 1); $count2 -ge 0; $count2--)
			{
				if ($global:ServersId[$count2] -eq $global:ContentDBProps[$count, 6]) 
				{ 
					$XMLWriter.WriteStartElement("Timer_Locked_By")
					$XMLWriter.WriteAttributeString("Server", ($global:Servers[$count2]))
					$XMLWriter.WriteEndElement()
				}
			}
			
			$XMLWriter.WriteStartElement("NeedsUpgrade")
			$XMLWriter.WriteString(($global:ContentDBProps[$count, 7]))
			$XMLWriter.WriteEndElement()
			
			$XMLWriter.WriteEndElement()
		}		
		$XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeContentDBs", $_)
    }
}

function o16writeCDConfig()
{
	try
	{
		$global:XMLWriter.WriteStartElement("Content_Deployment")
		
		#Writing General Information
		$global:XMLWriter.WriteStartElement("General_Information")
		$global:XMLWriter.WriteRaw($global:CDGI.Objects.Object.InnerXml)
		$global:XMLWriter.WriteEndElement()		
		
		#Writing Paths
		$global:CDPaths.GetEnumerator() | ForEach-Object {
		$PathId = ($_.key.Split('|'))[0]
		$PathName = ($_.key.Split('|'))[1]
		$PathName = $PathName.Trim()
		$tempstr = $_.value
		
		
		$global:XMLWriter.WriteStartElement("Path")
		$global:XMLWriter.WriteAttributeString("Name", $PathName)
		$global:XMLWriter.WriteStartElement("General_Information")
		$global:XMLWriter.WriteRaw($tempstr)
		$global:XMLWriter.WriteEndElement()		
		
		$global:CDJobs.GetEnumerator() | ForEach-Object {
		$PathId2 = ($_.key.Split('|'))[0]
		$JobName = ($_.key.Split('|'))[2]
		$JobName = $JobName.Trim()
		
		if($PathId2 -eq $PathId)
		{
			$global:XMLWriter.WriteStartElement("Job")
			$global:XMLWriter.WriteAttributeString("Name", $JobName)
			$global:XMLWriter.WriteRaw($_.value)
			$global:XMLWriter.WriteEndElement()	
		}
		
		}
		
		$global:XMLWriter.WriteEndElement()		
		}	
		$global:XMLWriter.WriteEndElement()
	}
		catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        #global:HandleException("o15writeSPServiceApplicationPools", $_)
    }
}

function o16writeHealthReport()
{
	try
	{
	
		if (($global:HealthReport0.Count -eq 0) -and ($global:HealthReport1.Count -eq 0) -and ($global:HealthReport2.Count -eq 0) -and ($global:HealthReport3.Count -eq 0))
			{ exit }
				
		$global:XMLWriter.WriteStartElement("Health_Analyzer_Reports")

		# We iterate through each Severity separately because the rules (their ids) are run and presented sporadic in CA.
		#Writing 0 - Rule Execution Failures
		if($global:HealthReport0.Count -gt 0)
		{
			$global:XMLWriter.WriteStartElement("Type")
			$global:XMLWriter.WriteAttributeString("Name", "Rule_Execution_Failures")
			$global:HealthReport0.GetEnumerator() | ForEach-Object {
			$id = $_.key
			$title = $_.value.Split("||")[0]
			$failingServers = $_.value.Split("||")[2]
			$failingServices = $_.value.Split("||")[4]
			$Modified = $_.value.Split("||")[6]
			
			$global:XMLWriter.WriteStartElement("Item")
			$global:XMLWriter.WriteAttributeString("Id", $id)
			$global:XMLWriter.WriteAttributeString("Title", $title)
			$global:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
			$global:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
			$global:XMLWriter.WriteAttributeString("Modified", $Modified)
			$global:XMLWriter.WriteEndElement()		
			}		
			$global:XMLWriter.WriteEndElement()
		}
		
		#Writing 1 - Errors
		if($global:HealthReport1.Count -gt 0)
		{
			$global:XMLWriter.WriteStartElement("Type")
			$global:XMLWriter.WriteAttributeString("Name", "Errors")
			$global:HealthReport1.GetEnumerator() | ForEach-Object {
			$id = $_.key
			$title = $_.value.Split("||")[0]
			$failingServers = $_.value.Split("||")[2]
			$failingServices = $_.value.Split("||")[4]
			$Modified = $_.value.Split("||")[6]
			
			$global:XMLWriter.WriteStartElement("Item")
			$global:XMLWriter.WriteAttributeString("Id", $id)
			$global:XMLWriter.WriteAttributeString("Title", $title)
			$global:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
			$global:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
			$global:XMLWriter.WriteAttributeString("Modified", $Modified)
			$global:XMLWriter.WriteEndElement()		
			}		
			$global:XMLWriter.WriteEndElement()
		}
		
		#Writing 2 - Warning
		if($global:HealthReport2.Count -gt 0)
		{
			$global:XMLWriter.WriteStartElement("Type")
			$global:XMLWriter.WriteAttributeString("Name", "Warnings")
			$global:HealthReport2.GetEnumerator() | ForEach-Object {
			$id = $_.key
			$title = $_.value.Split("||")[0]
			$failingServers = $_.value.Split("||")[2]
			$failingServices = $_.value.Split("||")[4]
			$Modified = $_.value.Split("||")[6]
			$global:XMLWriter.WriteStartElement("Item")
			$global:XMLWriter.WriteAttributeString("Id", $id)
			$global:XMLWriter.WriteAttributeString("Title", $title)
			$global:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
			$global:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
			$global:XMLWriter.WriteAttributeString("Modified", $Modified)
			$global:XMLWriter.WriteEndElement()		
			}		
			$global:XMLWriter.WriteEndElement()		
		}
		
		#Writing 3 - Information
		if($global:HealthReport3.Count -gt 0)
		{
			$global:XMLWriter.WriteStartElement("Type")
			$global:XMLWriter.WriteAttributeString("Name", "Information")
			$global:HealthReport3.GetEnumerator() | ForEach-Object {
			$id = $_.key
			$title = $_.value.Split("||")[0]
			$failingServers = $_.value.Split("||")[2]
			$failingServices = $_.value.Split("||")[4]
			$Modified = $_.value.Split("||")[6]
			$global:XMLWriter.WriteStartElement("Item")
			$global:XMLWriter.WriteAttributeString("Id", $id)
			$global:XMLWriter.WriteAttributeString("Title", $title)
			$global:XMLWriter.WriteAttributeString("Failing_Servers", $failingServers)
			$global:XMLWriter.WriteAttributeString("Failing_Services", $failingServices)
			$global:XMLWriter.WriteAttributeString("Modified", $Modified)
			$global:XMLWriter.WriteEndElement()		
			}		
			$global:XMLWriter.WriteEndElement()		
		}
		$global:XMLWriter.WriteEndElement()		
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        #global:HandleException("o15writeSPServiceApplicationPools", $_)
    }
}

function o16writeTimerJobs()
{
	try
	{
		if ($global:timerJobs.Count -eq 0)
		{ exit }
				
		$global:XMLWriter.WriteStartElement("Timer_Jobs")

		#Writing them
			$global:timerJobs.GetEnumerator() | ForEach-Object {
		
			$id = $_.value.Split("||")[0]
			$title = $_.value.Split("||")[2]
			$webapplication = $_.value.Split("||")[4]
			$schedule = $_.value.Split("||")[6]
			$lastruntime = $_.value.Split("||")[8]
			$isdisabled = $_.value.Split("||")[10]
			$locktype = $_.value.Split("||")[12]
			
			$global:XMLWriter.WriteStartElement("Job")
			$global:XMLWriter.WriteAttributeString("Id", $_.key)
			$global:XMLWriter.WriteAttributeString("Title", $title.replace('"'," "))
			$global:XMLWriter.WriteAttributeString("WebApplication", $webapplication)
			$global:XMLWriter.WriteAttributeString("Schedule", $schedule)
			$global:XMLWriter.WriteAttributeString("LastRunTime", $lastruntime)
			$global:XMLWriter.WriteAttributeString("IsDisabled", $isdisabled)
			$global:XMLWriter.WriteAttributeString("LockType", $locktype)
			$global:XMLWriter.WriteEndElement()
			}
			
		$global:XMLWriter.WriteEndElement()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        #global:HandleException("o15writeSPServiceApplicationPools", $_)
    }
}

function o16WriteEndXML()
{
	try
	{
		# Initial tag -> End
		#$global:XMLWriter.WriteEndElement()
		if($global:exceptionDetails.Length -gt 0)
		{
			$XMLWriter.WriteComment($global:exceptionDetails)
		}
		$XMLWriter.WriteEndDocument()		
		$XMLWriter.Flush()
		$XMLWriter.Close()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15WriteEndXML", $_)
    }
}

function global:HandleException([string]$functionName,[System.Exception]$err)
{
	$global:exceptionDetails = $global:exceptionDetails + "********* Exception caught:" + $functionName + " , " + $err
	Write-Output $_ | Out-File -FilePath $global:_logpath -Append
}

$dtime = " Starting run of SPSFarmReport at " + (Get-Date).ToString()
Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $global:_logpath -Append
Write-Output  $dtime | Out-File -FilePath $global:_logpath -Append
Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $global:_logpath -Append

o16WriteInitialXML 
$dtime = " Completed running o16WriteInitialXML at " + (Get-Date).ToString()
Write-Host o16WriteInitialXML
Write-Output  $dtime | Out-File -FilePath $global:_logpath -Append

$status = o16farmConfig
$dtime = " Completed running o16farmConfig at " + (Get-Date).ToString()
Write-Host o16farmConfig
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16WriteFarmGenSettings 
	$dtime = " Completed running o16WriteFarmGenSettings at " + (Get-Date).ToString()
	Write-Host o16WriteFarmGenSettings
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}

$status = o16enumServers
$dtime = " Completed running o16enumServers at " + (Get-Date).ToString()
Write-Output o16enumServers
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeServers 
	$dtime = " Completed running o16writeServers at " + (Get-Date).ToString()
	Write-Host o16writeServers
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}

$status = o16enumSPDcacheConfig
$dtime = " Completed running o16enumSPDcacheConfig at " + (Get-Date).ToString()
Write-Output o16enumSPDcacheConfig
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeDCacheConfig 
	$dtime = " Completed running o16writeDCacheConfig at " + (Get-Date).ToString()
	Write-Host o16writeDCacheConfig
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}

$status = o16enumProdVersions
$dtime = " Completed running o16enumProdVersions at " + (Get-Date).ToString()
Write-Host o16enumProdVersions
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeProdVersions2 
	$dtime = " Completed running o16writeProdVersions2 at " + (Get-Date).ToString()
	Write-Host o16writeProdVersions2
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append	
}

$status = o16enumFeatures
$dtime = " Completed running o16enumFeatures at " + (Get-Date).ToString()
Write-Host o16enumFeatures
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeFeatures 
	$dtime = " Completed running o16writeFeatures at " + (Get-Date).ToString()
	Write-Host o16writeFeatures
	Write-Output $dtime	| Out-File -FilePath $global:_logpath -Append	
}

$status = o16enumSolutions
$dtime = " Completed running o16enumSolutions at " + (Get-Date).ToString()
Write-Host o16enumSolutions
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeSolutions 
	$dtime = " Completed running o16writeSolutions at " + (Get-Date).ToString()
	Write-Host o16writeSolutions
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}


$status = o16enumSvcApps 
$dtime = " Completed running o16enumSvcApps at " + (Get-Date).ToString()
Write-Host  o16enumSvcApps
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append

if($status -eq 1) { o16enumSPSearchServiceApps }
Write-Host o16enumSPSearchServiceApps
if($status -eq 1) { o16enumSPSearchService }
Write-Host o16enumSPSearchService
if($status -eq 1) { o16enumHostControllers }
Write-Host o16enumHostControllers
if($status -eq 1) { o16enumSearchActiveTopologies }
Write-Host o16enumSearchActiveTopologies
if($status -eq 1) { o16enumSearchConfigAdminComponents }
Write-Host o16enumSearchConfigAdminComponents
if($status -eq 1) { o16enumSearchConfigLinkStores }
Write-Host o16enumSearchConfigLinkStores
if($status -eq 1) { o16enumSearchConfigCrawlDatabases }
Write-Host o16enumSearchConfigCrawlDatabases
if($status -eq 1) { o16enumSearchConfigCrawlRules }
Write-Host o16enumSearchConfigCrawlRules
if($status -eq 1) { o16enumSearchConfigQuerySiteSettings }
Write-Host o16enumSearchConfigQuerySiteSettings
if($status -eq 1) { o16enumSearchConfigContentSources }
Write-Host o16enumSearchConfigContentSources
if($status -eq 1) { o16enumProjectServiceApps }
Write-Host o16enumProjectServiceApps


if($status -eq 1) 
{ 
	o16writeServiceApps 
	$dtime = " Completed running o16writeServiceApps at " + (Get-Date).ToString()
	Write-Host o16writeServiceApps
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}

$status = o16enumSPServiceApplicationPools
$dtime = " Completed running o16enumSPServiceApplicationPools at " + (Get-Date).ToString()
Write-Host o16enumSPServiceApplicationPools
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeSPServiceApplicationPools 
	$dtime = " Completed running o16writeSPServiceApplicationPools at " + (Get-Date).ToString()
	Write-Host o16writeSPServiceApplicationPools	
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}

$status = o16enumSPServiceApplicationProxies
$dtime = " Completed running o16enumSPServiceApplicationProxies at " + (Get-Date).ToString()
Write-Host o16enumSPServiceApplicationProxies
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeSPServiceApplicationProxies 
	$dtime = " Completed running o16writeSPServiceApplicationProxies at " + (Get-Date).ToString()
	Write-Host o16writeSPServiceApplicationProxies 
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}

$status = o16enumSPServiceApplicationProxyGroups
$dtime = " Completed running o16enumSPServiceApplicationProxyGroups at " + (Get-Date).ToString()
Write-Host o16enumSPServiceApplicationProxyGroups
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeSPServiceApplicationProxyGroups 
	$dtime = " Completed running o16writeSPServiceApplicationProxyGroups at " + (Get-Date).ToString()
	Write-Host o16writeSPServiceApplicationProxyGroups 
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}

$status = o16enumWebApps
$dtime = " Completed running o16enumWebApps at " + (Get-Date).ToString()
Write-Host o16enumWebApps
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeWebApps 
	$dtime = " Completed running o16writeWebApps at " + (Get-Date).ToString()
	Write-Host o16writeWebApps  
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
	
	o16writeAAMsnAPs
	$dtime = " Completed running o16writeAAMsnAPs at " + (Get-Date).ToString()
	Write-Host o16writeAAMsnAPs  
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}

$status = o16enumContentDBs
$dtime = " Completed running o16enumContentDBs at " + (Get-Date).ToString()
Write-Host o16enumContentDBs
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeContentDBs 
	$dtime = " Completed running o16writeContentDBs at " + (Get-Date).ToString()
	Write-Host o16writeContentDBs   
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}

if($isFoundationOnlyInstalled -eq $false)
{
	$status = o16enumCDConfig
	$dtime = " Completed running o16enumCDConfig at " + (Get-Date).ToString()
	Write-Host o16enumCDConfig
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
	if($status -eq 1) 
	{ 
		o16writeCDConfig 
		$dtime = " Completed running o16writeCDConfig at " + (Get-Date).ToString()
		Write-Host o16writeCDConfig   
		Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
	}
}

$status = o16enumHealthReport
$dtime = " Completed running o16enumHealthReport at " + (Get-Date).ToString()
Write-Host o16enumHealthReport
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeHealthReport
	$dtime = " Completed running o16writeHealthReport at " + (Get-Date).ToString()
	Write-Host o16writeHealthReport   
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}

$status = o16enumTimerJobs
$dtime = " Completed running o16enumTimerJobs at " + (Get-Date).ToString()
Write-Host o16enumTimerJobs
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
if($status -eq 1) 
{ 
	o16writeTimerJobs
	$dtime = " Completed running o16writeTimerJobs at " + (Get-Date).ToString()
	Write-Host o16writeTimerJobs 
	Write-Output $dtime | Out-File -FilePath $global:_logpath -Append
}

o16WriteEndXML
Write-Host o16WriteEndXML
$dtime = " Completed running o16WriteEndXML at " + (Get-Date).ToString()
Write-Output $dtime | Out-File -FilePath $global:_logpath -Append

$dtime = " Ending run of SPSFarmReport at " + (Get-Date).ToString()
Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $global:_logpath -Append
Write-Output  $dtime | Out-File -FilePath $global:_logpath -Append
Write-Output "---------------------------------------------------------------------------------" | Out-File -FilePath $global:_logpath  -Append