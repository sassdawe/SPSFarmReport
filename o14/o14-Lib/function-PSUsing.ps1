function global:PSUsing {
    [CmdletBinding()]
    param (
        [System.IDisposable]
        $inputObject = $(throw "The parameter -inputObject is required.")
        ,
        [ScriptBlock]
        $scriptBlock = $(throw "The parameter -scriptBlock is required.")
    )
    try {
        &$scriptBlock
    }
    finally {
        if ($inputObject -ne $null) {
            if ($inputObject.psbase -eq $null) {
                $inputObject.Dispose()
            }
            else {
                $inputObject.psbase.Dispose()
            }
        }
    }
}