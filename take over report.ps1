# This sample script calls the Power BI API to progammatically take over a dataset.

# For documentation, please see:
# https://docs.microsoft.com/rest/api/power-bi/datasets/takeoveringroup

# Parameters - fill these in before running the script!
# =====================================================


# Login to the Power BI service with your Power BI credentials
Login-PowerBI

Get-PowerBIDataset

$workspaces = Get-PowerBIWorkspace

foreach ($workspace in $workspaces) {
    $datasets = Get-PowerBIDataset -WorkspaceId $workspace.Id
    
    "WORKSPACE: " + $workspace.Name

    foreach ($dataset in $datasets) {

        $datasetId = $dataset.Id
        $workspaceId = $workspace.Id

        "Taking over dataset: " + $dataset.Name

        $uri = "groups/$workspaceId/datasets/$datasetId/Default.TakeOver"
        $body = ""
    
        # Try to bind to a new gateway
        try { 
            Invoke-PowerBIRestMethod -Url $uri -Method Post -Body $body 
        
            # Show error if we had a non-terminating error which catch won't catch
            if (-Not $?) {
                $errmsg = Resolve-PowerBIError -Last
                $errmsg.Message
            }
        }
        catch {
            5

        
            $errmsg = Resolve-PowerBIError -Last
            $errmsg.Message
        }
    }
}
