Function Edit-PowerBIParameters
{

param (
    [Parameter(Mandatory=$true,Position=0)][string]$WorkspaceId,
    [Parameter(Mandatory=$true,Position=1)][string]$ReportName,
    [Parameter(Mandatory=$true, Position=3)][string]$Server,
    [Parameter(Mandatory=$true,Position=2)][string]$Origin,
    [Parameter(Mandatory=$true,Position=4)][string]$Token
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
            name = "Token"
            newValue = $Token
        },
        @{
            name = "Server"
            newValue = $Server
        },
        @{
            name = "Origin"
            newValue = $Origin
        }
    )
}

$jsonPostBody = $body | ConvertTo-JSON

# Update parameters

Invoke-PowerBIRestMethod -Url "datasets/$($datasetId)/parameters" -Method Get
"Changing parameters..."
Invoke-PowerBIRestMethod -URL "datasets/$($datasetId)/Default.UpdateParameters" -Body $jsonPostBody -Method Post
"Refreshing the dataset"
Invoke-PowerBIRestMethod -URL "datasets/$datasetId/refreshes" -Method Post
"Changed successfuly!!!"
Invoke-PowerBIRestMethod -Url "datasets/$($datasetId)/parameters" -Method Get


}


