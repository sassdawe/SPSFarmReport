function o16writeDCacheConfig {
    try {
        $script:XMLWriter.WriteStartElement("Distributed_Cache")	

        $script:XMLWriter.WriteStartElement("Containers")	
        $script:_DCacheContainers.GetEnumerator() | ForEach-Object {
            $keystr = $_.key
            $valuexml = $_.value | ConvertTo-Xml
            $script:XMLWriter.WriteStartElement($keystr)
            $script:XMLWriter.WriteRaw($valuexml.Objects.Object.InnerText)
            $XMLWriter.WriteEndElement()
        }
        $XMLWriter.WriteEndElement()

        $script:XMLWriter.WriteStartElement("Hosts")	
        if ($script:_DCacheHosts.Length -lt 2) {
            $keystr = [string]$_DCacheHosts.keys
            if ($keystr.ToString() -match "^[0-9]") {$keystr = $keystr.ToString().Insert(0, "_") }
            $valuexml = $_DCacheHosts.values | ConvertTo-Xml
            $script:XMLWriter.WriteStartElement($keystr)
            $script:XMLWriter.WriteRaw($valuexml.Objects.Object.InnerText)
            $XMLWriter.WriteEndElement()
        }
        else {
            $script:_DCacheHosts.GetEnumerator() | ForEach-Object {
                $keystr = $_.key
                $valuexml = $_.value | ConvertTo-Xml
                $script:XMLWriter.WriteStartElement($keystr)
                $script:XMLWriter.WriteRaw($valuexml.Objects.Object.InnerText)
                $XMLWriter.WriteEndElement()
            }
        }
                
        $XMLWriter.WriteEndElement()

        $XMLWriter.WriteEndElement()
    }
    catch [System.Exception] {
        Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        HandleException("o16writeDCacheConfig", $_)
    }
}