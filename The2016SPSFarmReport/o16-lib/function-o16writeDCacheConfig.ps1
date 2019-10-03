function o16writeDCacheConfig {
    try {
        $global:XMLWriter.WriteStartElement("Distributed_Cache")	

        $global:XMLWriter.WriteStartElement("Containers")	
        $global:_DCacheContainers.GetEnumerator() | ForEach-Object {
            $keystr = $_.key
            $valuexml = $_.value | ConvertTo-Xml
            $global:XMLWriter.WriteStartElement($keystr)
            $global:XMLWriter.WriteRaw($valuexml.Objects.Object.InnerText)
            $XMLWriter.WriteEndElement()
        }
        $XMLWriter.WriteEndElement()

        $global:XMLWriter.WriteStartElement("Hosts")	
        if ($global:_DCacheHosts.Length -lt 2) {
            $keystr = [string]$_DCacheHosts.keys
            if ($keystr.ToString() -match "^[0-9]") {$keystr = $keystr.ToString().Insert(0, "_") }
            $valuexml = $_DCacheHosts.values | ConvertTo-Xml
            $global:XMLWriter.WriteStartElement($keystr)
            $global:XMLWriter.WriteRaw($valuexml.Objects.Object.InnerText)
            $XMLWriter.WriteEndElement()
        }
        else {
            $global:_DCacheHosts.GetEnumerator() | ForEach-Object {
                $keystr = $_.key
                $valuexml = $_.value | ConvertTo-Xml
                $global:XMLWriter.WriteStartElement($keystr)
                $global:XMLWriter.WriteRaw($valuexml.Objects.Object.InnerText)
                $XMLWriter.WriteEndElement()
            }
        }
                
        $XMLWriter.WriteEndElement()

        $XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o15writeFeatures", $_)
    }
}