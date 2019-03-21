Function Edit-PowerBIParameters {

    param (
        [Parameter(Mandatory = $true, Position = 0)][string]$WorkspaceId,
        [Parameter(Mandatory = $true, Position = 1)][string]$ReportName,
        [Parameter(Mandatory = $true, Position = 3)][string]$Server,
        [Parameter(Mandatory = $true, Position = 2)][string]$Origin,
        [Parameter(Mandatory = $true, Position = 4)][string]$Token
    )



    $report = Get-PowerBIReport -WorkspaceId $WorkspaceId -Name $ReportName

    If ($report.Length -match 0) {
        Write-Output "There were no reports with name $($ReportName) in the $($Env) environment"
        exit "Press any key"
    }

    $datasetId = $report.DatasetId


    $body = @{
        updateDetails = @(
            @{
                name     = "Token"
                newValue = $Token
            },
            @{
                name     = "Server"
                newValue = $Server
            },
            @{
                name     = "Origin"
                newValue = $Origin
            }
        )
    }

    $jsonPostBody = $body | ConvertTo-JSON

    # Update parameters

    $uri = "/groups/$WorkspaceId/datasets/$datasetId/";

    try { 
        $parameters = Invoke-PowerBIRestMethod -Url $uri"parameters" -Method Get | ConvertFrom-Json 
        
        if($parameters.value) {
            
            "UPDATING: " + $report.Name
            "Changing parameters..."
            Invoke-PowerBIRestMethod -URL $uri"Default.UpdateParameters" -Body $jsonPostBody -Method Post
            "Refreshing the dataset"
            Invoke-PowerBIRestMethod -URL $uri"refreshes" -Method Post -Body ""
            "PARAMETERS SET TO: "
            Invoke-PowerBIRestMethod -Url $uri"parameters" -Method Get
        }
       
        # Show error if we had a non-terminating error which catch won't catch
        if (-Not $?) {
            $errmsg = Resolve-PowerBIError -Last
            $errmsg.Message
        }
    }
    catch {
        $errmsg = Resolve-PowerBIError -Last
        $errmsg.Message
    }
}
