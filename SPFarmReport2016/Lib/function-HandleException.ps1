function global:HandleException {
    [cmdletbinding()]
    param (
        [string]
        $functionName
        ,
        [System.Exception]
        $err
    )
    $script:exceptionDetails = $script:exceptionDetails + "********* Exception caught:" + $functionName + " , " + $err
    Write-Output $_ | Out-File -FilePath $script:_logpath -Append
}