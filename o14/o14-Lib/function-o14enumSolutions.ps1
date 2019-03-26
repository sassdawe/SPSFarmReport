
function o14enumSolutions {
    [CmdletBinding()]
    param ()
    try {
        $script:solutionCount = [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm.Solutions.Count
        $script:solutionProps = New-Object 'System.String[,]' $script:solutionCount, 6
        $count = 0
        foreach ($solution in [Microsoft.SharePoint.Administration.SPWebService]::ContentService.Farm.Solutions) {
            $script:solutionProps[$count, 0] = $solution.DisplayName
            $script:solutionProps[$count, 1] = $solution.Deployed.ToString()
            $script:solutionProps[$count, 2] = $solution.LastOperationDetails
            $script:solutionProps[$count, 5] = $solution.Id.ToString()

            foreach ($deployedServer in $solution.DeployedServers) {
                if ($script:solutionProps[$count, 3] -eq $null) {
                    if ($deployedServer.Address -eq $null)
                    { $script:solutionProps[$count, 3] = "" }
                    else
                    { $script:solutionProps[$count, 3] = $deployedServer.Address }
                }
                else
                { $script:solutionProps[$count, 3] = $script:solutionProps[$count, 3] + "<br>" + $deployedServer.Address }
            }
            $count = $count + 1
        }
        return 1
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14enumSolutions", $_)
        return 0
    }
}
