
# TODO: load the private and public cmdlets into session
$moduleRoot = (split-path -parent $MyInvocation.MyCommand.Definition)

# FIXME: function Start-SPFarmReport
. "$moduleRoot\SPFarmReport2016.ps1"

# FIXME: tests, lots of unit tests using PESTER

Export-ModuleMember -Function "Start-SPFarmReport"