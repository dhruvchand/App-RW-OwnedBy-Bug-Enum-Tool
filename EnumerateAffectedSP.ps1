
# Input list is a list of creator applications that had used this permission in an unintentional way (from App.RW.OB spreadsheet)
$OwnerApps = $args |  % {$_.ToLower()}


$principals = Get-AzureADServicePrincipal -All:$true

Write-Output "Service Principal Object IDs that were created by an App (aka creator app) that did not also own the app from which the service principal was instantiated:"
Foreach ($principal in $principals)
{
    # Exclude msft SPs
    If(
        ($principal.ServicePrincipalType -eq "Application") -AND
        (
            $principal.AppOwnerTenantId -eq "f8cdef31-a31e-4b4a-93e4-5f571e91255a" -OR
            $principal.AppOwnerTenantId -eq "null"
        )
    )
    {
        Continue
    }  
    
    $SPObjId = $principal.ObjectId
    $appId = $principal.AppId 

    $SPOwnerIds = (Get-AzureADServicePrincipalOwner -ObjectId $SPObjId).ObjectId
    
    # Write-Output "SP owners: $SPOwnerIds "
    # Consider only those SP owner(s) that are from our original creator app list
    $SPOwnerId = $SPOwnerIds | ?{$OwnerApps -contains $_}

    # Skip service principals that are not created by the any of the creator apps in consideration.
    if($SPOwnerId.length -eq 0){
        Continue
    }

    
    
    # Write-Output "SP owner: $SPOwnerId "
    # Write-Output "backing app id: $appId "

    $appObjId = (Get-AzureADApplication -Filter "AppId eq '$appId'").ObjectId
    # Write-Output "backing app obj id: $appObjId "
    
    # Filter out null AppObjIDs 
    if($appObjId){

        #Get backing app owners
        $appOwnerIds = (Get-AzureADApplicationOwner -ObjectId $appObjId).ObjectId
        $appOwnerId = $appOwnerIds| ?{$OwnerApps -contains $_}

        # Write-Output "backing app owners: $appOwnerId "
        
        # If the service principal and the app are not owned by the same creator app, and were present in the input list, list them out
        if(!($appOwnerId -eq $SPOwnerId)) {
            
            Write-Output "Service Principal ID: $SPObjId, Creator App Id: $SPOwnerId"
         }
    }
         

}
Write-Output "=End of output="
