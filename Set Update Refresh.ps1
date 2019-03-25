#####################
# Set Schedule Refresh for a dataset (MUST BE THE OWNER OF THE DATASET)
#####################

function SetScheduleRefresh([string]$groupId,[string]$datasetId) {

    # param([string]$groupId,[string]$datasetId) 
    # param (
    #     [Parameter(Mandatory = $true, Position = 0)][string]$groupId,
    #     [Parameter(Mandatory = $true, Position = 1)][string]$datasetId
    # )

    # $groupId = $arg1
    # $datasetId = $arg2
    
    "Setting Schedule refresh for: $datasetId"
    
    # Make the request 
    $uri = "/groups/$groupId/datasets/$datasetId/refreshSchedule";
    
    # Set "value": {"enabled": false} to disable the schedule refresh
    $body = '{
        "value": {
            "enabled": true,
            "days": [
                "Monday",
                "Tuesday",
                "Wednesday",
                "Thursday",
                "Friday",
                "Saturday",
                "Sunday"
                ],
                "times": [
                    "00:00",
                    "08:00",
                    "09:00",
                    "10:00",
                    "11:00",
                    "13:00",
                    "14:00",
                    "15:00",
                    "16:00",
                    "17:00",
                    "18:00",
                    "19:00",
                    "20:00",
                    "21:00",
                    "22:00",
                    "23:00"
                    ],
                    "localTimeZoneId": "UTC"
                }
            }';
            
            
            
            try { 
                Invoke-PowerBIRestMethod -Url $uri -Method Patch -Body $body
                
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


# =====================================================

$Environments = (Get-Content "environment.json" | Out-String | ConvertFrom-Json)

# $groupId = "6ff05d4e-4583-4f10-a152-d34ca16aacf2"         # the ID of workspace to rebind
# $datasetId = "9127fb5f-bae4-4597-a2bd-7b28415b23dd"         # the ID of dataset to rebind

$groupId = [string]$Environments.Benetton_PRD.WorkspaceId


# Login to the Power BI service with your Power BI credentials
Login-PowerBI


$datasets = Get-PowerBIDataset -WorkspaceId $groupId

#set schedules or this datasets

foreach ($dataset in $datasets) {
    $array = @([string]$groupId, [string]$dataset)
    SetScheduleRefresh @array
}