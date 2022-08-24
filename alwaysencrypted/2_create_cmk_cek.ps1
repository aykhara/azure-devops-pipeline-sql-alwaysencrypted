# 2. Powershell to deploy Column Master Keys (CMK) and column encryption keys (CEK)
# See https://docs.microsoft.com/en-us/sql/relational-databases/security/encryption/configure-always-encrypted-keys-using-powershell?view=sql-server-ver15#azure-key-vault-without-role-separation-example

# Create a column master key in Azure Key Vault.
Set-AzKeyVaultAccessPolicy -VaultName $env:akvName -ResourceGroupName $env:resourceGroup -PermissionsToKeys get, create, delete, list, wrapKey,unwrapKey, sign, verify -ServicePrincipalName $env:clientId
$akvKey = Get-AzKeyVaultKey -VaultName $env:AKV -Name $akvKeyName
if ($akvKey) {
    Write-Host "exit since key was already created"
    exit 0
}
$akvKey = Add-AzKeyVaultKey -VaultName $env:akvName -Name $env:akvKeyName -Destination "Software"

# Change the authentication method in the connection string, if needed.
$connStr = "Server = " + $env:SqlServerName + ".database.windows.net; Database = " + $env:SqlDatabaseName + "; User ID=" + $env:SQLUSER + ";Password='" + $env:SQLPASSWORD + "';"
$databaseInstance = Get-SqlDatabase -ConnectionString $connStr

# Create a SqlColumnMasterKeySettings object for your column master key. 
$cmkSettings = New-SqlAzureKeyVaultColumnMasterKeySettings -KeyURL $akvKey.Key.Kid

# Create column master key metadata in the database.
New-SqlColumnMasterKey -Name $env:cmkName -InputObject $databaseInstance -ColumnMasterKeySettings $cmkSettings

# Authenticate to Azure
Add-SqlAzureAuthenticationContext -ClientID $env:clientId -Secret $env:clientSecret -Tenant $env:tenantId

# Generate a column encryption key, encrypt it with the column master key and create column encryption key metadata in the database. 
New-SqlColumnEncryptionKey -Name $env:cekName -InputObject $databaseInstance -ColumnMasterKey $env:cmkName