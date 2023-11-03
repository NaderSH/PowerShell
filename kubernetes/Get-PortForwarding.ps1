Function Get-PortForwarding()
{
    # building output list    
    $output = New-Object System.Collections.Generic.List[Object]
    if((Get-ChildItem -Path Env: | Where-Object Name -eq "OS").Value -eq "Windows_NT"){
        $processesList = Get-Process | Where-Object ProcessName -eq 'kubectl' | Select-Object Id, ProcessName, StartTime | Sort-Object StartTime -Desc
        foreach ($process in $processesList) {
            $tcpPort = Get-NetTCPConnection -State Listen | Where-Object {($_.OwningProcess -eq $process.Id) -AND ($_.LocalAddress -eq "127.0.0.1")}
        # building output object
        $outObj = [PSCustomObject]@{
            StartTime    = $process.StartTime
            LocalAddress = $tcpPort.LocalAddress
            LocalPort    = $tcpPort.LocalPort
            Process      = $tcpPort.OwningProcess
            }
        $output.Add($outObj)
        }
        $output | Sort-Object StartTime -Desc
    }`
    else{
        ps -A -o pid,time,command | grep "kubectl port-forward" | sort -k 2 -r
    }
}