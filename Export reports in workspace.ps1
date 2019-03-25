param (
    [Parameter()][string]$WorkspaceId,
    [Parameter()] [boolean]$ExportFile,
    [Parameter()][boolean]$All
)

##########################  
# Export reports 

# Script to list all reports (with reportId and datasetId) that the logged user has access to
##########################  
Login-PowerBIServiceAccount

$Workspaces = Get-PowerBIWorkspace
$Workspaces


if (!$All) {   
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

$Reports = @()

foreach ($Workspace in $Workspaces) {

    #Set name to single report if the 
    if (!$All) {
        $WorkspaceName = $Workspace.Name
    }
    
    $Reports += Get-PowerBIReport -WorkspaceId $Workspace.Id | 
                Add-Member -MemberType AliasProperty -Name ReportId -Value Id -PassThru | 
                Select-Object -Property Name, ReportId, DatasetId | 
                Add-Member -NotePropertyName "WorkspaceId" -NotePropertyValue $workspace.Id -PassThru | 
                Add-Member -NotePropertyName "Workspace Name" -NotePropertyValue $workspace.Name -PassThru
        
}
    
#Export Data to a CSV File
$Reports | Export-Csv "Export Files/$WorkspaceName.csv" -NoTypeInformation -Delimiter ";"

