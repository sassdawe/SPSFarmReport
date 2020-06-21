function global:PSUsing {
    [CmdletBinding()]
    param (
        [System.IDisposable]
        $inputObject = $(throw "The parameter -inputObject is required.")
        ,
        [ScriptBlock]
        $scriptBlock = $(throw "The parameter -scriptBlock is required.")
    )
    Try {
        &$scriptBlock
    }
    Finally {
        if ($null -ne $inputObject) {
            if ($null -eq $inputObject.psbase) {
                $inputObject.Dispose()
            }
            else {
                $inputObject.psbase.Dispose()
            }
        }
    }
}