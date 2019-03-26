function o16enumSolutions() {
    try {
        $global:solutionCount = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm.Solutions.Count
        $global:solutionProps = New-Object 'System.String[,]' $global:solutionCount, 6
        $count = 0
        foreach ($solution in [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm.Solutions) {
            $global:solutionProps[$count, 0] = $solution.DisplayName
            $global:solutionProps[$count, 1] = $solution.Deployed.ToString()
            $global:solutionProps[$count, 2] = $solution.LastOperationDetails
            $global:solutionProps[$count, 5] = $solution.Id.ToString()

            foreach ($deployedServer in $solution.DeployedServers) {
                if ($global:solutionProps[$count, 3] -eq $null) {
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
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15enumSolutions", $_)
        return 0
    }
}