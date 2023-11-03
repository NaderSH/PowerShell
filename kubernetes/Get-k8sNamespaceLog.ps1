Function Get-k8sNamespaceLog([string]$Cluster, [string]$Namespace, [string]$PodFunction,[switch]$AllNamespaces, [switch]$CheckErrorsOnly)
{
    if(-not $PodFunction){
        Write-Host -Object "No pod function/type provided in input, please select a function/type from the below list:"
        [array]$podFunctionList = ("backup", "schema", "mssql", "scripts", "istio","monitoring")
        $podFunctionList
        $podFunction = Read-Host -Prompt ">"
    }
    if((-not $Cluster) -or ($cluster -notin ("msdev-infra","msdev01","msprod-infra","msprod01","msqas-infra","msqas01","msunstbl-infra","msunstbl01","msunstbl02"))){
        Write-Host -Object "No cluster provided in input, please select a cluster from the below list of clusters:"
        kubectl config get-contexts
        $cluster = Read-Host -Prompt ">"
        if(-not $cluster){
            $currentCluster = kubectl config current-context 
            Write-Host -Object "No cluster name provided, using the current cluster [$currentCluster] as the selected cluster !!" -ForegroundColor Yellow
        }
    }
    if(($cluster -notin ("msdev-infra","msdev01","msprod-infra","msprod01","msqas-infra","msqas01","msunstbl-infra","msunstbl01","msunstbl02")) -AND (-not $currentCluster)){
        Write-Host -Object "Wrong environment provided, please try again with a valid environment form the above list!!" -ForegroundColor Red
    }`
    else
    {
        # using new selected context
        kubectl config use-context $cluster
        if(-not $Namespace){
            Write-Host -Object "No namespace provided in input, please select a namespace from the below list in [$cluster]:"
            $namespacesList = kubectl get mssqlcluster --all-namespaces -o jsonpath='{.items[*].metadata.namespace}'
            $namespacesArray = $namespacesList.Split(" ")
            $namespacesArray
            $Namespace = Read-Host -Prompt ">"
        }
        if($AllNamespaces){
            Write-Host "No specific namespace provided, checking [$PodFunction] logs for all namespaces!!" -ForegroundColor Blue
            $mssqlPods = kubectl get pods --all-namespaces | grep mssql 
            foreach ($mssqlpod in $mssqlPods) {
                if($mssqlpod -notlike "*operator*"){
                    $currentNamespace = $mssqlpod.Substring(0, $mssqlpod.IndexOf(" "))
                    $mssqlFunctionPods = kubectl get pods -n $currentNamespace | grep $PodFunction
                    Write-Host -Object "Here are the list of pods will be examined:" -ForegroundColor Blue
                    $mssqlFunctionPods
                    foreach ($mssqlfuncpod in $mssqlFunctionPods) {
                        $currentFuncPod = $mssqlfuncpod.Substring(0, $mssqlfuncpod.IndexOf(" "))
                        Write-Host -Object "Checking Namespace [$currentNamespace] [$PodFunction] Pods .." -ForegroundColor DarkGreen
                        if($CheckErrorsOnly){
                            Write-Host -Object "Checking [$PodFunction] Pod [$currentFuncPod] Error Logs ..." -ForegroundColor Yellow
                            kubectl -n $currentNamespace logs $currentFuncPod | grep -e "error *" -e "fail*" -e "unable*"
                        }´
                        else{
                            Write-Host -Object "Checking [$PodFunction] Pod [$currentFuncPod] Logs ..." -ForegroundColor DarkGreen
                            kubectl -n $currentNamespace logs $currentFuncPod
                        }

                    }
                }
            }
        }`
        else{
            Write-Host "A namespace [$namespace] provided, checking [$PodFunction] logs for this namespace:" -ForegroundColor Blue
            $mssqlFunctionPods = kubectl get pods -n $namespace | grep $PodFunction
            Write-Host -Object "Here are the list of pods will be examined:" -ForegroundColor Blue
            $mssqlFunctionPods
            Write-Host -Object "Checking Namespace [$namespace] [$PodFunction] Pods .." -ForegroundColor DarkGreen
            foreach ($mssqlfuncpod in $mssqlFunctionPods) {
                $currentFuncPod = $mssqlfuncpod.Substring(0, $mssqlfuncpod.IndexOf(" "))

                $currentFuncContainersString = kubectl get pods -n $namespace $currentFuncPod -o jsonpath='{.spec.containers[*].name}'
                $currentFuncContainersArray = $currentFuncContainersString.Split(" ")
                foreach ($currentFuncContainer in $currentFuncContainersArray) {
                    if($CheckErrorsOnly){
                        Write-Host -Object "Checking [$PodFunction] Pod [$currentFuncPod] Container [$currentFuncContainer] Error Logs ..." -ForegroundColor Yellow
                        kubectl -n $namespace logs $currentFuncPod -c $currentFuncContainer | grep -e "error *" -e "fail*" -e "unable*"
                    }`
                    else{
                        Write-Host -Object "Checking [$PodFunction] Pod [$currentFuncPod] Container [$currentFuncContainer] Logs ..." -ForegroundColor DarkGreen
                        kubectl -n $namespace logs $currentFuncPod -c $currentFuncContainer
                    }
                }
            }
        }    
    }
}