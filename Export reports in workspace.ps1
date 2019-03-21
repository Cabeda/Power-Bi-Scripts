param (
    [Parameter()][string]$WorkspaceId,
    [Parameter()] [boolean]$ExportFile,
    [Parameter()][boolean]$ExportAll
)

##########################  
# Export reports 

# Script to list all reports (with reportId and datasetId) that the logged user has access to
##########################  
Login-PowerBIServiceAccount

$Workspaces = Get-PowerBIWorkspace
$Workspaces


if (!$ExportAll) {   
    $GridArguments = @{
        OutputMode = 'Single'
        Title      = 'Please select a Workspace and click OK'
    }
    
    if (!$WorkspaceId) {
        $WorkspaceId = $Workspaces | Out-GridView @GridArguments | ForEach-Object {
            $_.Id
        }
    }

    $Workspaces = $Workspaces | Where-Object Id -Match $WorkspaceId
}

$WorkspaceName = "Reports";

foreach ($Workspace in $Workspaces) {

    #Set name to single report if the 
    if (!$ExportAll) {
        $WorkspaceName = $Workspace.Name
    }
    
    $Reports = Get-PowerBIReport -WorkspaceId $Workspace.Id | Add-Member -MemberType AliasProperty -Name ReportId -Value Id -PassThru | Select-Object -Property Name, @{l="WorkspaceId";e={$Workspace.Id}}, @{l="Workspace Name";e={$Workspace.Name}} ReportId, DatasetId
        
}
    
#Export Data to a CSV File
$Reports | Export-Csv "Export Files/$WorkspaceName.csv" -NoTypeInformation -Delimiter ";"

