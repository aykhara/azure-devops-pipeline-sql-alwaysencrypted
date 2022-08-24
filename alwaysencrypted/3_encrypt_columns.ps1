# Import the SqlServer module.
Import-Module "SqlServer"

# Connect to your database.
# Change the authentication method in the connection string, if needed.
$connStr = "Server = " + $env:SqlServerName + ".database.windows.net; Database = " + $env:SqlDatabaseName + "; User ID=" + $env:SQLUSER + ";Password='" + $env:SQLPASSWORD + "';"
$databaseInstance = Get-SqlDatabase -ConnectionString $connStr

# Authenticate to Azure
Add-SqlAzureAuthenticationContext -ClientID $env:clientId -Secret $env:clientSecret -Tenant $env:tenantId

# Encrypt the selected columns (or re-encrypt, if they are already encrypted using keys/encrypt types, different than the specified keys/types.
$ces = @()
$ces += New-SqlColumnEncryptionSettings -ColumnName $env:encryptedColumnName -EncryptionType "Randomized" -EncryptionKey $env:cekName
Set-SqlColumnEncryption -InputObject $databaseInstance -ColumnEncryptionSettings $ces -LogFileDirectory .