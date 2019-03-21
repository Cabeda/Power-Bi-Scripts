Login-PowerBIServiceAccount

$Workspaces = Get-PowerBIWorkspace

$schedules = @();

foreach ($workspace in $Workspaces) {

    $Datasets = Get-PowerBIDataset -WorkspaceId $workspace.Id
    
    ""
    "####################################"
    "WORKSPACE: " + $workspace.Name
    "####################################"
    ""

    foreach ($dataset in $Datasets) {

        "Get schedule for dataset: " + $dataset.Name

        $datasetId = $dataset.Id
        $workspaceId = $workspace.Id

        $uri = "groups/$workspaceId/datasets/$datasetId/refreshSchedule";
    
        $schedules += Invoke-PowerBIRestMethod -Url $uri -Method Get | ConvertFrom-Json | Add-Member -NotePropertyName "Workspace" -NotePropertyValue $workspace.Name -PassThru | Add-Member -NotePropertyName "Dataset" -NotePropertyValue $dataset.Name -PassThru

    }

}

#Export Data to a CSV File
$schedules | Select-Object  Workspace, Dataset, enabled,localTimeZoneId,notifyOption,@{Name="Days"; Expression={$_.days -join ';'}}, @{Name="Times"; Expression={$_.times -join ';'}} | Export-Csv "Export Files/schedules.csv" -NoTypeInformation  -Delimiter ";"
