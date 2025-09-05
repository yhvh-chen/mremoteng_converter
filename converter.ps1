try {
    # Import the connection data from your CSV file.
    # Ensure your CSV file has the headers: Name,Hostname,Protocol,Container,Port,Icon,Description
    $Content = Import-Csv 'sessions.csv'

    # Create a new XML document
    $Xml = New-Object -TypeName System.Xml.XmlDocument

    # Create the XML declaration
    $xmlDeclaration = $Xml.CreateXmlDeclaration("1.0", "utf-8", $null)
    $Xml.AppendChild($xmlDeclaration)

    # Create a namespace manager
    $nsmgr = New-Object -TypeName System.Xml.XmlNamespaceManager -ArgumentList $Xml.NameTable
    $nsmgr.AddNamespace("mrng", "http://mremoteng.org")

    # Create the root node with the correct namespace
    $RootNode = $Xml.CreateElement("mrng", "Connections", "http://mremoteng.org")
    $RootNode.SetAttribute("Name", "New Folder")
    $RootNode.SetAttribute("Export", "false")
    $RootNode.SetAttribute("EncryptionEngine", "AES")
    $RootNode.SetAttribute("BlockCipherMode", "GCM")
    $RootNode.SetAttribute("KdfIterations", "10000")
    $RootNode.SetAttribute("FullFileEncryption", "false")
    $RootNode.SetAttribute("Protected", "1QHA5bWmnsqjypq/xw3J71N1UPkehZ/Ra6ITcNprbGMLffH+79wfdcH4YWa0xYuNUSSZwzs8VQ41kRy24eDiA2oT")
    $RootNode.SetAttribute("ConfVersion", "2.8")
    $Xml.AppendChild($RootNode)

    function Create-Container($parentNode, $containerPath, $port, $icon) {
        $pathParts = $containerPath.Split('\')
        $currentNode = $parentNode
        foreach ($part in $pathParts) {
            $childNode = $currentNode.SelectSingleNode("mrng:Node[@Name='$part']", $nsmgr)
            if (-not $childNode) {
                $childNode = $Xml.CreateElement("mrng", "Node", "http://mremoteng.org")
                $childNode.SetAttribute("Name", $part)
                $childNode.SetAttribute("Type", "Container")
                $childNode.SetAttribute("Expanded", "False")
                $childNode.SetAttribute("Id", [System.Guid]::NewGuid().ToString())
                if ($port) { $childNode.SetAttribute("Port", $port) }
                if ($icon) { $childNode.SetAttribute("Icon", $icon) }
                $currentNode.AppendChild($childNode)
            } else {
                # Update Port and Icon if provided and not already set
                if ($port -and -not $childNode.HasAttribute("Port")) { $childNode.SetAttribute("Port", $port) }
                if ($icon -and -not $childNode.HasAttribute("Icon")) { $childNode.SetAttribute("Icon", $icon) }
            }
            $currentNode = $childNode
        }
        return $currentNode
    }

    # This will loop through each row in your CSV file and create a connection object for it.
    foreach ($entry in $Content) {
    # Create the container structure, passing Port and Icon for the container if present
    $Container = Create-Container -parentNode $RootNode -containerPath $entry.Container -port $entry.Port -icon $entry.Icon

    # Create a new connection and add it to the container
    $Connection = $Xml.CreateElement("mrng", "Node", "http://mremoteng.org")
    $Connection.SetAttribute("Name", $entry.Name)
    $Connection.SetAttribute("Type", "Connection")
    $Connection.SetAttribute("Id", [System.Guid]::NewGuid().ToString())
    $Connection.SetAttribute("Hostname", $entry.Hostname)
    $Connection.SetAttribute("Protocol", $entry.Protocol)
    if ($entry.Port) { $Connection.SetAttribute("Port", $entry.Port) }
    if ($entry.Icon) { $Connection.SetAttribute("Icon", $entry.Icon) }
    $Connection.SetAttribute("Panel", "General")
    $Connection.SetAttribute("Description", $entry.Description)
    $Connection.SetAttribute("InheritCredential", "True")
    $Connection.SetAttribute("PuttySession", "Default Settings")
    $Container.AppendChild($Connection)
    }

    # Save the XML to a file
    $Xml.Save("sessions.xml")

    # Provide feedback that the script has completed successfully.
    Write-Host "Successfully created 'sessions.xml'. You can now import this file into mRemoteNG."

}
catch {
    # If any error occurs in the 'try' block, this 'catch' block will execute.
    Write-Host "An error occurred:" -ForegroundColor Red
    # The $_ variable holds the details of the specific error that was caught.
    Write-Host $_.Exception.Message
    Write-Host "Script execution halted." -ForegroundColor Yellow
}
finally {
    # This block will run regardless of whether there was an error or not.
    # It pauses the script, keeping the window open so you can read any output or error messages.
    Read-Host -Prompt "Press Enter to exit"
}