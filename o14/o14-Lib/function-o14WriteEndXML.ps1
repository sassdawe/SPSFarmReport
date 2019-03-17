function o14WriteEndXML()
{
	try
	{
		# Initial tag -> End
		$global:XMLWriter.WriteEndElement()
		if($global:exceptionDetails.Length -gt 0)
		{
			$XMLWriter.WriteComment($global:exceptionDetails)
		}
		$XMLWriter.WriteEndDocument()		
		$XMLWriter.Flush()
		$XMLWriter.Close()
	}
	catch [System.Exception] 
    {
		Write-Host " ******** Exception caught. Check the log file for more details. ******** "
        global:HandleException("o14WriteEndXML", $_)
    }
}