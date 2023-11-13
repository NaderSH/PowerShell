Function Get-k8sPodsLog([string]$Cluster, [string]$Namespace, [string]$Pod, [string]$Container, [switch]$CheckErrorsOnly)
{
    if(-not $Pod){
        Write-Host -Object "No pod provided in input, please select a pod from the below list in [$Namespace]:"
        kubectl get pods -n $Namespace
        $pod = Read-Host -Prompt ">"
    }
    # Getting list of containers inside the pod
    $containersString = kubectl get pods -n $Namespace $Pod -o jsonpath='{.spec.containers[*].name}'
    $containersArray = $containersString.Split(" ")
    while(-not $Container){
        Write-Host -Object "Please select a container from the below list in [$Pod]:"
        Write-Host -Object "List of containers for pod [$Pod]:"
        $containersArray
        $podContainer = Read-Host -Prompt ">"
        if($podContainer -in $containersArray){
            if($CheckErrorsOnly){
                Write-Host -Object "Checking Pod [$Pod] Container [$podContainer] Error Logs ..." -ForegroundColor Yellow
                kubectl -n $Namespace logs $Pod -c $podContainer | grep -e "error *" -e "fail*" -e "unable*" -e "not valid*"
            }
            else{
                Write-Host -Object "Checking Pod [$Pod] Container [$podContainer] Logs ..." -ForegroundColor 'DarkGreen'
                kubectl -n $Namespace logs $Pod -c $podContainer
            } 
        }
        else{
            Write-Host -Object "Container [$podContainer] does not exist in pod [$Pod], please try again with a correct container name." -ForegroundColor 'Red'
        }
    }
    elseif($Container -eq "All"){
        foreach ($podContainer in $containersArray) {
            if($CheckErrorsOnly){
                Write-Host -Object "Checking Pod [$Pod] Container [$podContainer] Error Logs ..." -ForegroundColor Yellow
                kubectl -n $Namespace logs $Pod -c $podContainer | grep -e "error *" -e "fail*" -e "unable*" -e "not valid*"
            }`
            else{
                Write-Host -Object "Checking Pod [$Pod] Container [$podContainer] Logs ..." -ForegroundColor DarkGreen
                kubectl -n $Namespace logs $Pod -c $podContainer
            }  
        }
    }
    else{
        if($Container -in $containersArray){
            if($CheckErrorsOnly){
                Write-Host -Object "Checking Pod [$Pod] Container [$Container] Error Logs ..." -ForegroundColor Yellow
                kubectl -n $Namespace logs $Pod -c $Container | grep -e "error *" -e "fail*" -e "unable*" -e "not valid*" 
            }`
            else{
                Write-Host -Object "Checking Pod [$Pod] Container [$Container] Logs ..." -ForegroundColor DarkGreen
                kubectl -n $Namespace logs $Pod -c $Container
            }
        }
        else{
            Write-Host -Object "Container [$Container] does not exist in pod [$Pod], please try again with a correct container name." -ForegroundColor 'Red'
        }
    }
}
