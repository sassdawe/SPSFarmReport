function o16enumProdVersions{
    [cmdletbinding()]
    param ()
    try {
        $global:serverProducts = new-object 'System.String[,,]' $global:Servernum, $global:_maxProductsonServer, $global:_maxItemsonServer
        $count = $global:Servernum - 1
        $count2, $count3 = 0, 0

        [Microsoft.SharePoint.Administration.SPProductVersions] $versions = [Microsoft.SharePoint.Administration.SPProductVersions]::GetProductVersions()
        $infos = New-Object 'System.Collections.Generic.List[Microsoft.SharePoint.Administration.SPServerProductInfo]' (, $versions.ServerInformation)

        foreach ($prodInfo in $infos) {
            $count2 = 0;
            $count3 = 0;
            $products = New-Object 'System.Collections.Generic.List[System.String]' (, $prodInfo.Products)
            $products.Sort()
            $global:serverProducts[$count, $count2, $count3] = $prodInfo.ServerName
            foreach ($str in $products) {
                $count2++
                $serverProducts[$count, $count2, $count3] = $str
                $singleProductInfo = $prodInfo.GetSingleProductInfo($str)
                $patchableUnitDisplayNames = New-Object 'System.Collections.Generic.List[System.String]' (, $singleProductInfo.PatchableUnitDisplayNames)
                $patchableUnitDisplayNames.Sort()
                foreach ($str2 in $patchableUnitDisplayNames) {
                    $patchableUnitInfoByDisplayName = New-Object 'System.Collections.Generic.List[Microsoft.SharePoint.Administration.SPPatchableUnitInfo]' (, $singleProductInfo.GetPatchableUnitInfoByDisplayName($str2))
                    foreach ($info in $patchableUnitInfoByDisplayName) {
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
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16enumProdVersions", $_)
        return 0
    }
}