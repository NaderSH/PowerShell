Function Get-PortForwarding
{
    param (
    )
    # building output list    
    $output = New-Object System.Collections.Generic.List[Object]
    if((Get-ChildItem -Path Env: | Where-Object Name -eq "OS").Value -eq "Windows_NT"){
        Get-WmiObject Win32_Process | Where-Object CommandLine -like '*port-forward*' | Select-Object CreationDate, CommandLine | Sort-Object CreationDate -Desc | Format-List
    }
    else{
        ps -A -o pid,time,command | grep "port-forward" | sort -k 2 -r
    }
}
