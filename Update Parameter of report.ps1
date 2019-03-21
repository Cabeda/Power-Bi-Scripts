<#
  Script to update the parameters of a dataset in a specified Workspace (called environment)
#>
param (
    [Parameter()]
    [string] $env ,
    
    [Parameter()]
    [string] $ReportName,
    
    [Parameter()]
    [boolean] $UpdateAll
)
##################################
# IMPORT
##################################

Import-Module -Name ".\Modules\EditDatasetParameters" -Force
#Convert environment in config to object
$Environments = (Get-Content ./environment.json) -join "`n" | ConvertFrom-Json

##################################
# Login
##################################

Login-PowerBIServiceAccount

##################################
# Select Environment
##################################


If (!$env) {
    Write-Output "There are the following enviroments:"
    $Environments.keys
    $env = Read-Host "Enter the environment to update"
}


$WorkspaceId = $Environments.$env.WorkspaceId
$Server = $Environments.$env.Server
$Token = $Environments.$env.Token
$Origin = $Environments.$env.Origin


##################################
# Select Report
##################################

$Reports = Get-PowerBIReport -WorkspaceId $WorkspaceId

# if(!$UpdateAll) {
#     if($ReportName == $null) {
#         $ReportName = Read-Host "Enter the Report Name to update"
#     }

# } 

##################################
# Update the dataset parameters
##################################

"Updating the parameters to the env $env..."

foreach($report in $Reports) {
    Edit-PowerBIParameters -WorkspaceId $WorkspaceId -ReportName $report.Name -Server $Server -Origin $Origin -Token $Token 
}
