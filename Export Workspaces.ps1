
##########################  
# Export Workspaces to Excel

# Script to list all workspaces (name and group ID) that the logged user has access to
##########################  
Login-PowerBIServiceAccount

$Workspaces = Get-PowerBIWorkspace
$Workspaces


#Export Data to a CSV File
$Workspaces | Export-Csv "Workspaces.csv" -NoTypeInformation -Delimiter ";"

