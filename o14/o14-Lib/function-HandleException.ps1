function global:HandleException([string]$functionName,[System.Exception]$err)
{
	$global:exceptionDetails = $global:exceptionDetails + "********* Exception caught:" + $functionName + " , " + $err
	Write-Output $_ | Out-File -FilePath $global:_logpath -Append
}