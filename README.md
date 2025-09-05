# mRemoteNG CSV to XML Converter

This PowerShell script converts a CSV file of server and network device information into an XML file that can be imported into mRemoteNG.

**Now supports Port, Icon, and Panel attributes for each connection!**

## Features

*   Converts a CSV file to an mRemoteNG XML file.
*   Supports nested containers.
*   Generates a unique ID for each connection.
*   Supports custom Port and Icon for both containers and connections.
*   Sets the Panel to `General` and PuttySession to `Default Settings` for each connection.

## Prerequisites

*   PowerShell 5.1 or later.

## Usage

1.  Create a `sessions.csv` file in the same directory as the script. The CSV file must have the following headers:

    ```
    Name,Hostname,Protocol,Container,Port,Icon,Description
    ```

2.  Run the `converter.ps1` script from PowerShell:

    ```powershell
    .\converter.ps1
    ```

3.  The script will generate a `sessions.xml` file in the same directory.

4.  In mRemoteNG, click on `File` > `Import` > `Import from File` and select the `sessions.xml` file.

## CSV File Format

The `sessions.csv` file must have the following columns:

*   `Name`: The name of the connection.
*   `Hostname`: The hostname or IP address of the device.
*   `Protocol`: The protocol to use (e.g., RDP, SSH2, VNC).
*   `Container`: The container to place the connection in. You can use a backslash (`\`) to create nested containers (e.g., `Servers\Web Servers`).
*   `Port`: The port number for the connection or container (e.g., 22 for SSH, 3389 for RDP).
*   `Icon`: The icon name for the connection or container (e.g., Switch, Server, Firewall).
*   `Description`: A description of the connection.
