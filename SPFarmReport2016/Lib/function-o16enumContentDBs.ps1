function o16enumContentDBs {
    [cmdletbinding()]
    param ()
    try {
        $DiskSpaceReq = 0.000
        $script:ContentDBProps = new-object 'System.String[,]' $script:totalContentDBCount, 8
        $count = 0
        $queryString = ""
        foreach ($webApplication in [Microsoft.SharePoint.Administration.SPWebService]::ContentService.WebApplications) {
            $contentDBs = $webApplication.ContentDatabases

            foreach ($contentDB in $contentDBs) {
                $script:ContentDBProps[$count, 0] = $contentDB.Name
                $script:ContentDBProps[$count, 1] = $webApplication.Name
                $script:ContentDBProps[$count, 2] = $contentDB.Id.ToString()
                $script:ContentDBProps[$count, 3] = $contentDB.ServiceInstance.DisplayName
                $script:ContentDBProps[$count, 4] = $contentDB.Sites.Count.ToString()
                $DiskSpaceReq = [double] $contentDB.DiskSizeRequired / 1048576
                $script:ContentDBProps[$count, 5] = $DiskSpaceReq.ToString() + " MB"
                $DBConnectionString = $contentDB.DatabaseConnectionString
                PSUsing ($sqlConnection = New-Object System.Data.SqlClient.SqlConnection $DBConnectionString) {
                    try {
                        $queryString = "select LockedBy from timerlock with (nolock)"
                        $sqlCommand = $sqlConnection.CreateCommand()
                        $sqlCommand.CommandText = $queryString
                        $sqlConnection.Open() | Out-Null
                        $reader = $sqlcommand.ExecuteReader()
                        while ($reader.Read()) {
                            $script:ContentDBProps[$count, 6] = $reader[0].ToString()
                        }
                        $reader.Close()
                    }
                    catch [Exception] {
                        Write-Host "Exception while running SQL query." -ForegroundColor "Cyan"
                        Write-Host "$($_.exception)" -ForegroundColor "Black"
                        return -1
                    }

                    $script:ContentDBProps[$count, 7] = $contentDB.NeedsUpgrade.ToString()
                }

                $count = $count + 1
            }
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumContentDBs", $_)
        return 0
    }
}