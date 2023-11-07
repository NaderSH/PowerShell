# 1- Environment Variables
[string]$FunctionsPath = 'The path where PowerShell functions are located on your local system.'
[array]$PodFunctionList = ("backup", "schema", "mssql", "scripts", "istio","monitoring")
# 2- Functions Call
.$FunctionsPath/Get-PortForwarding.ps1
