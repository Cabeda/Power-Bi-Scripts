
param (
    [Parameter()]
    [string] $env ,
    
    [Parameter(Mandatory = $true)]
    [string] $FilePath ,
    
    [Parameter()]
    [string]$ReportName,

    [Parameter()]
    [boolean]$NoParameterRefresh,

    [Parameter()]
    [boolean]$NoPublishReport

)

Import-Module -Name ".\Modules\PublishReport.psm1" -Force
Import-Module -Name ".\Modules\EditDatasetParameters" -Force

######################################################################
# Script to automate the flow of publishing a report to a specified report (publish and update variables)
# There's a report 
######################################################################
    
try{Get-PowerBIAccessToken}
catch
{
    Login-PowerBIServiceAccount
}

##################################
# IMPORTS
##################################

Import-Module -Name ".\Modules\EditDatasetParameters" -Force
#Convert environment in config to object
$Environments = ConvertFrom-Json "environment.json"


##################################
# Select Environment
##################################

If (!$env) {
    Write-Output "There are the following enviroments:"
    $Environments.keys
    $env = Read-Host "Enter the environment to update"
}

$WorkspaceId = $Environments["$env"].WorkspaceId
$Server = $Environments["$env"].Server
$Token = $Environments["$env"].Token
$Origin = $Environments["$env"].Origin
$ReportName = if (!$reportName) {$FilePath} 

if(!$NoPublishReport)
{
    "Publish the Report $ReportName..."
    Publish-PowerBIReport -FilePath $FilePath -WorkspaceId $WorkspaceId -ReportName $ReportName
}

if(!$NoParameterRefresh)
{
    "Updating the parameters to the env $env..."
    Edit-PowerBIParameters -WorkspaceId $WorkspaceId -ReportName $reportName -Origin $Origin -Token $Token -Server $Server
}
