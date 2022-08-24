# 1. Add data to dbo.ContainerRegistry

$sqlConn = New-Object System.Data.SqlClient.SqlConnection
$sqlConn.ConnectionString = 'Server = ' + $env:SqlServerName + '.database.windows.net; User ID=' + $env:SQLUSER + ';Password="' + $env:SQLPASSWORD + '";Database = ' + $env:SqlDatabaseName + '; Column Encryption Setting=enabled;'

$sqlConn.Open()
$sqlcmd = New-Object System.Data.SqlClient.SqlCommand
$sqlcmd.Connection = $sqlConn
$sqlcmd.CommandText = "INSERT INTO [dbo].[User] (Name, Password) VALUES (@Param1, @Param2)"
$sqlcmd.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Param1",[Data.SQLDBType]::NVarChar,50)))
$sqlcmd.Parameters["@Param1"].Value = "Ayaka"
$sqlcmd.Parameters.Add((New-Object Data.SqlClient.SqlParameter("@Param2",[Data.SQLDBType]::NVarChar,50)))
$sqlcmd.Parameters["@Param2"].Value = "password"
$sqlcmd.ExecuteNonQuery();
$sqlConn.Close()