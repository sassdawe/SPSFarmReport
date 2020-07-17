function o16writeProdVersions2() { 
    $thCount = $script:_maxItemsonServer - 1
    $writtenItem, $itemVal2Found, $allProductsConsistent = [Boolean] "false", [Boolean] "false", [Boolean] "false"
    $totalProducts = 0
    try {
        for ($count = ($script:Servernum - 1); $count -ge 0; $count--) {
            if ($script:serverProducts[$count, 0, 0] -eq $null)
            { continue }
				
				
            if ( [System.Convert]::ToInt32(($script:serverProducts[$count, ($script:_maxProductsonServer - 1), ($script:_maxItemsonServer - 1)])) -gt $totalProducts)
            { $totalProducts = [System.Convert]::ToInt32(($script:serverProducts[$count, ($script:_maxProductsonServer - 1), ($script:_maxItemsonServer - 1) ])) }
        }
		
        # get names of the installed products 
        $productsInstalled = New-Object System.Collections.ArrayList
        $itemsInstalled = New-Object System.Collections.ArrayList
        $itemsWriter = New-Object System.Collections.ArrayList
		
        for ($count = ($script:Servernum - 1); $count -ge 0; $count--) {
            for ($count2 = ($script:_maxProductsonServer - 1); $count2 -ge 1; $count2--) {
                if (!$productsInstalled.Contains(($script:serverProducts[$count, $count2, 0])) -and ($serverProducts[$count, $count2, 0] -ne $null))
                { $productsInstalled.Add(($serverProducts[$count, $count2, 0])) | Out-Null }

                for ($count3 = 1; $count3 -le ($script:_maxItemsonServer - 2); $count3++) {
                    $itemVal2Found = [boolean] "false"
                    if ($serverProducts[$count, $count2, $count3] -ne $null) {
						
                        $itemVal = $serverProducts[$count, $count2, 0] + " : " + $serverProducts[$count, $count2, $count3].Split(':')[0].Trim() 
                        foreach ($itemVal2 in $itemsInstalled) {
                            if ($itemVal.Trim() -eq $itemVal2.Trim())
                            { $itemVal2Found = [boolean] "true" }
                        }
                        if ($itemVal2Found -eq [boolean] "false") {
                            $itemsInstalled.Add(($serverProducts[$count, $count2, 0]) + " : " + ($serverProducts[$count, $count2, $count3].Split(':')[0])) | Out-Null
                        }
                    }
                }
            }
        }
		
        # let us get the max number of items per product 
        $count = $Servernum - 1
        $temptotalProducts = $totalProducts | Out-Null
        while ($count -ge 0) {
            while ($temptotalProducts -ge 0) {
                while ($thCount -ge 0) {
                    if ($serverProducts[$count, $temptotalProducts, $thCount] -ne $null)
                    { $itemCount = $itemCount + 1 }
                    $thCount--
                }
                if ($maxitemCount -lt $itemCount)
                { $maxitemCount = $itemCount | Out-Null }
                $itemCount = 0
                $temptotalProducts = $temptotalProducts - 1
            }
            $count = $count - 1
        }
		
        # Now, the writing part $Write-Host 
        $script:XMLWriter.WriteStartElement("Installed_Products_on_Servers")
		
        foreach ($tcp in $productsInstalled) {
            $star = [boolean] "false"
            # writing the Products
            $XMLWriter.WriteStartElement("Product")
            $XMLWriter.WriteAttributeString("Name", $tcp)
			
            foreach ($tcp0 in $itemsInstalled) {
                $XMLWriter.WriteStartElement("Item")	
                $XMLWriter.WriteAttributeString("Name", $tcp0.Split(':')[1].Trim())
				
                for ($count = ($script:Servernum - 1); $count -ge 0; $count--) {
                    for ($count2 = ($script:_maxProductsonServer - 1); $count2 -ge 1; $count2--) {
                        for ($count3 = ($script:_maxItemsonServer - 2); $count3 -ge 1; $count3--) {
                            if ($script:serverProducts[$count, $count2, $count3] -ne $null) {
                                if ($tcp0.Split(':')[1].ToLower().Trim() -eq $serverProducts[$count, $count2, $count3].Split(':')[0].Trim().ToLower()) {
                                    $XMLWriter.WriteStartElement("Server")	
                                    $XMLWriter.WriteAttributeString("Name", ($script:serverProducts[$count, 0, 0]))
                                    $XMLWriter.WriteString(($serverProducts[$count, $count2, $count3].Split(':')[1]))
                                    $XMLWriter.WriteEndElement()
                                }
                            }
                        }
                    }
                }
                $XMLWriter.WriteEndElement()
            }
            $XMLWriter.WriteEndElement()
        }
        $XMLWriter.WriteEndElement() # Install_Products_on_Servers		
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o16writeProdVersions2", $_)
    }
}
