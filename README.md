# mremoteng_converter

A PowerShell script to convert session data from CSV to mRemoteNG XML format.

## Usage

1. Prepare a `sessions.csv` file with the following headers:
   - Name
   - Hostname
   - Protocol
   - Container
   - Description
2. Run the script:
   ```powershell
   .\converter.ps1
   ```
3. The script will generate a `sessions.xml` file for import into mRemoteNG.
