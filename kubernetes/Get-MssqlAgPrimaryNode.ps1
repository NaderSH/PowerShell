function Get-MssqlAgPrimaryNode {
    param (
        [string]$Namespace,
        [string]$User,
        [string]$Password,
        [switch]$PortForwarding,
        [switch]$AddPortForwarding,
        [array]$PortsList,
        [switch]$ByPassCheck
    )

    $database = 'master'
    $quey = 'SELECT @@SERVERNAME AS instance_name, role_desc 
            FROM sys.dm_hadr_availability_replica_states
            WHERE role_desc = ''PRIMARY'''
    if($PortForwarding){
        if($AddPortForwarding){    
        }
        else{
            while(-not $PortsList){
                Write-Host "Please insert the range of ports defined separated by space or comma:"
                $portsList = Read-Host -Prompt ">"
                if($portsList.contains(',')){
                    $portsList = $portsList.Split(",")
                }`
                elseif($portsList.contains(' '))
                {
                    $portsList = $portsList.Split(" ")
                }`
                else{
                    $portsList = ''
                }
            }
            Write-Host "Checking current port forwarding established .."
            Get-PortForwarding
            if(-not (Get-PortForwarding)){
                Write-Host "No portforwarding defined!!, please exit the function and execute it again with -AddPortForwarding option!!, or execute function Add-PortForwarding separately first then run this function again!!" -ForegroundColor "Yellow"
            }
            if($ByPassCheck){
                $portForwardingStatus = 'y'
            }
            else{
                Write-Host "Does the current port forwarding configured meet your needs?, press (y) to continue or (n) to terminate"
                $portForwardingStatus = Read-Host -Prompt ">"
            }
            if($portForwardingStatus -eq 'y'){
                foreach ($portFwd in $portsList) {
                    $instance = "localhost," + $portFwd
                    Invoke-Sqlcmd -Query $quey -ServerInstance $instance -Database $database -Username $User -Password $Password -TrustServerCertificate
                }    
            }
            else{
                Write-Host -Object "Terminating!!"
            }
        }
    }
}
