#####################
# Set Schedule Refresh for a dataset (MUST BE THE OWNER OF THE DATASET)
#####################

# Parameters - fill these in before running the script!
# =====================================================

$groupId = "5befb9fb-e434-4e19-96c0-0fe600073569"         # the ID of workspace to rebind
$datasetId = "9127fb5f-bae4-4597-a2bd-7b28415b23dd"         # the ID of dataset to rebind

# End Parameters =======================================

# Login to the Power BI service with your Power BI credentials
Login-PowerBI

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