function o16enumServers() {
    try {
        [Microsoft.SharePoint.Administration.SPFarm] $mySPFarm = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm
        [Microsoft.SharePoint.Administration.SPServerCollection] $mySPServerCollection = $mySPFarm.Servers
        
        #To get the number of servers in farm
        $global:Servernum = $mySPServerCollection.Count
        $global:ServicesOnServers = new-object 'System.String[,]' $global:Servernum, $global:_maxServicesOnServers 
        $global:Servers = new-object 'System.String[]' $global:Servernum
        $global:ServersId = new-object 'System.String[]' $global:Servernum
        $local:count, $ServicesCount, $count2 = 0, 0, 0
        [Microsoft.SharePoint.Administration.SPServer] $ServerInstance  
        foreach ($ServerInstance in $mySPServerCollection) {
            $tempstr = ""
            $count2 = 0
            $Servers[$count] = $ServerInstance.Address
            $ServersId[$count] = $ServerInstance.Id.ToString()
            $ServicesCount = $ServerInstance.ServiceInstances.Count
            $global:ServicesOnServers[$local:count, ($global:_maxServicesOnServers - 1)] = $ServerInstance.ServiceInstances.Count.ToString()
            foreach ($serviceInstance in $ServerInstance.ServiceInstances) {
                if (($serviceInstance.Hidden -eq $FALSE) -and ($serviceInstance.Status.ToString().Trim().ToLower() -eq "online")) {
                    if ($global:_serviceTypeswithNames.ContainsKey($serviceInstance.Service.TypeName)) {
                        $ServicesOnServers[$count, $count2] = $global:_serviceTypeswithNames.Get_Item($serviceInstance.Service.TypeName)
                    }
                    else {
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
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumServers", $_)
        return 0
    }    
}