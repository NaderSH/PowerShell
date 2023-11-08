# 1- Environment Variables
[string]$FunctionsPath = 'The path where PowerShell functions are located on your local system.'
# Pod Functions List: these values used to define the pod functionality, and used also for filtering by function
[array]$PodFunctionList = ("backup", "schema", "mssql", "scripts", "istio","monitoring")
# 2- Functions Call
.$FunctionsPath/Get-PortForwarding.ps1
