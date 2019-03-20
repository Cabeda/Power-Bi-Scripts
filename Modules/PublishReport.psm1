Function Publish-PowerBIReport
{
param (
    [Parameter(Mandatory=$true)]
    [string] $FilePath,

    [Parameter(Mandatory=$true)]
    [string] $WorkspaceId,

    [Parameter( ParameterSetName='ReportName')]
    [string]$ReportName
    )

# 2. Set reportName to file name if not existing
$name = if(!$reportName) {$FilePath} Else {$ReportName}

#Import report create or Overwrite
# New-PowerBIReport -Path ".\$($FilePath).pbix" -Name $name -Workspace ( Get-PowerBIWorkspace -Name $Workspace )
New-PowerBIReport -Path $FilePath -Name $name -WorkspaceId $WorkspaceId -ConflictAction CreateOrOverwrite

#Apply parameters


}