Function Get-k8sPodsLog([string]$Cluster, [string]$Namespace, [string]$Pod, [switch]$Container, [switch]$CheckErrorsOnly)
{
    if(-not $Pod){
        Write-Host -Object "No pod provided in input, please select a pod from the below list in [$Namespace]:"
        kubectl get pods -n $Namespace
        $pod = Read-Host -Prompt ">"
    }
    if(-not $Container){
        if($CheckErrorsOnly){
            Write-Host -Object "Checking Pod [$Pod] Error Logs ..." -ForegroundColor Yellow
            kubectl -n $namespace logs $Pod | grep -e "error *" -e "fail*" -e "unable*"
        }`
        else{
            Write-Host -Object "Checking Pod [$Pod] Logs ..." -ForegroundColor DarkGreen
            kubectl -n $namespace logs $Pod
        }
    }`
    else{
        Write-Host -Object "List of containers for pod [$Pod]:"
        $containersString = kubectl get pods -n $Namespace $Pod -o jsonpath='{.spec.containers[*].name}'
        $containersArray = $containersString.Split(" ")
        Write-Host -Object "Please select a container from the below list in [$Pod]:"
        $containersArray
        $PodContainer = Read-Host -Prompt ">"
        if($CheckErrorsOnly){
            Write-Host -Object "Checking Pod [$Pod] Container [$PodContainer] Error Logs ..." -ForegroundColor Yellow
            kubectl -n $namespace logs $Pod -c $PodContainer | grep -e "error *" -e "fail*" -e "unable*"
        }`
        else{
            Write-Host -Object "Checking Pod [$Pod] Container [$PodContainer] Logs ..." -ForegroundColor DarkGreen
            kubectl -n $namespace logs $Pod -c $PodContainer
        }
    }
}